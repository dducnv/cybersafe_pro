import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/secure/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/secure/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as pc;

class EncryptV2 {
  static final instance = EncryptV2._();
  EncryptV2._();

  static const _ivLength = config.EncryptionConfig.IV_LENGTH_GCM;
  static const _saltLength = config.EncryptionConfig.SALT_SIZE_BYTES;
  static const _encryptionContext = 'critical_encryption';

  static Uint8List _secureRandomBytes(int length) {
    final sys = Random.secure();
    return Uint8List.fromList(List<int>.generate(length, (_) => sys.nextInt(256)));
  }

  static Uint8List _generateSalt() {
    return _secureRandomBytes(_saltLength);
  }

  // Generate secure IV
  static enc.IV _generateIV() {
    return enc.IV(_secureRandomBytes(_ivLength));
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

  // Local HKDF (HMAC-SHA256)
  static Uint8List _hkdf({
    required Uint8List inputKeyMaterial,
    required Uint8List salt,
    required Uint8List info,
    required int length,
  }) {
    if (length > 255 * 32) {
      throw ArgumentError('Output length too large for HKDF');
    }

    final hmacExtract = Hmac(sha256, salt);
    final prk = hmacExtract.convert(inputKeyMaterial).bytes;

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

  static Future<String> encrypt({
    required String plainText,
    required KeyType keyType,
    String? associatedData,
  }) async {
    if (plainText.isEmpty) {
      throw ArgumentError('plainText không được rỗng');
    }

    try {
      // Lấy master secret đã được dẫn xuất/cached từ KeyManager (Argon2 chỉ chạy khi unlock)
      final baseSecretB64 = await KeyManager.getKey(keyType);

      // Chạy trong isolate để tránh block UI
      final result = await compute<Map<String, dynamic>, String>(_encryptHKDFInIsolate, {
        'plainText': plainText,
        'baseSecret': baseSecretB64,
        'associatedData': associatedData,
      });

      return result;
    } catch (e, stackTrace) {
      logError("EncryptV2 encryption error: $e\n$stackTrace", functionName: "EncryptV2.encrypt");
      throw Exception('EncryptV2 encryption failed: $e');
    }
  }

  static Future<String> decrypt({
    required String value,
    required KeyType keyType,
    String? associatedData,
    bool fromMigrate = false,
  }) async {
    if (value.isEmpty) {
      throw ArgumentError('value không được rỗng');
    }

    Uint8List? salt;
    Uint8List? aesKeyBytes;

    try {
      final package = json.decode(value) as Map<String, dynamic>;
      salt = base64.decode(package['salt']);
      final iv = enc.IV(base64.decode(package['iv']));
      final data = enc.Encrypted.fromBase64(package['data']);

      String? packageAssociatedData;
      if (package.containsKey('associatedData')) {
        packageAssociatedData = utf8.decode(base64.decode(package['associatedData']));
      }

      if (associatedData != packageAssociatedData) {
        throw Exception('Associated data mismatch');
      }

      final kdf = (package['kdf'] as String?) ?? 'KeyManager-HKDF';

      String result;
      if (kdf == 'KeyManager-HKDF_V2') {
        final baseSecretB64 = await KeyManager.getKey(keyType, fromMigrate: fromMigrate);

        return await compute<Map<String, dynamic>, String>(_decryptHKDFInIsolate, {
          'encryptedData': package['data'],
          'iv': package['iv'],
          'salt': package['salt'],
          'baseSecret': baseSecretB64,
          'associatedData': associatedData,
        });
      } else {
        // Backward-compatible flow (old): KeyManager-derived AES/HMAC
        final stopwatch = Stopwatch()..start();
        final derivedKeys = await KeyManager.getDerivedKeys(
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

        aesKeyBytes = base64.decode(aesKey);
        final encKey = enc.Key(aesKeyBytes);
        final encrypter = _getEncrypter(encKey);
        result =
            associatedData != null
                ? encrypter.decrypt(data, iv: iv, associatedData: utf8.encode(associatedData))
                : encrypter.decrypt(data, iv: iv);

        if (package.containsKey('hmac')) {
          final dataForHmac =
              '$result|${base64.encode(salt)}|${base64.encode(iv.bytes)}|${associatedData ?? ''}';
          final expectedHmac = package['hmac'];

          if (!_verifyHMAC(dataForHmac, expectedHmac, hmacKey)) {
            logError("EncryptV2 HMAC integrity check failed", functionName: "EncryptV2.decrypt");
            throw Exception("EncryptV2 HMAC integrity check failed");
          }
        }
      }

      return result;
    } catch (e, stackTrace) {
      logError("EncryptV2 decryption error: $e\n$stackTrace", functionName: "EncryptV2.decrypt");
      throw Exception('EncryptV2 decryption failed: $e');
    } finally {
      if (salt != null) _secureWipe(salt);
      if (aesKeyBytes != null) _secureWipe(aesKeyBytes);
    }
  }

  static String _encryptHKDFInIsolate(Map<String, dynamic> params) {
    try {
      final plainText = params['plainText'] as String;
      final baseSecretB64 = params['baseSecret'] as String;
      final associatedData = params['associatedData'] as String?;

      final baseSecretBytes = Uint8List.fromList(base64.decode(baseSecretB64));
      final salt = _generateSalt();
      final iv = _generateIV();

      // HKDF → tách AES/HMAC key (HMAC không bắt buộc vì AES-GCM có tag, nhưng giữ để đồng bộ)
      final okm = _hkdf(
        inputKeyMaterial: baseSecretBytes,
        salt: salt,
        info: Uint8List.fromList(utf8.encode('aes_hmac_$_encryptionContext')),
        length: 64,
      );
      final aesKey = Uint8List.fromList(okm.sublist(0, 32));
      final encKey = enc.Key(aesKey);
      final encrypter = _getEncrypter(encKey);

      final encrypted =
          associatedData != null
              ? encrypter.encrypt(plainText, iv: iv, associatedData: utf8.encode(associatedData))
              : encrypter.encrypt(plainText, iv: iv);

      final package = {
        'salt': base64.encode(salt),
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'version': '6.1',
        'algorithm': 'AES-256-GCM',
        'kdf': 'KeyManager-HKDF_V2', // đánh dấu flow mới
        'security_level': 'critical',
        'key_type': 'pinCode', // hoặc đúng keyType tại caller nếu cần
        'context': _encryptionContext,
      };

      if (associatedData != null) {
        package['associatedData'] = base64.encode(utf8.encode(associatedData));
      }

      // wipe
      _secureWipe(baseSecretBytes);
      _secureWipe(okm);
      _secureWipe(aesKey);

      return json.encode(package);
    } catch (e) {
      throw Exception('EncryptV2 HKDF encryption in isolate failed: $e');
    }
  }

  // Hàm giải mã Argon2id trong isolate
  static String _decryptHKDFInIsolate(Map<String, dynamic> params) {
    try {
      final encryptedDataB64 = params['encryptedData'] as String;
      final ivB64 = params['iv'] as String;
      final saltB64 = params['salt'] as String;
      final baseSecretB64 = params['baseSecret'] as String;
      final associatedData = params['associatedData'] as String?;

      final baseSecretBytes = Uint8List.fromList(base64.decode(baseSecretB64));
      final salt = base64.decode(saltB64);
      final iv = enc.IV(base64.decode(ivB64));
      final data = enc.Encrypted.fromBase64(encryptedDataB64);

      final okm = _hkdf(
        inputKeyMaterial: baseSecretBytes,
        salt: salt,
        info: Uint8List.fromList(utf8.encode('aes_hmac_$_encryptionContext')),
        length: 64,
      );
      final aesKey = Uint8List.fromList(okm.sublist(0, 32));
      final encrypter = _getEncrypter(enc.Key(aesKey));

      final result =
          associatedData != null
              ? encrypter.decrypt(data, iv: iv, associatedData: utf8.encode(associatedData))
              : encrypter.decrypt(data, iv: iv);

      _secureWipe(baseSecretBytes);
      _secureWipe(okm);
      _secureWipe(aesKey);

      return result;
    } catch (e) {
      throw Exception('EncryptV2 HKDF decryption in isolate failed: $e');
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
