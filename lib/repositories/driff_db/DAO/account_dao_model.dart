import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';

class AccountDaoModel {
  final AccountDriftModelData account;
  final CategoryDriftModelData category;
  final TOTPDriftModelData? totp;
  final List<AccountCustomFieldDriftModelData> customFields;

  AccountDaoModel({required this.account, required this.category, required this.customFields, this.totp});

  static AccountDriftModelData fromAccountDriftModelCompanion(AccountDriftModelCompanion accountDriftModelData) {
    return AccountDriftModelData(
      id: accountDriftModelData.id.value,
      title: accountDriftModelData.title.value,
      username: accountDriftModelData.username.value,
      categoryId: accountDriftModelData.categoryId.value,
      createdAt: accountDriftModelData.createdAt.value,
      updatedAt: accountDriftModelData.updatedAt.value,
    );
  }
}
