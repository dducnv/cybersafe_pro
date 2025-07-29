import 'package:cybersafe_pro/repositories/driff_db/DAO/account_dao_model.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:drift/drift.dart';

class AccountServices {
  static final instance = AccountServices._();
  AccountServices._();

  Map<int, IconCustomDriftModelData> mapCustomIcon = {};

  Future<void> getListIconCustom() async {
    mapCustomIcon.clear();
    final iconsCustom = await DriffDbManager.instance.iconCustomAdapter.getAll();
    for (var icon in iconsCustom) {
      mapCustomIcon[icon.id] = icon;
    }
  }

  Future<AccountDriftModelData> decryptBasicInfo(AccountDriftModelData account) async {
    final titleDecrypted = await DataSecureService.decryptInfo(account.title);
    final usernameDecrypted = await DataSecureService.decryptInfo(account.username ?? '');

    final decryptedAccount = AccountDriftModelData(
      id: account.id,
      icon: account.icon,
      iconCustomId: account.iconCustomId,
      title: titleDecrypted,
      username: usernameDecrypted,
      categoryId: account.categoryId,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );
    return decryptedAccount;
  }

  Future<AccountDriftModelData> decryptAccount(AccountDriftModelData account) async {
    final basicInfo = await decryptBasicInfo(account);
    final passwordDecrypted = await DataSecureService.decryptPassword(account.password ?? '');
    final noteDecrypted = await DataSecureService.decryptInfo(account.notes ?? '');
    return basicInfo.copyWith(password: Value(passwordDecrypted), notes: Value(noteDecrypted));
  }

  Future<AccountAggregate> decryptDetailAccount(AccountDriftModelData account) async {
    final accountDecrypted = await decryptAccount(account);
    final results = await Future.wait([
      DriffDbManager.instance.totpAdapter.getByAccountId(account.id),
      DriffDbManager.instance.accountCustomFieldAdapter.getByAccountId(account.id),
      DriffDbManager.instance.categoryAdapter.getById(account.categoryId),
    ]);
    final totpDriftModelData = results[0] as TOTPDriftModelData?;
    final accountCustomFieldDriftModelData = results[1] as List<AccountCustomFieldDriftModelData>?;
    final categoryDriftModelData = results[2] as CategoryDriftModelData;
    return AccountAggregate(account: accountDecrypted, category: categoryDriftModelData, totp: totpDriftModelData, customFields: accountCustomFieldDriftModelData ?? []);
  }
}
