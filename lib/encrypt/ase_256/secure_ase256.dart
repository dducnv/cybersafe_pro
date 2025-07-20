import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart' as pc;

class SecureAse256 {
  static final instance = SecureAse256._();
  SecureAse256._();

  // Use standardized configuration from EncryptionConfig
  static const int _ivLength = config.EncryptionConfig.IV_LENGTH_GCM;
  static const int _saltLength = config.EncryptionConfig.SALT_SIZE_BYTES;
  static const int _hmacKeyLength = config.EncryptionConfig.HMAC_KEY_LENGTH;

  // HKDF implementation for key derivation
  static Uint8List _hkdf({
    required Uint8List inputKeyMaterial,
    required Uint8List salt,
    required Uint8List info,
    required int length,
  }) {
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

  // Generate secure salt for each encryption operation
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

  // Derive HMAC key using HKDF
  static Uint8List _deriveHmacKey(Uint8List masterKey, String purpose) {
    final salt = Uint8List(_saltLength); // Zero salt for HKDF
    final info = utf8.encode('${config.EncryptionConfig.KEY_PURPOSES['hmac']}_$purpose');
    
    return _hkdf(
      inputKeyMaterial: masterKey,
      salt: salt,
      info: Uint8List.fromList(info),
      length: _hmacKeyLength,
    );
  }

  // Create HMAC for integrity check
  static String _createHMAC(String data, Uint8List key) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).toString();
  }

  // Verify HMAC
  static bool _verifyHMAC(String data, String expectedHmac, Uint8List key) {
    final computedHmac = _createHMAC(data, key);
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

  // Generate secure IV
  static enc.IV _generateIV() {
    final random = pc.SecureRandom('Fortuna');
    
    // Seed with multiple entropy sources
    final entropy = utf8.encode(DateTime.now().microsecondsSinceEpoch.toString());
    
    // Ensure entropy is exactly 32 bytes (256 bits) for Fortuna
    final entropyBytes = Uint8List.fromList(sha256.convert(Uint8List.fromList(entropy)).bytes);
    
    random.seed(pc.KeyParameter(entropyBytes));
    return enc.IV(random.nextBytes(_ivLength));
  }

  static String encrypt({
    required String value,
    required String key, // Key từ KeyManager - đã được strengthen bằng PBKDF2
    String? associatedData,
  }) {
    if (key.isEmpty || value.isEmpty) {
      throw ArgumentError('Key và value không được rỗng');
    }

    try {
      // Decode key từ KeyManager (base64 encoded)
      final keyBytes = base64.decode(key);
      if (keyBytes.length != config.EncryptionConfig.KEY_SIZE_BYTES) {
        throw ArgumentError('Invalid key length: ${keyBytes.length}');
      }

      final salt = _generateSalt(); // Salt for HMAC only
      final iv = _generateIV();
      
      // Sử dụng trực tiếp key từ KeyManager (không derive thêm)
      final encKey = enc.Key(Uint8List.fromList(keyBytes));
      final encrypter = enc.Encrypter(enc.AES(encKey, mode: enc.AESMode.gcm));
      
      // Encrypt with associated data if provided
      final encrypted = associatedData != null
          ? encrypter.encrypt(value, iv: iv, associatedData: utf8.encode(associatedData))
          : encrypter.encrypt(value, iv: iv);

      // Derive HMAC key using HKDF
      final hmacKey = _deriveHmacKey(Uint8List.fromList(keyBytes), 'encryption');
      
      // Create data for HMAC (include all critical components)
      final dataForHmac = '$value|${base64.encode(salt)}|${base64.encode(iv.bytes)}|${associatedData ?? ''}';
      final integrityHmac = _createHMAC(dataForHmac, hmacKey);

      final package = {
        'salt': base64.encode(salt), // Salt cho HMAC
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'hmac': integrityHmac,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'version': '4.0', // New version - no key derivation
        'algorithm': 'AES-256-GCM',
        'kdf': 'None', // Key đã được KeyManager xử lý
      };

      if (associatedData != null) {
        package['associatedData'] = base64.encode(utf8.encode(associatedData));
      }

      // Clear sensitive data
      _secureWipe(Uint8List.fromList(keyBytes));

      return json.encode(package);
    } catch (e, stackTrace) {
      logError("AES256 encryption error: $e\n$stackTrace", functionName: "SecureAse256.encrypt");
      throw Exception('AES256 encryption failed: $e');
    }
  }

  static String decrypt({
    required String encryptedData,
    required String key, // Key từ KeyManager - đã được strengthen bằng PBKDF2
    String? associatedData,
  }) {
    if (key.isEmpty || encryptedData.isEmpty) {
      throw ArgumentError('Key và encryptedData không được rỗng');
    }

    try {
      final package = json.decode(encryptedData) as Map<String, dynamic>;
      final salt = base64.decode(package['salt']);
      final iv = enc.IV(base64.decode(package['iv']));
      final encrypted = enc.Encrypted.fromBase64(package['data']);
      final version = package['version'] ?? '4.0';

      if (version != '4.0') {
        throw Exception('Unsupported encryption version. Please re-encrypt your data.');
      }

      // Handle associated data
      String? packageAssociatedData;
      if (package.containsKey('associatedData')) {
        packageAssociatedData = utf8.decode(base64.decode(package['associatedData']));
      }

      // Verify associated data consistency
      if (associatedData != packageAssociatedData) {
        throw Exception('Associated data mismatch');
      }

      // Decode key từ KeyManager
      final keyBytes = base64.decode(key);
      if (keyBytes.length != config.EncryptionConfig.KEY_SIZE_BYTES) {
        throw ArgumentError('Invalid key length: ${keyBytes.length}');
      }

      // Direct key usage (no derivation)
      final encKey = enc.Key(keyBytes);
      final encrypter = enc.Encrypter(enc.AES(encKey, mode: enc.AESMode.gcm));
      
      // Decrypt with associated data if provided
      final decrypted = associatedData != null
          ? encrypter.decrypt(encrypted, iv: iv, associatedData: utf8.encode(associatedData))
          : encrypter.decrypt(encrypted, iv: iv);

      // Verify integrity
      if (package.containsKey('hmac')) {
        final hmacKey = _deriveHmacKey(Uint8List.fromList(keyBytes), 'encryption');
        final dataForHmac = '$decrypted|${base64.encode(salt)}|${base64.encode(iv.bytes)}|${associatedData ?? ''}';
        final expectedHmac = package['hmac'];
        
        if (!_verifyHMAC(dataForHmac, expectedHmac, hmacKey)) {
          logError("AES256 HMAC integrity check failed", functionName: "SecureAse256.decrypt");
          throw Exception("AES256 HMAC integrity check failed");
        }
      }

      // Clear sensitive data
      _secureWipe(Uint8List.fromList(keyBytes));

      return decrypted;
    } catch (e, stackTrace) {
      logError("AES256 decryption error: $e\n$stackTrace", functionName: "SecureAse256.decrypt");
      throw Exception('AES256 decryption failed: $e');
    }
  }

  // Utility method to get encryption info
  static Map<String, dynamic> getEncryptionInfo(String encryptedData) {
    try {
      final package = json.decode(encryptedData) as Map<String, dynamic>;
      return {
        'version': package['version'] ?? '1.0',
        'algorithm': package['algorithm'] ?? 'AES-256-GCM',
        'kdf': package['kdf'] ?? 'SHA-256',
        'iterations': package['iterations'] ?? 15000,
        'timestamp': package['timestamp'],
        'hasAssociatedData': package.containsKey('associatedData'),
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
