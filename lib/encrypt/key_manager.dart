import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/encrypt/cache_key.dart';
import 'package:cybersafe_pro/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as pc;

enum KeyType { info, password, totp, note, pinCode, database }

class KeyManager {
  static final instance = KeyManager._();
  KeyManager._() {
    _startCacheCleanup();
  }

  // Constants
  static const MAX_CACHE_DURATION = config.EncryptionConfig.KEY_CACHE_DURATION;
  static const MAX_CACHE_ITEMS = 20; // Increased for derived keys
  static const CLEANUP_INTERVAL = Duration(minutes: 4);
  static const DEVICE_KEY_LENGTH = config.EncryptionConfig.KEY_SIZE_BYTES;
  static const SALT_LENGTH = config.EncryptionConfig.SALT_SIZE_BYTES;
  static const DERIVED_KEY_CACHE_DURATION = Duration(minutes: 5); // Shorter for derived keys

  final _secureStorage = SecureStorage.instance;
  final Map<String, CachedKey> _keyCache = {};
  final Map<String, CachedKey> _derivedKeyCache = {}; // New cache for derived keys
  Timer? _cacheCleanupTimer;
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;

  // HKDF implementation for key derivation
  static Uint8List _hkdf({required Uint8List inputKeyMaterial, required Uint8List salt, required Uint8List info, required int length}) {
    if (length > 255 * 32) {
      throw ArgumentError('Output length too large for HKDF');
    }

    // Extract phase: HKDF-Extract(salt, IKM) = HMAC-Hash(salt, IKM)
    final hmac = Hmac(sha256, salt);
    final prk = hmac.convert(inputKeyMaterial).bytes;

    // Expand phase: HKDF-Expand(PRK, info, L)
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

  // NEW: Get derived keys for specific purpose and context
  Future<Map<String, String>> getDerivedKeys(KeyType type, String context, {List<String> purposes = const ['aes', 'hmac']}) async {
    final masterKey = await _getEncryptionKey(type);
    final derivedKeys = <String, String>{};

    for (final purpose in purposes) {
      derivedKeys[purpose] = await _getDerivedKeyFromMaster(masterKey, type, context, purpose);
    }

    return derivedKeys;
  }

  // NEW: Get single derived key for specific purpose
  Future<String> getDerivedKey(KeyType type, String context, String purpose) async {
    final cacheKey = '${type.name}_${context}_$purpose';

    // Check cache first
    if (_derivedKeyCache.containsKey(cacheKey) && !_derivedKeyCache[cacheKey]!.isExpired) {
      return _derivedKeyCache[cacheKey]!.value;
    }

    final masterKey = await _getEncryptionKey(type);
    return await _getDerivedKeyFromMaster(masterKey, type, context, purpose);
  }

  // PRIVATE: Derive key from existing master key (no duplicate calls)
  Future<String> _getDerivedKeyFromMaster(String masterKey, KeyType type, String context, String purpose) async {
    final cacheKey = '${type.name}_${context}_$purpose';

    // Check cache first
    if (_derivedKeyCache.containsKey(cacheKey) && !_derivedKeyCache[cacheKey]!.isExpired) {
      return _derivedKeyCache[cacheKey]!.value;
    }

    final masterKeyBytes = base64.decode(masterKey);

    // Generate salt for HKDF
    final salt = _generateHkdfSalt(type, context);

    // Generate info for HKDF
    final info = utf8.encode('${config.EncryptionConfig.KEY_PURPOSES[purpose] ?? purpose}_$context');

    // Derive key using HKDF
    final derivedKeyBytes = _hkdf(inputKeyMaterial: masterKeyBytes, salt: salt, info: Uint8List.fromList(info), length: config.EncryptionConfig.KEY_SIZE_BYTES);

    final derivedKey = base64.encode(derivedKeyBytes);

    // Cache the derived key
    _derivedKeyCache[cacheKey] = CachedKey(derivedKey, customDuration: DERIVED_KEY_CACHE_DURATION);
    _monitorDerivedKeyCache();

    // Clear sensitive data
    _secureWipe(masterKeyBytes);
    _secureWipe(derivedKeyBytes);

    return derivedKey;
  }

  // Generate consistent salt for HKDF
  Uint8List _generateHkdfSalt(KeyType type, String context) {
    final input = '${type.name}:$context:hkdf_salt';
    final hash = sha256.convert(utf8.encode(input)).bytes;

    // Extend to required salt length if needed
    if (hash.length < SALT_LENGTH) {
      final extendedSalt = <int>[];
      while (extendedSalt.length < SALT_LENGTH) {
        extendedSalt.addAll(hash);
      }
      return Uint8List.fromList(extendedSalt.take(SALT_LENGTH).toList());
    }

    return Uint8List.fromList(hash.take(SALT_LENGTH).toList());
  }

  // NEW: Clear derived key cache
  Future<void> clearDerivedKeyCache([String? specificContext]) async {
    if (specificContext != null) {
      // Clear only specific context
      final keysToRemove = _derivedKeyCache.keys.where((key) => key.contains('_${specificContext}_')).toList();
      _derivedKeyCache.removeWhere((key, value) => keysToRemove.contains(key));
    } else {
      _derivedKeyCache.clear();
    }

    logInfo('Derived key cache cleared${specificContext != null ? ' for context: $specificContext' : ''}');
  }

  // Monitor derived key cache
  void _monitorDerivedKeyCache() {
    if (_derivedKeyCache.length > MAX_CACHE_ITEMS) {
      _clearOldestDerivedCacheItems();
    }
  }

  void _clearOldestDerivedCacheItems() {
    final sortedEntries = _derivedKeyCache.entries.toList()..sort((a, b) => a.value.expiresAt.compareTo(b.value.expiresAt));

    while (_derivedKeyCache.length > MAX_CACHE_ITEMS) {
      final oldest = sortedEntries.removeAt(0);
      _derivedKeyCache.remove(oldest.key);
    }
  }

  // Core key generation & management
  static Future<String> getKey(KeyType type) async {
    ArgumentError.checkNotNull(type, 'type');
    return await instance._getEncryptionKey(type);
  }

  // Renamed from _generateEncryptionKey to _getEncryptionKey for clarity
  Future<String> _getEncryptionKey(KeyType type) async {
    return await _withRetry(() async {
      await _checkRateLimit();

      final cacheKey = '${type.name}_key';

      if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
        return _keyCache[cacheKey]!.value;
      }

      final storageKey = _getStorageKeyForType(type);
      final savedKey = await _secureStorage.read(key: storageKey);

      if (savedKey != null) {
        _keyCache[cacheKey] = CachedKey(savedKey);
        _monitorCache();
        return savedKey;
      }

      // Generate new key
      final deviceKey = await _getDeviceKey();
      final salt = _generateConsistentSalt(deviceKey, type);

      final key = await compute(_generateKeyInIsolate, {
        'salt': base64.encode(salt),
        'deviceKey': deviceKey,
        'type': type.name,
        'iterations': config.EncryptionConfig.pbkdf2Iterations,
        'keySize': config.EncryptionConfig.KEY_SIZE_BYTES,
      });

      _keyCache[cacheKey] = CachedKey(key);
      await _secureStorage.save(key: storageKey, value: key);
      await _setKeyCreationTime(type);

      _secureWipe(salt);
      _monitorCache();
      _failedAttempts = 0; // Reset on success
      return key;
    }, functionName: "_getEncryptionKey");
  }

  // Check for rate limiting
  Future<void> _checkRateLimit() async {
    if (_lockoutUntil != null && DateTime.now().isBefore(_lockoutUntil!)) {
      final remaining = _lockoutUntil!.difference(DateTime.now());
      throw Exception('Rate limited. Try again in ${remaining.inMinutes} minutes');
    }

    if (_failedAttempts >= config.EncryptionConfig.MAX_FAILED_ATTEMPTS) {
      _lockoutUntil = DateTime.now().add(config.EncryptionConfig.LOCKOUT_DURATION);
      _failedAttempts = 0;
      throw Exception('Too many failed attempts. Locked out for ${config.EncryptionConfig.LOCKOUT_DURATION.inMinutes} minutes');
    }
  }

  Future<void> _setKeyCreationTime(KeyType type) async {
    final storageKey = _getStorageKeyForType(type);
    await _secureStorage.save(key: '${storageKey}_creation_time', value: DateTime.now().toIso8601String());
  }

  Future<String> _getDeviceKey() async {
    return await _withRetry(() async {
      final cacheKey = 'device_key';
      if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
        return _keyCache[cacheKey]!.value;
      }

      final key = await _secureStorage.read(key: SecureStorageKey.secureDeviceKey);
      if (key == null) {
        await _generateDeviceKey();
        return await _getDeviceKey();
      }

      _keyCache[cacheKey] = CachedKey(key);
      _monitorCache();
      return key;
    }, functionName: "_getDeviceKey");
  }

  Future<void> _generateDeviceKey() async {
    return await _withRetry(() async {
      final keyBytes = _generateSecureRandomBytes(DEVICE_KEY_LENGTH);
      final key = base64.encode(keyBytes);

      await _secureStorage.save(key: SecureStorageKey.secureDeviceKey, value: key);

      _secureWipe(keyBytes);
      logInfo('Device key generated securely');
    }, functionName: "_generateDeviceKey");
  }

  // Generate consistent salt for each key type
  Uint8List _generateConsistentSalt(String deviceKey, KeyType type) {
    final input = '$deviceKey:${type.name}:${config.EncryptionConfig.KEY_PURPOSES[type.name] ?? 'default'}';
    final hash = sha256.convert(utf8.encode(input)).bytes;

    // Extend to required salt length if needed
    if (hash.length < SALT_LENGTH) {
      final extendedSalt = <int>[];
      while (extendedSalt.length < SALT_LENGTH) {
        extendedSalt.addAll(hash);
      }
      return Uint8List.fromList(extendedSalt.take(SALT_LENGTH).toList());
    }

    return Uint8List.fromList(hash.take(SALT_LENGTH).toList());
  }

  // Cache Management
  void _monitorCache() {
    if (_keyCache.length > MAX_CACHE_ITEMS) {
      _clearOldestCacheItems();
    }
  }

  void _clearOldestCacheItems() {
    final sortedEntries = _keyCache.entries.toList()..sort((a, b) => a.value.expiresAt.compareTo(b.value.expiresAt));

    while (_keyCache.length > MAX_CACHE_ITEMS) {
      final oldest = sortedEntries.removeAt(0);
      _keyCache.remove(oldest.key);
    }
  }

  void _startCacheCleanup() {
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = Timer.periodic(CLEANUP_INTERVAL, (_) => _clearExpiredCache());
  }

  void _clearExpiredCache() {
    // Clear expired master keys
    final expiredKeys = _keyCache.entries.where((entry) => entry.value.isExpired).map((entry) => entry.key).toList();

    for (final key in expiredKeys) {
      _keyCache.remove(key);
    }

    // Clear expired derived keys
    final expiredDerivedKeys = _derivedKeyCache.entries.where((entry) => entry.value.isExpired).map((entry) => entry.key).toList();

    for (final key in expiredDerivedKeys) {
      _derivedKeyCache.remove(key);
    }
  }

  void _clearAllCache() {
    _keyCache.clear();
    _derivedKeyCache.clear();
  }

  // Security Operations
  Uint8List _generateSecureRandomBytes(int length) {
    // Use multiple entropy sources
    final entropy = <int>[];
    entropy.addAll(utf8.encode(DateTime.now().toIso8601String()));
    entropy.addAll(utf8.encode(DateTime.now().microsecondsSinceEpoch.toString()));
    entropy.addAll(utf8.encode(hashCode.toString()));

    // Add system entropy
    final systemRandom = Random.secure();
    for (int i = 0; i < config.EncryptionConfig.SECURE_RANDOM_SEED_LENGTH; i++) {
      entropy.add(systemRandom.nextInt(256));
    }

    // Ensure entropy is exactly 32 bytes (256 bits)
    final entropyBytes = Uint8List.fromList(sha256.convert(Uint8List.fromList(entropy)).bytes);

    // Use entropyBytes to seed our random generation
    final result = Uint8List(length);
    final random = Random.secure();

    // Mix entropy with secure random
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

  // Lifecycle
  void onAppBackground() {
    _clearAllCache();
    logInfo('All caches cleared on app background');
  }

  void dispose() {
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = null;
    _clearAllCache();
    logInfo('KeyManager disposed');
  }

  // Utilities
  static String _generateKeyInIsolate(Map<String, dynamic> params) {
    try {
      final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
      generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(base64.decode(params['salt'])), params['iterations'], params['keySize']));

      final input = '${params['deviceKey']}_${params['type']}';
      return base64.encode(generator.process(Uint8List.fromList(utf8.encode(input))));
    } catch (e) {
      throw Exception('Key generation failed: $e');
    }
  }

  void _logError(String message, Object error) {
    logError('[KeyManager] ERROR: $message: $error');
    _failedAttempts++;
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
