import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:collection';
import 'package:crypto/crypto.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_custom_field.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
import 'package:cybersafe_pro/services/encrypt_service.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as pc;

// Cấu hình mã hóa
class EncryptionConfig {
  static const int PBKDF2_ITERATIONS = 50000;
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
  final _encryptData = EncryptData.instance;
  final _secureStorage = SecureStorage.instance;

  // Cache keys
  final Map<String, _CachedKey> _keyCache = {};
  final _lruCache = _LRUCache<String, String>(maxSize: 1000);
  String? _cachedDeviceKey;
  DateTime? _deviceKeyExpiry;

  // Storage keys

  EncryptAppDataService._();

  // Khởi tạo
  Future<void> initialize() async {
    try {
      final isLegacy = await _isLegacyUser();
      final hasDeviceKey = await _hasDeviceKey();

      if (!isLegacy) {
        if (!hasDeviceKey) {
          await _generateDeviceKey();
          await _saveCurrentVersion();
        } else {
          await _checkAndUpdateVersion();
          // await _checkAndRotateKeys();
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
  Future<Map<String, dynamic>> createBackup(String pin, String backupName) async {
    _validatePin(pin);

    try {
      final deviceKey = await _getDeviceKey();
      final accounts = await AccountBox.getAll();

      final backupData = {
        'version': AppVersion.latest,
        'timestamp': DateTime.now().toIso8601String(),
        'backupName': backupName,
        'deviceKey': deviceKey,
        'data': {'accounts': accounts.map((acc) => acc.toJson()).toList()},
      };

      final backupJson = jsonEncode(backupData);
      _validateBackupSize(backupJson);

      final encryptedData = await _encryptData.encryptFernet(value: backupJson, key: _generateBackupKey(pin));

      return {'type': 'CYBERSAFE_BACKUP', 'version': AppVersion.latest, 'data': encryptedData, 'checksum': _calculateChecksum(encryptedData), 'timestamp': DateTime.now().toIso8601String()};
    } catch (e) {
      _logError('Lỗi tạo backup', e);
      rethrow;
    }
  }

  // Khôi phục backup
  Future<bool> restoreBackup(String filePath, String pin) async {
    try {
      final backupContent = await File(filePath).readAsString();
      final backupData = jsonDecode(backupContent);

      _validateBackupData(backupData);

      final decryptedData = _encryptData.decryptFernet(value: backupData['data'], key: _generateBackupKey(pin));

      final data = jsonDecode(decryptedData);
      await _restoreData(data['data']);

      return true;
    } catch (e) {
      _logError('Lỗi khôi phục backup', e);
      return false;
    }
  }

  // Helper methods
  void _logError(String message, Object error) {
    debugPrint('[EncryptAppDataService] ERROR: $message: $error');
  }

  Future<bool> _isLegacyUser() async {
    return await _secureStorage.read(key: SecureStorageKey.themMode) != null;
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
      return _cachedDeviceKey!;
    }

    final key = await _secureStorage.read(key: SecureStorageKey.deviceKeyStorageKey);
    if (key == null) throw Exception('Chưa tạo device key');

    _cachedDeviceKey = key;
    _deviceKeyExpiry = DateTime.now().add(EncryptionConfig.KEY_CACHE_DURATION);
    return key;
  }

  Future<String> _generateEncryptionKey(String deviceKey, KeyType type) async {
    final cacheKey = '${type.name}_$deviceKey';
    if (_keyCache.containsKey(cacheKey) && !_keyCache[cacheKey]!.isExpired) {
      return _keyCache[cacheKey]!.key;
    }

    final storageKey = _getStorageKeyForType(type);
    final savedKey = await _secureStorage.read(key: storageKey);
    if (savedKey != null) {
      _keyCache[cacheKey] = _CachedKey(savedKey);
      return savedKey;
    }

    final salt = 'cybersafe_${type.name}_salt_$deviceKey';
    final key = await compute(_generateKeyInIsolate, {'salt': salt, 'deviceKey': deviceKey, 'iterations': EncryptionConfig.PBKDF2_ITERATIONS, 'keySize': EncryptionConfig.KEY_SIZE_BYTES});

    _keyCache[cacheKey] = _CachedKey(key);
    await _secureStorage.save(key: storageKey, value: key);

    return key;
  }

  static String _generateKeyInIsolate(Map<String, dynamic> params) {
    final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(utf8.encode(params['salt'])), params['iterations'], params['keySize']));
    return base64.encode(generator.process(Uint8List.fromList(utf8.encode(params['deviceKey']))));
  }

  static Future<String> _encryptInIsolate(Map<String, String> params) async {
    final encryptData = EncryptData.instance;
    return await encryptData.encryptFernet(value: params['value']!, key: params['key']!);
  }

  static String _decryptInIsolate(Map<String, String> params) {
    return EncryptData.instance.decryptFernet(value: params['value']!, key: params['key']!);
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
      throw Exception('PIN phải có ít nhất ${EncryptionConfig.MIN_PIN_LENGTH} ký tự');
    }
  }

  void _validateBackupSize(String data) {
    final backupSize = utf8.encode(data).length / (1024 * 1024);
    if (backupSize > EncryptionConfig.MAX_BACKUP_SIZE_MB) {
      throw Exception('Kích thước backup quá lớn');
    }
  }

  void _validateBackupData(Map<String, dynamic> data) {
    if (data['type'] != 'CYBERSAFE_BACKUP') {
      throw Exception('File không phải backup hợp lệ');
    }

    final requiredFields = ['version', 'data', 'checksum', 'timestamp'];
    for (var field in requiredFields) {
      if (!data.containsKey(field)) {
        throw Exception('Thiếu trường $field trong file backup');
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
        if (attempts == EncryptionConfig.MAX_RETRY_ATTEMPTS) rethrow;
        await Future.delayed(EncryptionConfig.RETRY_DELAY * attempts);
      }
    }
    throw Exception('Đã vượt quá số lần thử lại');
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
      _logError('Không thể tải trước keys', e);
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
    debugPrint('[EncryptAppDataService] Bắt đầu rotate keys...');

    // Lưu trữ keys cũ để rollback nếu cần
    final oldDeviceKey = await _getDeviceKey();
    final oldKeys = Map<String, String>.from(_keyCache);

    // Map lưu trữ tạm thời keys mới
    final newKeys = <KeyType, String>{};
    String? newDeviceKey;

    try {
      // Tạo device key mới (chưa lưu)
      newDeviceKey = await _generateNewDeviceKeyOnly();
      debugPrint('[EncryptAppDataService] So sánh device keys:');
      debugPrint('Old Device Key: $oldDeviceKey');
      debugPrint('New Device Key: $newDeviceKey');

      // So sánh key cũ và mới
      if (oldDeviceKey == newDeviceKey) {
        debugPrint('[EncryptAppDataService] Device key không thay đổi, bỏ qua rotate');
        return;
      }
      debugPrint('[EncryptAppDataService] Đã tạo device key mới');

      // Tạo mới các encryption keys (chưa lưu)
      debugPrint('[EncryptAppDataService] Bắt đầu tạo encryption keys mới...');
      for (var type in KeyType.values) {
        final newKey = await _generateNewEncryptionKeyOnly(newDeviceKey, type);
        newKeys[type] = newKey;
        debugPrint('[EncryptAppDataService] Đã tạo ${type.name} key mới');
      }

      // Lấy tất cả accounts cần re-encrypt
      final accounts = await AccountBox.getAll();
      if (accounts.isEmpty) return;
      final totalAccounts = accounts.length;

      debugPrint('[EncryptAppDataService] Bắt đầu mã hóa lại $totalAccounts tài khoản');
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
            throw Exception('Dữ liệu không khớp sau khi mã hóa lại');
          }

          // Lưu vào map tạm thời
          reencryptedAccounts[account.id.toString()] = reencryptedAccount;

          successCount++;
          if (successCount % 10 == 0 || successCount == totalAccounts) {
            final progress = (successCount / totalAccounts * 100);
            final elapsed = DateTime.now().difference(startTime);
            debugPrint('[EncryptAppDataService] Tiến độ: $progress% ($successCount/$totalAccounts) - Thời gian: ${elapsed.inSeconds}s');
            onCallBackCount(successEncrypt: successCount, totalAccount: totalAccounts);
            onCallBackProgress(progress);
            onCallBackTime(elapsed.inSeconds);
          }
        } catch (e) {
          errors.add('Account ${account.id}: $e');
          debugPrint('[EncryptAppDataService] Lỗi khi mã hóa lại account ${account.id}: $e');
        }
      }

      // Kiểm tra kết quả
      if (errors.isNotEmpty) {
        throw Exception('Có ${errors.length} lỗi khi mã hóa lại:\n${errors.join('\n')}');
      }

      // Lưu toàn bộ keys mới vào storage
      await _saveNewKeys(newDeviceKey, newKeys);

      // Lưu các accounts đã mã hóa lại
      for (var account in reencryptedAccounts.values) {
       await AccountBox.put(account);
      }

      // Xóa cache cũ
      _clearCache();
      onSuccess.call();
      timer.stop();
      debugPrint('[EncryptAppDataService] Hoàn thành rotate keys trong ${timer.elapsed.inSeconds}s');
    } catch (e) {
      timer.stop();
      debugPrint('[EncryptAppDataService] Lỗi rotate keys sau ${timer.elapsed.inSeconds}s: $e');
      onError.call();
      // Rollback - không cần rollback storage vì chưa lưu keys mới
      debugPrint('[EncryptAppDataService] Bắt đầu rollback...');
      _clearCache();
      _keyCache.addAll(oldKeys.map((k, v) => MapEntry(k, _CachedKey(v))));
      debugPrint('[EncryptAppDataService] Đã rollback xong');

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
        reencryptedAccount.customFields.addAll(reencryptedFields);
      }

      // Mã hóa lại TOTP nếu có
      if (account.getTotp != null) {
        final decryptedSecret = await decryptTOTPKey(account.getTotp!.secretKey);
        final reencryptedSecret = await tempService.encryptTOTPKey(decryptedSecret);

        reencryptedAccount.setTotp = TOTPOjbModel(secretKey: reencryptedSecret, algorithm: account.getTotp!.algorithm, digits: account.getTotp!.digits, period: account.getTotp!.period);
      }

      return reencryptedAccount;
    } catch (e) {
      debugPrint('[EncryptAppDataService] Lỗi mã hóa lại account ${account.id}: $e');
      rethrow;
    }
  }

  Future<void> _migrateData() async {
    // Implementation of data migration
  }

  Future<void> _restoreData(Map<String, dynamic> data) async {
    // Implementation of data restoration
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

  void _clearCache() {
    _keyCache.clear();
    _cachedDeviceKey = null;
    _deviceKeyExpiry = null;
    _lruCache.clear();
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

class _LRUCache<K, V> {
  final int maxSize;
  final LinkedHashMap<K, V> _cache = LinkedHashMap<K, V>();

  _LRUCache({required this.maxSize});

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;
    final value = _cache.remove(key);
    _cache[key] = value as V;
    return value;
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= maxSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  void clear() => _cache.clear();
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
      debugPrint('[EncryptAppDataService] Số lượng trường không khớp');
      debugPrint('Original length: ${original.length}');
      debugPrint('Reencrypted length: ${reencrypted.length}');
      return false;
    }

    for (var key in original.keys) {
      if (original[key] != reencrypted[key]) {
        debugPrint('[EncryptAppDataService] Không khớp dữ liệu ở trường: $key');
        debugPrint('Original: ${original[key]}');
        debugPrint('Reencrypted: ${reencrypted[key]}');
        return false;
      }
    }

    return true;
  }
}

class _TempEncryptionService {
  final String deviceKey;
  final Map<KeyType, String> encryptionKeys;
  final _encryptData = EncryptData.instance;

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
