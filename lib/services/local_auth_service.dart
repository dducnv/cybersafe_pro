import 'dart:io' show Platform;

import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthConfig {
  static final instance = LocalAuthConfig._internal();

  LocalAuthConfig._internal();

  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  bool? _isOpenUseBiometric;
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;

  bool get isAvailableBiometrics {
    logInfo("isAvailableBiometrics: $_canCheckBiometrics $_availableBiometrics");
    if (_canCheckBiometrics != true) return false;
    if (_availableBiometrics == null) return false;

    if (Platform.isIOS) {
      return _availableBiometrics!.contains(BiometricType.face) ||
          _availableBiometrics!.contains(BiometricType.strong);
    } else {
      return _availableBiometrics!.contains(BiometricType.fingerprint) ||
          _availableBiometrics!.contains(BiometricType.strong);
    }
  }

  bool get isOpenUseBiometric => _isOpenUseBiometric!;
  bool get isAuthenticating => _isAuthenticating;

  List<BiometricType> get availableBiometrics => _availableBiometrics!;

  bool get isFaceId =>
      Platform.isIOS && _availableBiometrics?.contains(BiometricType.face) == true ||
      _availableBiometrics?.contains(BiometricType.strong) == true;

  bool get isFingerprint =>
      Platform.isAndroid && _availableBiometrics?.contains(BiometricType.fingerprint) == true ||
      _availableBiometrics?.contains(BiometricType.strong) == true;

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
      _canCheckBiometrics = false;
    }
    return _canCheckBiometrics!;
  }

  Future<void> openUseBiometric() async {
    bool? enableLocalAuth = await SecureStorage.instance.readBool(
      SecureStorageKey.isEnableLocalAuth,
    );
    _isOpenUseBiometric = enableLocalAuth ?? false;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (_availableBiometrics != null) {
      return _availableBiometrics!;
    }
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      if (Platform.isIOS) {
        availableBiometrics.removeWhere(
          (type) => type != BiometricType.face && type != BiometricType.strong,
        );
      } else {
        availableBiometrics.removeWhere(
          (type) => type != BiometricType.fingerprint && type != BiometricType.strong,
        );
      }
    } on PlatformException catch (e) {
      logError("error getAvailableBiometrics: $e");
      availableBiometrics = [];
    }
    _availableBiometrics = availableBiometrics;
    return _availableBiometrics!;
  }

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

    if (_isAuthenticating) {
      logInfo("Authentication already in progress, cancelling previous attempt");
      await cancelAuthentication();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    bool authenticated = false;
    try {
      _isAuthenticating = true;
      final String reason = Platform.isIOS
          ? 'Kindly use Face ID for authentication'
          : 'Kindly scan your fingerprint for authentication';
      authenticated = await auth.authenticate(localizedReason: reason, biometricOnly: true);
    } on PlatformException catch (e) {
      logError("error authenticate: $e");
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

  Future<bool> hasBiometrics() async {
    final availableBiometrics = await getAvailableBiometrics();
    if (Platform.isIOS) {
      return availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.strong);
    }
    return availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.strong);
  }

  Future<void> setUseBiometric(bool enable) async {
    await SecureStorage.instance.save(
      key: SecureStorageKey.isEnableLocalAuth,
      value: enable.toString(),
    );
    _isOpenUseBiometric = enable;
  }
}
