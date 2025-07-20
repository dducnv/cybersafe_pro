import 'dart:convert';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

class EncryptService {
  static final instance = EncryptService._internal();

  EncryptService._internal();

  static const int _keyLength = 32; // 256 bits
  static const int _ivLength = 12; // 96 bits for GCM
  static const int _iterations = 20000;

  // Cache cho các encrypter để tránh tạo lại nhiều lần
  static final Map<String, encrypt.Encrypter> _encrypterCache = {};

  // Cache cho derived keys để tránh tính toán lại PBKDF2
  static final Map<String, encrypt.Key> _derivedKeyCache = {};

  // Thêm cache cho kết quả giải mã
  static final Map<String, String> _decryptionResultCache = {};

  // Tạo key an toàn từ password và salt sử dụng PBKDF2
  static encrypt.Key _deriveKey(String password, List<int> salt) {
    final cacheKey = '${base64.encode(salt)}_$password';

    // Kiểm tra cache trước
    if (_derivedKeyCache.containsKey(cacheKey)) {
      return _derivedKeyCache[cacheKey]!;
    }

    // Tính toán key mới
    final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(salt), _iterations, _keyLength));
    final key = generator.process(Uint8List.fromList(utf8.encode(password)));
    final derivedKey = encrypt.Key(key);

    // Lưu vào cache
    _derivedKeyCache[cacheKey] = derivedKey;

    return derivedKey;
  }

  // Tạo IV ngẫu nhiên
  static encrypt.IV _generateIV() => encrypt.IV.fromSecureRandom(_ivLength);

  // Lấy hoặc tạo encrypter từ cache
  static encrypt.Encrypter _getEncrypter(encrypt.Key key) {
    final keyString = base64.encode(key.bytes);
    if (!_encrypterCache.containsKey(keyString)) {
      _encrypterCache[keyString] = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.gcm), // Changed to GCM mode
      );
    }
    return _encrypterCache[keyString]!;
  }

  // Mã hóa dữ liệu với Argon2 (dùng cho dữ liệu mới)
  static Future<String> encryptData({required String value, required String key}) async {
    final stopwatch = Stopwatch()..start();
    try {
      if (key.isEmpty || value.isEmpty) return value;

      // Sử dụng phương thức nhanh cho chuỗi ngắn

      return _encryptDataFast(value: value, key: key);

      // Tạo salt và IV
      // final salt = encrypt.IV.fromSecureRandom(_keyLength).bytes;
      // final iv = encrypt.IV.fromSecureRandom(_ivLength);

      // final iterations = 2;
      // final memoryPowerOf2 = 14;
      // final lanes = 1;
      // final version = 19; // Argon2 version 19

      // // Dẫn xuất key bằng Argon2id
      // final argon2 = Argon2BytesGenerator();
      // final argon2Params = Argon2Parameters(
      //   Argon2Parameters.ARGON2_id,
      //   salt,
      //   version: Argon2Parameters.ARGON2_VERSION_13,
      //   iterations: iterations, // Có thể điều chỉnh cho mobile
      //   memoryPowerOf2: memoryPowerOf2, // 64MB
      //   lanes: lanes,
      // );
      // argon2.init(argon2Params);
      // final keyBytes = Uint8List(_keyLength);
      // argon2.generateBytes(Uint8List.fromList(utf8.encode(key)), keyBytes, 0, _keyLength);
      // final derivedKey = encrypt.Key(keyBytes);
      // final encrypter = encrypt.Encrypter(encrypt.AES(derivedKey, mode: encrypt.AESMode.gcm));
      // final encrypted = encrypter.encrypt(value, iv: iv);
      // final package = {
      //   'salt': base64.encode(salt),
      //   'iv': base64.encode(iv.bytes),
      //   'data': encrypted.base64,
      //   'kdf': 'argon2id',
      //   'argon2': {'iterations': iterations, 'memoryPowerOfTwo': memoryPowerOf2, 'lanes': lanes, 'version': version},
      // };
      // final result = json.encode(package);
      // final elapsedTime = stopwatch.elapsed;
      // logInfo('encryptFernet (Argon2): [32m${value.length} chars - Thao tác hoàn thành trong: ${elapsedTime.inMilliseconds}ms[0m');
      // return result;
    } catch (e) {
      logError("Encryption error (Argon2): $e");
      return value;
    }
  }

  // Giải mã dữ liệu
  static String decryptData({required String value, required String key}) {
    try {
      if (key.isEmpty || value.isEmpty) return value;

      // Kiểm tra cache kết quả
      final resultCacheKey = '$value:$key';
      if (_decryptionResultCache.containsKey(resultCacheKey)) {
        return _decryptionResultCache[resultCacheKey]!;
      }

      Map<String, dynamic> package;
      try {
        package = json.decode(value) as Map<String, dynamic>;
      } catch (e) {
        return value;
      }

      if (package.containsKey('fast') && package['fast'] == true && package.containsKey('salt')) {
        // Giải mã dữ liệu fast với salt (bảo mật hơn)
        final salt = base64.decode(package['salt']);
        final kdf = package['kdf'] ?? 'pbkdf2';
        encrypt.Key derivedKey;
        if (kdf == 'sha256') {
          // Dùng SHA-256(key + salt) cho fast mode mới
          final keyBytes = sha256.convert(utf8.encode(key) + salt).bytes;
          derivedKey = encrypt.Key(Uint8List.fromList(keyBytes));
        } else {
          // Legacy PBKDF2
          derivedKey = _deriveKey(key, salt);
        }
        final iv = encrypt.IV(base64.decode(package['iv']));
        final data = encrypt.Encrypted.fromBase64(package['data']);
        final encrypter = encrypt.Encrypter(encrypt.AES(derivedKey, mode: encrypt.AESMode.gcm));
        final result = encrypter.decrypt(data, iv: iv);

        // Kiểm tra integrity nếu có hash
        if (package.containsKey('hash')) {
          final dataHash = sha256.convert(utf8.encode(result)).toString();
          if (dataHash != package['hash']) {
            logError('Decrypt integrity check failed: hash mismatch');
            throw Exception('Integrity check failed');
          }
        }
        _decryptionResultCache[resultCacheKey] = result;
        return result;
      }

      // Kiểm tra xem có phải phương thức nhanh không
      if (package.containsKey('fast') && package['fast'] == true) {
        final iv = encrypt.IV(base64.decode(package['iv']));
        final data = encrypt.Encrypted.fromBase64(package['data']);

        // Tạo key đơn giản
        final keyBytes = sha256.convert(utf8.encode(key)).bytes;
        final derivedKey = encrypt.Key(Uint8List.fromList(keyBytes));

        final encrypter = encrypt.Encrypter(
          encrypt.AES(derivedKey, mode: encrypt.AESMode.gcm), // Changed to GCM mode
        );

        final result = encrypter.decrypt(data, iv: iv);

        // Lưu kết quả vào cache
        _decryptionResultCache[resultCacheKey] = result;
        return result;
      }

      if (!package.containsKey('salt') || !package.containsKey('iv') || !package.containsKey('data')) {
        return value;
      }

      final salt = base64.decode(package['salt']);
      final iv = encrypt.IV(base64.decode(package['iv']));
      final data = encrypt.Encrypted.fromBase64(package['data']);

      // Sử dụng cache cho derived key
      final cacheKey = '${base64.encode(salt)}_$key';
      encrypt.Key derivedKey;

      if (_derivedKeyCache.containsKey(cacheKey)) {
        derivedKey = _derivedKeyCache[cacheKey]!;
      } else {
        // Tính toán key mới - đây là phần tốn thời gian nhất
        final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
        generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(salt), _iterations, _keyLength));
        final keyBytes = generator.process(Uint8List.fromList(utf8.encode(key)));
        derivedKey = encrypt.Key(keyBytes);
        _derivedKeyCache[cacheKey] = derivedKey;
      }

      // Lấy encrypter từ cache
      final encrypter = _getEncrypter(derivedKey);
      final result = encrypter.decrypt(data, iv: iv);
      // Lưu kết quả vào cache
      _decryptionResultCache[resultCacheKey] = result;

      return result;
    } catch (e) {
      logError("Decryption error: $e");
      return value;
    }
  }


  List<int> encryptDataBytes({required List<int> data, required String key}) {
    try {
      if (data.isEmpty) return [];

      final salt = encrypt.IV.fromSecureRandom(_keyLength).bytes;
      final iv = _generateIV();
      final derivedKey = _deriveKey(key, salt);
      final encrypter = _getEncrypter(derivedKey);
      final encrypted = encrypter.encryptBytes(data, iv: iv);

      final combined = Uint8List(_keyLength + _ivLength + encrypted.bytes.length);
      combined.setAll(0, salt);
      combined.setAll(_keyLength, iv.bytes);
      combined.setAll(_keyLength + _ivLength, encrypted.bytes);

      return combined;
    } catch (e) {
      throw Exception("Lỗi mã hóa dữ liệu bytes: $e");
    }
  }

  List<int> decryptDataBytes({required List<int> encryptedData, required String key}) {
    try {
      if (encryptedData.length < _keyLength + _ivLength) {
        throw Exception("Dữ liệu không hợp lệ");
      }

      final salt = encryptedData.sublist(0, _keyLength);
      final iv = encryptedData.sublist(_keyLength, _keyLength + _ivLength);
      final encrypted = encryptedData.sublist(_keyLength + _ivLength);
      final derivedKey = _deriveKey(key, salt);
      final encrypter = _getEncrypter(derivedKey);

      return encrypter.decryptBytes(encrypt.Encrypted(Uint8List.fromList(encrypted)), iv: encrypt.IV(Uint8List.fromList(iv)));
    } catch (e) {
      throw Exception("Lỗi giải mã dữ liệu bytes: $e");
    }
  }

  // Xóa cache khi không cần thiết
  void clearCache() {
    _encrypterCache.clear();
    _derivedKeyCache.clear();
    _decryptionResultCache.clear();
  }

  // Giới hạn kích thước cache
  void limitCacheSize(int maxSize) {
    if (_encrypterCache.length > maxSize) {
      final keysToRemove = _encrypterCache.keys.take(_encrypterCache.length - maxSize).toList();
      for (var key in keysToRemove) {
        _encrypterCache.remove(key);
      }
    }

    if (_derivedKeyCache.length > maxSize) {
      final keysToRemove = _derivedKeyCache.keys.take(_derivedKeyCache.length - maxSize).toList();
      for (var key in keysToRemove) {
        _derivedKeyCache.remove(key);
      }
    }

    if (_decryptionResultCache.length > maxSize) {
      final keysToRemove = _decryptionResultCache.keys.take(_decryptionResultCache.length - maxSize).toList();
      for (var key in keysToRemove) {
        _decryptionResultCache.remove(key);
      }
    }
  }

  // Thêm phương thức mã hóa nhanh cho chuỗi ngắn
  static String _encryptDataFast({required String value, required String key}) {
    try {
      if (key.isEmpty || value.isEmpty) return value;

      // Sinh salt ngẫu nhiên
      final salt = encrypt.IV.fromSecureRandom(_keyLength).bytes;
      // Derive key bằng SHA-256(key + salt)
      final keyBytes = sha256.convert(utf8.encode(key) + salt).bytes;
      final derivedKey = encrypt.Key(Uint8List.fromList(keyBytes));

      // Tạo IV ngẫu nhiên
      final iv = _generateIV();
      final encrypter = encrypt.Encrypter(encrypt.AES(derivedKey, mode: encrypt.AESMode.gcm));

      final encrypted = encrypter.encrypt(value, iv: iv);

      // Tùy chọn: hash để kiểm tra integrity
      final dataHash = sha256.convert(utf8.encode(value)).toString();

      final package = {
        'salt': base64.encode(salt),
        'iv': base64.encode(iv.bytes),
        'data': encrypted.base64,
        'fast': true,
        'algo': 'aes-gcm',
        'kdf': 'sha256',
        'hash': dataHash,
        'createdAt': DateTime.now().toIso8601String(),
      };

      return json.encode(package);
    } catch (e) {
      logError("Fast encryption error: $e");
      return value;
    }
  }

  // Tạo và lưu trữ key trước khi sử dụng
  Future<void> precomputeKeys(String masterKey) async {
    // Tạo trước một số salt cố định
    final commonSalts = List.generate(5, (index) => Uint8List.fromList(utf8.encode('common_salt_$index')));

    // Tính toán và lưu trữ các key trước
    for (var salt in commonSalts) {
      final cacheKey = '${base64.encode(salt)}_$masterKey';
      if (!_derivedKeyCache.containsKey(cacheKey)) {
        final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
        generator.init(pc.Pbkdf2Parameters(salt, _iterations, _keyLength));
        final key = generator.process(Uint8List.fromList(utf8.encode(masterKey)));
        _derivedKeyCache[cacheKey] = encrypt.Key(key);
      }
    }
  }
}
