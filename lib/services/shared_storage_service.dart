import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SharedStorageService {
  static const String transferFileName = 'app_transfer_data.json';
  
  // Kiểm tra và yêu cầu quyền truy cập storage
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS không cần quyền explicit
  }

  // Lấy thư mục shared để lưu trữ
  Future<Directory> getSharedDirectory() async {
    if (Platform.isAndroid) {
      // Trên Android, sử dụng external storage
      return await getExternalStorageDirectory() 
          ?? await getApplicationDocumentsDirectory();
    } else {
      // Trên iOS, sử dụng application documents directory
      return await getApplicationDocumentsDirectory();
    }
  }

  // Export data từ app Lite
  Future<String> exportData(Map<String, dynamic> data) async {
    try {
      // Kiểm tra quyền
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission not granted');
      }

      // Lấy thư mục shared
      final directory = await getSharedDirectory();
      final file = File('${directory.path}/$transferFileName');

      // Mã hóa và lưu dữ liệu
      final jsonData = jsonEncode(data);
      await file.writeAsString(jsonData);

      return file.path;
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  // Import data vào app Pro
  Future<Map<String, dynamic>> importData() async {
    try {
      // Kiểm tra quyền
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission not granted');
      }

      // Lấy thư mục shared
      final directory = await getSharedDirectory();
      final file = File('${directory.path}/$transferFileName');

      // Kiểm tra file tồn tại
      if (!await file.exists()) {
        throw Exception('Transfer file not found');
      }

      // Đọc và giải mã dữ liệu
      final jsonData = await file.readAsString();
      final data = jsonDecode(jsonData) as Map<String, dynamic>;

      // Xóa file sau khi đọc xong
      await file.delete();

      return data;
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }
}