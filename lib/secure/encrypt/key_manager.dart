import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/secure/encrypt/cache_key.dart';
import 'package:cybersafe_pro/secure/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/secure/secure_app_manager.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';

enum KeyType { info, password, totp, note, pinCode, database }

class KeyManager {
  static final instance = KeyManager._();
  KeyManager._() {
    _startCacheCleanup();
  }

  // Constants
  static const MAX_CACHE_DURATION = config.EncryptionConfig.KEY_CACHE_DURATION;
  static const MAX_CACHE_ITEMS = 20;
  static const CLEANUP_INTERVAL = Duration(minutes: 4);
  static const DEVICE_KEY_LENGTH = config.EncryptionConfig.KEY_SIZE_BYTES;
  static const SALT_LENGTH = config.EncryptionConfig.SALT_SIZE_BYTES;
  static const DERIVED_KEY_CACHE_DURATION = Duration(minutes: 5);

  final _secureStorage = SecureStorage.instance;
  final Map<String, CachedKey> _keyCache = {};
  final Map<String, CachedKey> _derivedKeyCache = {};
  Timer? _cacheCleanupTimer;
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;

  static Future<String> getKey(KeyType type) async {
    ArgumentError.checkNotNull(type, 'type');
    return await instance._getEncryptionKey(type);
  }

  static Future<String> getDerivedKey(KeyType type, String context, String purpose) async {
    return await instance._getDerivedKey(type, context, purpose);
  }

  static Future<Map<String, String>> getDerivedKeys(
    KeyType type,
    String context, {
    List<String> purposes = const ['aes', 'hmac'],
  }) async {
    return await instance._getDerivedKeys(type, context, purposes);
  }

  static Future<void> clearDerivedKeyCache([String? specificContext]) async {
    await instance._clearDerivedKeyCache(specificContext);
  }

  static void onAppBackground() {
    instance._clearAllCache();
    logInfo('All caches cleared on app background');
  }

  static void dispose() {
    instance._dispose();
  }

  Future<String> _getEncryptionKey(KeyType type) async {
    return await _withRetry(() async {
      await _checkRateLimit();

      final cacheKey = '${type.name}_key';

      if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
        return _keyCache[cacheKey]!.value;
      }

      if (!SecureAppManager.isSessionValid()) {
        throw Exception('Session không hợp lệ, cần xác thực lại');
      }

      final rootMasterKey = await SecureAppManager.getRootMasterKey();
      if (rootMasterKey == null) {
        throw Exception('Không thể lấy Root Master Key');
      }

      final encryptionKey = await _createOrGetEncryptionKey(type, rootMasterKey);
      if (encryptionKey == null) {
        throw Exception('Không thể tạo encryption key');
      }

      final key = base64.encode(encryptionKey);
      _keyCache[cacheKey] = CachedKey(key);
      _monitorCache();
      _failedAttempts = 0;
      logInfo('✅ Đã lấy key thành công: $key');
      return key;
    }, functionName: "_getEncryptionKey");
  }

  Future<Uint8List?> _createOrGetEncryptionKey(KeyType type, Uint8List rootMasterKey) async {
    try {
      final keyId = _getStorageKeyForType(type);

      final existingKey = await _getStoredEncryptionKey(keyId, rootMasterKey);
      if (existingKey != null) {
        return existingKey;
      }
      final newKey = _generateSecureRandomBytes(32);
      await _saveEncryptionKey(keyId, newKey, rootMasterKey);
      return newKey;
    } catch (e, stackTrace) {
      logError(
        '❌ Lỗi tạo/lấy encryption key: $e\n$stackTrace',
        functionName: 'KeyManager._createOrGetEncryptionKey',
      );
      return null;
    }
  }

  Future<Uint8List?> _getStoredEncryptionKey(String keyId, Uint8List rootMasterKey) async {
    try {
      final wrappedKeyData = await _secureStorage.read(key: keyId);

      logInfo('wrappedKeyData $keyId ========= $wrappedKeyData');
      if (wrappedKeyData == null) {
        return null;
      }
      if (_isWrappedKey(wrappedKeyData)) {
        return await _unwrapKey(wrappedKeyData, rootMasterKey);
      } else {
        return base64.decode(wrappedKeyData);
      }
    } catch (e) {
      logError(
        'Lỗi lấy stored encryption key: $e',
        functionName: 'KeyManager._getStoredEncryptionKey',
      );
      return null;
    }
  }

  Future<void> _saveEncryptionKey(String keyId, Uint8List key, Uint8List rootMasterKey) async {
    try {
      final wrappedKey = await _wrapKey(key, rootMasterKey);
      await _secureStorage.save(key: keyId, value: wrappedKey);
    } catch (e, stackTrace) {
      logError(
        '❌ Lỗi lưu encryption key: $e\n$stackTrace',
        functionName: 'KeyManager._saveEncryptionKey',
      );
    }
  }

  bool _isWrappedKey(String keyData) {
    try {
      final package = json.decode(keyData) as Map<String, dynamic>;

      final hasRequiredFields =
          package.containsKey('iv') &&
          package.containsKey('data') &&
          package.containsKey('algorithm') &&
          package.containsKey('version') &&
          package.containsKey('type');

      if (!hasRequiredFields) {
        return false;
      }
      final type = package['type'] as String?;
      if (type != 'WRAP') {
        return false;
      }
      final version = package['version'] as String?;
      if (version != '2.0') {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _getDerivedKey(KeyType type, String context, String purpose) async {
    final cacheKey = '${type.name}_${context}_$purpose';

    if (_derivedKeyCache.containsKey(cacheKey) && !_derivedKeyCache[cacheKey]!.isExpired) {
      return _derivedKeyCache[cacheKey]!.value;
    }

    final masterKey = await _getEncryptionKey(type);
    return await _getDerivedKeyFromMaster(masterKey, type, context, purpose);
  }

  /// Lấy nhiều derived keys
  Future<Map<String, String>> _getDerivedKeys(
    KeyType type,
    String context,
    List<String> purposes,
  ) async {
    final masterKey = await _getEncryptionKey(type);
    final derivedKeys = <String, String>{};

    for (final purpose in purposes) {
      derivedKeys[purpose] = await _getDerivedKeyFromMaster(masterKey, type, context, purpose);
    }

    return derivedKeys;
  }

  Future<String> _getDerivedKeyFromMaster(
    String masterKey,
    KeyType type,
    String context,
    String purpose,
  ) async {
    final cacheKey = '${type.name}_${context}_$purpose';

    if (_derivedKeyCache.containsKey(cacheKey) && !_derivedKeyCache[cacheKey]!.isExpired) {
      return _derivedKeyCache[cacheKey]!.value;
    }

    final masterKeyBytes = base64.decode(masterKey);
    final salt = _generateHkdfSalt(type, context);
    final info = utf8.encode(
      '${config.EncryptionConfig.KEY_PURPOSES[purpose] ?? purpose}_$context',
    );

    final derivedKeyBytes = _hkdf(
      inputKeyMaterial: masterKeyBytes,
      salt: salt,
      info: Uint8List.fromList(info),
      length: config.EncryptionConfig.KEY_SIZE_BYTES,
    );

    final derivedKey = base64.encode(derivedKeyBytes);
    _derivedKeyCache[cacheKey] = CachedKey(derivedKey, customDuration: DERIVED_KEY_CACHE_DURATION);
    _monitorDerivedKeyCache();

    _secureWipe(masterKeyBytes);
    _secureWipe(derivedKeyBytes);

    return derivedKey;
  }

  /// HKDF implementation
  static Uint8List _hkdf({
    required Uint8List inputKeyMaterial,
    required Uint8List salt,
    required Uint8List info,
    required int length,
  }) {
    if (length > 255 * 32) {
      throw ArgumentError('Output length too large for HKDF');
    }

    final hmac = Hmac(sha256, salt);
    final prk = hmac.convert(inputKeyMaterial).bytes;

    final okm = <int>[];
    final hmacExpand = Hmac(sha256, prk);
    var counter = 1;
    var t = <int>[];

    while (okm.length < length) {
      final input = [...t, ...info, counter];
      t = hmacExpand.convert(input).bytes;
      okm.addAll(t);
      counter++;
    }

    return Uint8List.fromList(okm.take(length).toList());
  }

  /// Tạo salt cho HKDF
  Uint8List _generateHkdfSalt(KeyType type, String context) {
    final input = '${type.name}:$context:hkdf_salt';
    final hash = sha256.convert(utf8.encode(input)).bytes;

    if (hash.length < SALT_LENGTH) {
      final extendedSalt = <int>[];
      while (extendedSalt.length < SALT_LENGTH) {
        extendedSalt.addAll(hash);
      }
      return Uint8List.fromList(extendedSalt.take(SALT_LENGTH).toList());
    }

    return Uint8List.fromList(hash.take(SALT_LENGTH).toList());
  }

  /// Xóa derived key cache
  Future<void> _clearDerivedKeyCache([String? specificContext]) async {
    if (specificContext != null) {
      final keysToRemove =
          _derivedKeyCache.keys.where((key) => key.contains('_${specificContext}_')).toList();
      _derivedKeyCache.removeWhere((key, value) => keysToRemove.contains(key));
    } else {
      _derivedKeyCache.clear();
    }

    logInfo(
      'Derived key cache cleared${specificContext != null ? ' for context: $specificContext' : ''}',
    );
  }

  /// Wrap key
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
        'type': "WRAP",
        'timestamp': DateTime.now().toIso8601String(),
      };

      return json.encode(package);
    } catch (e) {
      throw Exception('Lỗi wrap key: $e');
    }
  }

  /// Unwrap key
  Future<Uint8List?> _unwrapKey(String wrappedKeyData, Uint8List wrappingKey) async {
    try {
      final package = json.decode(wrappedKeyData) as Map<String, dynamic>;
      final iv = base64.decode(package['iv']);
      final encryptedData = enc.Encrypted.fromBase64(package['data']);

      final encrypter = enc.Encrypter(enc.AES(enc.Key(wrappingKey), mode: enc.AESMode.gcm));

      final decrypted = encrypter.decrypt(encryptedData, iv: enc.IV(iv));
      return Uint8List.fromList(decrypted.codeUnits);
    } catch (e) {
      logError('Lỗi unwrap key: $e', functionName: 'KeyManager._unwrapKey');
      return null;
    }
  }

  /// Kiểm tra rate limit
  Future<void> _checkRateLimit() async {
    if (_lockoutUntil != null && DateTime.now().isBefore(_lockoutUntil!)) {
      final remaining = _lockoutUntil!.difference(DateTime.now());
      throw Exception('Rate limited. Try again in ${remaining.inMinutes} minutes');
    }

    if (_failedAttempts >= config.EncryptionConfig.MAX_FAILED_ATTEMPTS) {
      _lockoutUntil = DateTime.now().add(config.EncryptionConfig.LOCKOUT_DURATION);
      _failedAttempts = 0;
      throw Exception(
        'Too many failed attempts. Locked out for ${config.EncryptionConfig.LOCKOUT_DURATION.inMinutes} minutes',
      );
    }
  }

  /// Cache management
  void _monitorCache() {
    if (_keyCache.length > MAX_CACHE_ITEMS) {
      _clearOldestCacheItems();
    }
  }

  void _monitorDerivedKeyCache() {
    if (_derivedKeyCache.length > MAX_CACHE_ITEMS) {
      _clearOldestDerivedCacheItems();
    }
  }

  void _clearOldestCacheItems() {
    final sortedEntries =
        _keyCache.entries.toList()..sort((a, b) => a.value.expiresAt.compareTo(b.value.expiresAt));
    while (_keyCache.length > MAX_CACHE_ITEMS) {
      final oldest = sortedEntries.removeAt(0);
      _keyCache.remove(oldest.key);
    }
  }

  void _clearOldestDerivedCacheItems() {
    final sortedEntries =
        _derivedKeyCache.entries.toList()
          ..sort((a, b) => a.value.expiresAt.compareTo(b.value.expiresAt));
    while (_derivedKeyCache.length > MAX_CACHE_ITEMS) {
      final oldest = sortedEntries.removeAt(0);
      _derivedKeyCache.remove(oldest.key);
    }
  }

  void _startCacheCleanup() {
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = Timer.periodic(CLEANUP_INTERVAL, (_) => _clearExpiredCache());
  }

  void _clearExpiredCache() {
    final expiredKeys =
        _keyCache.entries
            .where((entry) => entry.value.isExpired)
            .map((entry) => entry.key)
            .toList();
    for (final key in expiredKeys) {
      _keyCache.remove(key);
    }

    final expiredDerivedKeys =
        _derivedKeyCache.entries
            .where((entry) => entry.value.isExpired)
            .map((entry) => entry.key)
            .toList();
    for (final key in expiredDerivedKeys) {
      _derivedKeyCache.remove(key);
    }
  }

  void _clearAllCache() {
    _keyCache.clear();
    _derivedKeyCache.clear();
  }

  void _dispose() {
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = null;
    _clearAllCache();
    logInfo('KeyManager disposed');
  }

  /// Security operations
  Uint8List _generateSecureRandomBytes(int length) {
    final entropy = <int>[];
    entropy.addAll(utf8.encode(DateTime.now().toIso8601String()));
    entropy.addAll(utf8.encode(DateTime.now().microsecondsSinceEpoch.toString()));
    entropy.addAll(utf8.encode(hashCode.toString()));

    final systemRandom = Random.secure();
    for (int i = 0; i < config.EncryptionConfig.SECURE_RANDOM_SEED_LENGTH; i++) {
      entropy.add(systemRandom.nextInt(256));
    }

    final entropyBytes = Uint8List.fromList(sha256.convert(Uint8List.fromList(entropy)).bytes);
    final result = Uint8List(length);
    final random = Random.secure();

    for (int i = 0; i < length; i++) {
      result[i] = (random.nextInt(256) ^ entropyBytes[i % entropyBytes.length]);
    }

    return result;
  }

  void _secureWipe(Uint8List data) {
    for (int pass = 0; pass < config.EncryptionConfig.MEMORY_WIPE_PASSES; pass++) {
      final random = Random.secure();
      for (int i = 0; i < data.length; i++) {
        data[i] = random.nextInt(256);
      }
    }
    data.fillRange(0, data.length, 0);
  }

  String _getStorageKeyForType(KeyType type) {
    return switch (type) {
      KeyType.info => SecureStorageKey.secureInfoKey,
      KeyType.password => SecureStorageKey.securePasswordKey,
      KeyType.totp => SecureStorageKey.secureTotpKey,
      KeyType.pinCode => SecureStorageKey.securePinCodeKey,
      KeyType.database => SecureStorageKey.secureDatabaseKey,
      KeyType.note => SecureStorageKey.secureNoteKey,
    };
  }

  /// Error handling
  void _logError(String message, Object error) {
    logError('[KeyManager] ERROR: $message: $error');
    _failedAttempts++;
  }

  Future<T> _withRetry<T>(Future<T> Function() operation, {required String functionName}) async {
    int attempts = 0;
    while (attempts < config.EncryptionConfig.MAX_RETRY_ATTEMPTS) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        _logError('Retry attempt $attempts failed', e);
        if (attempts == config.EncryptionConfig.MAX_RETRY_ATTEMPTS) {
          throwAppError(ErrorText.tooManyRetries, functionName: functionName);
        }
        await Future.delayed(config.EncryptionConfig.RETRY_DELAY * attempts);
      }
    }
    throw AppError.instance.createException(ErrorText.tooManyRetries, functionName: functionName);
  }
}
