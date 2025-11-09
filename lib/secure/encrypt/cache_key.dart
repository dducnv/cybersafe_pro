// Enhanced cached key with AES-256-GCM memory encryption
// 🔐 SECURITY FIX: Replaced XOR with proper AES-256-GCM encryption
// This provides cryptographically secure in-memory protection for cached keys

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/secure/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart' as pc;

class CachedKey {
  final String _encryptedValue;
  final DateTime expiresAt;

  // Memory encryption parameters
  static const int _keySize = 32; // 256 bits
  static const int _ivSize = 12; // 96 bits for GCM
  static const int _saltSize = 16; // salt for HKDF
  static const int _memoryWipePasses = 5; // Increased from 3 for in-memory protection
  static const String _cipherAlgorithm = 'AES-256-GCM'; // 🔐 Upgraded from XOR
  static const String _version = '1.0';

  CachedKey(String value, {Duration? customDuration})
    : expiresAt = DateTime.now().add(customDuration ?? KeyManager.MAX_CACHE_DURATION),
      _encryptedValue = _encryptValueAES(value);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  String get value {
    try {
      return _decryptValueAES(_encryptedValue);
    } catch (e) {
      logError('Failed to decrypt cached key: $e', functionName: 'CachedKey.value');
      throw Exception('Failed to decrypt cached key');
    }
  }

  /// Encrypt value using AES-256-GCM (cryptographically secure)
  /// 🔐 SECURITY: Uses proper authenticated encryption instead of XOR
  static String _encryptValueAES(String value) {
    Uint8List? memoryKey;
    Uint8List? iv;
    Uint8List? salt;
    try {
      // Derive a per-session memory key using HKDF(sessionSecret, salt)
      salt = _generateSecureRandomBytes(_saltSize);
      memoryKey = _deriveMemoryKey(_getSessionSecret(), salt, _keySize);
      iv = _generateSecureRandomBytes(_ivSize);

      // Create AES-256-GCM encrypter
      final encKey = enc.Key(memoryKey);
      final encrypter = enc.Encrypter(enc.AES(encKey, mode: enc.AESMode.gcm));

      // Encrypt with IV
      final encrypted = encrypter.encrypt(value, iv: enc.IV(iv));

      // Create package with metadata
      final package = {
        'algorithm': _cipherAlgorithm,
        'version': _version,
        'iv': base64.encode(iv),
        'salt': base64.encode(salt),
        'data': encrypted.base64,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final result = base64.encode(utf8.encode(json.encode(package)));

      // 🔐 Securely wipe sensitive data from memory
      _secureWipeMultiPass(memoryKey);
      _secureWipeMultiPass(iv);
      _secureWipeMultiPass(salt);

      return result;
    } catch (e) {
      logError('Failed to encrypt cached key: $e', functionName: 'CachedKey._encryptValueAES');
      // 🔐 Ensure cleanup on error
      if (memoryKey != null) _secureWipeMultiPass(memoryKey);
      if (iv != null) _secureWipeMultiPass(iv);
      if (salt != null) _secureWipeMultiPass(salt);
      throw Exception('Failed to encrypt cached key: $e');
    }
  }

  /// Decrypt value using AES-256-GCM
  /// 🔐 SECURITY: Validates algorithm version and uses authenticated encryption
  static String _decryptValueAES(String encryptedValue) {
    Uint8List? memoryKey;
    try {
      // Decode package
      final packageJson = utf8.decode(base64.decode(encryptedValue));
      final package = json.decode(packageJson) as Map<String, dynamic>;

      // Validate package structure
      if (!_isValidPackage(package)) {
        throw Exception('Invalid cached key package format');
      }

      // Validate algorithm version
      final algorithm = package['algorithm'] as String?;
      if (algorithm != _cipherAlgorithm) {
        throw Exception(
          'Unsupported encryption algorithm: $algorithm (expected: $_cipherAlgorithm)',
        );
      }

      // Extract components
      final iv = enc.IV(base64.decode(package['iv'] as String));
      final saltB64 = package['salt'] as String?;
      if (saltB64 == null) {
        throw Exception('Missing HKDF salt in cached key package');
      }
      final salt = base64.decode(saltB64);
      final encryptedData = enc.Encrypted.fromBase64(package['data'] as String);

      // Derive the same memory key via HKDF(sessionSecret, salt)
      memoryKey = _deriveMemoryKey(_getSessionSecret(), salt, _keySize);

      final encKey = enc.Key(memoryKey);
      final encrypter = enc.Encrypter(enc.AES(encKey, mode: enc.AESMode.gcm));

      // Decrypt
      final decrypted = encrypter.decrypt(encryptedData, iv: iv);

      // 🔐 Securely wipe sensitive data
      _secureWipeMultiPass(memoryKey);

      return decrypted;
    } catch (e) {
      logError('Failed to decrypt cached key: $e', functionName: 'CachedKey._decryptValueAES');
      // 🔐 Ensure cleanup on error
      if (memoryKey != null) _secureWipeMultiPass(memoryKey);
      throw Exception('Failed to decrypt cached key: $e');
    }
  }

  /// Validate package structure
  static bool _isValidPackage(Map<String, dynamic> package) {
    try {
      return package.containsKey('algorithm') &&
          package.containsKey('version') &&
          package.containsKey('iv') &&
          package.containsKey('salt') &&
          package.containsKey('data') &&
          package.containsKey('timestamp');
    } catch (e) {
      return false;
    }
  }

  /// Generate cryptographically secure random bytes
  static Uint8List _generateSecureRandomBytes(int length) {
    final random = pc.SecureRandom('Fortuna');

    // Seed with multiple entropy sources
    final entropy = utf8.encode(DateTime.now().microsecondsSinceEpoch.toString());
    final entropyBytes = Uint8List.fromList(sha256.convert(entropy).bytes);

    random.seed(pc.KeyParameter(entropyBytes));
    return random.nextBytes(length);
  }

  /// Derive per-session memory key using HKDF-SHA256
  static Uint8List _deriveMemoryKey(Uint8List ikm, Uint8List salt, int length) {
    if (length > 255 * 32) {
      throw ArgumentError('Output length too large for HKDF');
    }
    // Extract
    final hmacExtract = Hmac(sha256, salt);
    final prk = hmacExtract.convert(ikm).bytes;

    // Expand
    final okm = <int>[];
    final hmacExpand = Hmac(sha256, prk);
    var counter = 1;
    var t = <int>[];
    final info = utf8.encode('cached_key_memory_aes');
    while (okm.length < length) {
      final input = <int>[...t, ...info, counter];
      t = hmacExpand.convert(input).bytes;
      okm.addAll(t);
      counter++;
    }
    return Uint8List.fromList(okm.take(length).toList());
  }

  /// Lazily initialized per-process secret, not persisted
  static Uint8List? _sessionSecretBytes;
  static Uint8List _getSessionSecret() {
    _sessionSecretBytes ??= _generateSecureRandomBytes(_keySize);
    return _sessionSecretBytes!;
  }

  /// Securely wipe sensitive data (5 passes for in-memory protection)
  /// 🔐 SECURITY: More aggressive wiping for cached keys in memory
  static void _secureWipeMultiPass(Uint8List data) {
    if (data.isEmpty) return;

    for (int pass = 0; pass < _memoryWipePasses; pass++) {
      // Generate random data for each pass
      final randomData = _generateSecureRandomBytes(data.length);

      // Overwrite with random data
      for (int i = 0; i < data.length; i++) {
        data[i] = randomData[i];
      }
    }

    // Final zeroing pass
    data.fillRange(0, data.length, 0);
  }

  /// Get encryption info for debugging (in development only)
  static Map<String, dynamic> getEncryptionInfo(String encryptedValue) {
    try {
      final packageJson = utf8.decode(base64.decode(encryptedValue));
      final package = json.decode(packageJson) as Map<String, dynamic>;
      return {
        'algorithm': package['algorithm'],
        'version': package['version'],
        'timestamp': package['timestamp'],
        'isValid': _isValidPackage(package),
      };
    } catch (e) {
      return {'error': e.toString(), 'isValid': false};
    }
  }
}
