import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/boxes/account_custom_field_box.dart' show AccountCustomFieldBox;
import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/database/boxes/icon_custom_box.dart';
import 'package:cybersafe_pro/database/boxes/password_history_box.dart';
import 'package:cybersafe_pro/database/boxes/totp_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/env/env.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/encrypt_service.dart';
import 'package:cybersafe_pro/services/permission_service.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class DataManagerService {
  //instance
  static final DataManagerService _instance = DataManagerService._internal();
  factory DataManagerService() => _instance;
  DataManagerService._internal();

  //import data from browser
  static Future<void> importDataFromBrowser(BuildContext context) async {
    showLoadingDialog();
    try {
      // Chọn file CSV
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true, // Đọc file dưới dạng bytes
      );

      if (result == null || result.files.isEmpty) {
        throw Exception(context.trError(ErrorText.fileNotSelected));
      }

      final fileBytes = result.files.first.bytes;
      if (fileBytes == null) {
        throw Exception(context.trError(ErrorText.cannotReadFile));
      }

      // Thử các encoding khác nhau
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

      // Chuyển đổi CSV thành List với các tùy chọn phù hợp
      final csvConverter = CsvToListConverter(
        shouldParseNumbers: false, // Không tự động chuyển số
        fieldDelimiter: ',', // Dấu phân cách cột
        eol: '\n', // Dấu xuống dòng
      );

      final csvTable = csvConverter.convert(csvString, shouldParseNumbers: false);

      if (csvTable.isEmpty) {
        throw Exception("File CSV is empty");
      }

      // Kiểm tra header
      final header = csvTable.first.map((e) => e.toString().toLowerCase().trim()).toList();
      final requiredColumns = ['name', 'url', 'username', 'password', 'note'];

      // Kiểm tra xem có đủ các cột cần thiết không
      if (!requiredColumns.every((col) => header.contains(col))) {
        throw Exception("File CSV is not in the correct format. Need columns: name, url, username, password, note");
      }

      // Lấy index của các cột
      final nameIndex = header.indexOf('name');
      final urlIndex = header.indexOf('url');
      final usernameIndex = header.indexOf('username');
      final passwordIndex = header.indexOf('password');
      final noteIndex = header.indexOf('note');

      // Tạo category mới từ tên file
      final fileName = result.files.first.name.replaceAll(".csv", "");
      final newCategory = CategoryOjbModel(categoryName: fileName);
      final categoryId = CategoryBox.put(newCategory);
      newCategory.id = categoryId;

      if (!context.mounted) return;
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);

      int successCount = 0;
      // Import từng dòng dữ liệu
      for (var row in csvTable.skip(1)) {
        try {
          if (row.length < header.length) continue;

          final title = row[nameIndex].toString().trim();
          final url = row[urlIndex].toString().trim();
          final username = row[usernameIndex].toString().trim();
          final password = row[passwordIndex].toString().trim();
          final note = row[noteIndex].toString().trim();

          if (title.isEmpty || username.isEmpty || password.isEmpty) continue;

          final importNote = note.isEmpty ? url : note;

          // Tạo account mới
          final account = AccountOjbModel(title: title, email: username, password: password, notes: importNote, categoryOjbModel: newCategory);

          // Lưu vào database
          await accountProvider.createOrUpdateAccount(account);
          successCount++;
        } catch (e) {
          continue;
        }
      }

      // Refresh danh sách account
      await accountProvider.refreshAccounts();
      // Hiển thị thông báo thành công
      if (context.mounted) {
        context.read<CategoryProvider>().getCategories();
        hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import successfully $successCount accounts'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red));
      }
    }
  }

  static bool checkData(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    return accountProvider.accounts.isNotEmpty && categoryProvider.categories.isNotEmpty;
  }

  //backup data
  static Future<void> backupData(BuildContext context, String pin) async {
    try {
      if (!await PermissionService.instance.requestStoragePermission()) {
        return;
      }
      logInfo('requestStoragePermission: ${await PermissionService.instance.requestStoragePermission()}');

      showLoadingDialog();
      String dateTime = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}";
      final backupName = 'backup_cybersafe_$dateTime';
      final backupService = EncryptAppDataService.instance;

      final backup = await backupService.createBackup(pin, backupName);
      final fileName = "$backupName.enc";

      // Tạo thư mục cyber_safe
      Directory downloadDirectory = await getDownloadDirectory();
      final backupDir = Directory(path.join(downloadDirectory.path, 'cyber_safe'));
      if (!backupDir.existsSync()) {
        logInfo('Tạo thư mục cyber_safe');
        await backupDir.create();
      }

      // Lưu file
      final backupFile = File('${backupDir.path}/$fileName');
      final backupJson = jsonEncode(backup);
      final codeEncrypted = EncryptService.instance.encryptFernetBytes(data: utf8.encode(backupJson), key: Env.backupFileEncryptKey);
      await backupFile.writeAsBytes(codeEncrypted);
      logInfo('Backup successfully to ${backupFile.path}');
      if (context.mounted) {
        logInfo("context.mounted");
        hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup successfully to ${backupFile.path}'), backgroundColor: Colors.green, duration: const Duration(seconds: 2)));
        Navigator.of(context).pop();
      }
    } catch (e) {
      hideLoadingDialog();
      logError('Error backup data: ${e.toString()}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
      }
    }
  }

  static Future<void> restoreData(BuildContext context) async {
    try {
      // Bước 1: Chọn file
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result == null || result.files.isEmpty) {
        throw Exception(context.trError(ErrorText.fileNotSelected));
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception('File not found');
      }

      // Bước 2: Đọc và giải mã file
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

      // Bước 3: Giải mã dữ liệu file
      List<int> dataBackup;
      try {
        dataBackup = EncryptService.instance.decryptFernetBytes(encryptedData: encryptedBytes, key: Env.backupFileEncryptKey);
      } catch (e) {
        throw Exception('Backup data is not valid or corrupted');
      }

      // Bước 4: Chuyển đổi dữ liệu sang JSON
      String jsonString;
      try {
        jsonString = utf8.decode(dataBackup);
        // Kiểm tra xem có phải JSON hợp lệ không
        final jsonData = jsonDecode(jsonString);
        if (!jsonData.containsKey('type') || jsonData['type'] != 'CYBERSAFE_BACKUP') {
          throw Exception('Backup data is not valid');
        }
      } catch (e) {
        throw Exception('Backup data is not valid: ${e.toString()}');
      }

      // Bước 5: Hiển thị màn hình nhập PIN
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LoginMasterPassword(
              showBiometric: false,
              isFromBackup: true,
              callBackLoginSuccess: ({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey}) async {
                if (isLoginSuccess == true && pin != null && GlobalKeys.appRootNavigatorKey.currentContext != null) {
                  try {
                    showLoadingDialog();
                    // Bước 6: Kiểm tra PIN và khôi phục dữ liệu
                    final result = await EncryptAppDataService.instance.restoreBackup(jsonString, pin);
                    if (!context.mounted) return;
                    if (result) {
                      // Bước 7: Khôi phục thành công
                      await GlobalKeys.appRootNavigatorKey.currentContext!.read<CategoryProvider>().refresh();
                      await GlobalKeys.appRootNavigatorKey.currentContext!.read<AccountProvider>().refreshAccounts();
                      Navigator.of(GlobalKeys.appRootNavigatorKey.currentContext!).pop();
                      ScaffoldMessenger.of(
                        GlobalKeys.appRootNavigatorKey.currentContext!,
                      ).showSnackBar(const SnackBar(content: Text('Data restore successfully'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                    } else {
                      throw Exception('Data restore failed');
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    if (e.toString().contains('PIN_INCORRECT')) {
                      appPinCodeKey?.currentState?.triggerErrorAnimation();
                    } else {
                      // Các lỗi khác trong quá trình khôi phục
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.trError(ErrorText.restoreFailed)), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
                    }
                  }
                } else {
                  // Trường hợp không nhập PIN hoặc hủy
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data restore canceled'), backgroundColor: Colors.orange, duration: Duration(seconds: 2)));
                  }
                }
              },
            );
          },
        ),
      );
    } catch (e) {
      // Xử lý các lỗi chung
      hideLoadingDialog();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
      }
    }
  }

  // Hàm kiểm tra PIN có đúng không
  Future<bool> validateBackupPin(String jsonString, String pin) async {
    try {
      // Sử dụng hàm restoreBackup để kiểm tra PIN
      // Nếu không có lỗi PIN_INCORRECT thì PIN đúng
      await EncryptAppDataService.instance.restoreBackup(jsonString, pin);
      return true;
    } catch (e) {
      if (e.toString().contains('PIN_INCORRECT')) {
        return false;
      }
      rethrow;
    }
  }

  //delete data
  static Future<bool> deleteData() async {
    try {
      showLoadingDialog();

      // Xóa dữ liệu lần lượt và xử lý ngoại lệ
      try {
        await CategoryBox.deleteAll();
      } catch (e) {
        logError('Lỗi xóa CategoryBox: $e');
      }
      try {
        await AccountBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa AccountBox: $e');
      }
      try {
        await AccountCustomFieldBox.deleteAll();
      } catch (e) {
        logError('Lỗi xóa AccountCustomFieldBox: $e');
      }
      try {
        await IconCustomBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa IconCustomBox: $e');
      }
      try {
        await PasswordHistoryBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa PasswordHistoryBox: $e');
      }
      try {
        await TOTPBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa TOTPBox: $e');
      }

      hideLoadingDialog();
      return true;
    } catch (e) {
      hideLoadingDialog();
      logError('Lỗi xóa tất cả dữ liệu: $e');
      return false;
    }
  }

  //show dialog delete data
  //request user confirm
  //wait 5s

  static Future<void> deleteAllDataPopup({required BuildContext context}) async {
    bool canDelete = false;
    int countdown = 5;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!canDelete) {
              Future.delayed(const Duration(seconds: 1), () {
                if (countdown > 0 && context.mounted) {
                  setState(() {
                    countdown--;
                  });
                  if (countdown == 0) {
                    setState(() {
                      canDelete = true;
                    });
                  }
                }
              });
            } else {
              countdown = 5;
              canDelete = true;
            }

            return AlertDialog(
              title: const Text("Delete all"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [Text("Are you sure you want to delete all data?"), const SizedBox(height: 10)]),
              actions: [
                TextButton(
                  onPressed:
                      canDelete
                          ? () async {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LoginMasterPassword(
                                      showBiometric: false,
                                      isFromBackup: false,
                                      callBackLoginSuccess: ({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey}) async {
                                        if (isLoginSuccess == true && pin != null) {
                                          final success = await deleteData();

                                          if (success && GlobalKeys.appRootNavigatorKey.currentContext != null) {
                                            // Làm mới dữ liệu
                                            try {
                                              await GlobalKeys.appRootNavigatorKey.currentContext!.read<CategoryProvider>().refresh();
                                              await GlobalKeys.appRootNavigatorKey.currentContext!.read<AccountProvider>().refreshAccounts();
                                            } catch (e) {
                                              logError('Lỗi làm mới dữ liệu sau khi xóa: $e');
                                            }

                                            // Hiển thị thông báo thành công
                                            ScaffoldMessenger.of(
                                              GlobalKeys.appRootNavigatorKey.currentContext!,
                                            ).showSnackBar(const SnackBar(content: Text('Delete data successfully'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));

                                            // Quay về màn hình chính
                                            Navigator.of(GlobalKeys.appRootNavigatorKey.currentContext!).pop();
                                          } else {
                                            if (GlobalKeys.appRootNavigatorKey.currentContext != null) {
                                              ScaffoldMessenger.of(
                                                GlobalKeys.appRootNavigatorKey.currentContext!,
                                              ).showSnackBar(const SnackBar(content: Text('Delete data failed'), backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                                              Navigator.of(GlobalKeys.appRootNavigatorKey.currentContext!).pop();
                                            }
                                          }
                                        }
                                      },
                                    ),
                              ),
                            );
                          }
                          : null,
                  child: Text("Delete ${!canDelete ? "($countdown)" : ""}", style: TextStyle(color: canDelete ? Colors.redAccent : Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
