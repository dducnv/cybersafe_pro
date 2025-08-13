import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart' as pc;

class EncryptV2 {
  static final instance = EncryptV2._();
  EncryptV2._();

  static const _ivLength = config.EncryptionConfig.IV_LENGTH_GCM;
  static const _saltLength = config.EncryptionConfig.SALT_SIZE_BYTES;
  static const _encryptionContext = 'critical_encryption';

  static Uint8List _generateSalt() {
    final random = pc.SecureRandom('Fortuna');

    // Seed with multiple entropy sources
    final entropy = <int>[];
    entropy.addAll(utf8.encode(DateTime.now().toIso8601String()));
    entropy.addAll(utf8.encode(DateTime.now().microsecondsSinceEpoch.toString()));

    // Ensure entropy is exactly 32 bytes (256 bits) for Fortuna
    final entropyBytes = Uint8List.fromList(sha256.convert(Uint8List.fromList(entropy)).bytes);

    random.seed(pc.KeyParameter(entropyBytes));
    return random.nextBytes(_saltLength);
  }

  // Generate secure IV
  static enc.IV _generateIV() {
    final random = pc.SecureRandom('Fortuna');
    final entropy = utf8.encode(DateTime.now().microsecondsSinceEpoch.toString());

    // Ensure entropy is exactly 32 bytes (256 bits) for Fortuna
    final entropyBytes = Uint8List.fromList(sha256.convert(Uint8List.fromList(entropy)).bytes);

    random.seed(pc.KeyParameter(entropyBytes));
    return enc.IV(random.nextBytes(_ivLength));
  }

  static enc.Encrypter _getEncrypter(enc.Key key) {
    return enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm, padding: null));
  }

  // Create HMAC for integrity check
  static String _createHMAC(String data, String hmacKey) {
    final hmac = Hmac(sha256, base64.decode(hmacKey));
    return hmac.convert(utf8.encode(data)).toString();
  }

  // Verify HMAC with constant time comparison
  static bool _verifyHMAC(String data, String expectedHmac, String hmacKey) {
    final computedHmac = _createHMAC(data, hmacKey);
    return _constantTimeEquals(computedHmac, expectedHmac);
  }

  // Constant time string comparison to prevent timing attacks
  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;

    var result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  static Future<String> encrypt({
    required String plainText,
    required KeyType keyType,
    String? associatedData,
  }) async {
    if (plainText.isEmpty) {
      throw ArgumentError('plainText không được rỗng');
    }

    Uint8List? salt;
    Uint8List? aesKeyBytes;

    try {
      // Lấy derived keys từ KeyManager (đã có cache)
      final stopwatch = Stopwatch()..start();
      final derivedKeys = await KeyManager.instance.getDerivedKeys(
        keyType,
        _encryptionContext,
        purposes: ['aes', 'hmac'],
      );
      final keyTime = stopwatch.elapsedMilliseconds;
      if (keyTime > 100) {
        logInfo("getDerivedKeys took $keyTime ms");
      }

      final aesKey = derivedKeys['aes']!;
      final hmacKey = derivedKeys['hmac']!;

      // Tạo salt và IV
      salt = _generateSalt();
      final iv = _generateIV();

      // Mã hóa dữ liệu
      aesKeyBytes = base64.decode(aesKey);
      final encKey = enc.Key(aesKeyBytes);
      final encrypter = _getEncrypter(encKey);

      // Encrypt with associated data if provided
      final encrypted =
          associatedData != null
              ? encrypter.encrypt(plainText, iv: iv, associatedData: utf8.encode(associatedData))
              : encrypter.encrypt(plainText, iv: iv);

      // Tạo HMAC cho tính toàn vẹn
      final dataForHmac =
          '$plainText|${base64.encode(salt)}|${base64.encode(iv.bytes)}|${associatedData ?? ''}';
      final integrityHmac = _createHMAC(dataForHmac, hmacKey);

      // Đóng gói kết quả
      final package = {
        'salt': base64.encode(salt),
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'hmac': integrityHmac,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'version': '5.0',
        'algorithm': 'AES-256-GCM',
        'kdf': 'KeyManager-HKDF',
        'security_level': 'critical',
        'key_type': keyType.name,
        'context': _encryptionContext,
      };

      if (associatedData != null) {
        package['associatedData'] = base64.encode(utf8.encode(associatedData));
      }

      return json.encode(package);
    } catch (e, stackTrace) {
      logError("EncryptV2 encryption error: $e\n$stackTrace", functionName: "EncryptV2.encrypt");
      throw Exception('EncryptV2 encryption failed: $e');
    } finally {
      // Xóa dữ liệu nhạy cảm khỏi bộ nhớ
      if (salt != null) _secureWipe(salt);
      if (aesKeyBytes != null) _secureWipe(aesKeyBytes);
    }
  }

  static Future<String> decrypt({
    required String value,
    required KeyType keyType,
    String? associatedData,
  }) async {
    if (value.isEmpty) {
      throw ArgumentError('value không được rỗng');
    }

    Uint8List? salt;
    Uint8List? aesKeyBytes;

    try {
      // Parse dữ liệu mã hóa
      final package = json.decode(value) as Map<String, dynamic>;
      salt = base64.decode(package['salt']);
      final iv = enc.IV(base64.decode(package['iv']));
      final data = enc.Encrypted.fromBase64(package['data']);

      // Kiểm tra associated data
      String? packageAssociatedData;
      if (package.containsKey('associatedData')) {
        packageAssociatedData = utf8.decode(base64.decode(package['associatedData']));
      }

      if (associatedData != packageAssociatedData) {
        throw Exception('Associated data mismatch');
      }

      // Lấy derived keys từ KeyManager (đã có cache)
      final stopwatch = Stopwatch()..start();
      final derivedKeys = await KeyManager.instance.getDerivedKeys(
        keyType,
        _encryptionContext,
        purposes: ['aes', 'hmac'],
      );
      final keyTime = stopwatch.elapsedMilliseconds;
      if (keyTime > 100) {
        logInfo("getDerivedKeys took $keyTime ms");
      }

      final aesKey = derivedKeys['aes']!;
      final hmacKey = derivedKeys['hmac']!;

      // Giải mã dữ liệu
      aesKeyBytes = base64.decode(aesKey);
      final encKey = enc.Key(aesKeyBytes);
      final encrypter = _getEncrypter(encKey);

      final result =
          associatedData != null
              ? encrypter.decrypt(data, iv: iv, associatedData: utf8.encode(associatedData))
              : encrypter.decrypt(data, iv: iv);

      // Kiểm tra tính toàn vẹn
      if (package.containsKey('hmac')) {
        final dataForHmac =
            '$result|${base64.encode(salt)}|${base64.encode(iv.bytes)}|${associatedData ?? ''}';
        final expectedHmac = package['hmac'];

        if (!_verifyHMAC(dataForHmac, expectedHmac, hmacKey)) {
          logError("EncryptV2 HMAC integrity check failed", functionName: "EncryptV2.decrypt");
          throw Exception("EncryptV2 HMAC integrity check failed");
        }
      }

      return result;
    } catch (e, stackTrace) {
      logError("EncryptV2 decryption error: $e\n$stackTrace", functionName: "EncryptV2.decrypt");
      throw Exception('EncryptV2 decryption failed: $e');
    } finally {
      // Xóa dữ liệu nhạy cảm khỏi bộ nhớ
      if (salt != null) _secureWipe(salt);
      if (aesKeyBytes != null) _secureWipe(aesKeyBytes);
    }
  }

  static Map<String, dynamic> getEncryptionInfo(String encryptedData) {
    try {
      final package = json.decode(encryptedData) as Map<String, dynamic>;

      return {
        'version': package['version'] ?? '1.0',
        'algorithm': package['algorithm'] ?? 'AES-256-GCM',
        'kdf': package['kdf'] ?? 'KeyManager-HKDF',
        'timestamp': package['timestamp'],
        'hasAssociatedData': package.containsKey('associatedData'),
        'securityLevel': package['security_level'] ?? 'critical',
        'keyType': package['key_type'],
        'context': package['context'] ?? _encryptionContext,
      };
    } catch (e) {
      throw Exception('Invalid encrypted data format: $e');
    }
  }

  // Secure memory wipe
  static void _secureWipe(Uint8List data) {
    for (int pass = 0; pass < config.EncryptionConfig.MEMORY_WIPE_PASSES; pass++) {
      final random = pc.SecureRandom('Fortuna');

      // Seed with multiple entropy sources
      final entropy = utf8.encode(DateTime.now().microsecondsSinceEpoch.toString());

      // Ensure entropy is exactly 32 bytes (256 bits) for Fortuna
      final entropyBytes = Uint8List.fromList(sha256.convert(Uint8List.fromList(entropy)).bytes);

      random.seed(pc.KeyParameter(entropyBytes));

      final randomBytes = random.nextBytes(data.length);
      for (int i = 0; i < data.length; i++) {
        data[i] = randomBytes[i];
      }
    }
    data.fillRange(0, data.length, 0);
  }
}
