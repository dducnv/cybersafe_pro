import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class LocalAuthConfig {
  static final instance = LocalAuthConfig._internal();

  LocalAuthConfig._internal();

  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  bool? _isOpenUseBiometric;
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;

  // Kiểm tra xem thiết bị có hỗ trợ phương thức xác thực phù hợp không
  bool get isAvailableBiometrics {
    logInfo("isAvailableBiometrics: $_canCheckBiometrics $_availableBiometrics");
    if (_canCheckBiometrics != true) return false;
    if (_availableBiometrics == null) return false;

    if (Platform.isIOS) {
      return _availableBiometrics!.contains(BiometricType.face) || _availableBiometrics!.contains(BiometricType.strong);
    } else {
      return _availableBiometrics!.contains(BiometricType.fingerprint) || _availableBiometrics!.contains(BiometricType.strong);
    }
  }

  bool get isOpenUseBiometric => _isOpenUseBiometric!;
  bool get isAuthenticating => _isAuthenticating;

  List<BiometricType> get availableBiometrics => _availableBiometrics!;

  // Kiểm tra xem có phải là Face ID không (chỉ cho iOS)
  bool get isFaceId => Platform.isIOS && _availableBiometrics?.contains(BiometricType.face) == true || _availableBiometrics?.contains(BiometricType.strong) == true;

  // Kiểm tra xem có phải là vân tay không (chỉ cho Android)
  bool get isFingerprint => Platform.isAndroid && _availableBiometrics?.contains(BiometricType.fingerprint) == true || _availableBiometrics?.contains(BiometricType.strong) == true;

  String get biometricMethod {
    if (Platform.isIOS) return 'Face ID';
    return 'vân tay';
  }

  Future<void> init() async {
    await canCheckBiometrics;
    await getAvailableBiometrics();
    await openUseBiometric();
    await hasBiometrics();
  }

  Future<bool> get canCheckBiometrics async {
    if (_canCheckBiometrics != null) {
      return _canCheckBiometrics!;
    }
    try {
      _canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException {
      // customLogger(msg: "canCheckBiometrics: $e", typeLogger: TypeLogger.error);
      _canCheckBiometrics = false;
    }
    return _canCheckBiometrics!;
  }

  Future<void> openUseBiometric() async {
    bool? enableLocalAuth = await SecureStorage.instance.readBool(SecureStorageKey.isEnableLocalAuth);
    _isOpenUseBiometric = enableLocalAuth ?? false;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (_availableBiometrics != null) {
      return _availableBiometrics!;
    }
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      // Lọc phương thức xác thực theo platform
      if (Platform.isIOS) {
        // Chỉ giữ lại Face ID cho iOS
        availableBiometrics.removeWhere((type) => type != BiometricType.face && type != BiometricType.strong);
      } else {
        // Chỉ giữ lại vân tay cho Android
        availableBiometrics.removeWhere((type) => type != BiometricType.fingerprint && type != BiometricType.strong);
      }
    } on PlatformException catch (e) {
      logError("error getAvailableBiometrics: $e");
      availableBiometrics = [];
    }
    _availableBiometrics = availableBiometrics;
    return _availableBiometrics!;
  }

  // Hủy xác thực hiện tại nếu đang diễn ra
  Future<bool> cancelAuthentication() async {
    if (!_isAuthenticating) {
      return true;
    }
    
    try {
      _isAuthenticating = false;
      return await auth.stopAuthentication();
    } on PlatformException catch (e) {
      logError("error cancelAuthentication: $e");
      return false;
    }
  }

  Future<bool> authenticate() async {
    if (!isAvailableBiometrics) {
      return false;
    }

    // Kiểm tra xem đã có quá trình xác thực đang diễn ra không
    if (_isAuthenticating) {
      logInfo("Authentication already in progress, cancelling previous attempt");
      await cancelAuthentication();
      // Đợi một chút để đảm bảo quá trình xác thực trước đó đã bị hủy
      await Future.delayed(const Duration(milliseconds: 300));
    }

    bool authenticated = false;
    try {
      _isAuthenticating = true;
      final String reason = Platform.isIOS 
          ? 'Vui lòng sử dụng Face ID để xác thực' 
          : 'Vui lòng quét vân tay để xác thực';

      authenticated = await auth.authenticate(
        localizedReason: reason, 
        options: const AuthenticationOptions(
          stickyAuth: true, 
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      logError("error authenticate: $e");
      // Xử lý riêng lỗi auth_in_progress
      if (e.code == 'auth_in_progress') {
        logInfo("Authentication already in progress, retrying after cancel");
        await cancelAuthentication();
        await Future.delayed(const Duration(milliseconds: 500));
        return authenticate(); // Thử lại sau khi hủy
      }
      authenticated = false;
    } finally {
      _isAuthenticating = false;
    }
    
    return authenticated;
  }

  // Kiểm tra xem thiết bị có hỗ trợ phương thức xác thực phù hợp không
  Future<bool> hasBiometrics() async {
    final availableBiometrics = await getAvailableBiometrics();
    if (Platform.isIOS) {
      return availableBiometrics.contains(BiometricType.face) || availableBiometrics.contains(BiometricType.strong);
    }
    return availableBiometrics.contains(BiometricType.fingerprint) || availableBiometrics.contains(BiometricType.strong);
  }

  // Lưu trạng thái sử dụng sinh trắc học
  Future<void> setUseBiometric(bool enable) async {
    await SecureStorage.instance.save(key: SecureStorageKey.isEnableLocalAuth, value: enable.toString());
    _isOpenUseBiometric = enable;
  }
}
