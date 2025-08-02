import 'package:cybersafe_pro/repositories/adapters/account_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/account_custom_text_fied_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/category_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/icon_custom_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/password_history_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/totp_adapter.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class DriffDbManager {
  static DriffDbManager? _instance;
  static DriffDbManager get instance => _instance ??= DriffDbManager._();

  DriffDbManager._();

  late final AccountAdapter accountAdapter;
  late final AccountCustomFieldAdapter accountCustomFieldAdapter;
  late final CategoryAdapter categoryAdapter;
  late final IconCustomAdapter iconCustomAdapter;
  late final PasswordHistoryAdapter passwordHistoryAdapter;
  late final TOTPAdapter totpAdapter;
  DriftSqliteDatabase? _database;

  Future<void> init() async {
    if (_database != null) return;
    _database = DriftSqliteDatabase();
    if (_database == null) return;
    accountAdapter = AccountAdapter(_database!);
    accountCustomFieldAdapter = AccountCustomFieldAdapter(_database!);
    categoryAdapter = CategoryAdapter(_database!);
    iconCustomAdapter = IconCustomAdapter(_database!);
    passwordHistoryAdapter = PasswordHistoryAdapter(_database!);
    totpAdapter = TOTPAdapter(_database!);
  }

  Future<T> transaction<T>(Future<T> Function() action) {
    _database ??= DriftSqliteDatabase();
    return _database!.transaction(action);
  }

  // ================= CATEGORY =================

  // ================= ACCOUNT =================
  Future<List<AccountDriftModelData>> getAllAccountDecryptedBaseInfo() async {
    final accounts = await accountAdapter.getAllBasicInfo();
    final decryptedAccounts = await Future.wait(accounts.map((account) => _getDecryptedBasicInfo(account)));
    return decryptedAccounts;
  }

  Future<AccountDriftModelData> _getDecryptedBasicInfo(AccountDriftModelData account) async {
    final titleDecripted = await DataSecureService.decryptInfo(account.title);
    final usernameDecripted = await DataSecureService.decryptInfo(account.username ?? '');
    return account.copyWith(title: titleDecripted, username: Value(usernameDecripted));
  }

  Future<AccountDriftModelData?> createAccountWithEncriptData({
    required AccountDriftModelCompanion account,
    List<AccountCustomFieldDriftModelCompanion>? customFields,
    TOTPDriftModelCompanion? totp,
    List<PasswordHistoryDriftModelCompanion>? passwordHistories,
  }) async {
    final futures = await Future.wait([
      DataSecureService.encryptInfo(account.title.value),
      DataSecureService.encryptInfo(account.username.value ?? ""),
      DataSecureService.encryptPassword(account.password.value ?? ""),
      DataSecureService.encryptInfo(account.notes.value ?? ""),
    ]);

    account = account.copyWith(
      id: null,
      title: Value(futures[0]),
      username: account.username.present ? Value(futures[1]) : const Value.absent(),
      password: account.password.present ? Value(futures[2]) : const Value.absent(),
      notes: account.notes.present ? Value(futures[3]) : const Value.absent(),
    );
    final id = await accountAdapter.insertAccount(account);

    if (customFields != null && customFields.isNotEmpty) {
      await Future.wait(customFields.map((customField) => createAccountCustomFieldWithEncriptData(customField: customField, accountId: id)));
    }

    if (totp != null) {
      final encryptedSecretKey = await DataSecureService.encryptTOTPKey(totp.secretKey.value);
      await totpAdapter.insertOrUpdateTOTP(id, encryptedSecretKey, totp.isShowToHome.value);
    }

    if (passwordHistories != null && passwordHistories.isNotEmpty) {
      await Future.wait(passwordHistories.map((passwordHistory) => passwordHistoryAdapter.insertPasswordHistory(id, passwordHistory.password.value)));
    }

    return await accountAdapter.getById(id);
  }

  // Batch create accounts - tối ưu cho migrate
  Future<List<AccountDriftModelData>> batchCreateAccountsWithEncryptData(List<Map<String, dynamic>> accountsData) async {
    if (accountsData.isEmpty) return [];

    final stopwatch = Stopwatch()..start();
    logInfo("Starting batch create ${accountsData.length} accounts");

    try {
      await _preWarmEncryptionKeys();
      logInfo("Pre-warmed encryption keys: ${stopwatch.elapsed}");

      final encryptedAccountsData = await DataSecureService.batchEncryptAccountsData(accountsData);
      logInfo("Batch encrypted accounts: ${stopwatch.elapsed}");

      final results = <AccountDriftModelData>[];
      const batchSize = 20;
      
      for (int i = 0; i < encryptedAccountsData.length; i += batchSize) {
        final end = (i + batchSize < encryptedAccountsData.length) ? i + batchSize : encryptedAccountsData.length;
        final batch = encryptedAccountsData.sublist(i, end);
        
        final batchResults = await transaction(() async {
          final batchAccountResults = <AccountDriftModelData>[];
          
          for (final accountData in batch) {
            try {
              final account = AccountDriftModelCompanion.insert(
                title: accountData['title'],
                username: Value(accountData['username']),
                password: Value(accountData['password']),
                notes: Value(accountData['notes']),
                icon: Value(accountData['icon'] ?? 'account_circle'),
                categoryId: accountData['categoryId'],
                createdAt: Value(accountData['createdAt'] ?? DateTime.now()),
                updatedAt: Value(accountData['updatedAt'] ?? DateTime.now()),
                passwordUpdatedAt: Value(accountData['passwordUpdatedAt'] ?? DateTime.now()),
              );

              final accountId = await accountAdapter.insertAccount(account);

              // Insert custom fields
              if (accountData['customFields'] != null && (accountData['customFields'] as List).isNotEmpty) {
                for (final fieldData in accountData['customFields'] as List) {
                  final customField = AccountCustomFieldDriftModelCompanion.insert(
                    accountId: accountId,
                    name: fieldData['name'],
                    value: fieldData['value'],
                    hintText: fieldData['hintText'],
                    typeField: fieldData['typeField'],
                  );
                  await accountCustomFieldAdapter.insertOrUpdateCustomField(customField);
                }
              }

              // Insert TOTP
              if (accountData['totp'] != null) {
                final totpData = accountData['totp'] as Map<String, dynamic>;
                await totpAdapter.insertOrUpdateTOTP(
                  accountId, 
                  totpData['secretKey'], 
                  totpData['isShowToHome'] ?? false
                );
              }

              // Insert password histories
              if (accountData['passwordHistories'] != null && (accountData['passwordHistories'] as List).isNotEmpty) {
                for (final historyData in accountData['passwordHistories'] as List) {
                  await passwordHistoryAdapter.insertPasswordHistory(accountId, historyData['password']);
                }
              }

              final createdAccount = await accountAdapter.getById(accountId);
              if (createdAccount != null) {
                batchAccountResults.add(createdAccount);
              }
            } catch (e) {
              logError('Error creating account in batch: $e');
            }
          }
          
          return batchAccountResults;
        });
        
        results.addAll(batchResults);
        
        // Progress log
        logInfo("Batch ${(i ~/ batchSize) + 1}/${(encryptedAccountsData.length / batchSize).ceil()} completed: ${stopwatch.elapsed}");
      }

      logInfo("Batch create completed: ${stopwatch.elapsed}, created ${results.length} accounts");
      return results;
    } catch (e) {
      logError('Error in batch create accounts: $e');
      rethrow;
    }
  }

  // Pre-warm encryption keys để tránh tạo keys nhiều lần
  Future<void> _preWarmEncryptionKeys() async {
    try {
      await Future.wait([
        DataSecureService.preWarmKeys(),
      ]);
    } catch (e) {
      logError('Error pre-warming keys: $e');
    }
  }

  Future<AccountDriftModelData?> updateAccountWithEncriptData({
    required AccountDriftModelCompanion account,
    List<AccountCustomFieldDriftModelCompanion>? customFields,
    TOTPDriftModelCompanion? totp,
    List<PasswordHistoryDriftModelCompanion>? passwordHistories,
    String newPassword = "",
  }) async {
    final futures = await Future.wait([
      DataSecureService.encryptInfo(account.title.value),
      DataSecureService.encryptInfo(account.username.value ?? ""),
      DataSecureService.encryptPassword(account.password.value ?? ""),
      DataSecureService.encryptInfo(account.notes.value ?? ""),
    ]);
    account = account.copyWith(
      title: Value(futures[0]),
      username: account.username.present ? Value(futures[1]) : const Value.absent(),
      password: account.password.present ? Value(futures[2]) : const Value.absent(),
      notes: account.notes.present ? Value(futures[3]) : const Value.absent(),
    );
    if (newPassword.isNotEmpty) {
      final currentAccount = await accountAdapter.getById(account.id.value);
      if (currentAccount != null && currentAccount.password != null && currentAccount.password!.isNotEmpty) {
        await passwordHistoryAdapter.insertPasswordHistory(account.id.value, await DataSecureService.encryptPassword(currentAccount.password!));
        logInfo('Password history saved for account ${account.id.value}');
      } else {
        logInfo('No current password found for account ${account.id.value}');
      }

      // Update with new password
      final encryptedPassword = await DataSecureService.encryptPassword(newPassword);
      account = account.copyWith(password: Value(encryptedPassword));
      logInfo('Password updated for account ${account.id.value}');
    }

    await accountAdapter.updateAccount(account.id.value, account);

    // Delete existing custom fields first
    await accountCustomFieldAdapter.deleteCustomFieldsByAccount(account.id.value);

    // Create new custom fields if provided
    if (customFields != null && customFields.isNotEmpty) {
      await Future.wait(customFields.map((customField) => createAccountCustomFieldWithEncriptData(customField: customField, accountId: account.id.value)));
    }

    if (totp != null && totp.secretKey.value.isNotEmpty) {
      final encryptedSecretKey = await DataSecureService.encryptTOTPKey(totp.secretKey.value);
      await totpAdapter.insertOrUpdateTOTP(account.id.value, encryptedSecretKey, totp.isShowToHome.value);
    } else {
      await totpAdapter.deleteTOTP(account.id.value);
    }

    return await accountAdapter.getById(account.id.value);
  }

  // ================= ACCOUNT CUSTOM FIELD =================

  Future<void> createAccountCustomFieldWithEncriptData({required AccountCustomFieldDriftModelCompanion customField, required int accountId}) async {
    bool isEncrypted = DataSecureService.isValueEncrypted(customField.value.value);
    final encryptedValue =
        isEncrypted
            ? customField.value.value
            : customField.typeField.value == 'password'
            ? await DataSecureService.encryptPassword(customField.value.value)
            : await DataSecureService.encryptInfo(customField.value.value);

    // Create new custom field without ID (let database auto-generate)
    final newCustomField = AccountCustomFieldDriftModelCompanion.insert(
      id: const Value.absent(), // Let database auto-generate ID
      accountId: accountId,
      name: customField.name.value,
      value: encryptedValue,
      hintText: customField.hintText.value,
      typeField: customField.typeField.value,
    );

    await accountCustomFieldAdapter.insertOrUpdateCustomField(newCustomField);
  }
}
