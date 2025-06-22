import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
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
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/encrypt_service.dart';
import 'package:cybersafe_pro/services/permission_service.dart';
import 'package:cybersafe_pro/utils/file_picker_utils.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/utils/toast_noti.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DataManagerService {
  //instance
  static final DataManagerService _instance = DataManagerService._internal();
  factory DataManagerService() => _instance;
  DataManagerService._internal();

  static const String transferFileName = "cyber_safe_transfer.enc";
  static const String TRANSFER_FOLDER = "CyberSafeTransfer";
  static bool canLockApp = true;

  //import data from browser
  static Future<void> importDataFromBrowser(BuildContext context) async {
    showLoadingDialog();
    canLockApp = false;
    try {
      // Chọn file CSV
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true, // Đọc file dưới dạng bytes
      );

      if (result == null || result.files.isEmpty) {
        throw Exception(context.trSafe(ErrorText.fileNotSelected));
      }

      final fileBytes = result.files.first.bytes;
      if (fileBytes == null) {
        throw Exception(context.trSafe(ErrorText.cannotReadFile));
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

      // --- Sử dụng compute để mapping batch các dòng CSV ---
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
      final futures = mappedRows.map((row) async {
        try {
          final account = AccountOjbModel(title: row['title'], email: row['email'], password: row['password'], notes: row['notes'], categoryOjbModel: newCategory);
          await accountProvider.createOrUpdateAccount(account);
          return true;
        } catch (e) {
          return false;
        }
      });
      final results = await Future.wait(futures);
      int successCount = results.where((r) => r).length;

      // Refresh danh sách account
      await accountProvider.refreshAccounts();
      // Hiển thị thông báo thành công
      if (context.mounted) {
        context.read<CategoryProvider>().getCategories();
        hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import successfully $successCount accounts'), backgroundColor: Colors.green));
      }
      canLockApp = true;
    } catch (e) {
      canLockApp = true;
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
  static Future<bool> backupData(BuildContext context, String pin) async {
    try {
      await EncryptAppDataService.instance.initialize();
      final safeContext = GlobalKeys.appRootNavigatorKey.currentContext ?? context;
      // Check permissions first
      if (!await PermissionService.instance.requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      showLoadingDialog();

      // Generate backup file name with timestamp
      final dateTime = DateTime.now().toString().replaceAll(RegExp(r'[:\s]'), '-');
      final backupName = 'cybersafe_backup_$dateTime';
      final fileName = "$backupName.enc";

      // Create backup data
      final backupService = EncryptAppDataService.instance;
      final backup = await backupService.createBackup(pin, backupName);
      // --- Sử dụng compute để mã hóa dữ liệu backup (utf8.encode) ---
      final backupJsonBytes = await compute(_encodeBackupInIsolate, backup);
      final encryptedData = EncryptService.instance.encryptDataBytes(data: backupJsonBytes, key: Env.backupFileEncryptKey);

      // Get backup directory
      final downloadDir = await getDownloadDirectory();
      final backupDir = Directory(path.join(downloadDir.path, 'cyber_safe/backups'));

      // Create directories if they don't exist
      if (!backupDir.existsSync()) {
        await backupDir.create(recursive: true);
      }

      // Save file using FilePicker
      final filePath = await FilePicker.platform.saveFile(dialogTitle: 'Save Backup File', fileName: fileName, initialDirectory: backupDir.path, bytes: Uint8List.fromList(encryptedData));

      if (filePath == null) {
        throw Exception('Backup cancelled by user');
      }

      if (!safeContext.mounted) return false;

      hideLoadingDialog();
      await Future.delayed(const Duration(milliseconds: 100));
      if (safeContext.mounted) {
        SecureApplicationUtil.instance.unlock();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup data successful'), backgroundColor: Colors.green, duration: const Duration(seconds: 3)));
      }
      return true;
    } catch (e) {
      hideLoadingDialog();
      SecureApplicationUtil.instance.unlock();
      logError('Backup failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
      }
      return false;
    }
  }

  static Future<bool> restoreData(BuildContext context) async {
    try {
      canLockApp = false;
      // Bước 1: Chọn file
      FilePickerResult? result = await FilePickerUtils.pickFile(type: FileType.any);
      if (result == null || result.files.isEmpty) {
        throw Exception(context.trSafe(ErrorText.fileNotSelected));
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception('File not found');
      }
      // Kiểm tra đuôi file
      if (!filePath.endsWith('.enc')) {
        throw Exception('File is not a backup file');
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
        dataBackup = EncryptService.instance.decryptDataBytes(encryptedData: encryptedBytes, key: Env.backupFileEncryptKey);
      } catch (e) {
        throw Exception('Backup data is not valid or corrupted');
      }
      // --- Sử dụng compute để chuyển đổi dữ liệu sang JSON (utf8.decode) ---
      String jsonString;
      try {
        jsonString = await compute(_decodeBackupInIsolate, dataBackup);
        // Kiểm tra xem có phải JSON hợp lệ không
        final jsonData = jsonDecode(jsonString);
        if (!jsonData.containsKey('type') || jsonData['type'] != 'CYBERSAFE_BACKUP') {
          throw Exception('Backup data is not valid');
        }
      } catch (e) {
        throw Exception('Backup data is not valid: \\${e.toString()}');
      }

      // Bước 5: Hiển thị màn hình nhập PIN
      if (!context.mounted) return false;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return LoginMasterPassword(
              showBiometric: false,
              isFromRestore: true,
              callBackLoginCallback: ({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey}) async {
                if (isLoginSuccess == true && pin != null && GlobalKeys.appRootNavigatorKey.currentContext != null) {
                  try {
                    ValueNotifier<double>? loadingProgress = ValueNotifier<double>(0.0);
                    showLoadingDialog(context: GlobalKeys.appRootNavigatorKey.currentContext!, loadingProgress: loadingProgress);
                    await Future.delayed(const Duration(milliseconds: 50)); // Cho UI kịp render loading
                    // Bước 6: Kiểm tra PIN và khôi phục dữ liệu
                    final result = await EncryptAppDataService.instance.restoreBackup(
                      jsonString,
                      pin,
                      onIncorrectPin: () {
                        if (appPinCodeKey != null && context.mounted) {
                          appPinCodeKey.currentState?.triggerErrorAnimation();
                        }
                      },
                      onRestoreProgress: (progress) {
                        final contextRoot = GlobalKeys.appRootNavigatorKey.currentContext ?? context;
                        if (contextRoot.mounted) {
                          loadingProgress.value = progress;
                        }
                      },
                    );
                    if (!context.mounted) return;
                    if (result) {
                      loadingProgress.dispose();
                      hideLoadingDialog();
                      SecureApplicationUtil.instance.unlock();
                      Navigator.of(context).pop(true);
                    } else {
                      loadingProgress.dispose();
                      logError('Data restore failed');
                      throw Exception('Data restore failed');
                    }
                  } catch (e) {
                    logError('Restore data failed in catch: $e');
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.trSafe(ErrorText.restoreFailed)), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
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
      canLockApp = true;
      return true;
    } catch (e) {
      // Xử lý các lỗi chung
      canLockApp = true;
      hideLoadingDialog();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
      }
      logError('Restore data failed: $e');
      return false;
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
    final result = await showAppCustomDialog(
      context,
      AppCustomDialog(
        title: context.trSafe(SettingsLocale.deleteData),
        message: context.trSafe(SettingsLocale.deleteDataQuestion),
        confirmText: context.trSafe(SettingsLocale.deleteData),
        cancelText: context.trSafe(SettingsLocale.cancel),
        isCountDownTimer: false,
        canConfirmInitially: true,
      ),
    );
    if (result == true) {
      Navigator.of(GlobalKeys.appRootNavigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder:
              (context) => LoginMasterPassword(
                showBiometric: false,
                isFromDeleteData: true,
                callBackLoginCallback: ({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey}) async {
                  if (isLoginSuccess == true && pin != null) {
                    try {
                      final success = await deleteData();

                      if (success && context.mounted) {
                        // Làm mới dữ liệu
                        await context.read<CategoryProvider>().refresh();
                        context.read<AccountProvider>().refreshAccounts();
                        // Quay về home và xóa tất cả màn hình trước đó
                        // Hiển thị thông báo thành công
                        Navigator.of(context).pop();
                        showToastSuccess("Delete data successfully", context: context);
                      } else {
                        if (context.mounted) {
                          Navigator.of(context).pop(); // Đóng màn hình login
                          showToastError("Delete data failed", context: context);
                        }
                      }
                    } catch (e) {
                      logError('Lỗi trong quá trình xóa dữ liệu: $e');
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Đóng màn hình login
                        showToastError("Delete data failed", context: context);
                      }
                    }
                  } else {
                    // Trường hợp hủy hoặc login thất bại
                    if (context.mounted) {
                      Navigator.of(context).pop(); // Đóng màn hình login
                    }
                  }
                },
              ),
        ),
      );
    }
  }

  static Future<bool> transferData(BuildContext context) async {
    try {
      if (!await PermissionService.instance.requestStoragePermission()) {
        return false;
      }
      logInfo('requestStoragePermission: ${await PermissionService.instance.requestStoragePermission()}');
      showLoadingDialog();
      final backupService = EncryptAppDataService.instance;
      final backup = await backupService.createBackup(Env.transferFileEncryptKey, "cyber_safe_transfer", isTransfer: true);

      final backupJson = jsonEncode(backup);
      final codeEncrypted = EncryptService.instance.encryptDataBytes(data: utf8.encode(backupJson), key: Env.backupFileEncryptKey);

      // Save file using FilePicker
      await FilePicker.platform.saveFile(dialogTitle: 'Save Backup File', fileName: transferFileName, bytes: Uint8List.fromList(codeEncrypted));
      launchProApp(context);
      return true;
    } catch (e) {
      hideLoadingDialog();
      logError('Error transfer data: ${e.toString()}');
      return false;
    }
  }

  //import transfer data
  static Future<bool> importTransferData() async {
    try {
      FilePickerResult? result = await FilePickerUtils.pickFile(type: FileType.any);
      if (result == null || result.files.isEmpty) {
        throw Exception('File not selected');
      }
      Directory? directory = Directory(result.files.first.path!);
      if (directory.path.isEmpty) {
        throw Exception('File not selected');
      }
      //yêu cầu đuôi file
      if (!directory.path.endsWith('.enc')) {
        throw Exception('File is not a transfer file');
      }
      String filePath = directory.path;
      // 2. Kiểm tra file
      File file = File(filePath);
      logInfo('Checking file at: ${file.path}');

      if (!file.existsSync()) {
        // Log thêm thông tin để debug
        final dir = file.parent;
        final dirExists = await dir.exists();
        final dirContents = dirExists ? await dir.list().toList() : [];

        logError('''
          File not found at: ${file.path}
          Parent directory exists: $dirExists
          Parent directory path: ${dir.path}
          Directory contents: ${dirContents.map((e) => e.path).join('\n')}
      ''');

        throw Exception("${file.path} not found");
      }

      // 3. Đọc file với try-catch chi tiết
      List<int> fileBytes;
      try {
        fileBytes = file.readAsBytesSync();
        logInfo('Successfully read ${fileBytes.length} bytes from file');
      } catch (e) {
        logError('Error reading file: $e');
        throw Exception("Cannot read file: $e");
      }

      ValueNotifier<double>? loadingProgress = ValueNotifier<double>(0.0);

      showLoadingDialog(loadingProgress: loadingProgress);

      // 4. Giải mã và xử lý dữ liệu
      List<int> dataBackup = EncryptService.instance.decryptDataBytes(encryptedData: fileBytes, key: Env.backupFileEncryptKey);

      if (dataBackup.isEmpty) {
        throw Exception("Decrypted data is empty");
      }

      String jsonString = utf8.decode(dataBackup);

      // 5. Khôi phục dữ liệu
      final resultRestore = await EncryptAppDataService.instance.restoreBackup(
        jsonString,
        Env.transferFileEncryptKey,
        onRestoreProgress: (progress) {
          if (GlobalKeys.appRootNavigatorKey.currentContext != null) {
            loadingProgress.value = progress;
          }
        },
      );

      // 6. Xử lý kết quả
      if (resultRestore) {
        // Xóa file sau khi restore thành công
        try {
          await file.delete(recursive: true);
        } catch (e) {
          for (var file in directory.listSync(recursive: true)) {
            if (file.path.endsWith('.enc')) {
              try {
                await file.delete(recursive: true);
              } catch (e) {
                logError('Error delete file: ${e.toString()}');
              }
            }
          }
          logError('Warning: Could not delete transfer file: $e');
        }
        Navigator.of(GlobalKeys.appRootNavigatorKey.currentContext!).pop();
        loadingProgress.dispose();
        await GlobalKeys.appRootNavigatorKey.currentContext!.read<CategoryProvider>().refresh();
        GlobalKeys.appRootNavigatorKey.currentContext!.read<AccountProvider>().refreshAccounts();
        hideLoadingDialog();
        return true;
      } else {
        hideLoadingDialog();
        return false;
      }
    } catch (e, stackTrace) {
      hideLoadingDialog();
      logError('Error import transfer data: ${e.toString()}\nStack trace: $stackTrace');
      return false;
    }
  }

  static Future<void> launchProApp(BuildContext context) async {
    final proAppScheme = 'cybersafepro://transfer';
    openUrl(
      proAppScheme,
      context: context,
      onError: (error) {
        openUrl(AppConfig.proPlayStoreUrl, context: context);
      },
    );
  }

  static Future<Directory> getSharedDirectory() async {
    // Kiểm tra quyền trước
    await PermissionService.instance.requestStoragePermission();

    Directory downloadDirectory = await getDownloadDirectory();
    final transferDir = Directory(path.join(downloadDirectory.path, "cyber_safe"));
    final transferFolder = Directory(path.join(transferDir.path, TRANSFER_FOLDER));

    // Đảm bảo thư mục tồn tại
    if (!transferFolder.existsSync()) {
      try {
        await transferFolder.create(recursive: true);
        logInfo('Created directory: ${transferFolder.path}');
      } catch (e) {
        logError('Error creating directory: $e');
        // Thử tạo thư mục trong bộ nhớ ứng dụng nếu không tạo được trong Downloads
        final appDir = await getApplicationDocumentsDirectory();
        final appTransferDir = Directory(path.join(appDir.path, TRANSFER_FOLDER));
        if (!appTransferDir.existsSync()) {
          await appTransferDir.create(recursive: true);
        }
        return appTransferDir;
      }
    }

    // Kiểm tra quyền ghi vào thư mục
    try {
      final testFile = File('${transferDir.path}/test_permission.txt');
      await testFile.writeAsString('test');
      await testFile.delete();
      logInfo('Transfer directory: ${transferDir.path}');
      return transferDir;
    } catch (e) {
      logError('No write permission to directory: $e');
      // Sử dụng thư mục ứng dụng thay thế
      final appDir = await getApplicationDocumentsDirectory();
      final appTransferDir = Directory(path.join(appDir.path, TRANSFER_FOLDER));
      if (!appTransferDir.existsSync()) {
        await appTransferDir.create(recursive: true);
      }
      return appTransferDir;
    }
  }

  static deleteFile(String filePath) {
    File file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}

// --- Top-level functions for compute (Isolate) ---
String _decodeBackupInIsolate(List<int> dataBackup) {
  return utf8.decode(dataBackup);
}

List<int> _encodeBackupInIsolate(Map<String, dynamic> backup) {
  final backupJson = jsonEncode(backup);
  return utf8.encode(backupJson);
}

List<Map<String, dynamic>> _mapCsvRowsInIsolate(Map<String, dynamic> args) {
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
    final title = row[nameIndex].toString().trim();
    final url = row[urlIndex].toString().trim();
    final username = row[usernameIndex].toString().trim();
    final password = row[passwordIndex].toString().trim();
    final note = row[noteIndex].toString().trim();
    if (title.isEmpty || username.isEmpty || password.isEmpty) continue;
    final importNote = note.isEmpty ? url : note;
    result.add({'title': title, 'email': username, 'password': password, 'notes': importNote, 'categoryName': categoryName, 'categoryId': categoryId});
  }
  return result;
}

// --- End top-level functions ---
