import 'dart:convert';

import 'package:cybersafe_pro/secure/encrypt/encrypt_v1/encrypt_v1.dart';
import 'package:cybersafe_pro/secure/encrypt/encrypt_v2/encrypt_v2.dart';
import 'package:cybersafe_pro/secure/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';

class DataSecureService {
  static Future<String> encryptInfo(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      final key = await KeyManager.getKey(KeyType.info);
      return EncryptV1.encrypt(value: value, key: key);
    } catch (e) {
      throw Exception('Failed to encrypt info: $e');
    }
  }

  static Future<String> decryptInfo(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      final key = await KeyManager.getKey(KeyType.info);
      return EncryptV1.decrypt(encryptedData: value, key: key);
    } catch (e) {
      throw Exception('Failed to decrypt info: $e');
    }
  }

  static Future<String> encryptNote(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      final key = await KeyManager.getKey(KeyType.note);
      return EncryptV1.encrypt(value: value, key: key);
    } catch (e) {
      throw Exception('Failed to encrypt note: $e');
    }
  }

  static Future<String> decryptNote(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      final key = await KeyManager.getKey(KeyType.note);
      return EncryptV1.decrypt(encryptedData: value, key: key);
    } catch (e) {
      throw Exception('Failed to decrypt note: $e');
    }
  }

  static Future<String> encryptPassword(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      return await EncryptV2.encrypt(plainText: value, keyType: KeyType.password);
    } catch (e) {
      throw Exception('Failed to encrypt password: $e');
    }
  }

  static Future<String> decryptPassword(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      return await EncryptV2.decrypt(value: value, keyType: KeyType.password);
    } catch (e) {
      throw Exception('Failed to decrypt password: $e');
    }
  }

  static Future<String> encryptTOTPKey(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      return await EncryptV2.encrypt(plainText: value, keyType: KeyType.totp);
    } catch (e) {
      throw Exception('Failed to encrypt TOTP key: $e');
    }
  }

  static Future<String> decryptTOTPKey(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      return await EncryptV2.decrypt(value: value, keyType: KeyType.totp);
    } catch (e) {
      throw Exception('Failed to decrypt TOTP key: $e');
    }
  }

  static Future<String> encryptPinCode(String value) async {
    if (value.isEmpty) return "";
    if (isValueEncrypted(value)) return value;
    try {
      return await EncryptV2.encrypt(plainText: value, keyType: KeyType.pinCode);
    } catch (e) {
      throw Exception('Failed to encrypt PIN code: $e');
    }
  }

  static Future<String> decryptPinCode(String value) async {
    if (value.isEmpty) return "";
    if (!isValueEncrypted(value)) return "";
    try {
      return await EncryptV2.decrypt(value: value, keyType: KeyType.pinCode);
    } catch (e) {
      logError('Failed to decrypt PIN code: $e', functionName: 'DataSecureService.decryptPinCode');
      return "";
    }
  }

  static bool isValueEncrypted(String value) {
    if (value.isEmpty) return false;

    try {
      final package = json.decode(value) as Map<String, dynamic>;

      final hasRequiredFields =
          package.containsKey('salt') &&
          package.containsKey('iv') &&
          package.containsKey('data') &&
          package.containsKey('version');
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

  static Future<void> preWarmKeys() async {
    try {
      await Future.wait([
        KeyManager.getKey(KeyType.info),
        KeyManager.getKey(KeyType.password),
        KeyManager.getKey(KeyType.totp),
        KeyManager.getKey(KeyType.note),
        KeyManager.getKey(KeyType.pinCode),
        KeyManager.getKey(KeyType.database),
      ]);
    } catch (e) {
      throw Exception('Failed to pre-warm keys: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> batchEncryptAccountsData(
    List<Map<String, dynamic>> accountsData,
  ) async {
    if (accountsData.isEmpty) return [];

    try {
      // Không sử dụng compute() vì SecureArgon2 cần KeyManager trong main isolate
      // Thay vào đó xử lý batch trong main isolate với Future.wait()
      await preWarmKeys();

      const batchSize = 20;
      final results = <Map<String, dynamic>>[];

      for (int i = 0; i < accountsData.length; i += batchSize) {
        final end = (i + batchSize < accountsData.length) ? i + batchSize : accountsData.length;
        final batch = accountsData.sublist(i, end);

        // Xử lý batch song song trong main isolate
        final batchResults = await Future.wait(
          batch.map((accountData) => _encryptSingleAccount(accountData)),
        );

        results.addAll(batchResults);

        // Delay nhỏ để không block UI
        if (i + batchSize < accountsData.length) {
          await Future.delayed(const Duration(milliseconds: 1));
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to batch encrypt accounts: $e');
    }
  }

  /// Encrypt single account trong main isolate
  static Future<Map<String, dynamic>> _encryptSingleAccount(
    Map<String, dynamic> accountData,
  ) async {
    try {
      final encryptedAccount = <String, dynamic>{
        'title': await encryptInfo(accountData['title']?.toString() ?? ''),
        'username': await encryptInfo(accountData['email']?.toString() ?? ''),
        'password': await encryptPassword(accountData['password']?.toString() ?? ''),
        'notes': await encryptInfo(accountData['notes']?.toString() ?? ''),
        'icon': accountData['icon'] ?? 'account_circle',
        'categoryId': accountData['categoryId'] ?? 0,
        'iconCustomId': accountData['iconCustomId'],
        'createdAt':
            accountData['createdAt'] != null
                ? DateTime.tryParse(accountData['createdAt'])
                : DateTime.now(),
        'updatedAt':
            accountData['updatedAt'] != null
                ? DateTime.tryParse(accountData['updatedAt'])
                : DateTime.now(),
        'passwordUpdatedAt':
            accountData['passwordUpdatedAt'] != null
                ? DateTime.tryParse(accountData['passwordUpdatedAt'])
                : DateTime.now(),
      };

      // Encrypt custom fields
      final customFields = <Map<String, dynamic>>[];
      if (accountData['customFields'] != null && accountData['customFields'] is List) {
        for (final field in accountData['customFields'] as List) {
          if (field is Map<String, dynamic>) {
            final isPassword = field['typeField'] == 'password';
            final encryptedValue =
                isPassword
                    ? await encryptPassword(field['value']?.toString() ?? '')
                    : await encryptInfo(field['value']?.toString() ?? '');

            customFields.add({
              'name': field['name'] ?? '',
              'value': encryptedValue,
              'hintText': field['hintText'] ?? '',
              'typeField': field['typeField'] ?? 'text',
            });
          }
        }
      }
      encryptedAccount['customFields'] = customFields;

      // Encrypt TOTP
      if (accountData['totp'] != null && accountData['totp'] is Map<String, dynamic>) {
        final totpData = accountData['totp'] as Map<String, dynamic>;
        encryptedAccount['totp'] = {
          'secretKey': await encryptTOTPKey(totpData['secretKey']?.toString() ?? ''),
          'isShowToHome': totpData['isShowToHome'] ?? false,
        };
      }

      // Encrypt password histories
      final passwordHistories = <Map<String, dynamic>>[];
      if (accountData['passwordHistories'] != null && accountData['passwordHistories'] is List) {
        for (final history in accountData['passwordHistories'] as List) {
          if (history is Map<String, dynamic>) {
            passwordHistories.add({
              'password': await encryptPassword(history['password']?.toString() ?? ''),
              'createdAt': history['createdAt'],
            });
          }
        }
      }
      encryptedAccount['passwordHistories'] = passwordHistories;

      return encryptedAccount;
    } catch (e) {
      logError(
        'Error encrypting single account: $e',
        functionName: 'DataSecureService._encryptSingleAccount',
      );
      // Return empty data if encryption fails
      return {
        'title': '',
        'username': '',
        'password': '',
        'notes': '',
        'icon': accountData['icon'] ?? 'account_circle',
        'categoryId': accountData['categoryId'] ?? 0,
        'iconCustomId': accountData['iconCustomId'],
        'customFields': [],
        'totp': null,
        'passwordHistories': [],
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'passwordUpdatedAt': DateTime.now(),
      };
    }
  }

  static String encryptData({required String value, required String key}) {
    if (value.isEmpty || key.isEmpty) return "";
    try {
      final encryptedData = EncryptV1.encrypt(value: value, key: key);
      return encryptedData;
    } catch (e) {
      throw Exception('Failed to encrypt data: $e');
    }
  }

  static String decryptData({required String value, required String key}) {
    if (value.isEmpty || key.isEmpty) return "";
    try {
      final decryptedData = EncryptV1.decrypt(encryptedData: value, key: key);
      return decryptedData;
    } catch (e) {
      throw Exception('Failed to decrypt data: $e');
    }
  }
}
