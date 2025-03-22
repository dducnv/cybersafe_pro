import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/env/env.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_utils.dart';
import 'package:cybersafe_pro/services/permission_service.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
        throw Exception("Không có file nào được chọn");
      }

      final fileBytes = result.files.first.bytes;
      if (fileBytes == null) {
        throw Exception("Không thể đọc file");
      }

      // Thử các encoding khác nhau
      String csvString;
      try {
        csvString = utf8.decode(fileBytes);
      } catch (_) {
        try {
          csvString = latin1.decode(fileBytes);
        } catch (_) {
          throw Exception("Không thể đọc nội dung file, vui lòng kiểm tra encoding");
        }
      }

      if (csvString.isEmpty) {
        throw Exception("File CSV trống");
      }

      // Chuyển đổi CSV thành List với các tùy chọn phù hợp
      final csvConverter = CsvToListConverter(
        shouldParseNumbers: false, // Không tự động chuyển số
        fieldDelimiter: ',', // Dấu phân cách cột
        eol: '\n', // Dấu xuống dòng
      );

      final csvTable = csvConverter.convert(csvString, shouldParseNumbers: false);

      if (csvTable.isEmpty) {
        throw Exception("File CSV không có dữ liệu");
      }

      // Kiểm tra header
      final header = csvTable.first.map((e) => e.toString().toLowerCase().trim()).toList();
      final requiredColumns = ['name', 'url', 'username', 'password', 'note'];

      // Kiểm tra xem có đủ các cột cần thiết không
      if (!requiredColumns.every((col) => header.contains(col))) {
        throw Exception("File CSV không đúng định dạng. Cần có các cột: name, url, username, password, note");
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import thành công $successCount tài khoản'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red));
      }
    }
  }

  //backup data
  static Future<void> backupData(BuildContext context, String pin) async {
    try {
      if (!await PermissionService.instance.requestStoragePermission()) {
        return;
      }

      var statusManageExternalStorage = await Permission.manageExternalStorage.status;
      if (!statusManageExternalStorage.isGranted) {
        statusManageExternalStorage = await Permission.manageExternalStorage.request();
      }
      showLoadingDialog();
      final backupName = 'backup_cybersafe_${DateTime.now().toIso8601String()}';
      final backupService = EncryptAppDataService.instance;
      final backup = await backupService.createBackup(pin, backupName);
      final fileName = "$backupName.enc";

      // Tạo thư mục cyber_safe
      final directory = (await getExternalStorageDirectories(type: StorageDirectory.downloads))?.first;
      if (directory == null) {
        throw Exception('Không thể xác định thư mục lưu file');
      }
      final backupDir = Directory(path.join(directory.path, 'cyber_safe'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Lưu file
      final backupFile = File('${backupDir.path}/$fileName');
      final backupJson = jsonEncode(backup);
      final codeEncrypted = OldEncryptUtils.instance.encryptFernetBytes(data: utf8.encode(backupJson), key: Env.fileEncryptKey);
      await backupFile.writeAsBytes(codeEncrypted);

      if (context.mounted) {
        hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã sao lưu thành công vào ${backupFile.path}'), backgroundColor: Colors.green, duration: const Duration(seconds: 2)));
        Navigator.of(context).pop();
      }
    } catch (e) {
      hideLoadingDialog();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
      }
    }
  }

  Future<bool> requestPermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33 ? await Permission.storage.request() : PermissionStatus.granted;

    if (storageStatus == PermissionStatus.granted) {
      return true;
    }
    if (storageStatus == PermissionStatus.denied) {
      return false;
    }
    if (storageStatus == PermissionStatus.permanentlyDenied) {
      bool? result = await openAppSettings();
      return result;
    }
    return false;
  }

  static Future<void> restoreData(BuildContext context) async {
    try {
      // Bước 1: Chọn file
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result == null || result.files.isEmpty) {
        throw Exception('Không có file nào được chọn');
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception('Không tìm thấy file');
      }

      // Bước 2: Đọc và giải mã file
      File file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File không tồn tại');
      }

      List<int> encryptedBytes;
      try {
        encryptedBytes = file.readAsBytesSync();
      } catch (e) {
        throw Exception('Không thể đọc file: ${e.toString()}');
      }

      // Bước 3: Giải mã dữ liệu file
      List<int> dataBackup;
      try {
        dataBackup = OldEncryptUtils.instance.decryptFernetBytes(encryptedData: encryptedBytes, key: Env.fileEncryptKey);
      } catch (e) {
        throw Exception('File backup không hợp lệ hoặc đã bị hỏng');
      }

      // Bước 4: Chuyển đổi dữ liệu sang JSON
      String jsonString;
      try {
        jsonString = utf8.decode(dataBackup);
        // Kiểm tra xem có phải JSON hợp lệ không
        final jsonData = jsonDecode(jsonString);
        if (!jsonData.containsKey('type') || jsonData['type'] != 'CYBERSAFE_BACKUP') {
          throw Exception('File backup không đúng định dạng');
        }
      } catch (e) {
        throw Exception('Dữ liệu backup không hợp lệ: ${e.toString()}');
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
                if (isLoginSuccess == true && pin != null) {
                  try {
                    // Bước 6: Kiểm tra PIN và khôi phục dữ liệu
                    final result = await EncryptAppDataService.instance.restoreBackup(jsonString, pin);
                    if (!context.mounted) return;
                    if (result) {
                      // Bước 7: Khôi phục thành công
                      context.read<AccountProvider>().refreshAccounts();
                      context.read<CategoryProvider>().getCategories();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Khôi phục dữ liệu thành công'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                    } else {
                      throw Exception('Khôi phục dữ liệu thất bại');
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    if (e.toString().contains('PIN_INCORRECT')) {
                      appPinCodeKey?.currentState?.triggerErrorAnimation();
                    } else {
                      // Các lỗi khác trong quá trình khôi phục
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khôi phục: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
                    }
                  }
                } else {
                  // Trường hợp không nhập PIN hoặc hủy
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã hủy khôi phục dữ liệu'), backgroundColor: Colors.orange, duration: Duration(seconds: 2)));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
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
  Future<void> deleteData() async {
    // TODO: Implement delete data
  }
}
