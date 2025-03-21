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

  // Kiểm tra xem thiết bị có hỗ trợ phương thức xác thực phù hợp không
  bool get isAvailableBiometrics {
    if (_canCheckBiometrics != true) return false;
    if (_availableBiometrics == null) return false;

    if (Platform.isIOS) {
      return _availableBiometrics!.contains(BiometricType.face);
    } else {
      return _availableBiometrics!.contains(BiometricType.fingerprint);
    }
  }

  bool get isOpenUseBiometric => _isOpenUseBiometric!;

  List<BiometricType> get availableBiometrics => _availableBiometrics!;

  // Kiểm tra xem có phải là Face ID không (chỉ cho iOS)
  bool get isFaceId => Platform.isIOS && 
      _availableBiometrics?.contains(BiometricType.face) == true;

  // Kiểm tra xem có phải là vân tay không (chỉ cho Android)
  bool get isFingerprint => Platform.isAndroid && 
      _availableBiometrics?.contains(BiometricType.fingerprint) == true;

  String get biometricMethod {
    if (Platform.isIOS) return 'Face ID';
    return 'vân tay';
  }

  Future<void> init() async {
    await canCheckBiometrics;
    await getAvailableBiometrics();
    await openUseBiometric();
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
    String? enableLocalAuth = await SecureStorage.instance
        .read(key: SecureStorageKeys.isEnableLocalAuth.name);
    if (enableLocalAuth == null || enableLocalAuth == "false") {
      _isOpenUseBiometric = false;
    } else {
      _isOpenUseBiometric = true;
    }
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
        availableBiometrics.removeWhere((type) => type != BiometricType.face);
      } else {
        // Chỉ giữ lại vân tay cho Android
        availableBiometrics.removeWhere((type) => type != BiometricType.fingerprint);
      }
    } on PlatformException {
      availableBiometrics = [];
    }
    _availableBiometrics = availableBiometrics;
    return _availableBiometrics!;
  }

  Future<bool> authenticate() async {
    if (!isAvailableBiometrics) {
      return false;
    }

    bool authenticated = false;
    try {
      final String reason = Platform.isIOS
          ? 'Vui lòng sử dụng Face ID để xác thực'
          : 'Vui lòng quét vân tay để xác thực';

      authenticated = await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
    } on PlatformException {
      return false;
    }
    return authenticated;
  }

  // Kiểm tra xem thiết bị có hỗ trợ phương thức xác thực phù hợp không
  Future<bool> hasBiometrics() async {
    final availableBiometrics = await getAvailableBiometrics();
    if (Platform.isIOS) {
      return availableBiometrics.contains(BiometricType.face);
    }
    return availableBiometrics.contains(BiometricType.fingerprint);
  }

  // Lưu trạng thái sử dụng sinh trắc học
  Future<void> setUseBiometric(bool enable) async {
    await SecureStorage.instance.save(
      key: SecureStorageKeys.isEnableLocalAuth.name,
      value: enable.toString(),
    );
    _isOpenUseBiometric = enable;
  }
}
