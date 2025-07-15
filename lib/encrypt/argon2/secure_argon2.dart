import 'dart:convert';
import 'dart:typed_data';
import 'package:cybersafe_pro/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:crypto/crypto.dart';

class SecureArgon2 {
  static final instance = SecureArgon2._();
  SecureArgon2._();

  static const _keyLength = 32; // 256-bit key
  // Sử dụng cấu hình chuẩn hóa từ EncryptionConfig
  static const _ivLength = config.EncryptionConfig.IV_LENGTH_GCM;

  static enc.Encrypter _getEncrypter(enc.Key key) {
    return enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm, padding: null));
  }

  // Tạo HMAC cho integrity check
  static String _createHMAC(String data, Uint8List key) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).toString();
  }

  // Xác thực HMAC
  static bool _verifyHMAC(String data, String expectedHmac, Uint8List key) {
    final computedHmac = _createHMAC(data, key);
    return computedHmac == expectedHmac;
  }

  static String encrypt({
    required String plainText,
    required String key,
    int? iterations,
    int? memoryPowerOf2,
    int? lanes,
    int version = Argon2Parameters.ARGON2_VERSION_13,
  }) {
    if (key.isEmpty || plainText.isEmpty) {
      throw ArgumentError('Key và plainText không được rỗng');
    }

    try {
      final salt = enc.SecureRandom(16).bytes;
      final iv = enc.IV.fromSecureRandom(_ivLength);
      
      // Sử dụng adaptive configuration từ EncryptionConfig
      final actualIterations = iterations ?? config.EncryptionConfig.argon2Iterations;
      final actualMemoryPowerOf2 = memoryPowerOf2 ?? config.EncryptionConfig.argon2MemoryPower;
      final actualLanes = lanes ?? config.EncryptionConfig.argon2Lanes;
      
      final argon2 = Argon2BytesGenerator();
      final params = Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        salt,
        version: version,
        iterations: actualIterations,
        memoryPowerOf2: actualMemoryPowerOf2,
        lanes: actualLanes,
        desiredKeyLength: _keyLength,
      );

      final keyInput = utf8.encode(key);
      argon2.init(params);
      final keyBytes = Uint8List(_keyLength);
      argon2.deriveKey(keyInput, 0, keyBytes, 0);
      final derivedKey = enc.Key(keyBytes);

      final encrypter = _getEncrypter(derivedKey);
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      // Sử dụng HMAC thay vì hash đơn giản cho integrity check
      final hmacKey = sha256.convert(keyBytes + utf8.encode('hmac')).bytes;
      final integrityHmac = _createHMAC(plainText, Uint8List.fromList(hmacKey));

      final package = {
        'salt': base64.encode(salt),
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'hmac': integrityHmac, // Thay 'hash' bằng 'hmac'
        'argon2': {
          'version': version,
          'iterations': actualIterations,
          'memoryPowerOfTwo': actualMemoryPowerOf2,
          'lanes': actualLanes,
          'keyLength': _keyLength,
        },
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'version': '2.0', // Thêm version để support migration
      };

      return json.encode(package);
    } catch (e, stackTrace) {
      logError("Argon2 encryption error: $e\n$stackTrace");
      throw Exception('Argon2 encryption failed: $e');
    }
  }

  static String decrypt({required String value, required String key}) {
    if (key.isEmpty || value.isEmpty) {
      throw ArgumentError('Key và value không được rỗng');
    }

    try {
      final package = json.decode(value) as Map<String, dynamic>;
      final salt = base64.decode(package['salt']);
      final iv = enc.IV(base64.decode(package['iv']));
      final data = enc.Encrypted.fromBase64(package['data']);
      final argon2Params = package['argon2'] as Map<String, dynamic>;

      final argon2 = Argon2BytesGenerator();
      final params = Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        salt,
        version: argon2Params['version'] ?? Argon2Parameters.ARGON2_VERSION_13,
        iterations: argon2Params['iterations'] ?? config.EncryptionConfig.argon2Iterations,
        memoryPowerOf2: argon2Params['memoryPowerOfTwo'] ?? config.EncryptionConfig.argon2MemoryPower,
        lanes: argon2Params['lanes'] ?? config.EncryptionConfig.argon2Lanes,
        desiredKeyLength: argon2Params['keyLength'] ?? _keyLength,
      );

      final keyInput = utf8.encode(key);
      argon2.init(params);
      final keyBytes = Uint8List(_keyLength);
      argon2.deriveKey(keyInput, 0, keyBytes, 0);
      final derivedKey = enc.Key(keyBytes);

      final encrypter = _getEncrypter(derivedKey);
      final result = encrypter.decrypt(data, iv: iv);

      // Kiểm tra integrity với HMAC
      if (package.containsKey('hmac')) {
        final hmacKey = sha256.convert(keyBytes + utf8.encode('hmac')).bytes;
        final expectedHmac = package['hmac'];
        if (!_verifyHMAC(result, expectedHmac, Uint8List.fromList(hmacKey))) {
          logError("Argon2 HMAC integrity check failed");
          throw Exception("Argon2 HMAC integrity check failed");
        }
      } else if (package.containsKey('hash')) {
        // Backward compatibility với hash cũ
        final checkHash = sha256.convert(utf8.encode(result)).toString();
        if (checkHash != package['hash']) {
          logError("Argon2 hash integrity check failed");
          throw Exception("Argon2 hash integrity check failed");
        }
      }

      return result;
    } catch (e, stackTrace) {
      logError("Argon2 decryption error: $e\n$stackTrace");
      throw Exception('Argon2 decryption failed: $e');
    }
  }
}
