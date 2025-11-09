import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/repositories/driff_db/models/account_aggregate.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class AccountServices {
  static final instance = AccountServices._();
  AccountServices._();

  Map<int, IconCustomDriftModelData> mapCustomIcon = {};

  Future<bool> saveAccountFromAccountAggregate(AccountAggregate accountAggregate) async {
    try {
      // Xử lý category
      int categoryId = -1;
      CategoryDriftModelData? categoryDriftModelData = await DriffDbManager.instance.categoryAdapter
          .findByName(accountAggregate.category.categoryName);
      if (categoryDriftModelData == null) {
        categoryId = await DriffDbManager.instance.categoryAdapter.insertCategory(
          accountAggregate.category.categoryName,
        );
      } else {
        categoryId = categoryDriftModelData.id;
      }

      int iconId = -1;
      if (accountAggregate.iconCustom != null) {
        IconCustomDriftModelData? iconCustomDriftModelData = await DriffDbManager
            .instance
            .iconCustomAdapter
            .findByName(accountAggregate.iconCustom!.name);
        if (iconCustomDriftModelData == null) {
          if (accountAggregate.iconCustom!.name.isNotEmpty &&
              accountAggregate.iconCustom!.imageBase64.isNotEmpty) {
            iconId = await DriffDbManager.instance.iconCustomAdapter.insertCustomIcon(
              accountAggregate.iconCustom!.name,
              accountAggregate.iconCustom!.imageBase64,
            );
          }
        } else {
          iconId = iconCustomDriftModelData.id;
        }
      }

      await DriffDbManager.instance.createAccountWithEncriptData(
        account: accountAggregate.account
            .toCompanion(true)
            .copyWith(
              categoryId: Value(categoryId),
              iconCustomId: iconId != -1 ? Value(iconId) : const Value.absent(),
            ),
        customFields: accountAggregate.customFields.map((e) => e.toCompanion(true)).toList(),
        totp: accountAggregate.totp?.toCompanion(true),
        passwordHistories: accountAggregate.passwordHistories
            ?.map((e) => e.toCompanion(true))
            .toList(),
      );

      return true;
    } catch (e) {
      logError('Error saving account from account aggregate: $e');
      return false;
    }
  }

  Future<void> getListIconCustom() async {
    mapCustomIcon.clear();
    final iconsCustom = await DriffDbManager.instance.iconCustomAdapter.getAll();
    for (var icon in iconsCustom) {
      mapCustomIcon[icon.id] = icon;
    }
  }

  Future<AccountDriftModelData> decryptBasicInfo(AccountDriftModelData account) async {
    final futures = await Future.wait([
      DataSecureService.decryptInfo(account.title),
      DataSecureService.decryptInfo(account.username ?? ''),
    ]);

    final decryptedAccount = AccountDriftModelData(
      id: account.id,
      icon: account.icon,
      iconCustomId: account.iconCustomId,
      title: futures[0],
      username: futures[1],
      categoryId: account.categoryId,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
      openCount: account.openCount,
    );
    return decryptedAccount;
  }

  Future<AccountDriftModelData> decryptAccount(AccountDriftModelData account) async {
    final basicInfo = await decryptBasicInfo(account);
    final futures = await Future.wait([
      DataSecureService.decryptPassword(account.password ?? ''),
      DataSecureService.decryptInfo(account.notes ?? ''),
    ]);
    return basicInfo.copyWith(password: Value(futures[0]), notes: Value(futures[1]));
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
    return AccountAggregate(
      account: accountDecrypted,
      category: categoryDriftModelData,
      totp: totpDriftModelData,
      customFields: accountCustomFieldDriftModelData ?? [],
    );
  }

  Future<Map<String, dynamic>> accountCustomFieldToJson(
    AccountCustomFieldDriftModelData accountCustomField,
  ) async {
    return {
      ...accountCustomField.toJson(),
      'name': accountCustomField.name,
      'value': accountCustomField.typeField == 'password'
          ? await DataSecureService.decryptPassword(accountCustomField.value)
          : await DataSecureService.decryptInfo(accountCustomField.value),
      'hintText': accountCustomField.hintText,
      'typeField': accountCustomField.typeField,
    };
  }

  Future<Map<String, dynamic>> passwordHistoryToJson(
    PasswordHistoryDriftModelData passwordHistory,
  ) async {
    return {
      ...passwordHistory.toJson(),
      'password': await DataSecureService.decryptPassword(passwordHistory.password),
      'createdAt': passwordHistory.createdAt.toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> totpToJson(TOTPDriftModelData totp) async {
    return {
      ...totp.toJson(),
      'accountId': totp.accountId,
      'secretKey': await DataSecureService.decryptTOTPKey(totp.secretKey),
      'isShowToHome': totp.isShowToHome,
    };
  }

  Future<Map<String, dynamic>> toDataDecryptedJson({
    required AccountAggregate accountAggregate,
    required List<PasswordHistoryDriftModelData> passwordHistories,
  }) async {
    final futures = await Future.wait([
      DataSecureService.decryptInfo(accountAggregate.account.title),
      DataSecureService.decryptInfo(accountAggregate.account.username ?? ""),
      DataSecureService.decryptPassword(accountAggregate.account.password ?? ""),
      DataSecureService.decryptInfo(accountAggregate.account.notes ?? ""),
    ]);

    return {
      ...accountAggregate.account.toJson(),
      'title': futures[0],
      'username': futures[1],
      'password': futures[2],
      'notes': futures[3],
      'icon': accountAggregate.account.icon,
      'customFields': await Future.wait(
        accountAggregate.customFields.map((e) => accountCustomFieldToJson(e)),
      ),
      'totp': accountAggregate.totp != null ? await totpToJson(accountAggregate.totp!) : null,
      'category': accountAggregate.category.toJson(),
      'passwordUpdatedAt': accountAggregate.account.passwordUpdatedAt?.toIso8601String(),
      'passwordHistories': await Future.wait(
        passwordHistories.map((e) => passwordHistoryToJson(e)),
      ),
      'iconCustom': accountAggregate.iconCustom?.toJson(),
    };
  }

  Future<List<Map<String, dynamic>>> toDataDecryptedList(
    List<AccountAggregate> accountAggregates,
  ) async {
    return await Future.wait(
      accountAggregates.map(
        (e) =>
            toDataDecryptedJson(accountAggregate: e, passwordHistories: e.passwordHistories ?? []),
      ),
    );
  }

  Future<bool> saveAccountsFromAccountAggregates(List<AccountAggregate> accountAggregates) async {
    try {
      final Map<String, int> processedCategories = {};
      final Map<String, int> processedIcons = {};

      for (var aggregate in accountAggregates) {
        final categoryName = aggregate.category.categoryName;
        if (!processedCategories.containsKey(categoryName)) {
          CategoryDriftModelData? existingCategory = await DriffDbManager.instance.categoryAdapter
              .findByName(categoryName);
          if (existingCategory == null) {
            int id = await DriffDbManager.instance.categoryAdapter.insertCategory(categoryName);
            processedCategories[categoryName] = id;
          } else {
            processedCategories[categoryName] = existingCategory.id;
          }
        }
      }

      // Xử lý tất cả icon custom trước
      for (var aggregate in accountAggregates) {
        if (aggregate.iconCustom != null && aggregate.iconCustom!.name.isNotEmpty) {
          final iconName = aggregate.iconCustom!.name;
          if (!processedIcons.containsKey(iconName)) {
            IconCustomDriftModelData? existingIcon = await DriffDbManager.instance.iconCustomAdapter
                .findByName(iconName);
            if (existingIcon == null) {
              if (aggregate.iconCustom!.imageBase64.isNotEmpty) {
                int id = await DriffDbManager.instance.iconCustomAdapter.insertCustomIcon(
                  iconName,
                  aggregate.iconCustom!.imageBase64,
                );
                processedIcons[iconName] = id;
              }
            } else {
              processedIcons[iconName] = existingIcon.id;
            }
          }
        }
      }

      // Convert aggregates to data format for batch processing
      final accountsData = <Map<String, dynamic>>[];

      for (var aggregate in accountAggregates) {
        final categoryId = processedCategories[aggregate.category.categoryName]!;
        int? iconId;

        if (aggregate.iconCustom != null && aggregate.iconCustom!.name.isNotEmpty) {
          iconId = processedIcons[aggregate.iconCustom!.name];
        }

        // Convert AccountAggregate to Map format
        final accountData = <String, dynamic>{
          'title': aggregate.account.title,
          'email': aggregate.account.username ?? '',
          'password': aggregate.account.password ?? '',
          'notes': aggregate.account.notes ?? '',
          'icon': aggregate.account.icon ?? 'default',
          'categoryId': categoryId,
          'iconCustomId': iconId,
          'createdAt': aggregate.account.createdAt.toIso8601String(),
          'updatedAt': aggregate.account.updatedAt.toIso8601String(),
          'passwordUpdatedAt': aggregate.account.passwordUpdatedAt?.toIso8601String(),
        };

        // Add custom fields
        if (aggregate.customFields.isNotEmpty) {
          accountData['customFields'] = aggregate.customFields
              .map(
                (field) => {
                  'name': field.name,
                  'value': field.value,
                  'hintText': field.hintText,
                  'typeField': field.typeField,
                },
              )
              .toList();
        }

        // Add TOTP
        if (aggregate.totp != null) {
          accountData['totp'] = {
            'secretKey': aggregate.totp!.secretKey,
            'isShowToHome': aggregate.totp!.isShowToHome,
          };
        }

        // Add password histories
        if (aggregate.passwordHistories != null && aggregate.passwordHistories!.isNotEmpty) {
          accountData['passwordHistories'] = aggregate.passwordHistories!
              .map(
                (history) => {
                  'password': history.password,
                  'createdAt': history.createdAt.toIso8601String(),
                },
              )
              .toList();
        }

        accountsData.add(accountData);
      }

      // Use batch create method for better performance
      final results = await DriffDbManager.instance.batchCreateAccountsWithEncryptData(
        accountsData,
      );
      return results.length == accountAggregates.length;
    } catch (e) {
      logError('Error saving accounts from account aggregates: $e');
      return false;
    }
  }
}
