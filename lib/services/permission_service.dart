import 'package:cybersafe_pro/utils/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final instance = PermissionService._();
  PermissionService._();

  Future<bool> requestStoragePermission() async {
    try {
      final isGranted = await checkStoragePermission();
      if (isGranted) {
        return true;
      }
      final permission = Permission.storage;
      final status = await permission.status;
      if (status != PermissionStatus.granted) {
        final result = await permission.request();
        logInfo('storageStatus request: ${result.isGranted}');
        return result.isGranted;
      }
      logInfo('storageStatus: ${status.isGranted}');
      return status.isGranted;
    } catch (e) {
      logError('Lỗi khi yêu cầu quyền: $e');
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
      logError('Lỗi khi kiểm tra quyền: $e');
      return false;
    }
  }
}
