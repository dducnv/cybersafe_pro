// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:async';
// import 'dart:collection';
// import 'package:crypto/crypto.dart';
// import 'package:cybersafe_pro/database/boxes/account_box.dart';
// import 'package:cybersafe_pro/database/boxes/category_box.dart';
// import 'package:cybersafe_pro/database/models/account_custom_field.dart';
// import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
// import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
// import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
// import 'package:cybersafe_pro/services/encrypt_service.dart';
// import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_data.dart';
// import 'package:cybersafe_pro/utils/secure_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:pointycastle/export.dart' as pc;

// // Cấu hình cho encryption
// class EncryptionConfig {
//   static const int PBKDF2_ITERATIONS = 75000;
//   static const int KEY_SIZE_BYTES = 32;
//   static const int MIN_PIN_LENGTH = 6;
//   static const int MAX_BACKUP_SIZE_MB = 50;
//   static const Duration RETRY_DELAY = Duration(seconds: 1);
//   static const int MAX_RETRY_ATTEMPTS = 3;
// }

// // Thêm enum cho version
// enum AppVersion {
//   // legacy('1.0'), // Version cũ - tạm thời chưa cần dùng vì app cũ chưa có version
//   latest('2.0'); // Version hiện tại

//   final String version;
//   const AppVersion(this.version);
// }

// // Model cho backup data
// class BackupData {
//   final String version;
//   final DateTime timestamp;
//   final String backupName;
//   final String deviceKey;
//   final Map<String, dynamic> data;

//   BackupData({required this.version, required this.timestamp, required this.backupName, required this.deviceKey, required this.data});

//   Map<String, dynamic> toJson() => {'version': version, 'timestamp': timestamp.toIso8601String(), 'backupName': backupName, 'deviceKey': deviceKey, 'data': data};

//   factory BackupData.fromJson(Map<String, dynamic> json) {
//     return BackupData(version: json['version'], timestamp: DateTime.parse(json['timestamp']), backupName: json['backupName'], deviceKey: json['deviceKey'], data: json['data']);
//   }
// }

// enum KeyType { info, password, totp, pinCode }

// // Tách các class phụ trợ ra ngoài
// class _CachedKey {
//   final String key;
//   final DateTime expiresAt;

//   _CachedKey(this.key) : expiresAt = DateTime.now().add(const Duration(minutes: 30));
//   bool get isExpired => DateTime.now().isAfter(expiresAt);
// }

// class _LRUCache<K, V> {
//   final int maxSize;
//   final LinkedHashMap<K, V> _cache = LinkedHashMap<K, V>();

//   _LRUCache({required this.maxSize});

//   V? get(K key) {
//     if (!_cache.containsKey(key)) return null;

//     // Move to end (most recently used)
//     final value = _cache.remove(key);
//     _cache[key] = value as V;
//     return value;
//   }

//   void put(K key, V value) {
//     if (_cache.containsKey(key)) {
//       _cache.remove(key);
//     } else if (_cache.length >= maxSize) {
//       _cache.remove(_cache.keys.first);
//     }
//     _cache[key] = value;
//   }

//   void clear() => _cache.clear();
// }

// class EncryptAppData {
//   static final EncryptAppData instance = EncryptAppData._internal();
//   final _encryptData = EncryptData.instance;

//   // Add helper method for consistent debug printing
//   void _debug(String message) {
//     debugPrint('[EncryptAppData] $message');
//   }

//   static const _deviceKeyStorageKey = 'device_encryption_key';
//   static const _TEST_DATA = 'cybersafe_test_data_value';
//   static const _TEST_DATA_KEY = 'test_encrypted_data';
//   static const _TEST_DATA_BACKUP_KEY = 'test_encrypted_data_backup';

//   // Tối ưu cache cho encryption keys
//   static const Duration KEY_CACHE_DURATION = Duration(minutes: 30);
//   final Map<String, _CachedKey> _keyCache = {};

//   // Cache cho device key
//   String? _cachedDeviceKey;
//   DateTime? _deviceKeyExpiry;

//   // Cache cho kết quả encrypt/decrypt
//   final _lruCache = _LRUCache<String, String>(maxSize: 1000);

//   EncryptAppData._internal();

//   // Key cho SecureStorage
//   static const _infoKeyStorageKey = 'info_encryption_key';
//   static const _passwordKeyStorageKey = 'password_encryption_key';
//   static const _totpKeyStorageKey = 'totp_encryption_key';
//   static const _pinCodeKeyStorageKey = 'pinCode_encryption_key';
//   static const _keyCreationTimeStorageKey = 'encryption_key_creation_time';
//   static const Duration _keyRotationInterval = Duration(minutes: 2); // 3 tháng
//   static const _appVersionStorageKey = 'app_version';

//   // Cache cho các key đã tạo
//   final Map<String, Map<KeyType, String>> _deviceKeyCache = {};

//   // Retry mechanism
//   Future<T> _withRetry<T>(Future<T> Function() operation) async {
//     int attempts = 0;
//     while (attempts < EncryptionConfig.MAX_RETRY_ATTEMPTS) {
//       try {
//         return await operation();
//       } catch (e) {
//         attempts++;
//         _debug('Lần thử $attempts thất bại: $e');
//         if (attempts == EncryptionConfig.MAX_RETRY_ATTEMPTS) rethrow;
//         await Future.delayed(EncryptionConfig.RETRY_DELAY * attempts);
//       }
//     }
//     throw Exception('Đã vượt quá số lần thử lại');
//   }

//   // Validation
//   void _validatePin(String pin) {
//     if (pin.length < EncryptionConfig.MIN_PIN_LENGTH) {
//       throw Exception('PIN phải có ít nhất ${EncryptionConfig.MIN_PIN_LENGTH} ký tự');
//     }
//   }

//   /// Kiểm tra xem có phải là người dùng cũ không
//   Future<bool> isLegacyUser() async {
//     final firstOpen = await SecureStorage.instance.read(key: SecureStorageKeys.themMode.name);
//     return firstOpen != null;
//   }

//   /// Khởi tạo và migration nếu cần
//   Future<void> initialize() async {
//     try {
//       final isLegacy = await isLegacyUser();
//       final hasDeviceKey = await _hasDeviceKey();

//       // Kiểm tra tính nhất quán của key trước khi thực hiện các thao tác

//       if (!isLegacy) {
//         if (!hasDeviceKey) {
//           await generateDeviceKey();
//           // Lưu version mới khi tạo device key mới
//           await _saveCurrentVersion();
//         } else {
//           // Check và update version nếu cần
//           await _checkAndUpdateVersion();
//           await checkAndRotateKeys();
//         }
//         await preloadEncryptionKeys();
//         return;
//       }

//       // Người dùng cũ cần migrate
//       if (!hasDeviceKey) {
//         await _withRetry(() async {
//           await generateDeviceKey();
//           await _migrateData();
//           // Lưu version sau khi migrate
//           await _saveCurrentVersion();
//         });
//         _debug('Migration hoàn tất');
//       }
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi khởi tạo: $e');
//       rethrow;
//     }
//   }

//   /// Migration dữ liệu từ key cũ sang key mới
//   Future<void> _migrateData() async {
//     try {
//       EncryptionLogger.logOperation('migrate_data', details: 'Bắt đầu migration');

//       final accounts = AccountBox.getAll();
//       if (accounts.isEmpty) {
//         _debug('Không có dữ liệu cần migrate');
//         return;
//       }

//       final deviceKey = await getDeviceKey();
//       var migratedCount = 0;
//       var errorCount = 0;
//       final migratedAccounts = <AccountOjbModel>[]; // Danh sách các tài khoản đã migrate thành công

//       // Mã hóa pin code của người dùng cũ
//       String? pinCodeEncrypted = await SecureStorage.instance.read(key: SecureStorageKeys.pinCode.name);
//       final oldPinCode = OldEncryptData.decriptPinCode(pinCodeEncrypted!);
//       final encryptedPinCode = await encryptPinCode(oldPinCode);
      
//       for (var account in accounts) {
//         try {
//           await _withRetry(() async {
//             final decryptedAccount = await _decryptWithLegacyKey(account);
//             final reencryptedAccount = await _encryptWithDeviceKey(decryptedAccount, deviceKey);
//             migratedAccounts.add(reencryptedAccount); // Thêm vào danh sách chờ
//             migratedCount++;
//           });
//         } catch (e, stackTrace) {
//           errorCount++;
//           _debug('WARNING: Lỗi migrate account ${account.id}: $e');
//           break; // Dừng ngay khi có lỗi để tránh lãng phí tài nguyên
//         }
//       }

//       // Chỉ lưu vào database nếu tất cả đều thành công
//       if (errorCount == 0 && migratedCount == accounts.length) {
//         // Lưu pin code mới
//         await SecureStorage.instance.save(key: SecureStorageKeys.pinCode.name, value: encryptedPinCode);
        
//         // Lưu tất cả tài khoản đã migrate vào database
//         AccountBox.putMany(migratedAccounts);
//         _debug('Đã migrate thành công $migratedCount/${accounts.length} accounts');
//       } else {
//         throw Exception('Migration thất bại: $errorCount lỗi, chỉ migrate được $migratedCount/${accounts.length} accounts');
//       }

//       EncryptionLogger.logOperation('migrate_data', details: 'Migration hoàn tất');
//     } catch (e, stackTrace) {
//       EncryptionLogger.logOperation('migrate_data', error: e, stackTrace: stackTrace);
//       rethrow;
//     }
//   }

//   /// Giải mã với key cũ (chỉ dùng trong migration)
//   Future<AccountOjbModel> _decryptWithLegacyKey(AccountOjbModel account) async {
//     return AccountOjbModel(
//       id: account.id,
//       title: OldEncryptData.decryptInfo(account.title),
//       email: account.email != null ? OldEncryptData.decryptInfo(account.email!) : null,
//       password: account.password != null ? OldEncryptData.decryptPassword(account.password!) : null,
//       notes: account.notes != null ? OldEncryptData.decryptInfo(account.notes!) : null,
//       icon: account.icon,
//       categoryOjbModel: account.getCategory,
//       customFieldOjbModel:
//           account.getCustomFields.map((field) {
//             field.value = field.typeField == 'password' ? OldEncryptData.decryptPassword(field.value) : OldEncryptData.decryptInfo(field.value);
//             return field;
//           }).toList(),
//       totpOjbModel:
//           account.getTotp != null
//               ? TOTPOjbModel(
//                 secretKey: OldEncryptData.decryptTOTPKey(account.getTotp!.secretKey),
//                 algorithm: account.getTotp!.algorithm,
//                 digits: account.getTotp!.digits,
//                 period: account.getTotp!.period,
//               )
//               : null,
//       iconCustomModel: account.getIconCustom,
//       createdAt: account.createdAt,
//       updatedAt: account.updatedAt,
//     );
//   }

//   // Tạo backup với PIN
//   Future<Map<String, dynamic>> createBackup(String pin, String backupName, String backupPath) async {
//     _validatePin(pin);

//     try {
//       final deviceKey = await getDeviceKey();
//       final accounts = AccountBox.getAll();

//       final backupData = BackupData(
//         version: AppVersion.latest.version,
//         timestamp: DateTime.now(),
//         backupName: backupName,
//         deviceKey: deviceKey,
//         data: {'accounts': accounts.map((acc) => acc.toJson()).toList()},
//       );

//       final backupJson = jsonEncode(backupData.toJson());

//       // Kiểm tra kích thước
//       final backupSize = utf8.encode(backupJson).length / (1024 * 1024);
//       if (backupSize > EncryptionConfig.MAX_BACKUP_SIZE_MB) {
//         throw Exception(
//           'Kích thước backup (${backupSize.toStringAsFixed(2)}MB) vượt quá giới hạn '
//           '${EncryptionConfig.MAX_BACKUP_SIZE_MB}MB',
//         );
//       }

//       final encryptedData = await _withRetry(() async {
//         return _encryptData.encryptFernet(value: backupJson, key: _generateBackupKey(pin));
//       });

//       final checksum = _calculateChecksum(encryptedData);

//       final backupDataMap = {
//         'type': 'CYBERSAFE_BACKUP',
//         'version': AppVersion.latest.version,
//         'data': encryptedData,
//         'checksum': checksum,
//         'timestamp': DateTime.now().toIso8601String(),
//         'test_data': await SecureStorage.instance.read(key: _TEST_DATA_KEY),
//       };

//       // Validate trước khi trả về
//       BackupValidator.validateBackupData(backupDataMap);
//       return backupDataMap;
//     } catch (e) {
//       _debug('ERROR: Lỗi tạo backup: $e');
//       rethrow;
//     }
//   }

//   // Khôi phục từ backup
//   Future<bool> restoreBackup(String filePath, String pin) async {
//     if (!RateLimiter.instance.canProceed('restore_backup')) {
//       throw Exception('Vui lòng thử lại sau');
//     }

//     try {
//       // Đọc và verify file
//       final file = File(filePath);
//       final backupContent = await file.readAsString();
//       final backupFile = jsonDecode(backupContent);

//       BackupValidator.validateBackupData(backupFile);

//       if (backupFile['type'] != 'CYBERSAFE_BACKUP') {
//         throw Exception('File không hợp lệ');
//       }

//       // Verify checksum
//       if (!_verifyChecksum(backupFile['data'], backupFile['checksum'])) {
//         throw Exception('File backup bị hỏng');
//       }

//       // Kiểm tra version
//       if (!_isVersionCompatible(backupFile['version'])) {
//         throw Exception('Version backup không hỗ trợ');
//       }

//       // Giải mã với PIN
//       final decryptedData = _encryptData.decryptFernet(value: backupFile['data'], key: _generateBackupKey(pin));

//       final backupData = jsonDecode(decryptedData);

//       // Lưu device key mới
//       await SecureStorage.instance.save(key: _deviceKeyStorageKey, value: backupData['deviceKey']);

//       // Khôi phục dữ liệu
//       await _restoreData(backupData['data']);

//       return true;
//     } catch (e) {
//       RateLimiter.instance.resetLimits('restore_backup');
//       _debug('ERROR: Lỗi khôi phục backup: $e');
//       return false;
//     }
//   }

//   String _generateBackupKey(String pin) {
//     final salt = utf8.encode('cybersafe_backup_salt');
//     final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
//     generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(salt), EncryptionConfig.PBKDF2_ITERATIONS, 32));

//     final key = generator.process(Uint8List.fromList(utf8.encode(pin)));
//     return base64.encode(key);
//   }

//   String _calculateChecksum(String data) {
//     return sha256.convert(utf8.encode(data)).toString();
//   }

//   bool _verifyChecksum(String data, String checksum) {
//     return _calculateChecksum(data) == checksum;
//   }

//   Future<void> _restoreData(Map<String, dynamic> data) async {
//     try {
//       // Tạo tên category với timestamp
//       String categoryName = "Backup";

//       // Kiểm tra xem category name đã tồn tại chưa
//       final existingCategories = CategoryBox.getAll();
//       if (existingCategories.any((cat) => cat.categoryName.startsWith(categoryName))) {
//         // Nếu trùng tên, thêm index vào sau
//         int index = 1;
//         while (existingCategories.any((cat) => cat.categoryName == "$categoryName ($index)")) {
//           index++;
//         }
//         categoryName = "$categoryName ($index)";
//       }

//       // Tạo category mới
//       final backupCategory = CategoryOjbModel(categoryName: categoryName, createdAt: DateTime.now(), updatedAt: DateTime.now());
//       final categoryId = CategoryBox.put(backupCategory);
//       final category = await CategoryBox.getByIdAsync(categoryId);
//       _debug('Đã tạo category mới: $categoryName');

//       // Khôi phục accounts và gán vào category mới
//       if (data['accounts'] != null) {
//         final accounts =
//             (data['accounts'] as List).map((e) {
//               final account = AccountOjbModel.fromJson(e);
//               account.category.target = category;
//               return account;
//             }).toList();

//         AccountBox.putMany(accounts);
//         _debug('Đã thêm ${accounts.length} accounts vào category $categoryName');
//       }
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi khôi phục dữ liệu: $e');
//       rethrow;
//     }
//   }

//   /// Mã hóa thông tin chung (title, email, notes...)
//   Future<String> encryptInfo(String value) async {
//     if (value.isEmpty) return value;

//     // Tối ưu: Sử dụng hash của value làm key để giảm kích thước cache
//     final cacheKey = 'encrypt_${sha256.convert(utf8.encode(value)).toString()}';
//     final cached = _lruCache.get(cacheKey);
//     if (cached != null) return cached;

//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.info);

//       // Tối ưu: Sử dụng compute để mã hóa trong isolate
//       final result = await compute(_encryptInIsolate, {'value': value, 'key': encryptionKey});

//       _lruCache.put(cacheKey, result);
//       return result;
//     } catch (e) {
//       _debug('ERROR: Lỗi mã hóa thông tin: $e');
//       return value; // Trả về giá trị gốc thay vì throw exception
//     }
//   }

//   /// Mã hóa mật khẩu
//   Future<String> encryptPassword(String password) async {
//     if (password.isEmpty) return password;
//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.password);
//       return _encryptData.encryptFernet(value: password, key: encryptionKey);
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi mã hóa mật khẩu: $e');
//       rethrow;
//     }
//   }

//   /// Mã hóa TOTP secret key
//   Future<String> encryptTOTPKey(String secretKey) async {
//     if (secretKey.isEmpty) return secretKey;
//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.totp);
//       return _encryptData.encryptFernet(value: secretKey, key: encryptionKey);
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi mã hóa TOTP key: $e');
//       rethrow;
//     }
//   }

//   //Mã hóa pin code
//   Future<String> encryptPinCode(String pinCode) async {
//     if (pinCode.isEmpty) return pinCode;
//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.pinCode);
//       return _encryptData.encryptFernet(value: pinCode, key: encryptionKey);
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi mã hóa pin code: $e');
//       rethrow;
//     }
//   }

//   /// Giải mã thông tin chung
//   Future<String> decryptInfo(String encryptedValue) async {
//     if (encryptedValue.isEmpty) return encryptedValue;

//     // Tối ưu: Sử dụng hash của encryptedValue làm key để giảm kích thước cache
//     final cacheKey = 'decrypt_${sha256.convert(utf8.encode(encryptedValue)).toString()}';
//     final cached = _lruCache.get(cacheKey);
//     if (cached != null) return cached;

//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.info);

//       // Tối ưu: Sử dụng compute để giải mã trong isolate
//       final result = await compute(_decryptInIsolate, {'value': encryptedValue, 'key': encryptionKey});

//       _lruCache.put(cacheKey, result);
//       return result;
//     } catch (e) {
//       _debug('ERROR: Lỗi giải mã thông tin: $e');
//       return encryptedValue; // Trả về giá trị mã hóa thay vì throw exception
//     }
//   }

//   /// Giải mã mật khẩu
//   Future<String> decryptPassword(String encryptedPassword) async {
//     if (encryptedPassword.isEmpty) return encryptedPassword;
//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.password);
//       return _encryptData.decryptFernet(value: encryptedPassword, key: encryptionKey);
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi giải mã mật khẩu: $e');
//       rethrow;
//     }
//   }

//   /// Giải mã TOTP secret key
//   Future<String> decryptTOTPKey(String encryptedKey) async {
//     if (encryptedKey.isEmpty) return encryptedKey;
//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.totp);
//       return _encryptData.decryptFernet(value: encryptedKey, key: encryptionKey);
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi giải mã TOTP key: $e');
//       rethrow;
//     }
//   }

//   // Giải mã pin code
//   Future<String> decryptPinCode(String encryptedPinCode) async {
//     if (encryptedPinCode.isEmpty) return encryptedPinCode;
//     try {
//       final deviceKey = await getDeviceKey();
//       final encryptionKey = await _generateEncryptionKey(deviceKey, KeyType.pinCode);
//       return _encryptData.decryptFernet(value: encryptedPinCode, key: encryptionKey);
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi giải mã pin code: $e');
//       rethrow;
//     }
//   }

//   // Tạo và lưu device key mới
//   Future<void> generateDeviceKey() async {
//     if (await _hasDeviceKey()) {
//       throw Exception('Device key đã tồn tại');
//     }

//     // Clear keys cũ trước
//     await clearEncryptionKeys();

//     // Tạo random key 32 bytes (256 bits)
//     final key = Uint8List.fromList(
//       List.generate(32, (_) => Random.secure().nextInt(256))
//     );
//     final deviceKey = base64.encode(key);

//     // Lưu device key mới
//     await SecureStorage.instance.save(key: _deviceKeyStorageKey, value: deviceKey);
//   }

//   // Kiểm tra device key đã tồn tại chưa
//   Future<bool> _hasDeviceKey() async {
//     final key = await SecureStorage.instance.read(key: _deviceKeyStorageKey);
//     return key != null;
//   }

//   // Lấy device key
//   Future<String> getDeviceKey() async {
//     if (_cachedDeviceKey != null && _deviceKeyExpiry != null && DateTime.now().isBefore(_deviceKeyExpiry!)) {
//       _debug('Using cached device key');
//       return _cachedDeviceKey!;
//     }

//     // Kiểm tra tính nhất quán của key trước khi lấy

//     final key = await SecureStorage.instance.read(key: _deviceKeyStorageKey);
//     if (key == null) {
//       _debug('ERROR: Failed to retrieve device key from secure storage');
//       throw Exception('Chưa tạo device key');
//     }

//     _cachedDeviceKey = key;
//     _deviceKeyExpiry = DateTime.now().add(KEY_CACHE_DURATION);
//     return key;
//   }

//   // Mã hóa dữ liệu với device key mới
//   Future<AccountOjbModel> _encryptWithDeviceKey(AccountOjbModel account, String deviceKey) async {
//     return AccountOjbModel(
//       id: account.id,
//       title: await _encryptData.encryptFernet(value: account.title, key: await _generateEncryptionKey(deviceKey, KeyType.info)),
//       email: account.email != null ? await _encryptData.encryptFernet(value: account.email!, key: await _generateEncryptionKey(deviceKey, KeyType.info)) : null,
//       password: account.password != null ? await _encryptData.encryptFernet(value: account.password!, key: await _generateEncryptionKey(deviceKey, KeyType.password)) : null,
//       notes: account.notes != null ? await _encryptData.encryptFernet(value: account.notes!, key: await _generateEncryptionKey(deviceKey, KeyType.info)) : null,
//       icon: account.icon,
//       categoryOjbModel: account.getCategory,
//       customFieldOjbModel:
//           account.getCustomFields.isNotEmpty
//               ? await Future.wait(
//                 account.getCustomFields.map((field) async {
//                   field.value =
//                       field.typeField == 'password'
//                           ? await _encryptData.encryptFernet(value: field.value, key: await _generateEncryptionKey(deviceKey, KeyType.password))
//                           : await _encryptData.encryptFernet(value: field.value, key: await _generateEncryptionKey(deviceKey, KeyType.info));
//                   return field;
//                 }),
//               )
//               : null,
//       totpOjbModel:
//           account.getTotp != null
//               ? TOTPOjbModel(
//                 secretKey: await _encryptData.encryptFernet(value: account.getTotp!.secretKey, key: await _generateEncryptionKey(deviceKey, KeyType.totp)),
//                 algorithm: account.getTotp!.algorithm,
//                 digits: account.getTotp!.digits,
//                 period: account.getTotp!.period,
//               )
//               : null,
//       iconCustomModel: account.getIconCustom,
//       createdAt: account.createdAt,
//       updatedAt: DateTime.now(),
//     );
//   }

//   String _getStorageKeyForType(KeyType type) {
//     return switch (type) {
//       KeyType.info => _infoKeyStorageKey,
//       KeyType.password => _passwordKeyStorageKey,
//       KeyType.totp => _totpKeyStorageKey,
//       KeyType.pinCode => _pinCodeKeyStorageKey,
//     };
//   }

//   // Tối ưu generate encryption key
//   Future<String> _generateEncryptionKey(String deviceKey, KeyType type) async {
//     final cacheKey = '${type.name}_$deviceKey';

//     // Check memory cache - Ưu tiên cao nhất
//     final cachedKey = _keyCache[cacheKey];
//     if (cachedKey != null && !cachedKey.isExpired) {
//       return cachedKey.key;
//     }

//     // Check device key cache - Ưu tiên thứ hai
//     if (_deviceKeyCache.containsKey(deviceKey) && _deviceKeyCache[deviceKey]!.containsKey(type)) {
//       final key = _deviceKeyCache[deviceKey]![type]!;
//       _keyCache[cacheKey] = _CachedKey(key);
//       return key;
//     }

//     // Check SecureStorage - Ưu tiên thứ ba
//     final storageKey = _getStorageKeyForType(type);
//     final savedKey = await SecureStorage.instance.read(key: storageKey);
//     if (savedKey != null) {
//       _keyCache[cacheKey] = _CachedKey(savedKey);

//       // Lưu vào device key cache
//       _deviceKeyCache.putIfAbsent(deviceKey, () => {});
//       _deviceKeyCache[deviceKey]![type] = savedKey;

//       return savedKey;
//     }

//     // Tối ưu: Sử dụng salt cố định để tránh tính toán lại
//     final salt = _generateSalt(type, deviceKey);

//     // Tối ưu: Sử dụng compute để tạo key trong isolate
//     final key = await compute(_generateKeyInIsolate, {'salt': salt, 'deviceKey': deviceKey, 'iterations': EncryptionConfig.PBKDF2_ITERATIONS, 'keySize': EncryptionConfig.KEY_SIZE_BYTES});

//     // Cache key mới
//     _keyCache[cacheKey] = _CachedKey(key);

//     // Lưu vào device key cache
//     _deviceKeyCache.putIfAbsent(deviceKey, () => {});
//     _deviceKeyCache[deviceKey]![type] = key;

//     // Lưu vào SecureStorage
//     await SecureStorage.instance.save(key: storageKey, value: key);

//     return key;
//   }

//   // Generate key trong isolate
//   static String _generateKeyInIsolate(Map<String, dynamic> params) {
//     final generator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
//     generator.init(pc.Pbkdf2Parameters(Uint8List.fromList(utf8.encode(params['salt'])), params['iterations'], params['keySize']));

//     final key = generator.process(Uint8List.fromList(utf8.encode(params['deviceKey'])));
//     return base64.encode(key);
//   }

//   // Tối ưu encrypt info
//   static Future<String> _encryptInIsolate(Map<String, String> params) async {
//     return await EncryptData.instance.encryptFernet(value: params['value']!, key: params['key']!);
//   }

//   // Tối ưu decrypt info
//   static String _decryptInIsolate(Map<String, String> params) {
//     return EncryptData.instance.decryptFernet(value: params['value']!, key: params['key']!);
//   }

//   // Tối ưu memory management
//   Future<void> clearSensitiveData() async {
//     _keyCache.clear();
//     _lruCache.clear();
//     _deviceKeyCache.clear();
//     _cachedDeviceKey = null;
//     _deviceKeyExpiry = null;
//     _decryptedFieldsCache.clear();

//     // Xóa cache trong EncryptData
//     _encryptData.clearCache();

//     // Force GC
//     await Future.delayed(Duration.zero);
//   }

//   // Auto clear cache định kỳ
//   Timer? _cleanupTimer;

//   void startAutoClearCache() {
//     _cleanupTimer?.cancel();
//     _cleanupTimer = Timer.periodic(Duration(hours: 1), (_) {
//       final now = DateTime.now();

//       // Clear expired keys
//       _keyCache.removeWhere((_, value) => value.isExpired);

//       // Clear device key if expired
//       if (_deviceKeyExpiry != null && now.isAfter(_deviceKeyExpiry!)) {
//         _cachedDeviceKey = null;
//         _deviceKeyExpiry = null;
//       }
//     });
//   }

//   void dispose() {
//     _cleanupTimer?.cancel();
//     clearSensitiveData();
//   }

//   // Kiểm tra và rotate key nếu cần
//   Future<void> checkAndRotateKeys() async {
//     try {
//       final keyCreationTime = await SecureStorage.instance.read(key: _keyCreationTimeStorageKey);

//       if (keyCreationTime == null || _shouldRotateKeys(keyCreationTime)) {
//         // Sử dụng enhanced rotation với verification
//         await forceKeyRotation();
//       }
//     } catch (e) {
//       _debug('ERROR: Lỗi rotation keys: $e');
//       rethrow;
//     }
//   }

//   // Kiểm tra xem có nên rotate key không
//   bool _shouldRotateKeys(String creationTimeStr) {
//     final creationTime = DateTime.parse(creationTimeStr);
//     return DateTime.now().difference(creationTime) > _keyRotationInterval;
//   }

//   // Thực hiện rotate keys
//   bool _isRotating = false; // Thêm flag

//   Future<void> rotateKeys() async {
//     if (_isRotating) return;
//     _isRotating = true;
    
//     try {
//       // 1. Backup current keys and data
//       final oldKeys = await _backupCurrentKeys();
//       final oldDeviceKey = await getDeviceKey();
      
//       // 2. Generate new device key
//       final newDeviceKey = await _generateNewDeviceKey();
      
//       // 3. Save new device key AFTER verification
//       final success = await _verifyAndSaveNewKey(newDeviceKey);
      
//       if (success) {
//         // 4. Re-encrypt data with new key
//         await _reencryptData(newDeviceKey);
        
//         // 5. Clear old keys only after successful re-encryption
//         await _clearOldKeys(oldKeys);
        
//         // 6. Update key creation time
//         await SecureStorage.instance.save(
//           key: _keyCreationTimeStorageKey,
//           value: DateTime.now().toIso8601String()
//         );
        
//         _debug('Key rotation completed successfully');
//       } else {
//         // Rollback if verification fails
//         await _restoreOldKey(oldDeviceKey);
//         throw Exception('Key verification failed');
//       }
//     } catch (e) {
//       _debug('Key rotation failed: $e');
//       rethrow;
//     } finally {
//       _isRotating = false;
//     }
//   }

//   Future<bool> _verifyAndSaveNewKey(String newKey) async {
//     try {
//       // Test encryption/decryption with new key
//       final testData = 'test_data_${DateTime.now().millisecondsSinceEpoch}';
//       final encrypted = await _encryptData.encryptFernet(
//         value: testData,
//         key: newKey
//       );
//       final decrypted = _encryptData.decryptFernet(
//         value: encrypted,
//         key: newKey
//       );
      
//       if (testData != decrypted) {
//         return false;
//       }

//       // Save new key only after verification
//       await SecureStorage.instance.save(
//         key: _deviceKeyStorageKey,
//         value: newKey
//       );
      
//       return true;
//     } catch (e) {
//       _debug('Key verification failed: $e');
//       return false;
//     }
//   }

//   Future<Map<String, String>> _backupCurrentKeys() async {
//     return {
//       _infoKeyStorageKey: await SecureStorage.instance.read(key: _infoKeyStorageKey) ?? '',
//       _passwordKeyStorageKey: await SecureStorage.instance.read(key: _passwordKeyStorageKey) ?? '',
//       _totpKeyStorageKey: await SecureStorage.instance.read(key: _totpKeyStorageKey) ?? '',
//       _pinCodeKeyStorageKey: await SecureStorage.instance.read(key: _pinCodeKeyStorageKey) ?? '',
//     };
//   }

//   Future<bool> _reencryptData(String newDeviceKey) async {
//     final accounts = AccountBox.getAll();
//     final reencryptedAccounts = <AccountOjbModel>[];

//     try {
//       for (var account in accounts) {
//         final reencrypted = await _encryptWithDeviceKey(account, newDeviceKey);
//         // Verify re-encryption
//         final verified = await _verifyEncryption(reencrypted, newDeviceKey);
//         if (!verified) return false;
//         reencryptedAccounts.add(reencrypted);
//       }

//       if (reencryptedAccounts.length == accounts.length) {
//         AccountBox.putMany(reencryptedAccounts);
//         return true;
//       }
//       return false;
//     } catch (e) {
//       _debug('Reencryption failed: $e');
//       return false;
//     }
//   }

//   Future<void> _clearOldKeys(Map<String, String> oldKeys) async {
//     // Clear caches first
//     _keyCache.clear();
//     _lruCache.clear();
//     _deviceKeyCache.clear();

//     // Then remove old keys from storage
//     for (var key in oldKeys.keys) {
//       await SecureStorage.instance.delete(key: key);
//     }
//   }

//   // Tạo device key mới
//   Future<String> _generateNewDeviceKey() async {
//     final key = Uint8List.fromList(List.generate(32, (_) => Random.secure().nextInt(256)));
//     return base64.encode(key);
//   }

//   // Thêm phương thức giải mã account
//   Future<AccountOjbModel> _decryptAccount(AccountOjbModel account) async {
//     // Giải mã song song các trường cơ bản
//     final futures = await Future.wait([
//       decryptInfo(account.title),
//       account.email != null ? decryptInfo(account.email!) : Future.value(null),
//       account.password != null ? decryptPassword(account.password!) : Future.value(null),
//       account.notes != null ? decryptInfo(account.notes!) : Future.value(null),
//     ]);

//     // Giải mã TOTP nếu có
//     TOTPOjbModel? decryptedTotp;
//     if (account.getTotp != null) {
//       final decryptedSecretKey = await decryptTOTPKey(account.getTotp!.secretKey);
//       decryptedTotp = TOTPOjbModel(secretKey: decryptedSecretKey, algorithm: account.getTotp!.algorithm, digits: account.getTotp!.digits, period: account.getTotp!.period);
//     }

//     // Giải mã custom fields nếu có
//     List<AccountCustomFieldOjbModel>? decryptedCustomFields;
//     if (account.getCustomFields.isNotEmpty) {
//       // Giải mã song song các custom fields
//       decryptedCustomFields = await Future.wait(
//         account.getCustomFields.map((field) async {
//           field.value = field.typeField == 'password' ? await decryptPassword(field.value) : await decryptInfo(field.value);
//           return field;
//         }),
//       ).then((list) => list.cast<AccountCustomFieldOjbModel>());
//     }

//     // Tạo account mới với dữ liệu đã giải mã
//     return AccountOjbModel(
//       id: account.id,
//       title: futures[0] as String,
//       email: futures[1],
//       password: futures[2],
//       notes: futures[3],
//       icon: account.icon,
//       categoryOjbModel: account.getCategory,
//       customFieldOjbModel: decryptedCustomFields,
//       totpOjbModel: decryptedTotp,
//       iconCustomModel: account.getIconCustom,
//       createdAt: account.createdAt,
//       updatedAt: account.updatedAt,
//     );
//   }

//   // Lưu version hiện tại
//   Future<void> _saveCurrentVersion() async {
//     await SecureStorage.instance.save(key: _appVersionStorageKey, value: AppVersion.latest.version);
//     _debug('Đã lưu version ${AppVersion.latest.version}');
//   }

//   // Kiểm tra và cập nhật version
//   Future<void> _checkAndUpdateVersion() async {
//     final savedVersion = await SecureStorage.instance.read(key: _appVersionStorageKey);

//     if (savedVersion != AppVersion.latest.version) {
//       _debug('Cập nhật version từ $savedVersion lên ${AppVersion.latest.version}');
//       await _saveCurrentVersion();
//     }
//   }

//   // Lấy version hiện tại
//   Future<String?> getCurrentVersion() async {
//     return SecureStorage.instance.read(key: _appVersionStorageKey);
//   }

//   bool _isVersionCompatible(String version) {
//     // Kiểm tra version backup có phải là version mới nhất không
//     return version == AppVersion.latest.version;

//     // Sau này nếu cần check nhiều version có thể mở rộng như sau:
//     // final supportedVersions = AppVersion.values.map((v) => v.version).toList();
//     // return supportedVersions.contains(version);
//   }

//   /// Xóa tất cả các encryption keys khỏi SecureStorage
//   Future<void> clearEncryptionKeys() async {
//     try {
//       // Xóa tất cả các loại key
//       await Future.wait([
//         SecureStorage.instance.delete(key: _infoKeyStorageKey),
//         SecureStorage.instance.delete(key: _passwordKeyStorageKey),
//         SecureStorage.instance.delete(key: _totpKeyStorageKey),
//         SecureStorage.instance.delete(key: _pinCodeKeyStorageKey),
//       ]);

//       // Clear cache
//       _keyCache.clear();
//       _lruCache.clear();

//       _debug('Đã xóa tất cả encryption keys');
//     } catch (e, stackTrace) {
//       _debug('ERROR: Lỗi khi xóa encryption keys: $e');
//       rethrow;
//     }
//   }

//   /// Tạo salt cho từng loại key
//   String _generateSalt(KeyType type, String deviceKey) {
//     // Sử dụng một salt cố định cho mỗi loại key và device key
//     // để tránh phải tính toán lại mỗi lần
//     return 'cybersafe_${type.name}_salt_$deviceKey';
//   }

//   Future<List<AccountOjbModel>> decryptAccountsBatch(List<AccountOjbModel> accounts) async {
//     // Chia thành các nhóm nhỏ để xử lý song song
//     const int batchSize = 5;
//     final List<List<AccountOjbModel>> batches = [];

//     for (int i = 0; i < accounts.length; i += batchSize) {
//       final end = (i + batchSize < accounts.length) ? i + batchSize : accounts.length;
//       batches.add(accounts.sublist(i, end));
//     }

//     // Xử lý song song các nhóm
//     final results = await Future.wait(batches.map((batch) => Future.wait(batch.map((account) => _decryptAccount(account)))));

//     // Gộp kết quả
//     return results.expand((batch) => batch).toList();
//   }

//   final Map<int, Map<String, String>> _decryptedFieldsCache = {};

//   Future<String> getDecryptedField(int accountId, String field, String encryptedValue, KeyType type) async {
//     if (encryptedValue.isEmpty) return encryptedValue;

//     // Kiểm tra cache
//     if (_decryptedFieldsCache.containsKey(accountId) && _decryptedFieldsCache[accountId]!.containsKey(field)) {
//       return _decryptedFieldsCache[accountId]![field]!;
//     }

//     // Giải mã
//     String decrypted;
//     switch (type) {
//       case KeyType.info:
//         decrypted = await decryptInfo(encryptedValue);
//         break;
//       case KeyType.password:
//         decrypted = await decryptPassword(encryptedValue);
//         break;
//       case KeyType.totp:
//         decrypted = await decryptTOTPKey(encryptedValue);
//         break;
//       case KeyType.pinCode:
//         decrypted = await decryptPinCode(encryptedValue);
//         break;
//     }

//     // Lưu vào cache
//     _decryptedFieldsCache.putIfAbsent(accountId, () => {});
//     _decryptedFieldsCache[accountId]![field] = decrypted;

//     return decrypted;
//   }

//   // Phương thức tiện ích để lấy các trường phổ biến
//   Future<String> getDecryptedTitle(AccountOjbModel account) async {
//     return getDecryptedField(account.id, 'title', account.title, KeyType.info);
//   }

//   Future<String?> getDecryptedEmail(AccountOjbModel account) async {
//     if (account.email == null) return null;
//     return getDecryptedField(account.id, 'email', account.email!, KeyType.info);
//   }

//   Future<String?> getDecryptedPassword(AccountOjbModel account) async {
//     if (account.password == null) return null;
//     return getDecryptedField(account.id, 'password', account.password!, KeyType.password);
//   }

//   // Xóa cache khi cần
//   void clearAccountCache(int accountId) {
//     _decryptedFieldsCache.remove(accountId);
//   }

//   void clearAllAccountCache() {
//     _decryptedFieldsCache.clear();
//   }

//   Future<void> preloadEncryptionKeys() async {
//     try {
//       final deviceKey = await getDeviceKey();

//       // Tải trước tất cả các loại key song song
//       await Future.wait([
//         _generateEncryptionKey(deviceKey, KeyType.info),
//         _generateEncryptionKey(deviceKey, KeyType.password),
//         _generateEncryptionKey(deviceKey, KeyType.totp),
//         _generateEncryptionKey(deviceKey, KeyType.pinCode),
//       ]);

//       _debug('Đã tải trước tất cả encryption keys');
//     } catch (e) {
//       _debug('WARNING: Không thể tải trước encryption keys: $e');
//     }
//   }

//   Future<List<AccountOjbModel>> decryptBasicInfoBatch(List<AccountOjbModel> accounts) async {
//     // Tối ưu: Xử lý song song các tài khoản
//     final results = await Future.wait(
//       accounts.map((account) async {
//         // Tạo một bản sao của account
//         final decryptedAccount = AccountOjbModel.fromModel(account);

//         // Chỉ giải mã title và email
//         final decryptedTitle = await decryptInfo(account.title);
//         decryptedAccount.title = decryptedTitle;

//         if (account.email != null) {
//           final decryptedEmail = await decryptInfo(account.email!);
//           decryptedAccount.email = decryptedEmail;
//         }

//         return decryptedAccount;
//       }),
//     );

//     return results;
//   }

//   // Centralized cache management
//   final _cacheManager = _EncryptionCacheManager();
  


//   Future<List<AccountOjbModel>> encryptAccountsBatch(List<AccountOjbModel> accounts) async {
//     const batchSize = 5;
//     return await _processBatch(
//       accounts,
//       batchSize,
//       (account) => _encryptAccount(account)
//     );
//   }

//   Future<List<T>> _processBatch<T>(
//     List<T> items,
//     int batchSize,
//     Future<T> Function(T item) processor
//   ) async {
//     final batches = <List<T>>[];
//     for (var i = 0; i < items.length; i += batchSize) {
//       batches.add(items.sublist(
//         i,
//         i + batchSize > items.length ? items.length : i + batchSize
//       ));
//     }
    
//     final results = await Future.wait(
//       batches.map((batch) => Future.wait(
//         batch.map((item) => processor(item))
//       ))
//     );
    
//     return results.expand((batch) => batch).toList();
//   }

//   /// Verify encryption cho account sau khi re-encrypt
//   Future<bool> _verifyEncryption(AccountOjbModel encryptedAccount, String deviceKey) async {
//     try {
//       // Giải mã thử title để verify
//       final decryptedTitle = await decryptInfo(encryptedAccount.title);
//       if (decryptedTitle.isEmpty) return false;

//       // Verify password nếu có
//       if (encryptedAccount.password != null) {
//         final decryptedPassword = await decryptPassword(encryptedAccount.password!);
//         if (decryptedPassword.isEmpty) return false;
//       }

//       // Verify TOTP nếu có 
//       if (encryptedAccount.getTotp != null) {
//         final decryptedTotp = await decryptTOTPKey(encryptedAccount.getTotp!.secretKey);
//         if (decryptedTotp.isEmpty) return false;
//       }

//       // Test thêm với dữ liệu mới
//       final testData = 'test_${DateTime.now().millisecondsSinceEpoch}';
//       final encrypted = await _encryptData.encryptFernet(
//         value: testData,
//         key: deviceKey
//       );
//       final decrypted = _encryptData.decryptFernet(
//         value: encrypted, 
//         key: deviceKey
//       );

//       return testData == decrypted;
//     } catch (e) {
//       _debug('Verification failed: $e');
//       return false;
//     }
//   }

//   /// Khôi phục key cũ khi rotation thất bại
//   Future<void> _restoreOldKey(String oldDeviceKey) async {
//     try {
//       // Khôi phục device key cũ
//       await SecureStorage.instance.save(
//         key: _deviceKeyStorageKey,
//         value: oldDeviceKey
//       );

//       // Clear các cache để buộc generate lại
//       _keyCache.clear();
//       _lruCache.clear();
//       _deviceKeyCache.clear();
//       _cachedDeviceKey = null;
//       _deviceKeyExpiry = null;

//       // Verify key cũ hoạt động tốt
//       final testData = 'restore_test_${DateTime.now().millisecondsSinceEpoch}';
//       final encrypted = await _encryptData.encryptFernet(
//         value: testData,
//         key: oldDeviceKey
//       );
//       final decrypted = _encryptData.decryptFernet(
//         value: encrypted,
//         key: oldDeviceKey  
//       );

//       if (testData != decrypted) {
//         throw Exception('Old key verification failed');
//       }

//       _debug('Successfully restored old key');
//     } catch (e) {
//       _debug('Failed to restore old key: $e');
//       rethrow;
//     }
//   }

//   Future<AccountOjbModel> _encryptAccount(AccountOjbModel account) async {
//     try {
//       // Lấy device key hiện tại
//       final deviceKey = await getDeviceKey();
      
//       // Mã hóa song song các trường cơ bản
//       final futures = await Future.wait([
//         encryptInfo(account.title),
//         account.email != null ? encryptInfo(account.email!) : Future.value(null),
//         account.password != null ? encryptPassword(account.password!) : Future.value(null),
//         account.notes != null ? encryptInfo(account.notes!) : Future.value(null),
//       ]);

//       // Mã hóa TOTP nếu có
//       TOTPOjbModel? encryptedTotp;
//       if (account.getTotp != null) {
//         final encryptedSecretKey = await encryptTOTPKey(account.getTotp!.secretKey);
//         encryptedTotp = TOTPOjbModel(
//           secretKey: encryptedSecretKey,
//           algorithm: account.getTotp!.algorithm,
//           digits: account.getTotp!.digits,
//           period: account.getTotp!.period,
//         );
//       }

//       // Mã hóa custom fields nếu có
//       List<AccountCustomFieldOjbModel>? encryptedCustomFields;
//       if (account.getCustomFields.isNotEmpty) {
//         // Mã hóa song song các custom fields
//         encryptedCustomFields = await Future.wait(
//           account.getCustomFields.map((field) async {
//             field.value = field.typeField == 'password' 
//               ? await encryptPassword(field.value) 
//               : await encryptInfo(field.value);
//             return field;
//           }),
//         ).then((list) => list.cast<AccountCustomFieldOjbModel>());
//       }

//       // Tạo account mới với dữ liệu đã mã hóa
//       final encryptedAccount = AccountOjbModel(
//         id: account.id,
//         title: futures[0] as String,
//         email: futures[1],
//         password: futures[2],
//         notes: futures[3],
//         icon: account.icon,
//         categoryOjbModel: account.getCategory,
//         customFieldOjbModel: encryptedCustomFields,
//         totpOjbModel: encryptedTotp,
//         iconCustomModel: account.getIconCustom,
//         createdAt: account.createdAt,
//         updatedAt: DateTime.now(),
//       );

//       // Verify mã hóa
//       final verified = await _verifyEncryption(encryptedAccount, deviceKey);
//       if (!verified) {
//         throw Exception('Encryption verification failed');
//       }

//       return encryptedAccount;
//     } catch (e) {
//       _debug('ERROR: Encryption failed for account ${account.id}: $e');
//       rethrow;
//     }
//   }
// }

// class _EncryptionCacheManager {
//   final Map<String, _CachedKey> keyCache = {};
//   final _lruCache = _LRUCache<String, String>(maxSize: 1000);
//   final Map<String, Map<KeyType, String>> deviceKeyCache = {};
//   final Map<int, Map<String, String>> decryptedFieldsCache = {};

//   Future<void> clearAll() async {
//     keyCache.clear();
//     _lruCache.clear();
//     deviceKeyCache.clear();
//     decryptedFieldsCache.clear();
//   }
  
//   void clearForAccount(int accountId) {
//     decryptedFieldsCache.remove(accountId);
//   }
// }

// class BackupValidator {
//   static void validateBackupData(Map<String, dynamic> data) {
//     if (data['type'] != 'CYBERSAFE_BACKUP') {
//       throw Exception('File không phải backup hợp lệ');
//     }

//     // Kiểm tra cấu trúc
//     final requiredFields = ['version', 'data', 'checksum', 'timestamp'];
//     for (var field in requiredFields) {
//       if (!data.containsKey(field)) {
//         throw Exception('Thiếu trường $field trong file backup');
//       }
//     }

//     // Kiểm tra kích thước
//     final backupSize = utf8.encode(data['data']).length / (1024 * 1024);
//     if (backupSize > EncryptionConfig.MAX_BACKUP_SIZE_MB) {
//       throw Exception('Kích thước backup quá lớn');
//     }
//   }
// }

// class ErrorRecovery {
//   static Future<T?> handleEncryptionError<T>(EncryptAppData instance, Future<T> Function() operation, {bool shouldResetKeys = false, bool shouldRetry = true, int maxRetries = 3}) async {
//     int attempts = 0;

//     while (attempts < maxRetries) {
//       try {
//         return await operation();
//       } catch (e, stackTrace) {
//         attempts++;
//         instance._debug('WARNING: Lần thử $attempts thất bại: $e');

//         if (shouldResetKeys) {
//           await instance.clearEncryptionKeys();
//           await instance.generateDeviceKey();
//         }

//         if (!shouldRetry || attempts >= maxRetries) {
//           rethrow;
//         }

//         await Future.delayed(Duration(seconds: attempts));
//       }
//     }
//     return null;
//   }
// }

// class EncryptionMetrics {
//   static final EncryptionMetrics _instance = EncryptionMetrics._internal();
//   static EncryptionMetrics get instance => _instance;

//   final Map<String, int> _operationCounts = {};
//   final Map<String, List<Duration>> _operationTimes = {};

//   EncryptionMetrics._internal();

//   void recordOperation(String operation, Duration duration) {
//     _operationCounts[operation] = (_operationCounts[operation] ?? 0) + 1;
//     _operationTimes.putIfAbsent(operation, () => []).add(duration);
//   }

//   Map<String, dynamic> getMetrics() {
//     final averageTimes = <String, Duration>{};
//     _operationTimes.forEach((key, times) {
//       final average = times.fold<Duration>(Duration.zero, (prev, curr) => Duration(microseconds: prev.inMicroseconds + curr.inMicroseconds)).inMicroseconds ~/ times.length;
//       averageTimes[key] = Duration(microseconds: average);
//     });

//     return {'counts': Map<String, int>.from(_operationCounts), 'averageTimes': averageTimes, 'totalOperations': _operationCounts.values.fold(0, (a, b) => a + b)};
//   }

//   void reset() {
//     _operationCounts.clear();
//     _operationTimes.clear();
//   }
// }

// extension MemoryManagement on EncryptAppData {
//   Future<void> clearSensitiveData() async {
//     _keyCache.clear();
//     _lruCache.clear();
//     _deviceKeyCache.clear();
//     _cachedDeviceKey = null;
//     _deviceKeyExpiry = null;
//     _decryptedFieldsCache.clear();

//     // Xóa cache trong EncryptData
//     _encryptData.clearCache();

//     // Force GC
//     await Future.delayed(Duration.zero);
//   }
// }

// class EncryptionLogger {
//   static void logOperation(String operation, {String? details, Object? error, StackTrace? stackTrace}) {
//     final timestamp = DateTime.now().toIso8601String();

//     if (error != null) {
//       debugPrint('[$timestamp][$operation] ERROR: $details');
//       return;
//     }

//     debugPrint('[$timestamp][$operation] $details');
//   }
// }

// class RateLimiter {
//   static final RateLimiter _instance = RateLimiter._internal();
//   static RateLimiter get instance => _instance;

//   final Map<String, DateTime> _lastOperationTime = {};
//   final Map<String, int> _attemptCounts = {};

//   static const _minInterval = Duration(seconds: 1);
//   static const _maxAttempts = 5;
//   static const _lockoutDuration = Duration(minutes: 5);

//   RateLimiter._internal();

//   bool canProceed(String operation) {
//     final now = DateTime.now();
//     final lastTime = _lastOperationTime[operation];
//     final attempts = _attemptCounts[operation] ?? 0;

//     // Check if in lockout
//     if (attempts >= _maxAttempts) {
//       if (lastTime != null && now.difference(lastTime) < _lockoutDuration) {
//         return false;
//       }
//       // Reset after lockout period
//       _attemptCounts[operation] = 0;
//     }

//     if (lastTime == null || now.difference(lastTime) > _minInterval) {
//       _lastOperationTime[operation] = now;
//       return true;
//     }

//     // Increment attempt count
//     _attemptCounts[operation] = attempts + 1;
//     return false;
//   }

//   void resetLimits(String operation) {
//     _lastOperationTime.remove(operation);
//     _attemptCounts.remove(operation);
//   }
// }

// extension EnhancedKeyRotation on EncryptAppData {
//   Future<void> forceKeyRotation() async {
//     await rotateKeys();
//     await _saveCurrentVersion();

//     // Backup old keys correctly
//     final oldKeys = Map<String, _CachedKey>.from(_keyCache);

//     try {
//       // Verify all data can be decrypted with new keys
//       final accounts = AccountBox.getAll();
//       // Chỉ kiểm tra một số lượng nhỏ tài khoản để tăng tốc
//       final samplesToCheck = accounts.length > 10 ? accounts.sublist(0, 10) : accounts;

//       for (var account in samplesToCheck) {
//         await _decryptAccount(account);
//       }
//     } catch (e) {
//       // Rollback if verification fails
//       _keyCache.clear();
//       _keyCache.addAll(oldKeys);
//       rethrow;
//     }
//   }
// }
