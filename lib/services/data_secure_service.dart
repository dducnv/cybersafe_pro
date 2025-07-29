import 'dart:convert';

import 'package:cybersafe_pro/encrypt/argon2/secure_argon2.dart';
import 'package:cybersafe_pro/encrypt/ase_256/secure_ase256.dart';
import 'package:cybersafe_pro/encrypt/key_manager.dart';

class DataSecureService {
  static Future<String> encryptInfo(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      final key = await KeyManager.getKey(KeyType.info);
      return SecureAse256.encrypt(value: value, key: key);
    } catch (e) {
      throw Exception('Failed to encrypt info: $e');
    }
  }

  static Future<String> decryptInfo(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      final key = await KeyManager.getKey(KeyType.info);
      return SecureAse256.decrypt(encryptedData: value, key: key);
    } catch (e) {
      throw Exception('Failed to decrypt info: $e');
    }
  }

  static Future<String> encryptNote(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      final key = await KeyManager.getKey(KeyType.note);
      return SecureAse256.encrypt(value: value, key: key);
    } catch (e) {
      throw Exception('Failed to encrypt note: $e');
    }
  }

  static Future<String> decryptNote(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      final key = await KeyManager.getKey(KeyType.note);
      return SecureAse256.decrypt(encryptedData: value, key: key);
    } catch (e) {
      throw Exception('Failed to decrypt note: $e');
    }
  }

  static Future<String> encryptPassword(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      return await SecureArgon2.encrypt(plainText: value, keyType: KeyType.password);
    } catch (e) {
      throw Exception('Failed to encrypt password: $e');
    }
  }

  static Future<String> decryptPassword(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      return await SecureArgon2.decrypt(value: value, keyType: KeyType.password);
    } catch (e) {
      throw Exception('Failed to decrypt password: $e');
    }
  }

  static Future<String> encryptTOTPKey(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      return await SecureArgon2.encrypt(plainText: value, keyType: KeyType.totp);
    } catch (e) {
      throw Exception('Failed to encrypt TOTP key: $e');
    }
  }

  static Future<String> decryptTOTPKey(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      return await SecureArgon2.decrypt(value: value, keyType: KeyType.totp);
    } catch (e) {
      throw Exception('Failed to decrypt TOTP key: $e');
    }
  }

  static Future<String> encryptPinCode(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      return await SecureArgon2.encrypt(plainText: value, keyType: KeyType.pinCode);
    } catch (e) {
      throw Exception('Failed to encrypt PIN code: $e');
    }
  }

  static Future<String> decryptPinCode(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      return await SecureArgon2.decrypt(value: value, keyType: KeyType.pinCode);
    } catch (e) {
      throw Exception('Failed to decrypt PIN code: $e');
    }
  }

  static bool isValueEncrypted(String value) {
    if (value.isEmpty) return false;

    try {
      final package = json.decode(value) as Map<String, dynamic>;

      final hasRequiredFields = package.containsKey('salt') && package.containsKey('iv') && package.containsKey('data') && package.containsKey('version');
      if (!hasRequiredFields) return false;

      // Validate field types
      final salt = package['salt'];
      final iv = package['iv'];
      final data = package['data'];
      final version = package['version'];

      return salt is String && iv is String && data is String && version is String;
    } catch (e) {
      return false;
    }
  }

  /// Get encryption version from encrypted data
  static String? getEncryptionVersion(String value) {
    if (!isValueEncrypted(value)) return null;
    
    try {
      final package = json.decode(value) as Map<String, dynamic>;
      return package['version'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Check if data needs to be re-encrypted (version mismatch)
  static bool needsReEncryption(String value, String expectedVersion) {
    final currentVersion = getEncryptionVersion(value);
    return currentVersion != expectedVersion;
  }

  /// Batch encrypt multiple values (for performance)
  static Future<List<String>> encryptInfoBatch(List<String> values) async {
    final results = <String>[];
    for (final value in values) {
      results.add(await encryptInfo(value));
    }
    return results;
  }

  /// Batch decrypt multiple values (for performance)
  static Future<List<String>> decryptInfoBatch(List<String> values) async {
    final results = <String>[];
    for (final value in values) {
      results.add(await decryptInfo(value));
    }
    return results;
  }
}
