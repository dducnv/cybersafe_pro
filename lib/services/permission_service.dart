import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final instance = PermissionService._();
  PermissionService._();

  Future<bool> requestStoragePermission() async {
    try {
      var storageStatus = await Permission.storage.status;
      if (storageStatus.isDenied) {
        storageStatus = await Permission.storage.request();
      }
      return storageStatus.isGranted;
    } catch (e) {
      debugPrint('Lỗi khi yêu cầu quyền: $e');
      return false;
    }
  }

  Future<bool> checkStoragePermission() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        return true;
      }

      if (androidInfo.version.sdkInt >= 29) {
        return await Permission.manageExternalStorage.isGranted;
      }

      return await Permission.storage.isGranted;
    } catch (e) {
      debugPrint('Lỗi khi kiểm tra quyền: $e');
      return false;
    }
  }
} 