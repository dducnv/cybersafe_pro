import 'dart:convert';

import 'package:cybersafe_pro/encrypt/argon2/secure_argon2.dart';
import 'package:cybersafe_pro/encrypt/ase_256/secure_ase256.dart';
import 'package:cybersafe_pro/encrypt/key_manager.dart';

class DataSecureService {
  static Future<String> encryptInfo(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    final key = await KeyManager.getKey(KeyType.info);
    return SecureAse256.encrypt(value: value, key: key);
  }

  static Future<String> decryptInfo(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    final key = await KeyManager.getKey(KeyType.info);
    return SecureAse256.decrypt(encryptedData: value, key: key);
  }

  static Future<String> encryptNote(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    final key = await KeyManager.getKey(KeyType.note);
    return SecureAse256.encrypt(value: value, key: key);
  }

  static Future<String> decryptNote(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    final key = await KeyManager.getKey(KeyType.note);
    return SecureAse256.decrypt(encryptedData: value, key: key);
  }

  static Future<String> encryptPassword(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    return await SecureArgon2.encrypt(plainText: value, keyType: KeyType.password);
  }

  static Future<String> decryptPassword(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    return await SecureArgon2.decrypt(value: value, keyType: KeyType.password);
  }

  static Future<String> encryptTOTPKey(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    return await SecureArgon2.encrypt(plainText: value, keyType: KeyType.totp);
  }

  static Future<String> decryptTOTPKey(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    return await SecureArgon2.decrypt(value: value, keyType: KeyType.totp);
  }

  static Future<String> encryptPinCode(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    return await SecureArgon2.encrypt(plainText: value, keyType: KeyType.pinCode);
  }

  static Future<String> decryptPinCode(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    return await SecureArgon2.decrypt(value: value, keyType: KeyType.pinCode);
  }

  static bool isValueEncrypted(String value) {
    try {
      final package = json.decode(value) as Map<String, dynamic>;
      if (package.containsKey('salt') && package.containsKey('iv') && package.containsKey('data')) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
