import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/database/boxes/icon_custom_box.dart';
import 'package:cybersafe_pro/database/models/account_custom_field.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/database/models/password_history_model.dart';
import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_service.dart';
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

  Future<void>? _initializing;
  Future<void> initialize() async {
    if (_initializing != null) return _initializing!;
    final completer = Completer<void>();
    _initializing = completer.future;
    try {
      // Khởi tạo orchestration key trước
      await _initializeOrchestrationKey();
      final hasDeviceKey = await _hasDeviceKey();

      if (!hasDeviceKey) {
        await _generateDeviceKey();
        await _saveCurrentVersion();
      } else {
        await _checkAndUpdateVersion();
      }
      await _preloadKeys();
      completer.complete();
    } catch (e) {
      _logError('Lỗi khởi tạo', e);
      completer.completeError(e);
      rethrow;
    } finally {
      _initializing = null;
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
      // _logError('Orchestration key chưa được khởi tạo', 'Không thể bảo vệ khóa');
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
      // _logError('Orchestration key chưa được khởi tạo', 'Không thể khôi phục khóa');
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
    try {
      if (pinCode.isEmpty) return pinCode;

      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.pinCode);
      return EncryptService.encryptData(value: pinCode, key: encryptionKey);
    } catch (e) {
      _logError('Lỗi mã hóa pin code', e);
      rethrow;
    }
  }

  Future<String> decryptPinCode(String encrypted) async {
    final deviceKey = await _getDeviceKey();
    final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.pinCode);
    return EncryptService.decryptData(value: encrypted, key: encryptionKey);
  }

  // Mã hóa thông tin
  Future<String> encryptInfo(String value) async {
    if (value.isEmpty) return value;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.info);
      return _encryptInIsolate({'value': value, 'key': encryptionKey});
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

  // Batch decrypt info - tối ưu cho nhiều trường cùng lúc
  Future<List<String>> batchDecryptInfo(List<String> encryptedList) async {
    if (encryptedList.isEmpty) return encryptedList;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.info);
      
      return await compute(_batchDecryptInIsolate, {
        'values': encryptedList,
        'key': encryptionKey,
        'type': 'info'
      });
    } catch (e) {
      _logError('Lỗi batch giải mã thông tin', e);
      return encryptedList;
    }
  }

  // Mã hóa mật khẩu
  Future<String> encryptPassword(String password) async {
    if (password.isEmpty) return password;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.password);
      return EncryptService.encryptData(value: password, key: encryptionKey);
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
      return EncryptService.decryptData(value: encrypted, key: encryptionKey);
    } catch (e) {
      _logError('Lỗi giải mã mật khẩu', e);
      rethrow;
    }
  }

  // Batch decrypt password - tối ưu cho nhiều password cùng lúc
  Future<List<String>> batchDecryptPassword(List<String> encryptedList) async {
    if (encryptedList.isEmpty) return encryptedList;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.password);
      
      return await compute(_batchDecryptInIsolate, {
        'values': encryptedList,
        'key': encryptionKey,
        'type': 'password'
      });
    } catch (e) {
      _logError('Lỗi batch giải mã mật khẩu', e);
      rethrow;
    }
  }

  // Giải mã TOTP
  Future<String> decryptTOTPKey(String encrypted) async {
    if (encrypted.isEmpty) return encrypted;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.totp);
      return EncryptService.decryptData(value: encrypted, key: encryptionKey);
    } catch (e) {
      _logError('Lỗi giải mã TOTP', e);
      rethrow;
    }
  }

  // Batch decrypt TOTP - tối ưu cho nhiều TOTP key cùng lúc
  Future<List<String>> batchDecryptTOTPKey(List<String> encryptedList) async {
    if (encryptedList.isEmpty) return encryptedList;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.totp);
      
      return await compute(_batchDecryptInIsolate, {
        'values': encryptedList,
        'key': encryptionKey,
        'type': 'totp'
      });
    } catch (e) {
      _logError('Lỗi batch giải mã TOTP', e);
      rethrow;
    }
  }

  // Batch decrypt account - tối ưu cho việc decrypt toàn bộ account
  Future<List<Map<String, dynamic>>> batchDecryptAccounts(List<AccountOjbModel> accounts) async {
    if (accounts.isEmpty) return [];

    try {
      // Lấy tất cả keys cần thiết trước
      final deviceKey = await _getDeviceKey();
      final keys = await Future.wait([
        _generateEncryptionKey(deviceKey, KeyType.info),
        _generateEncryptionKey(deviceKey, KeyType.password),
        _generateEncryptionKey(deviceKey, KeyType.totp),
      ]);

      // Chuyển đổi accounts thành format có thể serialize
      final accountsData = accounts.map((account) => {
        'id': account.id,
        'title': account.title,
        'email': account.email ?? '',
        'password': account.password ?? '',
        'notes': account.notes ?? '',
        'icon': account.icon,
        'customFields': account.getCustomFields.map((field) => {
          'id': field.id,
          'name': field.name,
          'value': field.value,
          'hintText': field.hintText,
          'typeField': field.typeField,
        }).toList(),
        'totp': account.getTotp != null ? {
          'secretKey': account.getTotp!.secretKey,
          'isShowToHome': account.getTotp!.isShowToHome,
          'createdAt': account.getTotp!.createdAt.toIso8601String(),
          'updatedAt': account.getTotp!.updatedAt.toIso8601String(),
        } : null,
        'category': account.getCategory?.toJson(),
        'passwordUpdatedAt': account.passwordUpdatedAt?.toIso8601String(),
        'passwordHistories': account.getPasswordHistories.map((history) => {
          'password': history.password,
          'createdAt': history.createdAt.toIso8601String(),
        }).toList(),
        'iconCustom': account.getIconCustom?.toJson(),
        'createdAt': account.createdAt?.toIso8601String(),
        'updatedAt': account.updatedAt?.toIso8601String(),
      }).toList();

      // Gửi tất cả vào isolate để decrypt
      return await compute(_batchDecryptAccountsInIsolate, {
        'accounts': accountsData,
        'infoKey': keys[0],
        'passwordKey': keys[1],
        'totpKey': keys[2],
      });
    } catch (e) {
      _logError('Lỗi batch giải mã accounts', e);
      rethrow;
    }
  }

  // Mã hóa TOTP
  Future<String> encryptTOTPKey(String key) async {
    if (key.isEmpty) return key;

    try {
      final deviceKey = await _getDeviceKey();
      final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.totp);
      return EncryptService.encryptData(value: key, key: encryptionKey);
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
      // --- Sử dụng compute cho batch toDecryptedJson ---
      final accountsJson = await _accountsToDecryptedJsonBatch(accounts);
      final backupData = {
        'type': 'CYBERSAFE_BACKUP',
        'version': AppVersion.latest.version,
        'timestamp': DateTime.now().toIso8601String(),
        'backupName': backupName,
        'deviceKey': deviceKey,
        'data': {'accounts': accountsJson},
      };
      final backupJson = jsonEncode(backupData);
      _validateBackupSize(backupJson);
      final encryptedData = await EncryptService.encryptData(value: backupJson, key: _generateBackupKey(pin));
      return {'type': 'CYBERSAFE_BACKUP', 'version': AppVersion.latest.version, 'data': encryptedData, 'checksum': _calculateChecksum(encryptedData), 'timestamp': DateTime.now().toIso8601String()};
    } catch (e) {
      _logError('Lỗi tạo backup', e);
      rethrow;
    }
  }

  // Khôi phục backup
  Future<bool> restoreBackup(
    String dataBackup,
    String pin, {
    Function()? onIncorrectPin,
    Function()? onRestoreSuccess,
    Function()? onRestoreFailed,
    Function()? onRestoreStart,
    Function(double progress)? onRestoreProgress,
  }) async {
    try {
      final backupData = jsonDecode(dataBackup);
      _validateBackupData(backupData);

      try {
        final decryptedData = EncryptService.decryptData(value: backupData['data'], key: _generateBackupKey(pin));
        // Kiểm tra xem dữ liệu giải mã có đúng định dạng JSON không
        final data = jsonDecode(decryptedData);

        // Kiểm tra xem có phải là dữ liệu backup hợp lệ không
        if (!data.containsKey('type') || data['type'] != 'CYBERSAFE_BACKUP') {
          onIncorrectPin?.call();
          throwAppError(ErrorText.invalidBackupFile);
        }

        await _restoreData(data['data'], onRestoreProgress: onRestoreProgress);
        return true;
      } catch (e) {
        hideLoadingDialog();
        if (e.toString().contains('PIN_INCORRECT')) {
          onIncorrectPin?.call();
          _logError('PIN không chính xác', e);
          throw Exception('PIN_INCORRECT');
        }

        throwAppError(ErrorText.invalidBackupFile);
        return false;
      }
    } catch (e) {
      hideLoadingDialog();
      _logError('Lỗi khôi phục backup', e);
      if (e.toString().contains('PIN_INCORRECT')) {
        onIncorrectPin?.call();
        throw Exception('PIN_INCORRECT');
      }
      return false;
    }
  }

  // Helper methods
  void _logError(String message, Object error) {
    logError('[EncryptAppDataService] ERROR: $message: $error');
  }

  Future<bool> _hasDeviceKey() async {
    return await _secureStorage.read(key: SecureStorageKey.deviceKeyStorageKey) != null;
  }

  Future<void> _generateDeviceKey() async {
    return await _withRetry(() async {
      final key = base64.encode(List.generate(32, (_) => Random.secure().nextInt(256)));
      await _secureStorage.save(key: SecureStorageKey.deviceKeyStorageKey, value: key);
    });
  }

  Future<String> _getDeviceKey() async {
    return await _withRetry(() async {
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
    });
  }

  Future<String> _generateEncryptionKey(String deviceKey, KeyType type) async {
    return await _withRetry(() async {
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
    });
  }

  static String _generateKeyInIsolate(Map<String, dynamic> params) {
    final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(utf8.encode(params['salt'])), params['iterations'], params['keySize']));
    return base64.encode(generator.process(Uint8List.fromList(utf8.encode(params['deviceKey']))));
  }

  static Future<String> _encryptInIsolate(Map<String, String> params) async {
    return await EncryptService.encryptData(value: params['value']!, key: params['key']!);
  }

  static String _decryptInIsolate(Map<String, String> params) {
    return EncryptService.decryptData(value: params['value']!, key: params['key']!);
  }

  // Batch decrypt trong isolate - xử lý nhiều giá trị cùng lúc
  static List<String> _batchDecryptInIsolate(Map<String, dynamic> params) {
    final List<String> values = List<String>.from(params['values']);
    final String key = params['key'];
    
    return values.map((value) {
      if (value.isEmpty) return value;
      try {
        return EncryptService.decryptData(value: value, key: key);
      } catch (e) {
        // Trả về giá trị gốc nếu decrypt thất bại
        return value;
      }
    }).toList();
  }

  // Batch decrypt accounts trong isolate - xử lý toàn bộ accounts
  static List<Map<String, dynamic>> _batchDecryptAccountsInIsolate(Map<String, dynamic> params) {
    final List<Map<String, dynamic>> accounts = List<Map<String, dynamic>>.from(params['accounts']);
    final String infoKey = params['infoKey'];
    final String passwordKey = params['passwordKey'];
    final String totpKey = params['totpKey'];

    return accounts.map((account) {
      try {
        // Decrypt basic fields
        final decryptedAccount = <String, dynamic>{
          'id': account['id'],
          'title': _safeDecrypt(account['title'], infoKey),
          'email': _safeDecrypt(account['email'], infoKey),
          'password': _safeDecrypt(account['password'], passwordKey),
          'notes': _safeDecrypt(account['notes'], infoKey),
          'icon': account['icon'],
          'category': account['category'],
          'passwordUpdatedAt': account['passwordUpdatedAt'],
          'iconCustom': account['iconCustom'],
          'createdAt': account['createdAt'],
          'updatedAt': account['updatedAt'],
        };

        // Decrypt custom fields
        final customFields = (account['customFields'] as List<dynamic>).map((field) {
          final fieldMap = field as Map<String, dynamic>;
          final isPassword = fieldMap['typeField'] == 'password';
          final decryptedValue = _safeDecrypt(
            fieldMap['value'], 
            isPassword ? passwordKey : infoKey
          );
          
          return {
            'id': fieldMap['id'],
            'name': fieldMap['name'],
            'value': decryptedValue,
            'hintText': fieldMap['hintText'],
            'typeField': fieldMap['typeField'],
          };
        }).toList();

        decryptedAccount['customFields'] = customFields;

        // Decrypt TOTP
        if (account['totp'] != null) {
          final totpMap = account['totp'] as Map<String, dynamic>;
          decryptedAccount['totp'] = {
            'secretKey': _safeDecrypt(totpMap['secretKey'], totpKey),
            'isShowToHome': totpMap['isShowToHome'],
            'createdAt': totpMap['createdAt'],
            'updatedAt': totpMap['updatedAt'],
          };
        } else {
          decryptedAccount['totp'] = null;
        }

        // Decrypt password histories
        final passwordHistories = (account['passwordHistories'] as List<dynamic>).map((history) {
          final historyMap = history as Map<String, dynamic>;
          return {
            'password': _safeDecrypt(historyMap['password'], passwordKey),
            'createdAt': historyMap['createdAt'],
          };
        }).toList();

        decryptedAccount['passwordHistories'] = passwordHistories;

        return decryptedAccount;
      } catch (e) {
        // Trả về dữ liệu gốc nếu có lỗi
        return account;
      }
    }).toList();
  }

  // Helper method để decrypt an toàn
  static String _safeDecrypt(dynamic value, String key) {
    if (value == null || value.toString().isEmpty) return '';
    try {
      return EncryptService.decryptData(value: value.toString(), key: key);
    } catch (e) {
      return value.toString(); // Trả về giá trị gốc nếu decrypt thất bại
    }
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
      await AccountBox.putMany(reencryptedAccounts.values.toList());

      // Xóa cache cũ
      clearCache();
      _initializeOrchestrationKey();
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

  Future<void> _restoreData(Map<String, dynamic> data, {Function(double progress)? onRestoreProgress}) async {
    // 1. Chuẩn bị danh sách account mới (reset id, xử lý category/icon/custom fields/histories)
    final List<AccountOjbModel> newAccounts =
        (data['accounts'] as List).map((json) => AccountOjbModel.fromJson(json)).map((account) {
          // Reset ID về 0 để ObjectBox tự tạo ID mới
          final accountNew = AccountOjbModel(id: 0, title: account.title, email: account.email ?? "", password: account.password ?? "", notes: account.notes ?? "", icon: account.icon ?? "");
          // TOTP
          if (account.getTotp != null) {
            accountNew.totp.target = TOTPOjbModel(id: 0, secretKey: account.getTotp!.secretKey);
          }
          // Custom fields
          if (account.getCustomFields.isNotEmpty) {
            for (var customField in account.getCustomFields) {
              accountNew.customFields.add(AccountCustomFieldOjbModel(id: 0, name: customField.name, value: customField.value, hintText: customField.hintText, typeField: customField.typeField));
            }
          }
          // Password histories
          if (account.getPasswordHistories.isNotEmpty) {
            for (var passwordHistory in account.getPasswordHistories) {
              accountNew.passwordHistories.add(PasswordHistory(id: 0, password: passwordHistory.password, createdAt: passwordHistory.createdAt));
            }
          }
          // Category
          account.category.target ??= CategoryOjbModel(categoryName: "Backup");
          final categoryResult = CategoryBox.findCategoryByName(account.category.target?.categoryName ?? "Backup");
          if (categoryResult == null) {
            final newCategory = CategoryOjbModel(id: 0, categoryName: account.category.target?.categoryName ?? "Backup");
            final id = CategoryBox.put(newCategory);
            newCategory.id = id;
            accountNew.category.target = newCategory;
          } else {
            accountNew.category.target = categoryResult;
          }
          // Icon custom
          if (account.getIconCustom != null && account.getIconCustom!.imageBase64.isNotEmpty) {
            final existingIcon = IconCustomBox.findIconByBase64Image(account.getIconCustom!.imageBase64);
            if (existingIcon != null) {
              accountNew.iconCustom.target = existingIcon;
            } else {
              final newIcon = IconCustomModel(
                id: 0,
                name: account.getIconCustom!.name,
                imageBase64DarkModel: account.getIconCustom?.imageBase64DarkModel ?? "",
                imageBase64: account.getIconCustom!.imageBase64,
              );
              final iconId = IconCustomBox.put(newIcon);
              newIcon.id = iconId;
              accountNew.iconCustom.target = newIcon;
            }
          }
          return accountNew;
        }).toList();

    // 2. Lấy deviceKey và các encryptionKey trên main isolate
    final deviceKey = await _getDeviceKey();
    final infoKey = await _generateEncryptionKey(deviceKey, KeyType.info);
    final passwordKey = await _generateEncryptionKey(deviceKey, KeyType.password);
    final totpKey = await _generateEncryptionKey(deviceKey, KeyType.totp);

    // 3. Truyền vào Isolate để batch encrypt và cập nhật progress
    const int batchSize = 10;
    final total = newAccounts.length;
    int done = 0;
    List<AccountOjbModel> allEncrypted = [];
    for (var i = 0; i < newAccounts.length; i += batchSize) {
      final batch = newAccounts.skip(i).take(batchSize).toList();
      final accountsEncrypted = await compute(_encryptAccountsWithKeysBatch, {
        'accounts': batch,
        'encryptionKeys': {'deviceKey': deviceKey, 'infoKey': infoKey, 'passwordKey': passwordKey, 'totpKey': totpKey},
      });
      allEncrypted.addAll(accountsEncrypted);
      done += batch.length;
      if (onRestoreProgress != null) {
        double progress = done / total;
        onRestoreProgress(progress > 1.0 ? 1.0 : progress);
      }
    }
    logInfo("accountsEncrypted: \u001b[32m\u001b[1m${allEncrypted.length}\u001b[0m");
    await AccountBox.putMany(allEncrypted);
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

// Top-level function for compute: batch toDecryptedJson
Future<List<Map<String, dynamic>>> _accountsToDecryptedJsonBatch(List<AccountOjbModel> accounts) async {
  return await Future.wait(accounts.map((acc) => acc.toDecryptedJson()));
}

// Helper: concurrentMap with throttled concurrency
Future<List<T>> _concurrentMap<T, E>(Iterable<E> items, Future<T> Function(E item) mapper, {int maxConcurrent = 4}) async {
  final results = <T>[];
  final iterator = items.iterator;
  int running = 0;
  final completer = Completer<void>();
  bool done = false;

  void runNext() {
    if (!iterator.moveNext()) {
      if (running == 0 && !done) {
        done = true;
        completer.complete();
      }
      return;
    }
    running++;
    mapper(iterator.current).then((result) {
      results.add(result);
      running--;
      runNext();
    });
    if (running < maxConcurrent) {
      runNext();
    }
  }

  for (int i = 0; i < maxConcurrent; i++) {
    runNext();
  }
  await completer.future;
  return results;
}

// Top-level function for compute: batch encryptAccountWithKeys
Future<List<AccountOjbModel>> _encryptAccountsWithKeysBatch(Map<String, dynamic> args) async {
  final List<AccountOjbModel> accounts = (args['accounts'] as List).cast<AccountOjbModel>();
  final keys = args['encryptionKeys'] as Map<String, String>;
  final tempService = _TempEncryptionService(deviceKey: keys['deviceKey']!, encryptionKeys: {KeyType.info: keys['infoKey']!, KeyType.password: keys['passwordKey']!, KeyType.totp: keys['totpKey']!});

  const int batchSize = 50; // hoặc 20, 100 tùy RAM
  const int maxConcurrent = 4; // Giới hạn số encryptFernet chạy song song
  List<AccountOjbModel> result = [];
  for (var i = 0; i < accounts.length; i += batchSize) {
    final batch = accounts.skip(i).take(batchSize);
    final encryptedBatch = await _concurrentMap(batch, (acc) async {
      List<AccountCustomFieldOjbModel> customFields = [];
      if (acc.getCustomFields.isNotEmpty) {
        customFields = await Future.wait(
          acc.getCustomFields.map((field) async {
            return AccountCustomFieldOjbModel(
              id: field.id,
              name: field.name,
              value: field.typeField == 'password' ? await tempService.encryptPassword(field.value) : await tempService.encryptInfo(field.value),
              hintText: field.hintText,
              typeField: field.typeField,
            );
          }),
        );
      }

      List<PasswordHistory> passwordHistoriesList = [];
      if (acc.getPasswordHistories.isNotEmpty) {
        passwordHistoriesList = await Future.wait(
          acc.getPasswordHistories.map((history) async {
            return PasswordHistory(id: history.id, password: await tempService.encryptPassword(history.password), createdAt: history.createdAt);
          }),
        );
      }

      return AccountOjbModel(
        id: acc.id,
        title: await tempService.encryptInfo(acc.title),
        email: acc.email != null ? await tempService.encryptInfo(acc.email!) : null,
        password: acc.password != null ? await tempService.encryptPassword(acc.password!) : null,
        notes: acc.notes != null ? await tempService.encryptInfo(acc.notes!) : null,
        icon: acc.icon,
        totpOjbModel: acc.getTotp != null ? TOTPOjbModel(secretKey: await tempService.encryptTOTPKey(acc.getTotp!.secretKey)) : null,
        categoryOjbModel: acc.getCategory,
        iconCustomModel: acc.getIconCustom,
        customFieldOjbModel: customFields,
        passwordHistoriesList: passwordHistoriesList,
        createdAt: acc.createdAt,
        updatedAt: DateTime.now(),
      );
    }, maxConcurrent: maxConcurrent);
    result.addAll(encryptedBatch);
  }
  return result;
}

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

  void clearAllKey() {
    _secureStorage.delete(key: SecureStorageKey.deviceKeyStorageKey);
    _secureStorage.delete(key: SecureStorageKey.infoKeyStorageKey);
    _secureStorage.delete(key: SecureStorageKey.passwordKeyStorageKey);
    _secureStorage.delete(key: SecureStorageKey.totpKeyStorageKey);
    _secureStorage.delete(key: SecureStorageKey.pinCodeKeyStorageKey);
  }
}

class _TempEncryptionService {
  final String deviceKey;
  final Map<KeyType, String> encryptionKeys;

  _TempEncryptionService({required this.deviceKey, required this.encryptionKeys});

  Future<String> encryptInfo(String value) async {
    if (value.isEmpty) return value;
    return await EncryptService.encryptData(value: value, key: encryptionKeys[KeyType.info]!);
  }

  Future<String> encryptPassword(String value) async {
    if (value.isEmpty) return value;
    return await EncryptService.encryptData(value: value, key: encryptionKeys[KeyType.password]!);
  }

  Future<String> encryptTOTPKey(String value) async {
    if (value.isEmpty) return value;
    return await EncryptService.encryptData(value: value, key: encryptionKeys[KeyType.totp]!);
  }

  Future<String> decryptInfo(String value) async {
    if (value.isEmpty) return value;
    return EncryptService.decryptData(value: value, key: encryptionKeys[KeyType.info]!);
  }

  Future<String> decryptPassword(String value) async {
    if (value.isEmpty) return value;
    return EncryptService.decryptData(value: value, key: encryptionKeys[KeyType.password]!);
  }

  Future<String> decryptTOTPKey(String value) async {
    if (value.isEmpty) return value;
    return EncryptService.decryptData(value: value, key: encryptionKeys[KeyType.totp]!);
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
