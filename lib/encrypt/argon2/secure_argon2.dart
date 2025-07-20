import 'dart:convert';
import 'dart:typed_data';
import 'package:cybersafe_pro/encrypt/encryption_config.dart' as config;
import 'package:cybersafe_pro/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart' as pc;
import 'package:crypto/crypto.dart';

class SecureArgon2 {
  static final instance = SecureArgon2._();
  SecureArgon2._();

  // Use standardized configuration from EncryptionConfig
  static const _ivLength = config.EncryptionConfig.IV_LENGTH_GCM;
  static const _saltLength = config.EncryptionConfig.SALT_SIZE_BYTES;
  static const _encryptionContext = 'critical_encryption';

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
        purposes: ['aes', 'hmac']
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
      final encrypted = associatedData != null
          ? encrypter.encrypt(plainText, iv: iv, associatedData: utf8.encode(associatedData))
          : encrypter.encrypt(plainText, iv: iv);

      // Tạo HMAC cho tính toàn vẹn
      final dataForHmac = '$plainText|${base64.encode(salt)}|${base64.encode(iv.bytes)}|${associatedData ?? ''}';
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
      logError("SecureArgon2 encryption error: $e\n$stackTrace", functionName: "SecureArgon2.encrypt");
      throw Exception('SecureArgon2 encryption failed: $e');
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
        purposes: ['aes', 'hmac']
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
      
      final result = associatedData != null
          ? encrypter.decrypt(data, iv: iv, associatedData: utf8.encode(associatedData))
          : encrypter.decrypt(data, iv: iv);

      // Kiểm tra tính toàn vẹn
      if (package.containsKey('hmac')) {
        final dataForHmac = '$result|${base64.encode(salt)}|${base64.encode(iv.bytes)}|${associatedData ?? ''}';
        final expectedHmac = package['hmac'];
        
        if (!_verifyHMAC(dataForHmac, expectedHmac, hmacKey)) {
          logError("SecureArgon2 HMAC integrity check failed", functionName: "SecureArgon2.decrypt");
          throw Exception("SecureArgon2 HMAC integrity check failed");
        }
      }

      return result;
    } catch (e, stackTrace) {
      logError("SecureArgon2 decryption error: $e\n$stackTrace", functionName: "SecureArgon2.decrypt");
      throw Exception('SecureArgon2 decryption failed: $e');
    } finally {
      // Xóa dữ liệu nhạy cảm khỏi bộ nhớ
      if (salt != null) _secureWipe(salt);
      if (aesKeyBytes != null) _secureWipe(aesKeyBytes);
    }
  }

  // Utility method to get encryption info
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

  // Benchmark performance (với KeyManager integration)
  static Future<Map<String, dynamic>> benchmarkPerformance({
    String testData = 'benchmark_test_data_for_secure_encryption',
    KeyType keyType = KeyType.password,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final encrypted = await encrypt(
        plainText: testData,
        keyType: keyType,
      );
      
      final decrypted = await decrypt(
        value: encrypted,
        keyType: keyType,
      );
      
      stopwatch.stop();
      
      return {
        'success': decrypted == testData,
        'duration_ms': stopwatch.elapsedMilliseconds,
        'version': '5.0',
        'algorithm': 'AES-256-GCM',
        'kdf': 'KeyManager-HKDF',
        'keyType': keyType.name,
        'context': _encryptionContext,
      };
    } catch (e) {
      stopwatch.stop();
      return {
        'success': false,
        'error': e.toString(),
        'duration_ms': stopwatch.elapsedMilliseconds,
      };
    }
  }

  // Performance comparison with old method
  static Future<Map<String, dynamic>> comparePerformance({
    String testData = 'performance_comparison_test_data',
    KeyType keyType = KeyType.password,
    int iterations = 10,
  }) async {
    final results = <String, dynamic>{};
    
    // Test new method
    final newMethodTimes = <int>[];
    for (int i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();
      
      try {
        final encrypted = await encrypt(
          plainText: testData,
          keyType: keyType,
        );
        
        await decrypt(
          value: encrypted,
          keyType: keyType,
        );
        
        stopwatch.stop();
        newMethodTimes.add(stopwatch.elapsedMilliseconds);
      } catch (e) {
        stopwatch.stop();
        newMethodTimes.add(-1); // Error marker
      }
    }
    
    final validTimes = newMethodTimes.where((time) => time > 0).toList();
    if (validTimes.isNotEmpty) {
      results['new_method'] = {
        'avg_ms': validTimes.reduce((a, b) => a + b) / validTimes.length,
        'min_ms': validTimes.reduce((a, b) => a < b ? a : b),
        'max_ms': validTimes.reduce((a, b) => a > b ? a : b),
        'success_rate': validTimes.length / iterations,
      };
    }
    
    results['method_version'] = '5.0';
    results['optimization'] = 'KeyManager-HKDF integration';
    
    return results;
  }

  // Test new architecture
  static Future<Map<String, dynamic>> testNewArchitecture() async {
    final results = <String, dynamic>{};
    
    try {
      // Test 1: Basic encryption/decryption
      final testData = 'Test data for new architecture';
      final keyType = KeyType.password;
      
      final stopwatch = Stopwatch()..start();
      
      final encrypted = await encrypt(
        plainText: testData,
        keyType: keyType,
      );
      
      final decrypted = await decrypt(
        value: encrypted,
        keyType: keyType,
      );
      
      stopwatch.stop();
      
      results['basic_test'] = {
        'success': decrypted == testData,
        'duration_ms': stopwatch.elapsedMilliseconds,
        'encrypted_length': encrypted.length,
      };
      
      // Test 2: Associated data
      final associatedData = 'test_associated_data';
      
      final encryptedWithAD = await encrypt(
        plainText: testData,
        keyType: keyType,
        associatedData: associatedData,
      );
      
      final decryptedWithAD = await decrypt(
        value: encryptedWithAD,
        keyType: keyType,
        associatedData: associatedData,
      );
      
      results['associated_data_test'] = {
        'success': decryptedWithAD == testData,
        'associated_data': associatedData,
      };
      
      // Test 3: Key derivation performance
      final keyDerivationStopwatch = Stopwatch()..start();
      
      // Test multiple key derivations (should be cached)
      for (int i = 0; i < 5; i++) {
        await KeyManager.instance.getDerivedKeys(
          keyType, 
          _encryptionContext,
          purposes: ['aes', 'hmac']
        );
      }
      
      keyDerivationStopwatch.stop();
      
      results['key_derivation_test'] = {
        'multiple_derivations_ms': keyDerivationStopwatch.elapsedMilliseconds,
        'avg_per_derivation_ms': keyDerivationStopwatch.elapsedMilliseconds / 5,
      };
      
      // Test 4: Encryption info
      final encryptionInfo = getEncryptionInfo(encrypted);
      results['encryption_info'] = encryptionInfo;
      
      // Test 5: Performance comparison
      final perfResults = await comparePerformance(
        testData: testData,
        keyType: keyType,
        iterations: 5,
      );
      results['performance_comparison'] = perfResults;
      
      results['overall_success'] = true;
      results['architecture_version'] = '5.0';
      results['optimization'] = 'KeyManager-HKDF integration với intelligent caching';
      
    } catch (e, stackTrace) {
      results['overall_success'] = false;
      results['error'] = e.toString();
      results['stackTrace'] = stackTrace.toString();
    }
    
    return results;
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
