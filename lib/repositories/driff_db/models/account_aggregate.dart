import 'dart:developer';

import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:drift/drift.dart';

class AccountAggregate {
  final IconCustomDriftModelData? iconCustom;
  final AccountDriftModelData account;
  final CategoryDriftModelData category;
  final TOTPDriftModelData? totp;
  final List<AccountCustomFieldDriftModelData> customFields;
  final List<PasswordHistoryDriftModelData>? passwordHistories;

  AccountAggregate({
    required this.account,
    required this.category,
    required this.customFields,
    this.totp,
    this.iconCustom,
    this.passwordHistories,
  });

  static AccountDriftModelData fromAccountDriftModelCompanion(
    AccountDriftModelCompanion accountDriftModelData,
  ) {
    return AccountDriftModelData(
      id: accountDriftModelData.id.value,
      title: accountDriftModelData.title.value,
      username: accountDriftModelData.username.value,
      password: accountDriftModelData.password.value,
      notes: accountDriftModelData.notes.value,
      icon: accountDriftModelData.icon.value,
      categoryId: accountDriftModelData.categoryId.value,
      createdAt: accountDriftModelData.createdAt.value,
      updatedAt: accountDriftModelData.updatedAt.value,
      openCount: accountDriftModelData.openCount.value,
    );
  }

  static AccountAggregate fromOldDataJson(Map<String, dynamic> json) {
    log(json.toString());
    final AccountDriftModelCompanion accountDriftModelCompanion = AccountDriftModelCompanion(
      id: Value(
        json['id'] is int ? json['id'] ?? 0 : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      ),
      title: Value(json['title']?.toString() ?? ''),
      username: Value(json['email']?.toString() ?? ''),
      password: Value(json['password']?.toString() ?? ''),
      notes: Value(json['notes']?.toString() ?? ''),
      icon: Value(json['icon']?.toString() ?? 'account_circle'),
      openCount: Value(
        json['openCount'] is int
            ? json['openCount'] ?? 0
            : int.tryParse(json['openCount']?.toString() ?? '') ?? 0,
      ),
      categoryId: Value(
        json['category'] != null
            ? (json['category']['id'] is int
                  ? json['category']['id'] ?? 0
                  : int.tryParse(json['category']['id']?.toString() ?? '') ?? 0)
            : 0,
      ),
      createdAt: Value(
        json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      ),
      updatedAt: Value(
        json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      ),
      passwordUpdatedAt: Value(
        json['passwordUpdatedAt'] != null
            ? DateTime.tryParse(json['passwordUpdatedAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      ),
    );

    final categoryJson = json['category'] as Map<String, dynamic>? ?? {};
    final category = CategoryDriftModelData(
      id: categoryJson['id'] is int
          ? categoryJson['id'] ?? 0
          : int.tryParse(categoryJson['id']?.toString() ?? '') ?? 0,
      categoryName: categoryJson['categoryName']?.toString() ?? '',
      indexPos: categoryJson['indexPos'] is int
          ? categoryJson['indexPos'] ?? 0
          : int.tryParse(categoryJson['indexPos']?.toString() ?? '') ?? 0,
      createdAt: categoryJson['createdAt'] != null
          ? DateTime.tryParse(categoryJson['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: categoryJson['updatedAt'] != null
          ? DateTime.tryParse(categoryJson['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );

    final customFieldsList = (json['customFields'] as List<dynamic>? ?? []).map((fieldJson) {
      final Map<String, dynamic> fieldData = Map<String, dynamic>.from(fieldJson as Map);
      fieldData['accountId'] = fieldData['accountId'] is int
          ? fieldData['accountId']
          : int.tryParse(fieldData['accountId']?.toString() ?? '') ??
                accountDriftModelCompanion.id.value ??
                0;
      fieldData['name'] = fieldData['name']?.toString() ?? '';
      fieldData['value'] = fieldData['value']?.toString() ?? '';
      fieldData['hintText'] = fieldData['hintText']?.toString() ?? '';
      fieldData['typeField'] = fieldData['typeField']?.toString() ?? '';
      fieldData['id'] = fieldData['id'] is int
          ? fieldData['id']
          : int.tryParse(fieldData['id']?.toString() ?? '') ?? 0;
      return AccountCustomFieldDriftModelData.fromJson(fieldData);
    }).toList();

    TOTPDriftModelData? totp;
    if (json['totp'] != null) {
      final totpJson = Map<String, dynamic>.from(json['totp']);
      totpJson['accountId'] = totpJson['accountId'] is int
          ? totpJson['accountId']
          : int.tryParse(totpJson['accountId']?.toString() ?? '') ??
                accountDriftModelCompanion.id.value ??
                0;
      totpJson['id'] = totpJson['id'] is int
          ? totpJson['id']
          : int.tryParse(totpJson['id']?.toString() ?? '') ?? 0;
      totpJson['secretKey'] = totpJson['secretKey']?.toString() ?? '';
      totpJson['isShowToHome'] = totpJson['isShowToHome'] ?? false;
      totpJson['createdAt'] = totpJson['createdAt'] != null
          ? totpJson['createdAt'].toString()
          : DateTime.now().toIso8601String();
      totpJson['updatedAt'] = totpJson['updatedAt'] != null
          ? totpJson['updatedAt'].toString()
          : DateTime.now().toIso8601String();
      totp = TOTPDriftModelData.fromJson(totpJson);
    }

    IconCustomDriftModelData? iconCustom;
    if (json['iconCustom'] != null) {
      final iconJson = Map<String, dynamic>.from(json['iconCustom']);
      iconJson['id'] = iconJson['id'] is int
          ? iconJson['id'] ?? 0
          : int.tryParse(iconJson['id']?.toString() ?? '') ?? 0;
      iconJson['name'] = iconJson['name']?.toString() ?? '';
      iconJson['imageBase64'] = iconJson['imageBase64']?.toString() ?? '';
      iconCustom = IconCustomDriftModelData.fromJson(iconJson);
    }

    List<PasswordHistoryDriftModelData>? passwordHistories;
    if (json['passwordHistories'] != null) {
      passwordHistories = (json['passwordHistories'] as List<dynamic>).map((historyJson) {
        final Map<String, dynamic> historyData = Map<String, dynamic>.from(historyJson as Map);
        historyData['accountId'] = historyData['accountId'] is int
            ? historyData['accountId']
            : int.tryParse(historyData['accountId']?.toString() ?? '') ??
                  accountDriftModelCompanion.id.value ??
                  0;
        historyData['id'] = historyData['id'] is int
            ? historyData['id']
            : int.tryParse(historyData['id']?.toString() ?? '') ?? 0;
        historyData['password'] = historyData['password']?.toString() ?? '';
        historyData['createdAt'] = historyData['createdAt'] != null
            ? historyData['createdAt'].toString()
            : DateTime.now().toIso8601String();
        return PasswordHistoryDriftModelData.fromJson(historyData);
      }).toList();
    }

    return AccountAggregate(
      account: AccountAggregate.fromAccountDriftModelCompanion(accountDriftModelCompanion),
      category: category,
      customFields: customFieldsList,
      totp: totp,
      iconCustom: iconCustom,
      passwordHistories: passwordHistories,
    );
  }

  static AccountAggregate fromBackupJson(Map<String, dynamic> json) {
    try {
      // Chuyển đổi account từ JSON
      final account = AccountDriftModelData.fromJson(json);

      // Chuyển đổi category từ JSON
      final category = CategoryDriftModelData.fromJson(json['category'] as Map<String, dynamic>);

      // Chuyển đổi customFields từ JSON
      final customFieldsList = (json['customFields'] as List<dynamic>).map((fieldJson) {
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
        passwordHistories = (json['passwordHistories'] as List<dynamic>).map((historyJson) {
          final Map<String, dynamic> historyData = Map<String, dynamic>.from(historyJson as Map);
          if (!historyData.containsKey('accountId')) {
            historyData['accountId'] = account.id;
          }
          return PasswordHistoryDriftModelData.fromJson(historyData);
        }).toList();
      }

      return AccountAggregate(
        account: account,
        category: category,
        customFields: customFieldsList,
        totp: totp,
        iconCustom: iconCustom,
        passwordHistories: passwordHistories,
      );
    } catch (e) {
      throw Exception('Cannot convert backup json to AccountAggregate: $e');
    }
  }

  static AccountAggregate fromJson(Map<String, dynamic> json) {
    try {
      return AccountAggregate(
        account: AccountDriftModelData.fromJson(json['account']),
        category: CategoryDriftModelData.fromJson(json['category']),
        customFields: json['customFields']
            .map((e) => AccountCustomFieldDriftModelData.fromJson(e))
            .toList(),
        totp: json['totp'] != null ? TOTPDriftModelData.fromJson(json['totp']) : null,
        iconCustom: json['iconCustom'] != null
            ? IconCustomDriftModelData.fromJson(json['iconCustom'])
            : null,
        passwordHistories: json['passwordHistories']
            ?.map((e) => PasswordHistoryDriftModelData.fromJson(e))
            .toList(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
