import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKeys {
  themeMode,
  appLang,
  pinCode,
  isEnableLocalAuth,
  firstOpenApp,
  isRequiredPinCodeForFileBackup,
  isAutoLock,
  timeAutoLock,
  versionEncryptKey,
  numberLogin,
}

class SecureStorage {
  static final instance = SecureStorage._internal();

  final _storage = const FlutterSecureStorage();

  SecureStorage._internal();

  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> saveObject<T>(String key, T value) async {
    await save(key, jsonEncode(value));
  }

  Future<T> readObject<T>(String key) async {
    String? value = await read(key);
    if (value != null) {
      return jsonDecode(value) as T;
    } else {
      throw Exception('Value of $key is null');
    }
  }
}
