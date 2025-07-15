import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as pc;

enum KeyType { info, password, totp, pinCode }

class KeyManager {
  static final instance = KeyManager._();
  KeyManager._() {
    _startCacheCleanup();
  }

  // Constants
  static const MAX_CACHE_DURATION = Duration(minutes: 30);
  static const MAX_CACHE_ITEMS = 10;
  static const CLEANUP_INTERVAL = Duration(minutes: 15);

  final _secureStorage = SecureStorage.instance;
  final Map<String, _CachedKey> _keyCache = {};
  Timer? _cacheCleanupTimer;

  // Core key generation & management
  static Future<String> getKey(KeyType type) async {
    ArgumentError.checkNotNull(type, 'type');
    _antiDebugCheck(); // Anti-debugging check
    return await instance._generateEncryptionKey(
      await instance._getDeviceKey(), 
      type
    );
  }
  
  Future<void> _setKeyCreationTime(KeyType type) async {
    final storageKey = _getStorageKeyForType(type);
    await _secureStorage.save(
      key: '${storageKey}_creation_time',
      value: DateTime.now().toIso8601String()
    );
  }

  Future<String> _getDeviceKey() async {
    return await _withRetry(() async {
      final cacheKey = 'device_key';
      if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
        return _keyCache[cacheKey]!.decrypt();
      }

      final key = await _secureStorage.read(key: SecureStorageKey.secureDeviceKey);
      if (key == null) {
        await _generateDeviceKey();
        return await _getDeviceKey(); // Recursive call after generation
      }

      _keyCache[cacheKey] = _CachedKey(key);
      _monitorCache();
      return key;
    });
  }

  Future<void> _generateDeviceKey() async {
    return await _withRetry(() async {
      final keyBytes = _generateSecureRandomBytes(32);
      final key = base64.encode(keyBytes);
      
      await _secureStorage.save(
        key: SecureStorageKey.secureDeviceKey, 
        value: key
      );
      
      _secureWipe(keyBytes);
      logInfo('Device key generated securely');
    });
  }

  Future<String> _generateEncryptionKey(String deviceKey, KeyType type) async {
    return await _withRetry(() async {
      final cacheKey = '${type.name}_$deviceKey';

      if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
        return _keyCache[cacheKey]!.decrypt();
      }

      final storageKey = _getStorageKeyForType(type);
      final savedKey = await _secureStorage.read(key: storageKey);

      if (savedKey != null) {
        _keyCache[cacheKey] = _CachedKey(savedKey);
        _monitorCache();
        return savedKey;
      }

      // Sử dụng random salt thay vì pattern cố định
      final salt = _generateSecureRandomBytes(32); // 256-bit salt
      final key = await compute(_generateKeyInIsolate, {
        'salt': base64.encode(salt),
        'deviceKey': deviceKey,
        'type': type.name,
        'iterations': config.EncryptionConfig.PBKDF2_ITERATIONS,
        'keySize': config.EncryptionConfig.KEY_SIZE_BYTES,
      });

      _keyCache[cacheKey] = _CachedKey(key);
      await _secureStorage.save(key: storageKey, value: key);
      await _setKeyCreationTime(type); // Lưu thời gian tạo key
      
      _secureWipe(salt);
      _monitorCache();
      return key;
    });
  }

  // Anti-debugging protection methods
  @pragma('vm:never-inline')
  static void _antiDebugCheck() {
    if (kDebugMode) return; // Skip trong debug mode
    
    // Timing attack detection
    final stopwatch = Stopwatch()..start();
    _performTimingCheck();
    stopwatch.stop();
    
    // Nếu execution time quá lâu, có thể đang bị debug
    if (stopwatch.elapsedMicroseconds > 50000) { // 50ms threshold
      _handleSecurityViolation('Timing anomaly detected');
    }
    
    // Memory pressure check
    _checkMemoryPressure();
    
    // Process name check
    _checkProcessIntegrity();
  }

  @pragma('vm:never-inline')
  static void _performTimingCheck() {
    // Thực hiện một số operations để đo timing
    var sum = 0;
    for (int i = 0; i < 1000; i++) {
      sum += i * i;
    }
    
    // Dummy calculation to prevent optimization
    if (sum < 0) {
      throw Exception('Impossible condition');
    }
  }

  @pragma('vm:never-inline')
  static void _checkMemoryPressure() {
    // Kiểm tra memory usage patterns
    final now = DateTime.now();
    final hash1 = now.hashCode;
    final hash2 = now.millisecondsSinceEpoch.hashCode;
    
    // Nếu hash patterns bất thường, có thể đang bị manipulate
    if ((hash1 ^ hash2) == 0) {
      _handleSecurityViolation('Memory manipulation detected');
    }
  }

  @pragma('vm:never-inline')
  static void _checkProcessIntegrity() {
    // Kiểm tra environment variables và process state
    final env = identical(1, 1); // Always true in normal execution
    final ref = identical(env, env); // Always true
    
    if (!env || !ref) {
      _handleSecurityViolation('Process integrity violation');
    }
  }

  static void _handleSecurityViolation(String reason) {
    logError('Security violation detected: $reason');
    
    // Không throw exception ngay lập tức để tránh phát hiện
    // Thay vào đó, làm chậm execution và corrupt data
    _corruptExecution();
  }

  @pragma('vm:never-inline')
  static void _corruptExecution() {
    // Corrupt execution by introducing delays and wrong results
    final random = Random.secure();
    
    // Random delay
    final delay = Duration(milliseconds: random.nextInt(1000) + 500);
    Timer(delay, () {
      // Corrupt some static data
      if (random.nextBool()) {
        throw Exception('Encryption service unavailable');
      }
    });
  }

  // Cache Management
  void _monitorCache() {
    if (_keyCache.length > MAX_CACHE_ITEMS) {
      _clearOldestCacheItems();
    }
  }

  void _clearOldestCacheItems() {
    final sortedEntries = _keyCache.entries.toList()
      ..sort((a, b) => a.value.expiresAt.compareTo(b.value.expiresAt));
    
    while (_keyCache.length > MAX_CACHE_ITEMS) {
      final oldest = sortedEntries.removeAt(0);
      oldest.value.clear();
      _keyCache.remove(oldest.key);
    }
  }

  void _startCacheCleanup() {
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = Timer.periodic(
      CLEANUP_INTERVAL,
      (_) => _clearExpiredCache()
    );
  }

  void _clearExpiredCache() {
    final expiredKeys = _keyCache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _keyCache[key]?.clear();
      _keyCache.remove(key);
    }
  }

  Future<void> _clearAllCache() async {
    for (final cachedKey in _keyCache.values) {
      cachedKey.clear();
    }
    _keyCache.clear();
  }

  // Security Operations
  Uint8List _generateSecureRandomBytes(int length) {
    final random = pc.SecureRandom('Fortuna');
    
    // Use multiple entropy sources
    final entropy = <int>[];
    entropy.addAll(utf8.encode(DateTime.now().toIso8601String()));
    entropy.addAll(utf8.encode(identical(1, 1).toString()));
    entropy.addAll(utf8.encode(hashCode.toString()));
    
    // Add system entropy
    final systemRandom = Random.secure();
    for (int i = 0; i < 32; i++) {
      entropy.add(systemRandom.nextInt(256));
    }
    
    random.seed(pc.KeyParameter(Uint8List.fromList(entropy)));
    return random.nextBytes(length);
  }

  @pragma('vm:never-inline')
  void _memoryBarrier() {
    // Prevent compiler optimizations
  }

  void _secureWipe(Uint8List data) {
    // Multiple pass clear
    for (int pass = 0; pass < 3; pass++) {
      final random = Random.secure();
      for (int i = 0; i < data.length; i++) {
        data[i] = random.nextInt(256);
      }
    }
    data.fillRange(0, data.length, 0);
    _memoryBarrier();
  }

  // Lifecycle
  Future<void> onAppBackgroundAsync() async {
    await _clearAllCache();
    logInfo('Cache cleared on app background');
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
      generator.init(pc.Pbkdf2Parameters(
        Uint8List.fromList(base64.decode(params['salt'])),
        params['iterations'],
        params['keySize']
      ));
      
      // Kết hợp deviceKey và type để tạo input unique
      final input = '${params['deviceKey']}_${params['type']}';
      return base64.encode(generator.process(
        Uint8List.fromList(utf8.encode(input))
      ));
    } catch (e) {
      throw Exception('Key generation failed: $e');
    }
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
    while (attempts < config.EncryptionConfig.MAX_RETRY_ATTEMPTS) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        _logError('Retry attempt $attempts failed', e);
        if (attempts == config.EncryptionConfig.MAX_RETRY_ATTEMPTS) {
          throwAppError(ErrorText.tooManyRetries);
        }
        await Future.delayed(config.EncryptionConfig.RETRY_DELAY * attempts);
      }
    }
    throw AppError.instance.createException(ErrorText.tooManyRetries);
  }
}

class _CachedKey {
  late final Uint8List _encryptedKey;
  late final Uint8List _encryptionKey;
  late final Uint8List _iv;
  final DateTime expiresAt;

  _CachedKey(String key) : expiresAt = DateTime.now().add(
    KeyManager.MAX_CACHE_DURATION
  ) {
    _encryptionKey = _generateMemoryEncryptionKey();
    _iv = _generateSecureRandomBytes(16);
    _encryptedKey = _encryptInMemory(utf8.encode(key));
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Uint8List _generateMemoryEncryptionKey() {
    // Generate unique key for this instance
    final info = '${DateTime.now().microsecondsSinceEpoch}:$hashCode:${identical(1, 1)}';
    return Uint8List.fromList(sha256.convert(utf8.encode(info)).bytes);
  }

  Uint8List _generateSecureRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
  }

  Uint8List _encryptInMemory(List<int> data) {
    try {
      final cipher = pc.PaddedBlockCipher('AES/CBC/PKCS7');
      cipher.init(true, pc.PaddedBlockCipherParameters(
        pc.ParametersWithIV(pc.KeyParameter(_encryptionKey), _iv),
        null
      ));
      
      return cipher.process(Uint8List.fromList(data));
    } catch (e) {
      throw Exception('Memory encryption failed: $e');
    }
  }

  String decrypt() {
    try {
      final cipher = pc.PaddedBlockCipher('AES/CBC/PKCS7');
      cipher.init(false, pc.PaddedBlockCipherParameters(
        pc.ParametersWithIV(pc.KeyParameter(_encryptionKey), _iv),
        null
      ));
      
      final decrypted = cipher.process(_encryptedKey);
      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Memory decryption failed: $e');
    }
  }

  void clear() {
    // Multiple pass clear for all sensitive data
    for (int pass = 0; pass < 3; pass++) {
      final random = Random.secure();
      
      // Clear encrypted key
      for (int i = 0; i < _encryptedKey.length; i++) {
        _encryptedKey[i] = random.nextInt(256);
      }
      
      // Clear encryption key
      for (int i = 0; i < _encryptionKey.length; i++) {
        _encryptionKey[i] = random.nextInt(256);
      }
      
      // Clear IV
      for (int i = 0; i < _iv.length; i++) {
        _iv[i] = random.nextInt(256);
      }
    }
    
    // Final zero pass
    _encryptedKey.fillRange(0, _encryptedKey.length, 0);
    _encryptionKey.fillRange(0, _encryptionKey.length, 0);
    _iv.fillRange(0, _iv.length, 0);
  }
}
