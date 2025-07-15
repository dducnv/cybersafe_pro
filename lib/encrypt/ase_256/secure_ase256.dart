import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;

class SecureAse256 {
  static final instance = SecureAse256._();
  SecureAse256._();

  // Sử dụng cấu hình chuẩn hóa từ EncryptionConfig
  static const int _ivLength = config.EncryptionConfig.IV_LENGTH_GCM;

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

  static String encrypt({required String value, required String key}) {
    if (key.isEmpty || value.isEmpty) {
      throw ArgumentError('Key và value không được rỗng');
    }

    try {
      final salt = enc.IV.fromSecureRandom(16).bytes; // 128-bit salt
      
      final keyWithSalt = utf8.encode(key) + salt;
      final hashedKey = sha256.convert(keyWithSalt).bytes;
      final derivedKey = enc.Key(Uint8List.fromList(hashedKey));

      final iv = _generateIV();
      
      final encrypter = enc.Encrypter(enc.AES(derivedKey, mode: enc.AESMode.gcm));
      final encrypted = encrypter.encrypt(value, iv: iv);

      // Sử dụng HMAC thay vì hash đơn giản cho integrity check
      final hmacKey = sha256.convert(hashedKey + utf8.encode('hmac')).bytes;
      final integrityHmac = _createHMAC(value, Uint8List.fromList(hmacKey));

      final package = {
        'salt': base64.encode(salt),
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'hmac': integrityHmac, // Thay 'hash' bằng 'hmac'
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'version': '2.0', // Thêm version để support migration
      };

      return json.encode(package);
    } catch (e, stackTrace) {
      logError("AES256 encryption error: $e\n$stackTrace");
      throw Exception('AES256 encryption failed: $e');
    }
  }

  static String decrypt({required String encryptedData, required String key}) {
    if (key.isEmpty || encryptedData.isEmpty) {
      throw ArgumentError('Key và encryptedData không được rỗng');
    }

    try {
      final package = json.decode(encryptedData) as Map<String, dynamic>;
      final salt = base64.decode(package['salt']);
      final iv = enc.IV(base64.decode(package['iv']));
      final encrypted = enc.Encrypted.fromBase64(package['data']);

      final keyWithSalt = utf8.encode(key) + salt;
      final hashedKey = sha256.convert(keyWithSalt).bytes;
      final derivedKey = enc.Key(Uint8List.fromList(hashedKey));

      final encrypter = enc.Encrypter(enc.AES(derivedKey, mode: enc.AESMode.gcm));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      // Kiểm tra integrity với HMAC
      if (package.containsKey('hmac')) {
        final hmacKey = sha256.convert(hashedKey + utf8.encode('hmac')).bytes;
        final expectedHmac = package['hmac'];
        if (!_verifyHMAC(decrypted, expectedHmac, Uint8List.fromList(hmacKey))) {
          logError("AES256 HMAC integrity check failed");
          throw Exception("AES256 HMAC integrity check failed");
        }
      } else if (package.containsKey('hash')) {
        // Backward compatibility với hash cũ
        final checkHash = sha256.convert(utf8.encode(decrypted)).toString();
        if (checkHash != package['hash']) {
          logError("AES256 hash integrity check failed");
          throw Exception("AES256 hash integrity check failed");
        }
      }

      return decrypted;
    } catch (e, stackTrace) {
      logError("AES256 decryption error: $e\n$stackTrace");
      throw Exception('AES256 decryption failed: $e');
    }
  }

  static enc.IV _generateIV() => enc.IV.fromSecureRandom(_ivLength);
}
