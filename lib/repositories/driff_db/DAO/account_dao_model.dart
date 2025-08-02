import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';

class AccountAggregate {
  final IconCustomDriftModelData? iconCustom;
  final AccountDriftModelData account;
  final CategoryDriftModelData category;
  final TOTPDriftModelData? totp;
  final List<AccountCustomFieldDriftModelData> customFields;
  final List<PasswordHistoryDriftModelData>? passwordHistories;

  AccountAggregate({required this.account, required this.category, required this.customFields, this.totp, this.iconCustom, this.passwordHistories});

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

  static AccountAggregate fromBackupJson(Map<String, dynamic> json) {
    try {
      // Chuyển đổi account từ JSON
      final account = AccountDriftModelData.fromJson(json);

      // Chuyển đổi category từ JSON
      final category = CategoryDriftModelData.fromJson(json['category'] as Map<String, dynamic>);

      // Chuyển đổi customFields từ JSON
      final customFieldsList =
          (json['customFields'] as List<dynamic>).map((fieldJson) {
            // Đảm bảo accountId được thiết lập đúng
            final Map<String, dynamic> fieldData = Map<String, dynamic>.from(fieldJson as Map);
            if (!fieldData.containsKey('accountId')) {
              fieldData['accountId'] = account.id;
            }
            return AccountCustomFieldDriftModelData.fromJson(fieldData);
          }).toList();

      // Chuyển đổi TOTP nếu có
      TOTPDriftModelData? totp;
      if (json['totp'] != null) {
        final totpJson = json['totp'] as Map<String, dynamic>;
        if (!totpJson.containsKey('accountId')) {
          totpJson['accountId'] = account.id;
        }
        totp = TOTPDriftModelData.fromJson(totpJson);
      }

      // Chuyển đổi iconCustom nếu có
      IconCustomDriftModelData? iconCustom;
      if (json['iconCustom'] != null) {
        iconCustom = IconCustomDriftModelData.fromJson(json['iconCustom'] as Map<String, dynamic>);
      }

      // Chuyển đổi passwordHistories nếu có
      List<PasswordHistoryDriftModelData>? passwordHistories;
      if (json['passwordHistories'] != null) {
        passwordHistories =
            (json['passwordHistories'] as List<dynamic>).map((historyJson) {
              final Map<String, dynamic> historyData = Map<String, dynamic>.from(historyJson as Map);
              if (!historyData.containsKey('accountId')) {
                historyData['accountId'] = account.id;
              }
              return PasswordHistoryDriftModelData.fromJson(historyData);
            }).toList();
      }

      return AccountAggregate(account: account, category: category, customFields: customFieldsList, totp: totp, iconCustom: iconCustom, passwordHistories: passwordHistories);
    } catch (e) {
      throw Exception('Cannot convert backup json to AccountAggregate: $e');
    }
  }

  static AccountAggregate fromJson(Map<String, dynamic> json) {
    try {
      return AccountAggregate(
        account: AccountDriftModelData.fromJson(json['account']),
        category: CategoryDriftModelData.fromJson(json['category']),
        customFields: json['customFields'].map((e) => AccountCustomFieldDriftModelData.fromJson(e)).toList(),
        totp: json['totp'] != null ? TOTPDriftModelData.fromJson(json['totp']) : null,
        iconCustom: json['iconCustom'] != null ? IconCustomDriftModelData.fromJson(json['iconCustom']) : null,
        passwordHistories: json['passwordHistories']?.map((e) => PasswordHistoryDriftModelData.fromJson(e)).toList(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
