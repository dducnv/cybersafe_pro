import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/secure/encrypt/encryption_config.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as pc;

class SecureAppManager {
  static final instance = SecureAppManager._internal();
  SecureAppManager._internal();

  Uint8List? _rootMasterKey;
  bool _isAuthenticated = false;
  DateTime? _lastActivity;

  static const Duration _sessionTimeout = Duration(hours: 24);

  static Future<bool> initializeNewUser(String pin) async {
    try {
      final pinSaved = await instance._savePIN(pin);
      if (!pinSaved) {
        logError('Không thể lưu PIN', functionName: 'SecureAppManager.initializeNewUser');
        return false;
      }

      final sessionInitialized = await instance._initializeSession(pin);
      if (!sessionInitialized) {
        logError('Không thể khởi tạo session', functionName: 'SecureAppManager.initializeNewUser');
        return false;
      }

      logInfo('Người dùng mới đã được khởi tạo thành công');
      return true;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khởi tạo người dùng mới: $e\n$stackTrace',
        functionName: 'SecureAppManager.initializeNewUser',
      );
      return false;
    }
  }

  static Future<bool> authenticateUser([String? pin]) async {
    try {
      final isAuthenticated = await instance._authenticate(pin);
      if (!isAuthenticated) {
        logError('Xác thực thất bại', functionName: 'SecureAppManager.authenticateUser');
        return false;
      }

      final sessionInitialized = await instance._initializeSession(pin);
      if (!sessionInitialized) {
        logError('Không thể khởi tạo session', functionName: 'SecureAppManager.authenticateUser');
        return false;
      }

      logInfo('Người dùng đã được xác thực thành công');
      await DriffDbManager.instance.init();
      return true;
    } catch (e, stackTrace) {
      logError(
        'Lỗi xác thực người dùng: $e\n$stackTrace',
        functionName: 'SecureAppManager.authenticateUser',
      );
      return false;
    }
  }

  static Future<bool> enableBiometric() async {
    try {
      return await instance._enableBiometric();
    } catch (e, stackTrace) {
      logError(
        'Lỗi bật biometric: $e\n$stackTrace',
        functionName: 'SecureAppManager.enableBiometric',
      );
      return false;
    }
  }

  static Future<bool> disableBiometric() async {
    try {
      return await instance._disableBiometric();
    } catch (e, stackTrace) {
      logError(
        'Lỗi tắt biometric: $e\n$stackTrace',
        functionName: 'SecureAppManager.disableBiometric',
      );
      return false;
    }
  }

  static Future<bool> changePIN(String oldPIN, String newPIN) async {
    try {
      return await instance._changePIN(oldPIN, newPIN);
    } catch (e, stackTrace) {
      logError('Lỗi đổi PIN: $e\n$stackTrace', functionName: 'SecureAppManager.changePIN');
      return false;
    }
  }

  static bool isSessionValid() {
    return instance._isSessionValid();
  }

  static Future<void> logout() async {
    try {
      await instance._clearSession();
      logInfo('Đã logout thành công');
    } catch (e, stackTrace) {
      logError('Lỗi logout: $e\n$stackTrace', functionName: 'SecureAppManager.logout');
    }
  }

  static Future<bool> isPINSet() async {
    return await instance._isPINSet();
  }

  static Future<bool> isBiometricEnabled() async {
    return await instance._isBiometricEnabled();
  }

  static bool isBiometricAvailable() {
    return instance._isBiometricAvailable();
  }

  static Future<Uint8List?> getRootMasterKey() async {
    return instance._rootMasterKey;
  }

  Future<bool> _savePIN(String pin) async {
    try {
      if (pin.isEmpty || pin.length < 4) {
        throw ArgumentError('PIN phải có ít nhất 4 ký tự');
      }

      final pinSalt = _generateSecureRandomBytes(EncryptionConfig.saltLength);

      final pinHash = await compute(_hashPINInIsolate, {
        'pin': pin,
        'salt': base64.encode(pinSalt),
        'memoryPowerOf2': EncryptionConfig.memoryPowerOf2,
        'iterations': EncryptionConfig.iterations,
        'parallelism': EncryptionConfig.parallelism,
        'desiredLength': EncryptionConfig.pinHashLength,
      });

      final success = await _generateAndSaveRootMasterKey(pin);
      if (!success) {
        throw Exception('Không thể tạo Root Master Key');
      }

      await SecureStorage.instance.save(
        key: SecureStorageKey.pinSaltKey,
        value: base64.encode(pinSalt),
      );
      await SecureStorage.instance.save(key: SecureStorageKey.pinHashKey, value: pinHash);
      _secureWipe(pinSalt);

      logInfo('PIN đã được lưu an toàn với Argon2id hash');
      return true;
    } catch (e, stackTrace) {
      logError('Lỗi khi lưu PIN: $e\n$stackTrace', functionName: 'SecureAppManager._savePIN');
      return false;
    }
  }

  Future<bool> _authenticate([String? pin]) async {
    try {
      if (await _isBiometricEnabled()) {
        final biometricResult = await _authenticateWithBiometric();
        if (biometricResult) {
          logInfo('Xác thực bằng biometric thành công');
          return true;
        }
      }
      if (pin != null) {
        return await _verifyPIN(pin);
      }

      return false;
    } catch (e, stackTrace) {
      logError('Lỗi khi xác thực: $e\n$stackTrace', functionName: 'SecureAppManager._authenticate');
      return false;
    }
  }

  Future<bool> _verifyPIN(String pin) async {
    try {
      if (pin.isEmpty) return false;

      final saltBase64 = await SecureStorage.instance.read(key: SecureStorageKey.pinSaltKey);
      final storedHash = await SecureStorage.instance.read(key: SecureStorageKey.pinHashKey);

      if (saltBase64 == null || storedHash == null) {
        logError('PIN chưa được thiết lập', functionName: 'SecureAppManager._verifyPIN');
        return false;
      }

      final computedHash = await compute(_hashPINInIsolate, {
        'pin': pin,
        'salt': saltBase64,
        'memoryPowerOf2': EncryptionConfig.memoryPowerOf2,
        'iterations': EncryptionConfig.iterations,
        'parallelism': EncryptionConfig.parallelism,
        'desiredLength': EncryptionConfig.pinHashLength,
      });

      final isValid = _constantTimeEquals(computedHash, storedHash);

      if (!isValid) {
        logError('PIN không chính xác', functionName: 'SecureAppManager._verifyPIN');
      }

      return isValid;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khi xác thực PIN: $e\n$stackTrace',
        functionName: 'SecureAppManager._verifyPIN',
      );
      return false;
    }
  }

  Future<bool> _initializeSession([String? pin]) async {
    try {
      final rmk = await _getRootMasterKey(pin);
      if (rmk == null) {
        logError(
          'Không thể lấy Root Master Key',
          functionName: 'SecureAppManager._initializeSession',
        );
        return false;
      }

      _rootMasterKey = rmk;
      _isAuthenticated = true;
      _lastActivity = DateTime.now();

      logInfo('Session đã được khởi tạo thành công');
      return true;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khởi tạo session: $e\n$stackTrace',
        functionName: 'SecureAppManager._initializeSession',
      );
      return false;
    }
  }

  bool _isSessionValid() {
    if (!_isAuthenticated || _rootMasterKey == null) {
      return false;
    }

    if (_lastActivity != null) {
      final timeSinceLastActivity = DateTime.now().difference(_lastActivity!);
      if (timeSinceLastActivity > _sessionTimeout) {
        logInfo('Session đã hết hạn');
        return false;
      }
    }

    return true;
  }

  Future<Uint8List?> _getRootMasterKey([String? pin]) async {
    try {
      if (await _isBiometricEnabled()) {
        final rmk = await _getRootMasterKeyWithBiometric();
        if (rmk != null) {
          return rmk;
        }
      }

      if (pin != null) {
        return await _getRootMasterKeyWithPIN(pin);
      }

      return null;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khi lấy RMK: $e\n$stackTrace',
        functionName: 'SecureAppManager._getRootMasterKey',
      );
      return null;
    }
  }

  Future<bool> _enableBiometric() async {
    try {
      if (!_isBiometricAvailable()) {
        logError(
          'Thiết bị không hỗ trợ biometric',
          functionName: 'SecureAppManager._enableBiometric',
        );
        return false;
      }

      final biometricKey = _generateSecureRandomBytes(EncryptionConfig.biometricKeyLength);
      final biometricSalt = _generateSecureRandomBytes(32);

      final biometricKeyHash = await compute(_hashBiometricKeyInIsolate, {
        'key': base64.encode(biometricKey),
        'salt': base64.encode(biometricSalt),
        'memoryPowerOf2': EncryptionConfig.memoryPowerOf2,
        'iterations': EncryptionConfig.iterations,
        'desiredLength': EncryptionConfig.biometricKeyLength,
      });

      await SecureStorage.instance.save(
        key: SecureStorageKey.biometricKeyKey,
        value: biometricKeyHash,
      );
      await SecureStorage.instance.save(
        key: SecureStorageKey.biometricSaltKey,
        value: base64.encode(biometricSalt),
      );
      await SecureStorage.instance.save(key: SecureStorageKey.biometricEnabledKey, value: 'true');

      await LocalAuthConfig.instance.setUseBiometric(true);

      _secureWipe(biometricKey);
      _secureWipe(biometricSalt);

      logInfo('Biometric authentication đã được bật');
      return true;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khi bật biometric: $e\n$stackTrace',
        functionName: 'SecureAppManager._enableBiometric',
      );
      return false;
    }
  }

  Future<bool> _disableBiometric() async {
    try {
      await Future.wait([
        SecureStorage.instance.delete(key: SecureStorageKey.biometricKeyKey),
        SecureStorage.instance.delete(key: SecureStorageKey.biometricSaltKey),
        SecureStorage.instance.delete(key: SecureStorageKey.biometricEnabledKey),
      ]);

      await LocalAuthConfig.instance.setUseBiometric(false);
      logInfo('Biometric authentication đã được tắt');
      return true;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khi tắt biometric: $e\n$stackTrace',
        functionName: 'SecureAppManager._disableBiometric',
      );
      return false;
    }
  }

  Future<bool> _changePIN(String oldPIN, String newPIN) async {
    try {
      if (!await _verifyPIN(oldPIN)) {
        logError('PIN cũ không chính xác', functionName: 'SecureAppManager._changePIN');
        return false;
      }

      final rmk = await _getRootMasterKeyWithPIN(oldPIN);
      if (rmk == null) {
        logError('Không thể lấy RMK với PIN cũ', functionName: 'SecureAppManager._changePIN');
        return false;
      }

      final newPinDerivedKey = await _deriveKeyFromPIN(newPIN);
      final newWrappedRMK = await _wrapKey(rmk, newPinDerivedKey);

      final newPinSalt = _generateSecureRandomBytes(EncryptionConfig.saltLength);
      final newPinHash = await compute(_hashPINInIsolate, {
        'pin': newPIN,
        'salt': base64.encode(newPinSalt),
        'memoryPowerOf2': EncryptionConfig.memoryPowerOf2,
        'iterations': EncryptionConfig.iterations,
        'parallelism': EncryptionConfig.parallelism,
        'desiredLength': EncryptionConfig.pinHashLength,
      });

      await SecureStorage.instance.save(
        key: SecureStorageKey.pinSaltKey,
        value: base64.encode(newPinSalt),
      );
      await SecureStorage.instance.save(key: SecureStorageKey.pinHashKey, value: newPinHash);
      await SecureStorage.instance.save(key: SecureStorageKey.wrappedRmkKey, value: newWrappedRMK);

      _secureWipe(rmk);
      _secureWipe(newPinDerivedKey);
      _secureWipe(newPinSalt);

      logInfo('PIN đã được thay đổi thành công');
      return true;
    } catch (e, stackTrace) {
      logError('Lỗi khi đổi PIN: $e\n$stackTrace', functionName: 'SecureAppManager._changePIN');
      return false;
    }
  }

  Future<void> _clearSession() async {
    try {
      if (_rootMasterKey != null) {
        _secureWipe(_rootMasterKey!);
      }

      _rootMasterKey = null;
      _isAuthenticated = false;
      _lastActivity = null;

      logInfo('Session đã được xóa');
    } catch (e, stackTrace) {
      logError('Lỗi xóa session: $e\n$stackTrace', functionName: 'SecureAppManager._clearSession');
    }
  }

  Future<bool> _isPINSet() async {
    final pinHash = await SecureStorage.instance.read(key: SecureStorageKey.pinHashKey);
    final wrappedRMK = await SecureStorage.instance.read(key: SecureStorageKey.wrappedRmkKey);
    return pinHash != null && wrappedRMK != null;
  }

  Future<bool> _isBiometricEnabled() async {
    final enabled = await SecureStorage.instance.read(key: SecureStorageKey.biometricEnabledKey);
    return enabled == 'true';
  }

  bool _isBiometricAvailable() {
    return LocalAuthConfig.instance.isAvailableBiometrics;
  }

  Future<bool> _authenticateWithBiometric() async {
    try {
      return await checkLocalAuth();
    } catch (e) {
      logError(
        'Lỗi xác thực biometric: $e',
        functionName: 'SecureAppManager._authenticateWithBiometric',
      );
      return false;
    }
  }

  Future<Uint8List?> _getRootMasterKeyWithPIN(String pin) async {
    try {
      final isValidPIN = await _verifyPIN(pin);
      if (!isValidPIN) {
        logError('PIN không hợp lệ', functionName: 'SecureAppManager._getRootMasterKeyWithPIN');
        return null;
      }

      final wrappedRMKBase64 = await SecureStorage.instance.read(
        key: SecureStorageKey.wrappedRmkKey,
      );
      if (wrappedRMKBase64 == null) {
        logError(
          'Wrapped RMK không tồn tại',
          functionName: 'SecureAppManager._getRootMasterKeyWithPIN',
        );
        return null;
      }

      final pinDerivedKey = await _deriveKeyFromPIN(pin);
      final rmk = await _unwrapKey(wrappedRMKBase64, pinDerivedKey);
      _secureWipe(pinDerivedKey);

      return rmk;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khi lấy RMK với PIN: $e\n$stackTrace',
        functionName: 'SecureAppManager._getRootMasterKeyWithPIN',
      );
      return null;
    }
  }

  Future<Uint8List?> _getRootMasterKeyWithBiometric() async {
    try {
      if (!await _authenticateWithBiometric()) {
        return null;
      }
      final wrappedRMKBase64 = await SecureStorage.instance.read(
        key: SecureStorageKey.wrappedRmkKey,
      );
      if (wrappedRMKBase64 == null) {
        return null;
      }
      final biometricDerivedKey = await _deriveBiometricKey();
      final rmk = await _unwrapKey(wrappedRMKBase64, biometricDerivedKey);
      _secureWipe(biometricDerivedKey);

      return rmk;
    } catch (e, stackTrace) {
      logError(
        'Lỗi khi lấy RMK với biometric: $e\n$stackTrace',
        functionName: 'SecureAppManager._getRootMasterKeyWithBiometric',
      );
      return null;
    }
  }

  Future<bool> _generateAndSaveRootMasterKey(String pin) async {
    try {
      final rmk = _generateSecureRandomBytes(EncryptionConfig.rmkLength);
      final pinDerivedKey = await _deriveKeyFromPIN(pin);
      final wrappedRMK = await _wrapKey(rmk, pinDerivedKey);
      await SecureStorage.instance.save(key: SecureStorageKey.wrappedRmkKey, value: wrappedRMK);
      await SecureStorage.instance.save(
        key: SecureStorageKey.rmkCreatedAtKey,
        value: DateTime.now().toIso8601String(),
      );
      _secureWipe(rmk);
      _secureWipe(pinDerivedKey);

      return true;
    } catch (e, stackTrace) {
      logError(
        'Lỗi tạo RMK: $e\n$stackTrace',
        functionName: 'SecureAppManager._generateAndSaveRootMasterKey',
      );
      return false;
    }
  }

  /// Tạo khóa dẫn xuất từ PIN
  Future<Uint8List> _deriveKeyFromPIN(String pin) async {
    final derivationSalt = _generateDeterministicSalt('pin_key_derivation_v2');
    final argon2Output = await compute(_deriveKeyInIsolate, {
      'pin': pin,
      'salt': base64.encode(derivationSalt),
      'memoryPowerOf2': EncryptionConfig.memoryPowerOf2,
      'iterations': EncryptionConfig.iterations,
      'parallelism': EncryptionConfig.parallelism,
      'desiredLength': 32,
    });

    return base64.decode(argon2Output);
  }

  Future<Uint8List> _deriveBiometricKey() async {
    final saltBase64 = await SecureStorage.instance.read(key: SecureStorageKey.biometricSaltKey);
    if (saltBase64 == null) {
      throw Exception('Biometric salt không tồn tại');
    }

    final salt = base64.decode(saltBase64);
    final deviceInfo = await _getDeviceInfo();
    final keyMaterial = utf8.encode('$deviceInfo${DateTime.now().millisecondsSinceEpoch}');

    final argon2Params = pc.Argon2Parameters(
      pc.Argon2Parameters.ARGON2_id,
      salt,
      iterations: EncryptionConfig.iterations,
      memoryPowerOf2: EncryptionConfig.memoryPowerOf2,
      desiredKeyLength: EncryptionConfig.biometricKeyLength,
    );

    final generator = pc.Argon2BytesGenerator();
    generator.init(argon2Params);
    final derivedKey = generator.process(keyMaterial);

    return Uint8List.fromList(derivedKey);
  }

  static String _hashPINInIsolate(Map<String, dynamic> params) {
    try {
      final pin = params['pin'] as String;
      final saltBase64 = params['salt'] as String;
      final memoryPowerOf2 = params['memoryPowerOf2'] as int;
      final iterations = params['iterations'] as int;
      final desiredLength = params['desiredLength'] as int;

      final salt = base64.decode(saltBase64);

      final argon2Params = pc.Argon2Parameters(
        pc.Argon2Parameters.ARGON2_id,
        salt,
        iterations: iterations,
        memoryPowerOf2: memoryPowerOf2,
        desiredKeyLength: desiredLength,
      );

      final generator = pc.Argon2BytesGenerator();
      generator.init(argon2Params);
      final hash = generator.process(utf8.encode(pin));

      return base64.encode(hash);
    } catch (e) {
      throw Exception('Lỗi hash PIN trong isolate: $e');
    }
  }

  static String _hashBiometricKeyInIsolate(Map<String, dynamic> params) {
    try {
      final keyBase64 = params['key'] as String;
      final saltBase64 = params['salt'] as String;
      final memoryPowerOf2 = params['memoryPowerOf2'] as int;
      final iterations = params['iterations'] as int;
      final desiredLength = params['desiredLength'] as int;

      final key = base64.decode(keyBase64);
      final salt = base64.decode(saltBase64);

      final argon2Params = pc.Argon2Parameters(
        pc.Argon2Parameters.ARGON2_id,
        salt,
        iterations: iterations,
        memoryPowerOf2: memoryPowerOf2,
        desiredKeyLength: desiredLength,
      );

      final generator = pc.Argon2BytesGenerator();
      generator.init(argon2Params);
      final hash = generator.process(key);

      return base64.encode(hash);
    } catch (e) {
      throw Exception('Lỗi hash biometric key trong isolate: $e');
    }
  }

  static String _deriveKeyInIsolate(Map<String, dynamic> params) {
    try {
      final pin = params['pin'] as String;
      final saltBase64 = params['salt'] as String;
      final memoryPowerOf2 = params['memoryPowerOf2'] as int;
      final iterations = params['iterations'] as int;
      final desiredLength = params['desiredLength'] as int;

      final salt = base64.decode(saltBase64);

      final argon2Params = pc.Argon2Parameters(
        pc.Argon2Parameters.ARGON2_id,
        salt,
        iterations: iterations,
        memoryPowerOf2: memoryPowerOf2,
        desiredKeyLength: desiredLength,
      );

      final generator = pc.Argon2BytesGenerator();
      generator.init(argon2Params);
      final derivedKey = generator.process(utf8.encode(pin));

      return base64.encode(derivedKey);
    } catch (e) {
      throw Exception('Lỗi derive key trong isolate: $e');
    }
  }

  Future<String> _getDeviceInfo() async {
    return 'device_unique_id_v2';
  }

  Future<String> _wrapKey(Uint8List keyToWrap, Uint8List wrappingKey) async {
    try {
      final iv = _generateSecureRandomBytes(12);
      final encrypter = enc.Encrypter(enc.AES(enc.Key(wrappingKey), mode: enc.AESMode.gcm));

      final encrypted = encrypter.encrypt(String.fromCharCodes(keyToWrap), iv: enc.IV(iv));

      final package = {
        'iv': base64.encode(iv),
        'data': encrypted.base64,
        'algorithm': 'AES-256-GCM',
        'version': '2.0',
        'timestamp': DateTime.now().toIso8601String(),
      };

      return json.encode(package);
    } catch (e) {
      throw Exception('Lỗi wrap key: $e');
    }
  }

  Future<Uint8List?> _unwrapKey(String wrappedKeyData, Uint8List wrappingKey) async {
    try {
      final package = json.decode(wrappedKeyData) as Map<String, dynamic>;
      final iv = base64.decode(package['iv']);
      final encryptedData = enc.Encrypted.fromBase64(package['data']);

      final encrypter = enc.Encrypter(enc.AES(enc.Key(wrappingKey), mode: enc.AESMode.gcm));

      final decrypted = encrypter.decrypt(encryptedData, iv: enc.IV(iv));
      return Uint8List.fromList(decrypted.codeUnits);
    } catch (e) {
      logError('Lỗi unwrap key: $e', functionName: 'SecureAppManager._unwrapKey');
      return null;
    }
  }

  /// Tạo random bytes an toàn
  Uint8List _generateSecureRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List<int>.generate(length, (_) => random.nextInt(256)));
  }

  /// Tạo salt deterministic
  Uint8List _generateDeterministicSalt(String context) {
    final contextBytes = utf8.encode(context);
    final hash = sha256.convert(contextBytes).bytes;
    return Uint8List.fromList(hash);
  }

  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;

    var result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  void _secureWipe(Uint8List data) {
    final random = Random.secure();
    for (int pass = 0; pass < 3; pass++) {
      for (int i = 0; i < data.length; i++) {
        data[i] = random.nextInt(256);
      }
    }
    data.fillRange(0, data.length, 0);
  }
}
