import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:collection';
import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/boxes/account_custom_field_box.dart';
import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/database/boxes/icon_custom_box.dart';
import 'package:cybersafe_pro/database/boxes/password_history_box.dart';
import 'package:cybersafe_pro/database/models/account_custom_field.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/database/models/password_history_model.dart';
import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/services/encrypt_service.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_data.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as pc;

// Cấu hình mã hóa
class EncryptionConfig {
  static const int PBKDF2_ITERATIONS = 20000;
  static const int KEY_SIZE_BYTES = 32;
  static const int MIN_PIN_LENGTH = 6;
  static const int MAX_BACKUP_SIZE_MB = 50;
  static const Duration RETRY_DELAY = Duration(seconds: 1);
  static const int MAX_RETRY_ATTEMPTS = 3;
  static const Duration KEY_CACHE_DURATION = Duration(minutes: 15);
}

// Enum cho version
enum AppVersion {
  latest;

  String get version {
    switch (this) {
      case AppVersion.latest:
        return '2.0';
    }
  }
}

// Enum cho loại key
enum KeyType { info, password, totp, pinCode }

// Service chính để mã hóa/giải mã
class EncryptAppDataService {
  static final instance = EncryptAppDataService._();
  final _encryptData = EncryptService.instance;
  final _secureStorage = SecureStorage.instance;

  // Orchestration key cho việc bảo vệ khóa trong bộ nhớ
  late String _orchestrationKey;
  bool _isOrchestrationKeyInitialized = false;

  // Cache keys
  final Map<String, _CachedKey> _keyCache = {};
  String? _cachedDeviceKey;
  DateTime? _deviceKeyExpiry;

  // Storage keys

  EncryptAppDataService._();

  // Khởi tạo
  Future<void> initialize() async {
    try {
      // Khởi tạo orchestration key trước
      await _initializeOrchestrationKey();

      final isLegacy = await _isLegacyUser();
      final hasDeviceKey = await _hasDeviceKey();

      if (!isLegacy) {
        if (!hasDeviceKey) {
          await _generateDeviceKey();
          await _saveCurrentVersion();
        } else {
          await _checkAndUpdateVersion();
        }
        await _preloadKeys();
        return;
      }

      if (!hasDeviceKey) {
        await _withRetry(() async {
          await _generateDeviceKey();
          await _migrateData();
          await _saveCurrentVersion();
        });
      }
    } catch (e) {
      _logError('Lỗi khởi tạo', e);
      rethrow;
    }
  }

  // Khởi tạo orchestration key
  Future<void> _initializeOrchestrationKey() async {
    if (_isOrchestrationKeyInitialized) return;

    _orchestrationKey = await _generateOrchestrationKey();
    _isOrchestrationKeyInitialized = true;
    logInfo('Đã khởi tạo orchestration key');
  }

  // Tạo orchestration key dựa trên thông tin thiết bị
  Future<String> _generateOrchestrationKey() async {
    final deviceInfo = await _getDeviceSpecificInfo();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final appSignature = 'cybersafe_pro_v2';
    final rawKey = '$deviceInfo:$timestamp:$appSignature';
    return base64.encode(sha256.convert(utf8.encode(rawKey)).bytes);
  }

  // Lấy thông tin đặc trưng của thiết bị để tạo orchestration key
  Future<String> _getDeviceSpecificInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return '${androidInfo.brand}_${androidInfo.device}_${androidInfo.id}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return '${iosInfo.model}_${iosInfo.identifierForVendor}';
      } else {
        return 'unknown_device_${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      _logError('Lỗi lấy thông tin thiết bị', e);
      return 'fallback_device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // Bảo vệ khóa trong bộ nhớ bằng orchestration key
  String _protectKey(String key) {
    if (!_isOrchestrationKeyInitialized) {
      _logError('Orchestration key chưa được khởi tạo', 'Không thể bảo vệ khóa');
      return key; // Fallback nếu chưa khởi tạo
    }

    final keyBytes = utf8.encode(key);
    final orchestrationBytes = utf8.encode(_orchestrationKey);
    final result = List<int>.filled(keyBytes.length, 0);

    for (var i = 0; i < keyBytes.length; i++) {
      result[i] = keyBytes[i] ^ orchestrationBytes[i % orchestrationBytes.length];
    }

    return base64.encode(result);
  }

  // Khôi phục khóa đã được bảo vệ
  String _unprotectKey(String protectedKey) {
    if (!_isOrchestrationKeyInitialized) {
      _logError('Orchestration key chưa được khởi tạo', 'Không thể khôi phục khóa');
      return protectedKey; // Fallback nếu chưa khởi tạo
    }

    try {
      final protectedBytes = base64.decode(protectedKey);
      final orchestrationBytes = utf8.encode(_orchestrationKey);
      final result = List<int>.filled(protectedBytes.length, 0);

      for (var i = 0; i < protectedBytes.length; i++) {
        result[i] = protectedBytes[i] ^ orchestrationBytes[i % orchestrationBytes.length];
      }

      return utf8.decode(result);
    } catch (e) {
      _logError('Lỗi khôi phục khóa', e);
      return protectedKey; // Fallback nếu có lỗi
    }
  }

  //Pin code
  Future<String> encryptPinCode(String pinCode) async {
    final deviceKey = await _getDeviceKey();
    final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.pinCode);
    return _encryptData.encryptFernet(value: pinCode, key: encryptionKey);
  }

  Future<String> decryptPinCode(String encrypted) async {
    final deviceKey = await _getDeviceKey();
    final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.pinCode);
    return _encryptData.decryptFernet(value: encrypted, key: encryptionKey);
  }

  // Mã hóa thông tin
  Future<String> encryptInfo(String value) async {
    if (value.isEmpty) return value;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.info);
      return await compute(_encryptInIsolate, {'value': value, 'key': encryptionKey});
    } catch (e) {
      _logError('Lỗi mã hóa thông tin', e);
      return value;
    }
  }

  // Giải mã thông tin
  Future<String> decryptInfo(String encrypted) async {
    if (encrypted.isEmpty) return encrypted;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.info);
      return await compute(_decryptInIsolate, {'value': encrypted, 'key': encryptionKey});
    } catch (e) {
      _logError('Lỗi giải mã thông tin', e);
      return encrypted;
    }
  }

  // Mã hóa mật khẩu
  Future<String> encryptPassword(String password) async {
    if (password.isEmpty) return password;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.password);
      return _encryptData.encryptFernet(value: password, key: encryptionKey);
    } catch (e) {
      _logError('Lỗi mã hóa mật khẩu', e);
      rethrow;
    }
  }

  // Giải mã mật khẩu
  Future<String> decryptPassword(String encrypted) async {
    if (encrypted.isEmpty) return encrypted;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.password);
      return _encryptData.decryptFernet(value: encrypted, key: encryptionKey);
    } catch (e) {
      _logError('Lỗi giải mã mật khẩu', e);
      rethrow;
    }
  }

  // Giải mã TOTP
  Future<String> decryptTOTPKey(String encrypted) async {
    if (encrypted.isEmpty) return encrypted;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.totp);
      return _encryptData.decryptFernet(value: encrypted, key: encryptionKey);
    } catch (e) {
      _logError('Lỗi giải mã TOTP', e);
      rethrow;
    }
  }

  // Mã hóa TOTP
  Future<String> encryptTOTPKey(String key) async {
    if (key.isEmpty) return key;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.totp);
      return _encryptData.encryptFernet(value: key, key: encryptionKey);
    } catch (e) {
      _logError('Lỗi mã hóa TOTP', e);
      rethrow;
    }
  }

  // Tạo backup
  Future<Map<String, dynamic>> createBackup(String pin, String backupName, {bool isTransfer = false}) async {
    if (!isTransfer) _validatePin(pin);
    try {
      final deviceKey = await _getDeviceKey();
      final accounts = await AccountBox.getAll();
      final backupData = {
        'type': 'CYBERSAFE_BACKUP',
        'version': AppVersion.latest.version,
        'timestamp': DateTime.now().toIso8601String(),
        'backupName': backupName,
        'deviceKey': deviceKey,
        'data': {'accounts': await Future.wait(accounts.map((acc) => acc.toDecryptedJson()))},
      };
      final backupJson = jsonEncode(backupData);
      _validateBackupSize(backupJson);
      final encryptedData = await _encryptData.encryptFernet(value: backupJson, key: _generateBackupKey(pin));
      return {'type': 'CYBERSAFE_BACKUP', 'version': AppVersion.latest.version, 'data': encryptedData, 'checksum': _calculateChecksum(encryptedData), 'timestamp': DateTime.now().toIso8601String()};
    } catch (e) {
      _logError('Lỗi tạo backup', e);
      rethrow;
    }
  }

  // Khôi phục backup
  Future<bool> restoreBackup(String dataBackup, String pin) async {
    try {
      final backupData = jsonDecode(dataBackup);
      _validateBackupData(backupData);

      try {
        final decryptedData = _encryptData.decryptFernet(value: backupData['data'], key: _generateBackupKey(pin));
        // Kiểm tra xem dữ liệu giải mã có đúng định dạng JSON không
        final data = jsonDecode(decryptedData);

        // Kiểm tra xem có phải là dữ liệu backup hợp lệ không
        if (!data.containsKey('type') || data['type'] != 'CYBERSAFE_BACKUP') {
          throw Exception('PIN_INCORRECT');
        }

        await _restoreData(data['data']);
        return true;
      } catch (e) {
        hideLoadingDialog();
        if (e.toString().contains('PIN_INCORRECT')) {
          _logError('PIN không chính xác', e);
          rethrow;
        }
        // Nếu giải mã thất bại hoặc dữ liệu không hợp lệ, có thể là do PIN sai
        throw Exception('PIN_INCORRECT');
      }
    } catch (e) {
      hideLoadingDialog();
      _logError('Lỗi khôi phục backup', e);
      if (e.toString().contains('PIN_INCORRECT')) {
        throw Exception('PIN_INCORRECT');
      }
      return false;
    }
  }

  // Helper methods
  void _logError(String message, Object error) {
    logError('[EncryptAppDataService] ERROR: $message: $error');
  }

  Future<bool> _isLegacyUser() async {
    return await _secureStorage.read(key: SecureStorageKeys.themMode.name) != null || await _secureStorage.read(key: SecureStorageKeys.fistOpenApp.name) != null;
  }

  Future<bool> _hasDeviceKey() async {
    return await _secureStorage.read(key: SecureStorageKey.deviceKeyStorageKey) != null;
  }

  Future<void> _generateDeviceKey() async {
    final key = base64.encode(List.generate(32, (_) => Random.secure().nextInt(256)));
    await _secureStorage.save(key: SecureStorageKey.deviceKeyStorageKey, value: key);
  }

  Future<String> _getDeviceKey() async {
    if (_cachedDeviceKey != null && _deviceKeyExpiry != null && DateTime.now().isBefore(_deviceKeyExpiry!)) {
      // Khôi phục khóa từ cache (đã được bảo vệ)
      return _unprotectKey(_cachedDeviceKey!);
    }

    final key = await _secureStorage.read(key: SecureStorageKey.deviceKeyStorageKey);
    if (key == null) throw Exception('Device key not created');

    // Lưu khóa vào cache sau khi bảo vệ
    _cachedDeviceKey = _protectKey(key);
    _deviceKeyExpiry = DateTime.now().add(EncryptionConfig.KEY_CACHE_DURATION);
    return key;
  }

  Future<String> _generateEncryptionKey(String deviceKey, KeyType type) async {
    final cacheKey = '${type.name}_$deviceKey';

    // Nếu có trong cache, giải mã và trả về
    if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
      return _unprotectKey(_keyCache[cacheKey]!.key);
    }

    final storageKey = _getStorageKeyForType(type);
    final savedKey = await _secureStorage.read(key: storageKey);
    if (savedKey != null) {
      // Lưu vào cache sau khi bảo vệ
      _keyCache[cacheKey] = _CachedKey(_protectKey(savedKey));
      return savedKey;
    }

    final salt = 'cybersafe_${type.name}_salt_$deviceKey';
    final key = await compute(_generateKeyInIsolate, {'salt': salt, 'deviceKey': deviceKey, 'iterations': EncryptionConfig.PBKDF2_ITERATIONS, 'keySize': EncryptionConfig.KEY_SIZE_BYTES});

    // Lưu vào cache sau khi bảo vệ
    _keyCache[cacheKey] = _CachedKey(_protectKey(key));
    await _secureStorage.save(key: storageKey, value: key);

    return key;
  }

  static String _generateKeyInIsolate(Map<String, dynamic> params) {
    final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(utf8.encode(params['salt'])), params['iterations'], params['keySize']));
    return base64.encode(generator.process(Uint8List.fromList(utf8.encode(params['deviceKey']))));
  }

  static Future<String> _encryptInIsolate(Map<String, String> params) async {
    final encryptData = EncryptService.instance;
    return await encryptData.encryptFernet(value: params['value']!, key: params['key']!);
  }

  static String _decryptInIsolate(Map<String, String> params) {
    return EncryptService.instance.decryptFernet(value: params['value']!, key: params['key']!);
  }

  String _getStorageKeyForType(KeyType type) {
    return switch (type) {
      KeyType.info => SecureStorageKey.infoKeyStorageKey,
      KeyType.password => SecureStorageKey.passwordKeyStorageKey,
      KeyType.totp => SecureStorageKey.totpKeyStorageKey,
      KeyType.pinCode => SecureStorageKey.pinCodeKeyStorageKey,
    };
  }

  void _validatePin(String pin) {
    if (pin.length < EncryptionConfig.MIN_PIN_LENGTH) {
      throwAppError(ErrorText.pinTooShort);
    }
  }

  void _validateBackupSize(String data) {
    final backupSize = utf8.encode(data).length / (1024 * 1024);
    if (backupSize > EncryptionConfig.MAX_BACKUP_SIZE_MB) {
      throwAppError(ErrorText.backupTooLarge);
    }
  }

  void _validateBackupData(Map<String, dynamic> data) {
    if (data['type'] != 'CYBERSAFE_BACKUP') {
      throwAppError(ErrorText.invalidBackupFile);
    }

    final requiredFields = ['version', 'data', 'checksum', 'timestamp'];
    for (var field in requiredFields) {
      if (!data.containsKey(field)) {
        throwAppError(ErrorText.missingBackupField);
      }
    }
  }

  String _calculateChecksum(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  String _generateBackupKey(String pin) {
    final salt = utf8.encode('cybersafe_backup_salt');
    final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(salt), EncryptionConfig.PBKDF2_ITERATIONS, 32));
    return base64.encode(generator.process(Uint8List.fromList(utf8.encode(pin))));
  }

  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (attempts < EncryptionConfig.MAX_RETRY_ATTEMPTS) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts == EncryptionConfig.MAX_RETRY_ATTEMPTS) {
          throwAppError(ErrorText.tooManyRetries);
        }
        await Future.delayed(EncryptionConfig.RETRY_DELAY * attempts);
      }
    }
    // Code không bao giờ chạy đến đây vì throwAppError ở trên
    throw AppError.instance.createException(ErrorText.tooManyRetries);
  }

  Future<void> _preloadKeys() async {
    try {
      final deviceKey = await _getDeviceKey();
      await Future.wait([
        _generateEncryptionKey(deviceKey, KeyType.info),
        _generateEncryptionKey(deviceKey, KeyType.password),
        _generateEncryptionKey(deviceKey, KeyType.totp),
        _generateEncryptionKey(deviceKey, KeyType.pinCode),
      ]);
    } catch (e) {
      _logError('Cannot load keys', e);
    }
  }

  // Future<void> _checkAndRotateKeys() async {
  //   final keyCreationTime = await _secureStorage.read(key: SecureStorageKey.encryptionKeyCreationTime);
  //   if (keyCreationTime == null || DateTime.now().difference(DateTime.parse(keyCreationTime)) > const Duration(days: 30)) {
  //     await _rotateKeys();
  //   }
  // }

  Future<void> rotateKeys({
    required void Function(String message) onCallBackMessage,
    required void Function(double progress) onCallBackProgress,
    required void Function({int successEncrypt, int totalAccount}) onCallBackCount,
    required void Function(int time) onCallBackTime,
    required void Function() onError,
    required void Function() onSuccess,
  }) async {
    final timer = Stopwatch()..start();
    logInfo('[EncryptAppDataService] Bắt đầu rotate keys...');

    // Lưu trữ keys cũ để rollback nếu cần
    final oldDeviceKey = await _getDeviceKey();
    final oldKeys = Map<String, String>.from(_keyCache);

    // Map lưu trữ tạm thời keys mới
    final newKeys = <KeyType, String>{};
    String? newDeviceKey;

    try {
      // Tạo device key mới (chưa lưu)
      newDeviceKey = await _generateNewDeviceKeyOnly();
      logInfo('[EncryptAppDataService] So sánh device keys:');
      logInfo('Old Device Key: $oldDeviceKey');
      logInfo('New Device Key: $newDeviceKey');

      // So sánh key cũ và mới
      if (oldDeviceKey == newDeviceKey) {
        logInfo('[EncryptAppDataService] Device key không thay đổi, bỏ qua rotate');
        return;
      }
      logInfo('[EncryptAppDataService] Đã tạo device key mới');

      // Tạo mới các encryption keys (chưa lưu)
      logInfo('[EncryptAppDataService] Bắt đầu tạo encryption keys mới...');
      for (var type in KeyType.values) {
        final newKey = await _generateNewEncryptionKeyOnly(newDeviceKey, type);
        newKeys[type] = newKey;
        logInfo('[EncryptAppDataService] Đã tạo ${type.name} key mới');
      }

      // Lấy tất cả accounts cần re-encrypt
      final accounts = await AccountBox.getAll();
      if (accounts.isEmpty) return;
      final totalAccounts = accounts.length;

      logInfo('[EncryptAppDataService] Bắt đầu mã hóa lại $totalAccounts tài khoản');
      onCallBackMessage("Bắt đầu mã hóa lại $totalAccounts tài khoản");

      // Map tạm thời để lưu trữ accounts đã mã hóa lại
      final reencryptedAccounts = <String, AccountOjbModel>{};
      int successCount = 0;
      final errors = <String>[];
      final startTime = DateTime.now();

      // Tạo một service tạm thời với keys mới để mã hóa
      final tempService = _TempEncryptionService(deviceKey: newDeviceKey, encryptionKeys: newKeys);

      for (var account in accounts) {
        try {
          // Verify dữ liệu trước khi mã hóa lại
          final originalDecrypted = await _decryptAccountForVerification(account);

          // Mã hóa lại account với keys mới
          final reencryptedAccount = await _reencryptAccountWithKeys(account, tempService);

          // Verify dữ liệu sau khi mã hóa lại
          final reencryptedDecrypted = await tempService.decryptAccountForVerification(reencryptedAccount);

          // So sánh dữ liệu trước và sau
          if (!_compareDecryptedAccounts(originalDecrypted, reencryptedDecrypted)) {
            throw Exception('Data does not match after encryption');
          }

          // Lưu vào map tạm thời
          reencryptedAccounts[account.id.toString()] = reencryptedAccount;

          successCount++;
          if (successCount % 10 == 0 || successCount == totalAccounts) {
            final progress = (successCount / totalAccounts * 100);
            final elapsed = DateTime.now().difference(startTime);
            logInfo('[EncryptAppDataService] Tiến độ: $progress% ($successCount/$totalAccounts) - Thời gian: ${elapsed.inSeconds}s');
            onCallBackCount(successEncrypt: successCount, totalAccount: totalAccounts);
            onCallBackProgress(progress);
            onCallBackTime(elapsed.inSeconds);
          }
        } catch (e) {
          errors.add('Account ${account.id}: $e');
          logError('[EncryptAppDataService] Lỗi khi mã hóa lại account ${account.id}: $e');
        }
      }

      // Kiểm tra kết quả
      if (errors.isNotEmpty) {
        throw Exception('There are ${errors.length} errors when encrypting:\n${errors.join('\n')}');
      }

      // Lưu toàn bộ keys mới vào storage
      await _saveNewKeys(newDeviceKey, newKeys);

      // Lưu các accounts đã mã hóa lại
      for (var account in reencryptedAccounts.values) {
        await AccountBox.put(account);
      }

      // Xóa cache cũ
      clearCache();
      onSuccess.call();
      timer.stop();
      logInfo('[EncryptAppDataService] Hoàn thành rotate keys trong ${timer.elapsed.inSeconds}s');
    } catch (e) {
      timer.stop();
      logError('[EncryptAppDataService] Lỗi rotate keys sau ${timer.elapsed.inSeconds}s: $e');
      onError.call();
      // Rollback - không cần rollback storage vì chưa lưu keys mới
      logInfo('[EncryptAppDataService] Bắt đầu rollback...');
      clearCache();
      _keyCache.addAll(oldKeys.map((k, v) => MapEntry(k, _CachedKey(v))));
      logInfo('[EncryptAppDataService] Đã rollback xong');

      rethrow;
    }
  }

  // Service tạm thời để mã hóa với keys mới

  Future<AccountOjbModel> _reencryptAccountWithKeys(AccountOjbModel account, _TempEncryptionService tempService) async {
    try {
      // Mã hóa lại các trường cơ bản với keys mới
      final reencryptedAccount = AccountOjbModel(
        id: account.id,
        title: await tempService.encryptInfo(await decryptInfo(account.title)),
        email: account.email != null ? await tempService.encryptInfo(await decryptInfo(account.email!)) : null,
        password: account.password != null ? await tempService.encryptPassword(await decryptPassword(account.password!)) : null,
        notes: account.notes != null ? await tempService.encryptInfo(await decryptInfo(account.notes!)) : null,
        icon: account.icon,
        categoryOjbModel: account.getCategory,
        iconCustomModel: account.getIconCustom,
        createdAt: account.createdAt,
        updatedAt: DateTime.now(),
      );

      // Mã hóa lại custom fields nếu có
      if (account.getCustomFields.isNotEmpty) {
        final reencryptedFields = await Future.wait(
          account.getCustomFields.map((field) async {
            final decryptedValue = field.typeField == 'password' ? await decryptPassword(field.value) : await decryptInfo(field.value);
            final reencryptedValue = field.typeField == 'password' ? await tempService.encryptPassword(decryptedValue) : await tempService.encryptInfo(decryptedValue);

            return AccountCustomFieldOjbModel(id: field.id, name: field.name, hintText: field.hintText, value: reencryptedValue, typeField: field.typeField);
          }),
        );
        reencryptedAccount.customFields.clear();
        reencryptedAccount.customFields.addAll(reencryptedFields.where((field) => field.value.isNotEmpty).cast<AccountCustomFieldOjbModel>());
      }

      // Mã hóa lại TOTP nếu có
      if (account.getTotp != null) {
        final decryptedSecret = await decryptTOTPKey(account.getTotp!.secretKey);
        if (decryptedSecret.isNotEmpty) {
          final reencryptedSecret = await tempService.encryptTOTPKey(decryptedSecret);
          reencryptedAccount.setTotp = TOTPOjbModel(secretKey: reencryptedSecret);
        }
      }

      return reencryptedAccount;
    } catch (e) {
      logError('[EncryptAppDataService] Lỗi mã hóa lại account ${account.id}: $e');
      rethrow;
    }
  }

  Future<void> _migrateData() async {
    try {
      final accounts = await AccountBox.getAll();
      if (accounts.isEmpty) {
        return;
      }
      var migratedCount = 0;
      var errorCount = 0;
      final migratedAccounts = <AccountOjbModel>[];
      // Mã hóa pin code của người dùng cũ
      String? pinCodeEncrypted = await SecureStorage.instance.read(key: SecureStorageKeys.pinCode.name);
      final oldPinCode = OldEncryptData.decriptPinCode(pinCodeEncrypted!);
      final encryptedPinCode = await encryptPinCode(oldPinCode);

      for (var account in accounts) {
        try {
          await _withRetry(() async {
            final decryptedAccount = await _decryptWithLegacyKey(account);
            final reencryptedAccount = await _encryptAccountWithKeys(decryptedAccount, decryptValue: false);
            migratedAccounts.add(reencryptedAccount); // Thêm vào danh sách chờ
            migratedCount++;
          });
        } catch (e) {
          _logError('Không thể tải trước keys', e);
          errorCount++;
          break; // Dừng ngay khi có lỗi để tránh lãng phí tài nguyên
        }
      }

      // Chỉ lưu vào database nếu tất cả đều thành công
      if (errorCount == 0 && migratedCount == accounts.length) {
        // Lưu pin code mới
        await SecureStorage.instance.save(key: SecureStorageKeys.pinCode.name, value: encryptedPinCode);

        // Lưu tất cả tài khoản đã migrate vào database
        await AccountBox.putMany(migratedAccounts);
      } else {
        throw Exception('Migration failed: $errorCount errors, only migrated $migratedCount/${accounts.length} accounts');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AccountOjbModel> _encryptAccountWithKeys(AccountOjbModel account, {bool decryptValue = true}) async {
    try {
      // Mã hóa lại các trường cơ bản với keys mới
      final reencryptedAccount = AccountOjbModel(
        id: account.id,
        title: await encryptInfo(account.title),
        email: account.email != null ? await encryptInfo(account.email!) : null,
        password: account.password != null ? await encryptPassword(account.password!) : null,
        notes: account.notes != null ? await encryptInfo(account.notes!) : null,
        icon: account.icon,
        categoryOjbModel: account.getCategory,
        iconCustomModel: account.getIconCustom,
        createdAt: account.createdAt,
        updatedAt: DateTime.now(),
      );

      // Mã hóa lại custom fields nếu có
      if (account.getCustomFields.isNotEmpty) {
        final reencryptedFields = await Future.wait(
          account.getCustomFields.map((field) async {
            try {
              String decryptedValue = field.value;
              if (decryptValue) {
                decryptedValue = field.typeField == 'password' ? await decryptPassword(field.value) : await decryptInfo(field.value);
                if (decryptedValue.isEmpty) {
                  return null; // Không thêm vào nếu giá trị rỗng
                }
              }
              final reencryptedValue = field.typeField == 'password' ? await encryptPassword(decryptedValue) : await encryptInfo(decryptedValue);
              return AccountCustomFieldOjbModel(id: field.id, name: field.name, hintText: field.hintText, value: reencryptedValue, typeField: field.typeField);
            } catch (e) {
              return null; // Không thêm vào nếu có lỗi
            }
          }),
        );
        reencryptedAccount.customFields.clear();
        reencryptedAccount.customFields.addAll(reencryptedFields.where((field) => field != null).cast<AccountCustomFieldOjbModel>());
      }

      // Mã hóa lại password histories nếu có
      if (account.getPasswordHistories.isNotEmpty) {
        final reencryptedHistories = await Future.wait(
          account.getPasswordHistories.map((history) async {
            try {
              final decryptedPassword = await decryptPassword(history.password);
              if (decryptedPassword.isEmpty) {
                return null; // Không thêm vào nếu giá trị rỗng
              }
              final reencryptedPassword = await encryptPassword(decryptedPassword);
              return PasswordHistory(id: history.id, password: reencryptedPassword, createdAt: history.createdAt);
            } catch (e) {
              return null; // Không thêm vào nếu có lỗi
            }
          }),
        );
        reencryptedAccount.passwordHistories.clear();
        reencryptedAccount.passwordHistories.addAll(reencryptedHistories.where((history) => history != null).cast<PasswordHistory>());
      }

      // Mã hóa lại TOTP nếu có
      if (account.getTotp != null) {
        try {
          final decryptedSecret = await decryptTOTPKey(account.getTotp!.secretKey);
          if (decryptedSecret.isEmpty) {
            return reencryptedAccount; // Không thêm TOTP nếu giá trị rỗng
          }
          final reencryptedSecret = await encryptTOTPKey(decryptedSecret);
          reencryptedAccount.setTotp = TOTPOjbModel(secretKey: reencryptedSecret);
        } catch (e) {
          logError('Lỗi mã hóa TOTP: ${e.toString()}');
        }
      }

      return reencryptedAccount;
    } catch (e) {
      logError('[EncryptAppDataService] Lỗi mã hóa lại account ${account.id}: $e');
      rethrow;
    }
  }

  //   /// Giải mã với key cũ (chỉ dùng trong migration)
  Future<AccountOjbModel> _decryptWithLegacyKey(AccountOjbModel account) async {
    try {
      return AccountOjbModel(
        id: account.id,
        title: OldEncryptData.decryptInfo(account.title),
        email: account.email != null ? OldEncryptData.decryptInfo(account.email!) : null,
        password: account.password != null ? OldEncryptData.decryptPassword(account.password!) : null,
        notes: account.notes != null ? OldEncryptData.decryptInfo(account.notes!) : null,
        icon: account.icon,
        categoryOjbModel: account.getCategory,
        customFieldOjbModel:
            account.getCustomFields
                .map((field) {
                  try {
                    String decryptedValue = field.typeField == 'password' ? OldEncryptData.decryptPassword(field.value) : OldEncryptData.decryptInfo(field.value);
                    if (decryptedValue.isEmpty || decryptedValue == "") {
                      AccountCustomFieldBox.removeById(field.id);
                      return null; // Không thêm vào nếu giá trị rỗng
                    }

                    field.value = decryptedValue;
                    return field;
                  } catch (e) {
                    AccountCustomFieldBox.removeById(field.id);
                    return null; // Không thêm vào nếu có lỗi
                  }
                })
                .where((field) => field != null)
                .cast<AccountCustomFieldOjbModel>()
                .toList(),
        passwordHistoriesList:
            account.getPasswordHistories
                .map((history) {
                  try {
                    String decryptedPassword = OldEncryptData.decryptPassword(history.password);
                    if (decryptedPassword.isEmpty || decryptedPassword == "") {
                      PasswordHistoryBox.removeById(history.id);
                      return null; // Không thêm vào nếu giá trị rỗng
                    }
                    history.password = decryptedPassword;
                    return history;
                  } catch (e) {
                    PasswordHistoryBox.removeById(history.id);
                    return null; // Không thêm vào nếu có lỗi
                  }
                })
                .where((history) => history != null)
                .cast<PasswordHistory>()
                .toList(),
        totpOjbModel: account.getTotp != null ? TOTPOjbModel(id: 0, secretKey: OldEncryptData.decryptTOTPKey(account.getTotp!.secretKey)) : null,
        iconCustomModel: account.getIconCustom,
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
      );
    } catch (e) {
      logError('[EncryptAppDataService] Lỗi giải mã với key cũ cho account ${account.id}: $e');
      rethrow;
    }
  }

  Future<void> _restoreData(Map<String, dynamic> data) async {
    List<AccountOjbModel> accountsEncrypted = [];
    List<AccountOjbModel> newAccounts = (data['accounts'] as List).map((json) => AccountOjbModel.fromJson(json)).toList();

    for (var account in newAccounts) {
      // Reset ID về 0 để ObjectBox tự tạo ID mới
      final accountNew = AccountOjbModel(
        id: 0, // Set ID = 0 để ObjectBox tự tạo ID mới
        title: account.title,
        email: account.email ?? "",
        password: account.password ?? "",
        notes: account.notes ?? "",
        icon: account.icon ?? "",
      );

      // Xử lý TOTP
      if (account.getTotp != null) {
        accountNew.totp.target = TOTPOjbModel(
          id: 0, // Reset ID
          secretKey: account.getTotp!.secretKey,
        );
      }

      // Xử lý custom fields
      if (account.getCustomFields.isNotEmpty) {
        for (var customField in account.getCustomFields) {
          final newCustomField = AccountCustomFieldOjbModel(
            id: 0, // Reset ID
            name: customField.name,
            value: customField.value,
            hintText: customField.hintText,
            typeField: customField.typeField,
          );
          accountNew.customFields.add(newCustomField);
        }
      }

      // Xử lý password histories
      if (account.getPasswordHistories.isNotEmpty) {
        for (var passwordHistory in account.getPasswordHistories) {
          final newPasswordHistory = PasswordHistory(
            id: 0, // Reset ID
            password: passwordHistory.password,
            createdAt: passwordHistory.createdAt,
          );
          accountNew.passwordHistories.add(newPasswordHistory);
        }
      }

      // Xử lý category
      account.category.target ??= CategoryOjbModel(categoryName: "Backup");
      final categoryResult = CategoryBox.findCategoryByName(account.category.target?.categoryName ?? "Backup");
      if (categoryResult == null) {
        final newCategory = CategoryOjbModel(
          id: 0, // Reset ID
          categoryName: account.category.target?.categoryName ?? "Backup",
        );
        final id = CategoryBox.put(newCategory);
        newCategory.id = id;
        accountNew.category.target = newCategory;
      } else {
        accountNew.category.target = categoryResult;
      }

      // Xử lý icon custom
      if (account.getIconCustom != null && account.getIconCustom!.imageBase64.isNotEmpty) {
        final existingIcon = IconCustomBox.findIconByBase64Image(account.getIconCustom!.imageBase64);
        if (existingIcon != null) {
          accountNew.iconCustom.target = existingIcon;
        } else {
          final newIcon = IconCustomModel(
            id: 0, // Reset ID
            name: account.getIconCustom!.name,
            imageBase64DarkModel: account.getIconCustom?.imageBase64DarkModel ?? "",
            imageBase64: account.getIconCustom!.imageBase64,
          );
          final iconId = IconCustomBox.put(newIcon);
          newIcon.id = iconId;
          accountNew.iconCustom.target = newIcon;
        }
      }

      final accountEncrypted = await _encryptAccountWithKeys(accountNew);
      accountsEncrypted.add(accountEncrypted);
    }
    logInfo("accountsEncrypted: ${accountsEncrypted.length}");
    await AccountBox.putMany(accountsEncrypted);
  }

  Future<void> _saveCurrentVersion() async {
    await _secureStorage.save(key: SecureStorageKey.appVersionStorageKey, value: AppVersion.latest.version);
  }

  Future<void> _checkAndUpdateVersion() async {
    final savedVersion = await _secureStorage.read(key: SecureStorageKey.appVersionStorageKey);
    if (savedVersion != AppVersion.latest.version) {
      await _saveCurrentVersion();
    }
  }

  void clearCache() {
    _keyCache.clear();
    _cachedDeviceKey = null;
    _deviceKeyExpiry = null;
    _orchestrationKey = "";
    _isOrchestrationKeyInitialized = false;
  }

  // Tạo device key mới nhưng không lưu
  Future<String> _generateNewDeviceKeyOnly() async {
    return base64.encode(List.generate(32, (_) => Random.secure().nextInt(256)));
  }

  // Tạo encryption key mới nhưng không lưu
  Future<String> _generateNewEncryptionKeyOnly(String deviceKey, KeyType type) async {
    final salt = 'cybersafe_${type.name}_salt_$deviceKey';
    return await compute(_generateKeyInIsolate, {'salt': salt, 'deviceKey': deviceKey, 'iterations': EncryptionConfig.PBKDF2_ITERATIONS, 'keySize': EncryptionConfig.KEY_SIZE_BYTES});
  }

  // Lưu toàn bộ keys mới vào storage
  Future<void> _saveNewKeys(String newDeviceKey, Map<KeyType, String> newKeys) async {
    await _secureStorage.save(key: SecureStorageKey.deviceKeyStorageKey, value: newDeviceKey);

    for (var entry in newKeys.entries) {
      final storageKey = _getStorageKeyForType(entry.key);
      await _secureStorage.save(key: storageKey, value: entry.value);
    }

    await _secureStorage.save(key: SecureStorageKey.encryptionKeyCreationTime, value: DateTime.now().toIso8601String());
  }
}

// Helper classes
class _CachedKey {
  final String key;
  final DateTime expiresAt;

  _CachedKey(this.key) : expiresAt = DateTime.now().add(EncryptionConfig.KEY_CACHE_DURATION);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

// Thêm extension cho EncryptAppDataService
extension EncryptAppDataServiceExtension on EncryptAppDataService {
  // Helper method để decrypt account cho việc verify
  Future<Map<String, String>> _decryptAccountForVerification(AccountOjbModel account) async {
    final decrypted = <String, String>{
      'title': await decryptInfo(account.title),
      'email': account.email != null ? await decryptInfo(account.email!) : '',
      'password': account.password != null ? await decryptPassword(account.password!) : '',
      'notes': account.notes != null ? await decryptInfo(account.notes!) : '',
    };

    // Decrypt custom fields
    if (account.getCustomFields.isNotEmpty) {
      for (var field in account.getCustomFields) {
        final decryptedValue = field.typeField == 'password' ? await decryptPassword(field.value) : await decryptInfo(field.value);
        decrypted['custom_${field.id}'] = decryptedValue;
      }
    }

    // Decrypt TOTP
    if (account.getTotp != null) {
      decrypted['totp'] = await decryptTOTPKey(account.getTotp!.secretKey);
    }

    return decrypted;
  }

  // Helper method để so sánh dữ liệu đã decrypt
  bool _compareDecryptedAccounts(Map<String, String> original, Map<String, String> reencrypted) {
    if (original.length != reencrypted.length) {
      logError('[EncryptAppDataService] Số lượng trường không khớp');
      logInfo('Original length: ${original.length}');
      logInfo('Reencrypted length: ${reencrypted.length}');
      return false;
    }

    for (var key in original.keys) {
      if (original[key] != reencrypted[key]) {
        logError('[EncryptAppDataService] Không khớp dữ liệu ở trường: $key');
        logInfo('Original: ${original[key]}');
        logInfo('Reencrypted: ${reencrypted[key]}');
        return false;
      }
    }

    return true;
  }
}

class _TempEncryptionService {
  final String deviceKey;
  final Map<KeyType, String> encryptionKeys;
  final _encryptData = EncryptService.instance;

  _TempEncryptionService({required this.deviceKey, required this.encryptionKeys});

  Future<String> encryptInfo(String value) async {
    if (value.isEmpty) return value;
    return await _encryptData.encryptFernet(value: value, key: encryptionKeys[KeyType.info]!);
  }

  Future<String> encryptPassword(String value) async {
    if (value.isEmpty) return value;
    return await _encryptData.encryptFernet(value: value, key: encryptionKeys[KeyType.password]!);
  }

  Future<String> encryptTOTPKey(String value) async {
    if (value.isEmpty) return value;
    return await _encryptData.encryptFernet(value: value, key: encryptionKeys[KeyType.totp]!);
  }

  Future<String> decryptInfo(String value) async {
    if (value.isEmpty) return value;
    return _encryptData.decryptFernet(value: value, key: encryptionKeys[KeyType.info]!);
  }

  Future<String> decryptPassword(String value) async {
    if (value.isEmpty) return value;
    return _encryptData.decryptFernet(value: value, key: encryptionKeys[KeyType.password]!);
  }

  Future<String> decryptTOTPKey(String value) async {
    if (value.isEmpty) return value;
    return _encryptData.decryptFernet(value: value, key: encryptionKeys[KeyType.totp]!);
  }

  Future<Map<String, String>> decryptAccountForVerification(AccountOjbModel account) async {
    final decrypted = <String, String>{
      'title': await decryptInfo(account.title),
      'email': account.email != null ? await decryptInfo(account.email!) : '',
      'password': account.password != null ? await decryptPassword(account.password!) : '',
      'notes': account.notes != null ? await decryptInfo(account.notes!) : '',
    };

    if (account.getCustomFields.isNotEmpty) {
      for (var field in account.getCustomFields) {
        final decryptedValue = field.typeField == 'password' ? await decryptPassword(field.value) : await decryptInfo(field.value);
        decrypted['custom_${field.id}'] = decryptedValue;
      }
    }

    if (account.getTotp != null) {
      decrypted['totp'] = await decryptTOTPKey(account.getTotp!.secretKey);
    }

    return decrypted;
  }
}
