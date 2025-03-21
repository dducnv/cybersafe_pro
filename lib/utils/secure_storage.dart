import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKeys {
  themMode,
  themeMode,
  themeColor,
  surfaceColor,
  isDefaultTheme,
  appLang,
  pinCode,
  isEnableLocalAuth,
  firstOpenApp,
  fistOpenApp,
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

  Future<void> save({
   required String key,required String value
  }) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({
    required String key,
  }) async {
    return await _storage.read(key: key);
  }

  Future<void> delete({
    required String key,
  }) async {
    await _storage.delete(key: key);
  }

  Future<void> saveObject<T>({
    required String key,
    required T value,
  }) async {
    await save(key: key, value: jsonEncode(value));
  }

  Future<T> readObject<T>({
    required String key,
  }) async {
    String? value = await read(key: key);
    if (value != null) {
      return jsonDecode(value) as T;
    } else {
      throw Exception('Value of $key is null');
    }
  }

  Future<void> saveBool(String key, bool value) async {
    await save(key: key, value: value.toString());
  }

  Future<bool?> readBool(String key) async {
    String? value = await read(key:key);
    if (value != null) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }

  Future<void> saveInt(String key, int value) async {
    await save(key: key, value: value.toString());
  }

  Future<int?> readInt(String key) async {
    String? value = await read(key:key);
    if (value != null) {
      return int.tryParse(value);
    }
    return null;
  }

  Future<void> saveDouble(String key, double value) async {
    await save(key: key, value: value.toString());
  }

  Future<double?> readDouble(String key) async {
    String? value = await read(key:key);
    if (value != null) {
      return double.tryParse(value);
    }
    return null;
  }

  //reset all data
  Future<void> reset() async {
    await _storage.deleteAll();
  }
}