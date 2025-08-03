import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:cybersafe_pro/encrypt/aes_256/secure_aes256.dart';
import 'package:cybersafe_pro/env/env.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/repositories/driff_db/models/account_aggregate.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/services/account/account_services.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/utils/file_picker_utils.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' as pc;

class DataManagerService {
  static final DataManagerService _instance = DataManagerService._internal();
  factory DataManagerService() => _instance;
  DataManagerService._internal();

  static Future<bool> checkData() async {
    final db = DriffDbManager.instance;
    final accounts = await db.accountAdapter.getAll();
    return accounts.isNotEmpty;
  }

  static Future<bool> deleteAllData() async {
    try {
      await DriffDbManager.instance.categoryAdapter.deleteAll();
      await DriffDbManager.instance.iconCustomAdapter.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> pickFileBackup(BuildContext context) async {
    FilePickerResult? result = await FilePickerUtils.pickFile(type: FileType.any);
    if (result == null || result.files.isEmpty) {
      if (!context.mounted) return "";
      throw Exception(context.trSafe(ErrorText.fileNotSelected));
    }

    final filePath = result.files.first.path;
    if (filePath == null) {
      throw Exception('File not found');
    }
    if (!filePath.endsWith('.enc')) {
      throw Exception('File is not an backup file');
    }
    return filePath;
  }

  static Future<bool> restoreBackup({
    required BuildContext context,
    required String pin,
    required String filePath,
  }) async {
    try {
      if (filePath.isEmpty) return throw Exception('File not found');
      File file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File not found');
      }

      List<int> encryptedBytes;
      try {
        encryptedBytes = file.readAsBytesSync();
      } catch (e) {
        throw Exception('Cannot read file: ${e.toString()}');
      }
      final keyEncryptFile = await _generateBackupKey(Env.backupFileEncryptKey);
      final keyEncryptData = await _generateBackupKey(pin);

      final decryptedData = SecureAes256.decryptDataBytes(
        encryptedData: encryptedBytes,
        key: keyEncryptFile,
      );
      final decryptedUtf8Decode = utf8.decode(decryptedData);

      String decryptedDataResult;
      try {
        decryptedDataResult = DataSecureService.decryptData(
          value: decryptedUtf8Decode,
          key: keyEncryptData,
        );
      } catch (e) {
        throw Exception('KEY_INVALID');
      }

      final decryptedDataJson = jsonDecode(decryptedDataResult);

      if (decryptedDataJson == null) {
        throw Exception('Data is null');
      }

      if (decryptedDataJson is! List) {
        throw Exception('Data is not a list');
      }

      final List<AccountAggregate> accountAggregates = [];
      log(decryptedDataJson.toString());

      for (var item in decryptedDataJson) {
        if (item != null && item is Map<String, dynamic>) {
          try {
            accountAggregates.add(AccountAggregate.fromBackupJson(item));
          } catch (e) {
            logError(
              'Error restoring backup: $e',
              functionName: 'DataManagerServiceNew.restoreBackup',
            );
          }
        }
      }

      if (accountAggregates.isEmpty) {
        throw Exception('No data to restore');
      }
      await AccountServices.instance.saveAccountsFromAccountAggregates(accountAggregates);
      return true;
    } catch (e) {
      throw Exception(e);
    } finally {
      SecureApplicationUtil.instance.unlock();
    }
  }

  static Future<bool> backupData(BuildContext context, String pin) async {
    try {
      final db = DriffDbManager.instance;

      final listAccountAggregates = await db.transaction(() async {
        final accounts = await db.accountAdapter.getAll();
        if (accounts.isEmpty) {
          return <AccountAggregate>[];
        }

        final iconCustomIds =
            accounts.where((a) => a.iconCustomId != null).map((a) => a.iconCustomId!).toSet();
        final categoryIds = accounts.map((a) => a.categoryId).toSet();
        final accountIds = accounts.map((a) => a.id).toSet();

        final results = await Future.wait([
          db.iconCustomAdapter.getByIds(iconCustomIds.toList()),
          db.categoryAdapter.getByIds(categoryIds.toList()),
          db.totpAdapter.getByAccountIds(accountIds.toList()),
          db.passwordHistoryAdapter.getByAccountIds(accountIds.toList()),
          db.accountCustomFieldAdapter.getByAccountIds(accountIds.toList()),
        ]);

        final iconCustomMap = {
          for (var icon in results[0] as List<IconCustomDriftModelData>) icon.id: icon,
        };
        final categoryMap = {
          for (var cat in results[1] as List<CategoryDriftModelData>) cat.id: cat,
        };
        final totpMap = {for (var t in results[2] as List<TOTPDriftModelData>) t.accountId: t};

        final passwordHistoriesMap = <int, List<PasswordHistoryDriftModelData>>{};
        for (var ph in results[3] as List<PasswordHistoryDriftModelData>) {
          passwordHistoriesMap.putIfAbsent(ph.accountId, () => []).add(ph);
        }

        final customFieldsMap = <int, List<AccountCustomFieldDriftModelData>>{};
        for (var cf in results[4] as List<AccountCustomFieldDriftModelData>) {
          customFieldsMap.putIfAbsent(cf.accountId, () => []).add(cf);
        }

        return accounts.map((account) {
          return AccountAggregate(
            account: account,
            iconCustom: account.iconCustomId != null ? iconCustomMap[account.iconCustomId] : null,
            category: categoryMap[account.categoryId]!,
            totp: totpMap[account.id],
            passwordHistories: passwordHistoriesMap[account.id] ?? [],
            customFields: customFieldsMap[account.id] ?? [],
          );
        }).toList();
      });

      if (listAccountAggregates.isEmpty) {
        throw Exception('Không có dữ liệu để backup');
      }

      final accountAggregates = await AccountServices.instance.toDataDecryptedList(
        listAccountAggregates,
      );

      final backupData = {
        'metadata': {
          'version': '1.0',
          'timestamp': DateTime.now().toIso8601String(),
          'count': accountAggregates.length,
        },
        'data': accountAggregates,
      };

      final keyEncryptFile = await _generateBackupKey(Env.backupFileEncryptKey);
      final keyEncryptData = await _generateBackupKey(pin);

      // Mã hóa dữ liệu
      final encryptedData = DataSecureService.encryptData(
        value: jsonEncode(backupData['data']),
        key: keyEncryptData,
      );

      final backupJsonBytes = await compute<String, List<int>>(
        _encodeBackupInIsolate,
        encryptedData,
      );
      List<int> encryptedDataBytes = SecureAes256.encryptDataBytes(
        data: backupJsonBytes,
        key: keyEncryptFile,
      );

      final dateTime = DateTime.now().toString().replaceAll(RegExp(r'[:\s]'), '-');
      final backupName = 'cybersafe_backup_$dateTime';
      final fileName = "$backupName.enc";
      final filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: fileName,
        bytes: Uint8List.fromList(encryptedDataBytes),
      );
      return filePath != null;
    } catch (e) {
      logError('Error backing up data: $e', functionName: 'DataManagerServiceNew.backupData');
      return false;
    } finally {
      SecureApplicationUtil.instance.unlock();
    }
  }

  static List<int> _encodeBackupInIsolate(String encryptedData) {
    return utf8.encode(encryptedData);
  }

  static const int BACKUP_PBKDF2_ITERATIONS = 50000; // Giảm số vòng lặp cho backup/restore

  static Future<String> _generateBackupKey(String pin) async {
    return compute<Map<String, dynamic>, String>(_generateKeyInIsolate, {
      'pin': pin,
      'salt': Env.appSignatureKey,
    });
  }

  static String _generateKeyInIsolate(Map<String, dynamic> params) {
    final String pin = params['pin'];
    final String saltBase = params['salt'];

    final salt = utf8.encode(saltBase);

    final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(salt), BACKUP_PBKDF2_ITERATIONS, 32));

    return base64.encode(generator.process(Uint8List.fromList(utf8.encode(pin))));
  }

  static Future<bool> importDataFromBrowser() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true, // Đọc file dưới dạng bytes
      );

      if (result == null || result.files.isEmpty) {
        throw Exception("File not selected");
      }

      final fileBytes = result.files.first.bytes;
      if (fileBytes == null) {
        throw Exception("Cannot read file content");
      }

      String csvString;
      try {
        csvString = utf8.decode(fileBytes);
      } catch (_) {
        try {
          csvString = latin1.decode(fileBytes);
        } catch (_) {
          throw Exception("Cannot read file content, please check encoding");
        }
      }

      if (csvString.isEmpty) {
        throw Exception("File CSV is empty");
      }

      final csvConverter = CsvToListConverter(
        shouldParseNumbers: false,
        fieldDelimiter: ',',
        eol: '\n',
      );

      final csvTable = csvConverter.convert(csvString, shouldParseNumbers: false);

      if (csvTable.isEmpty) {
        throw Exception("File CSV is empty");
      }

      final header = csvTable.first.map((e) => e.toString().toLowerCase().trim()).toList();
      final requiredColumns = ['name', 'url', 'username', 'password', 'note'];

      if (!requiredColumns.every((col) => header.contains(col))) {
        throw Exception(
          "File CSV is not in the correct format. Need columns: name, url, username, password, note",
        );
      }

      final nameIndex = header.indexOf('name');
      final urlIndex = header.indexOf('url');
      final usernameIndex = header.indexOf('username');
      final passwordIndex = header.indexOf('password');
      final noteIndex = header.indexOf('note');

      final fileName = result.files.first.name.replaceAll(".csv", "");
      int categoryId = -1;
      final category = await DriffDbManager.instance.categoryAdapter.findByName(fileName);
      if (category == null) {
        categoryId = await DriffDbManager.instance.categoryAdapter.insertCategory(fileName);
      } else {
        categoryId = category.id;
      }

      final mappedRows = await compute(_mapCsvRowsInIsolate, {
        'rows': csvTable.skip(1).toList(),
        'header': header,
        'nameIndex': nameIndex,
        'urlIndex': urlIndex,
        'usernameIndex': usernameIndex,
        'passwordIndex': passwordIndex,
        'noteIndex': noteIndex,
        'categoryName': fileName,
        'categoryId': categoryId,
      });

      final List<BranchLogo> branchLogos =
          branchLogoCategories.expand((element) => element.branchLogos).toList();

      final accountCompanions = <AccountDriftModelCompanion>[];
      for (var row in mappedRows) {
        try {
          String iconSlug = "account_circle";
          try {
            final title = row['title'].toString().toLowerCase();
            var matchingIcons = branchLogos.where(
              (element) => element.branchName?.toLowerCase().contains(title) ?? false,
            );

            if (matchingIcons.isEmpty && (title.contains('.') || title.contains('/'))) {
              final urlParts = title
                  .replaceAll('http://', '')
                  .replaceAll('https://', '')
                  .replaceAll('www.', '')
                  .split('.');
              for (final part in urlParts) {
                if (part.isNotEmpty) {
                  final partMatches = branchLogos.where(
                    (element) =>
                        element.branchName?.toLowerCase() == part ||
                        (element.keyWords?.any((keyword) => keyword.toLowerCase() == part) ??
                            false),
                  );

                  if (partMatches.isNotEmpty) {
                    matchingIcons = partMatches;
                    break;
                  }
                }
              }
            }

            if (matchingIcons.isNotEmpty) {
              iconSlug = matchingIcons.first.branchLogoSlug ?? "account_circle";
            }
          } catch (e) {
            logError(
              'Error finding icon: $e',
              functionName: 'DataManagerServiceNew.importDataFromBrowser',
            );
          }

          accountCompanions.add(
            AccountDriftModelCompanion(
              icon: Value(iconSlug),
              title: Value(row['title']),
              username: Value(row['email']),
              password: Value(row['password']),
              notes: Value(row['notes']),
              categoryId: Value(categoryId),
            ),
          );
        } catch (e) {
          logError(
            'Error preparing account data: $e',
            functionName: 'DataManagerServiceNew.importDataFromBrowser',
          );
        }
      }

      if (accountCompanions.isEmpty) {
        return false;
      }

      int successCount = 0;
      await DriffDbManager.instance.transaction(() async {
        for (var account in accountCompanions) {
          try {
            await DriffDbManager.instance.createAccountWithEncriptData(account: account);
            successCount++;
          } catch (e) {
            logError(
              'Error creating account: $e',
              functionName: 'DataManagerServiceNew.importDataFromBrowser',
            );
          }
        }
      });

      return successCount > 0;
    } catch (e) {
      logError(e.toString());
      return false;
    } finally {
      SecureApplicationUtil.instance.unlock();
    }
  }

  static List<Map<String, dynamic>> _mapCsvRowsInIsolate(Map<String, dynamic> args) {
    final List<List<dynamic>> rows = args['rows'] as List<List<dynamic>>;
    final List<String> header = List<String>.from(args['header']);
    final int nameIndex = args['nameIndex'];
    final int urlIndex = args['urlIndex'];
    final int usernameIndex = args['usernameIndex'];
    final int passwordIndex = args['passwordIndex'];
    final int noteIndex = args['noteIndex'];
    final String categoryName = args['categoryName'];
    final int categoryId = args['categoryId'];

    final List<Map<String, dynamic>> result = [];

    for (var row in rows) {
      if (row.length < header.length) continue;

      final title = _safeGetString(row, nameIndex);
      final url = _safeGetString(row, urlIndex);
      final username = _safeGetString(row, usernameIndex);
      final password = _safeGetString(row, passwordIndex);
      final note = _safeGetString(row, noteIndex);

      if (title.isEmpty || username.isEmpty || password.isEmpty) continue;

      final importNote = note.isEmpty ? url : note;

      result.add({
        'title': title,
        'email': username,
        'password': password,
        'notes': importNote,
        'categoryName': categoryName,
        'categoryId': categoryId,
      });
    }

    return result;
  }

  static String _safeGetString(List<dynamic> row, int index) {
    if (index < 0 || index >= row.length) return '';
    final value = row[index];
    if (value == null) return '';
    return value.toString().trim();
  }
}
