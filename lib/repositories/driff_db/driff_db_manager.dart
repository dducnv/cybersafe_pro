import 'package:cybersafe_pro/repositories/adapters/account_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/account_custom_text_fied_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/category_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/icon_custom_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/password_history_adapter.dart';
import 'package:cybersafe_pro/repositories/adapters/totp_adapter.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
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

  Future<void> init() async {
    final database = DriftSqliteDatabase();
    accountAdapter = AccountAdapter(database);
    accountCustomFieldAdapter = AccountCustomFieldAdapter(database);
    categoryAdapter = CategoryAdapter(database);
    iconCustomAdapter = IconCustomAdapter(database);
    passwordHistoryAdapter = PasswordHistoryAdapter(database);
    totpAdapter = TOTPAdapter(database);
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
  }) async {
    final futures = await Future.wait([
      DataSecureService.encryptInfo(account.title.value),
      DataSecureService.encryptInfo(account.username.value ?? ""),
      DataSecureService.encryptPassword(account.password.value ?? ""),
      DataSecureService.encryptInfo(account.notes.value ?? ""),
    ]);

    account = account.copyWith(title: Value(futures[0]), username: Value(futures[1]), password: Value(futures[2]), notes: Value(futures[3]));
    final id = await accountAdapter.insertAccount(account);

    if (customFields != null) {
      await Future.wait(customFields.map((customField) => createAccountCustomFieldWithEncriptData(customField: customField, accountId: id)));
    }

    if (totp != null) {
      await totpAdapter.insertOrUpdateTOTP(id, totp.secretKey.value, totp.isShowToHome.value);
    }
    return await accountAdapter.getById(id);
  }

  Future<AccountDriftModelData?> updateAccountWithEncriptData({
    required AccountDriftModelCompanion account,
    List<AccountCustomFieldDriftModelCompanion>? customFields,
    TOTPDriftModelCompanion? totp,
    String newPassword = "",
  }) async {
    final futures = await Future.wait([
      DataSecureService.encryptInfo(account.title.value),
      DataSecureService.encryptInfo(account.username.value ?? ""),
      DataSecureService.encryptPassword(account.password.value ?? ""),
      DataSecureService.encryptInfo(account.notes.value ?? ""),
    ]);

    account = account.copyWith(title: Value(futures[0]), username: Value(futures[1]), password: Value(futures[2]), notes: Value(futures[3]));

    if (newPassword.isNotEmpty) {
      final encryptedPassword = await DataSecureService.encryptPassword(newPassword);
      account = account.copyWith(password: Value(encryptedPassword));
      if (account.password.value != null && account.password.value!.isNotEmpty) {
        final encriptOldPassword = await DataSecureService.encryptPassword(account.password.value!);
        await passwordHistoryAdapter.insertPasswordHistory(account.id.value, encriptOldPassword);
      }
    }

    await accountAdapter.updateAccount(account.id.value, account);
    await accountCustomFieldAdapter.deleteCustomFieldsByAccount(account.id.value);
    if (customFields != null && customFields.isNotEmpty) {
      await Future.wait(customFields.map((customField) => createAccountCustomFieldWithEncriptData(customField: customField, accountId: account.id.value)));
    }

    if (totp != null && totp.secretKey.value.isNotEmpty) {
      bool isSecretKeyEncrypted = DataSecureService.isValueEncrypted(totp.secretKey.value);
      final encryptedSecretKey = isSecretKeyEncrypted ? totp.secretKey.value : await DataSecureService.encryptInfo(totp.secretKey.value);
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
    customField = customField.copyWith(name: customField.name, value: Value(encryptedValue));
    await accountCustomFieldAdapter.insertOrUpdateCustomField(customField.copyWith(accountId: Value(accountId)));
  }

  // ================= CATEGORY =================

  // ================= ICON CUSTOM =================

  // ================= PASSWORD HISTORY =================
}
