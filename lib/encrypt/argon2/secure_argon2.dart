import 'dart:convert';
import 'dart:typed_data';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';

class SecureArgon2 {
  static final instance = SecureArgon2._();
  SecureArgon2._();

  static const _keyLength = 32; // 256-bit key
  static const _ivLength = 16; // 128-bit IV for AES

  static enc.Encrypter _getEncrypter(enc.Key key) {
    return enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm, padding: null));
  }

  // Encrypt function
  static String encrypt({
    required String plainText,
    required String key,
    int iterations = 2,
    int memoryPowerOf2 = 19, // 2^19 = 512MB
    int lanes = 2,
    int version = Argon2Parameters.ARGON2_VERSION_13,
  }) {
    try {
      if (key.isEmpty || plainText.isEmpty) return plainText;
      final salt = enc.SecureRandom(16).bytes;
      final iv = enc.IV.fromSecureRandom(_ivLength);
      final argon2 = Argon2BytesGenerator();
      final params = Argon2Parameters(Argon2Parameters.ARGON2_id, salt, version: version, iterations: iterations, memoryPowerOf2: memoryPowerOf2, lanes: lanes, desiredKeyLength: _keyLength);

      // Generate key from password using Argon2
      argon2.init(params);
      final input = Uint8List.fromList(utf8.encode(key));
      final keyBytes = Uint8List(_keyLength);
      argon2.deriveKey(input, 0, keyBytes, 0);
      final derivedKey = enc.Key(keyBytes);

      final encrypter = _getEncrypter(derivedKey);
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      final package = {
        'kdf': 'argon2id',
        'salt': base64.encode(salt),
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'argon2': {'version': version, 'iterations': iterations, 'memoryPowerOfTwo': memoryPowerOf2, 'lanes': lanes, 'keyLength': _keyLength},
      };

      return json.encode(package);
    } catch (e) {
      logError("Encryption error (Argon2): $e");
      return plainText;
    }
  }

  // Decrypt function
  static String decrypt({required String value, required String key}) {
    try {
      if (key.isEmpty || value.isEmpty) return value;

      Map<String, dynamic> package;
      try {
        package = json.decode(value) as Map<String, dynamic>;
      } catch (e) {
        return value;
      }

      if (package['kdf'] != 'argon2id') return value;

      final salt = base64.decode(package['salt']);
      final iv = enc.IV(base64.decode(package['iv']));
      final data = enc.Encrypted.fromBase64(package['data']);
      final argon2Params = package[ 'argon2'] as Map<String, dynamic>;

      // Set up Argon2 parameters
      final argon2 = Argon2BytesGenerator();
      final params = Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        salt,
        version: argon2Params['version'] ?? Argon2Parameters.ARGON2_VERSION_13,
        iterations: argon2Params['iterations'] ?? 2,
        memoryPowerOf2: argon2Params['memoryPowerOfTwo'] ?? 19,
        lanes: argon2Params['lanes'] ?? 2,
        desiredKeyLength: argon2Params['keyLength'] ?? _keyLength,
      );

      argon2.init(params);
      final input = Uint8List.fromList(utf8.encode(key));
      final keyBytes = Uint8List(_keyLength);
      argon2.deriveKey(input, 0, keyBytes, 0);
      final derivedKey = enc.Key(keyBytes);

      final encrypter = _getEncrypter(derivedKey);
      final result = encrypter.decrypt(data, iv: iv);
      return result;
    } catch (e) {
      logError("Decryption error (Argon2): $e");
      return value;
    }
  }
}
