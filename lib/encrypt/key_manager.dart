import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/encrypt/ase_256/secure_ase256.dart';
import 'package:cybersafe_pro/env/env.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:pointycastle/export.dart' as pc;

enum KeyType { info, password, totp, pinCode }

class KeyManager {
  static final instance = KeyManager._();
  KeyManager._();

  final _secureStorage = SecureStorage.instance;

  // Orchestration key cho việc bảo vệ khóa trong bộ nhớ
  static String _orchestrationKey = '';

  // Cache keys
  final Map<String, _CachedKey> _keyCache = {};

  String? _cachedDeviceKey;
  DateTime? _deviceKeyExpiry;

  Future<void>? _initializing;

  Future<void> init() async {
    if (_initializing != null) return _initializing!;
    final completer = Completer<void>();
    _initializing = completer.future;
    try {
      await _initializeOrchestrationKey();
      final hasDeviceKey = await _hasDeviceKey();
      if (!hasDeviceKey) {
        await _generateDeviceKey();
      }
      await _preloadKeys();
      completer.complete();
    } catch (e) {
      _logError('Lỗi khởi tạo KeyManager', e);
      completer.completeError(e);
      return;
    }
  }

  static Future<String> getKey(KeyType type) async {
    return await instance._generateEncryptionKey(await instance._getDeviceKey(), type);
  }

  Future<void> _initializeOrchestrationKey() async {
    if (_orchestrationKey.isNotEmpty) return;
    _orchestrationKey = await _generateOrchestrationKey();
    logInfo('Đã khởi tạo orchestration key');
  }

  Future<String> _generateOrchestrationKey() async {
    final deviceInfo = await _getDeviceSpecificInfo();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final appSignature = Env.appSignatureKey;
    final rawKey = '$deviceInfo:$timestamp:$appSignature';
    Env.orchestrationEncryptionKey;
    final key = base64.encode(sha256.convert(utf8.encode(rawKey)).bytes);
    final ase256Encrypt = SecureAse256.encrypt(value: key, key: Env.orchestrationEncryptionKey);
    return ase256Encrypt;
  }

  //#region DEVICE KEY MANAGEMENT
  Future<String> _getDeviceSpecificInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return '${androidInfo.brand}_${androidInfo.device}_${androidInfo.id}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return '${iosInfo.model}_${iosInfo.identifierForVendor}';
      } else {
        return 'unknown_device_${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      _logError('Lỗi lấy thông tin thiết bị', e);
      return 'fallback_device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<String> _getDeviceKey() async {
    return await _withRetry(() async {
      if (_cachedDeviceKey != null && _deviceKeyExpiry != null && DateTime.now().isBefore(_deviceKeyExpiry!)) {
        // Khôi phục khóa từ cache (đã được bảo vệ)
        return _unprotectKey(_cachedDeviceKey!);
      }

      final key = await _secureStorage.read(key: SecureStorageKey.secureDeviceKey);
      if (key == null) throw Exception('Device key not created');

      // Lưu khóa vào cache sau khi bảo vệ
      _cachedDeviceKey = _protectKey(key);
      _deviceKeyExpiry = DateTime.now().add(EncryptionConfig.KEY_CACHE_DURATION);
      return key;
    });
  }

  Future<void> _generateDeviceKey() async {
    return await _withRetry(() async {
      final key = base64.encode(List.generate(32, (_) => Random.secure().nextInt(256)));
      await _secureStorage.save(key: SecureStorageKey.secureDeviceKey, value: key);
    });
  }

  Future<bool> _hasDeviceKey() async {
    return await _secureStorage.read(key: SecureStorageKey.secureDeviceKey) != null;
  }
  //#endregion

  Future<void> _preloadKeys() async {
    try {
      final deviceKey = await _getDeviceKey();
      await Future.wait([
        _generateEncryptionKey(deviceKey, KeyType.info),
        _generateEncryptionKey(deviceKey, KeyType.password),
        _generateEncryptionKey(deviceKey, KeyType.totp),
        _generateEncryptionKey(deviceKey, KeyType.pinCode),
      ]);
    } catch (e) {
      _logError('Cannot load keys', e);
    }
  }

  Future<String> _generateEncryptionKey(String deviceKey, KeyType type) async {
    return await _withRetry(() async {
      final cacheKey = '${type.name}_$deviceKey';

      // Nếu có trong cache, giải mã và trả về
      if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
        return _unprotectKey(_keyCache[cacheKey]!.key);
      }

      final storageKey = _getStorageKeyForType(type);
      final savedKey = await _secureStorage.read(key: storageKey);

      if (savedKey != null) {
        // Lưu vào cache sau khi bảo vệ
        _keyCache[cacheKey] = _CachedKey(_protectKey(savedKey));
        return savedKey;
      }

      final salt = 'cybersafe_${type.name}_salt_${deviceKey}_${Env.appSignatureKey}';
      final key = await compute(_generateKeyInIsolate, {'salt': salt, 'deviceKey': deviceKey, 'iterations': EncryptionConfig.PBKDF2_ITERATIONS, 'keySize': EncryptionConfig.KEY_SIZE_BYTES});

      _keyCache[cacheKey] = _CachedKey(_protectKey(key));
      await _secureStorage.save(key: storageKey, value: key);

      return key;
    });
  }

  //Bảo vệ key khi lưu vào RAM
  String _protectKey(String key) {
    if (_orchestrationKey.isEmpty) {
      _logError('Orchestration key chưa được khởi tạo', 'Không thể bảo vệ khóa');
      return key; // Fallback nếu chưa khởi tạo
    }
    final keyBytes = utf8.encode(key);
    final orchestrationKey = SecureAse256.decrypt(encryptedData: _orchestrationKey, key: Env.orchestrationEncryptionKey);
    final orchestrationBytes = utf8.encode(orchestrationKey);
    final result = List<int>.filled(keyBytes.length, 0);

    for (var i = 0; i < keyBytes.length; i++) {
      result[i] = keyBytes[i] ^ orchestrationBytes[i % orchestrationBytes.length];
    }

    return base64.encode(result);
  }

  String _unprotectKey(String protectedKey) {
    if (_orchestrationKey.isNotEmpty) {
      _logError('Orchestration key chưa được khởi tạo', 'Không thể khôi phục khóa');
      return protectedKey; // Fallback nếu chưa khởi tạo
    }

    try {
      final protectedBytes = base64.decode(protectedKey);
      final orchestrationKey = SecureAse256.decrypt(encryptedData: _orchestrationKey, key: Env.orchestrationEncryptionKey);
      final orchestrationBytes = utf8.encode(orchestrationKey);
      final result = List<int>.filled(protectedBytes.length, 0);

      for (var i = 0; i < protectedBytes.length; i++) {
        result[i] = protectedBytes[i] ^ orchestrationBytes[i % orchestrationBytes.length];
      }

      return utf8.decode(result);
    } catch (e) {
      _logError('Lỗi khôi phục khóa', e);
      return protectedKey; // Fallback nếu có lỗi
    }
  }

  static String _generateKeyInIsolate(Map<String, dynamic> params) {
    final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(utf8.encode(params['salt'])), params['iterations'], params['keySize']));
    return base64.encode(generator.process(Uint8List.fromList(utf8.encode(params['deviceKey']))));
  }

  void _logError(String message, Object error) {
    logError('[KeyManager] ERROR: $message: $error');
  }

  String _getStorageKeyForType(KeyType type) {
    return switch (type) {
      KeyType.info => SecureStorageKey.secureInfoKey,
      KeyType.password => SecureStorageKey.securePasswordKey,
      KeyType.totp => SecureStorageKey.secureTotpKey,
      KeyType.pinCode => SecureStorageKey.securePinCodeKey,
    };
  }

  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (attempts < EncryptionConfig.MAX_RETRY_ATTEMPTS) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts == EncryptionConfig.MAX_RETRY_ATTEMPTS) {
          throwAppError(ErrorText.tooManyRetries);
        }
        await Future.delayed(EncryptionConfig.RETRY_DELAY * attempts);
      }
    }
    // Code không bao giờ chạy đến đây vì throwAppError ở trên
    throw AppError.instance.createException(ErrorText.tooManyRetries);
  }
}

class _CachedKey {
  final String key;
  final DateTime expiresAt;

  _CachedKey(this.key) : expiresAt = DateTime.now().add(EncryptionConfig.KEY_CACHE_DURATION);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
