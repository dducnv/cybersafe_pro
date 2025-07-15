import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;

class SecureAse256 {
  static final instance = SecureAse256._();
  SecureAse256._();

  static const int _keyLength = 32; // 256 bits
  static const int _ivLength = 12; // 96 bits for GCM

  static String encrypt({required String value, required String key}) {
    if (key.isEmpty || value.isEmpty) return value;

    try {
      
      final salt = enc.IV.fromSecureRandom(_keyLength).bytes;

      final keyBytes = sha256.convert(utf8.encode(key) + salt).bytes;
      final derivedKey = enc.Key(Uint8List.fromList(keyBytes));

      final iv = _generateIV();
      final encrypter = enc.Encrypter(enc.AES(derivedKey, mode: enc.AESMode.gcm));

      final encrypted = encrypter.encrypt(value, iv: iv);

      final integrityHash = sha256.convert(utf8.encode(value)).toString();

      final package = {
        'version': 1,
        'salt': base64.encode(salt),
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'hash': integrityHash,
        'kdf': 'sha256',
        'algo': 'aes-gcm',
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      };

      return json.encode(package);
    } catch (e, stackTrace) {
      logError("Encryption error: $e\n$stackTrace");
      return value;
    }
  }

  static String decrypt({required String encryptedData, required String key}) {
    if (key.isEmpty || encryptedData.isEmpty) return encryptedData;

    try {
      final package = json.decode(encryptedData);
      final salt = base64.decode(package['salt']);
      final iv = enc.IV(base64.decode(package['iv']));
      final encrypted = enc.Encrypted.fromBase64(package['data']);

      late enc.Key derivedKey;

      final keyBytes = sha256.convert(utf8.encode(key) + salt).bytes;
      derivedKey = enc.Key(Uint8List.fromList(keyBytes));

      final encrypter = enc.Encrypter(enc.AES(derivedKey, mode: enc.AESMode.gcm));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      if (package.containsKey('hash')) {
        final checkHash = sha256.convert(utf8.encode(decrypted)).toString();
        if (checkHash != package['hash']) {
          logError("Integrity check failed: hash mismatch");
          throw Exception("Integrity check failed");
        }
      }

      return decrypted;
    } catch (e, stackTrace) {
      logError("Decryption error: $e\n$stackTrace");
      return encryptedData;
    }
  }

  static enc.IV _generateIV() => enc.IV.fromSecureRandom(_ivLength);
}
