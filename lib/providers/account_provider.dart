import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/repositories/driff_db/models/account_aggregate.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/services/account/account_services.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:diacritic/diacritic.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class AccountProvider extends ChangeNotifier {
  final Map<int, AccountDriftModelData> _accounts = {};
  final Map<int, List<AccountDriftModelData>> _groupedCategoryIdAccounts = {};
  final Map<int, AccountDriftModelData> _basicInfoCache = {};
  final Map<int, int> mapCategoryIdTotalAccount = {};
  List<AccountDriftModelData> _decryptedAccountsCache = [];

  Map<int, AccountDriftModelData> get accounts => Map.unmodifiable(_accounts);
  List<AccountDriftModelData> get accountList => _accounts.values.toList();
  Map<int, List<AccountDriftModelData>> get groupedAccountsByCategoryId =>
      Map.unmodifiable(_groupedCategoryIdAccounts);
  List<IconCustomDriftModelData> listIconsCustom = [];

  /// Refresh cache of all decrypted accounts (call after any change)
  Future<void> refreshDecryptedAccountsCache() async {
    final accountsToSearch = await DriffDbManager.instance.accountAdapter.getAllBasicInfo();
    if (accountsToSearch.isEmpty) {
      _decryptedAccountsCache = [];
      return;
    }
    _decryptedAccountsCache = await _getDecryptedBasicInfoMany(accountsToSearch);
  }

  Future<void> getLimitAccountsByCategory({
    required Map<int, CategoryDriftModelData> mapCategories,
    required int limit,
  }) async {
    clearData();
    if (mapCategories.isEmpty) return;
    final categories = mapCategories.values.toList();
    await getTotalAccountsByCategory(categoryIds: categories.map((e) => e.id).toList());
    final accountsByCategory = await DriffDbManager.instance.accountAdapter
        .getByCategoriesWithLimit(categories, limit);
    await _processAccountsByCategory(accountsByCategory: accountsByCategory);
  }

  Future<List<AccountDriftModelData>> loadMoreAccountsForCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) async {
    // Load more accounts using the provided offset
    final moreAccounts = await DriffDbManager.instance.accountAdapter.getBasicByCategoryWithLimit(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );

    if (moreAccounts.isEmpty) {
      return [];
    }

    // Get current accounts to filter duplicates
    final currentAccounts = _groupedCategoryIdAccounts[categoryId] ?? [];
    final existingAccountIds = currentAccounts.map((a) => a.id).toSet();
    final newAccounts = moreAccounts.where((a) => !existingAccountIds.contains(a.id)).toList();
    if (newAccounts.isEmpty) {
      return [];
    }

    // Process and add new accounts to the cache
    final decryptedAccounts = await _processNewAccounts(categoryId, newAccounts);

    notifyListeners();
    return decryptedAccounts;
  }

  Future<void> getTotalAccountsByCategory({required List<int> categoryIds}) async {
    final accountCounts = await DriffDbManager.instance.accountAdapter.countByCategories(
      categoryIds,
    );
    mapCategoryIdTotalAccount.addAll(accountCounts);
  }

  /// Refresh total account count for a specific category
  Future<void> refreshCategoryCount(int categoryId) async {
    final count = await DriffDbManager.instance.accountAdapter.countByCategory(categoryId);
    mapCategoryIdTotalAccount[categoryId] = count;
    notifyListeners();
  }

  Future<void> _processAccountsByCategory({
    required Map<int, List<AccountDriftModelData>> accountsByCategory,
  }) async {
    for (var categoryId in accountsByCategory.keys) {
      final accounts = accountsByCategory[categoryId] ?? [];

      // Decrypt accounts (parallel)
      final decryptedAccounts = await _getDecryptedBasicInfoMany(accounts);

      // Update cache
      for (var i = 0; i < accounts.length; i++) {
        final account = accounts[i];
        final decryptedAccount = decryptedAccounts[i];
        _accounts[account.id] = account;
        _groupedCategoryIdAccounts.putIfAbsent(categoryId, () => []).add(decryptedAccount);
      }

      notifyListeners();
    }
  }

  Future<bool> createAccountFromForm(AccountFormProvider form) async {
    if (!form.validateForm()) {
      return false;
    }
    final now = DateTime.now();
    final AccountAggregate newAccountDrift = AccountAggregate(
      account: AccountDriftModelData(
        id: form.accountId,
        icon: form.branchLogoSelected?.branchLogoSlug,
        title: form.appNameController.text.trim(),
        username: form.usernameController.text.trim(),
        password: form.passwordController.text,
        categoryId: form.selectedCategory!.id,
        iconCustomId: form.selectedIconCustom?.id,
        notes: form.noteController.text.trim(),
        createdAt: now,
        updatedAt: now,
      ),
      category: form.selectedCategory!,
      customFields:
          form.dynamicTextFieldNotifier.map((e) {
            return AccountCustomFieldDriftModelData(
              id: 0,
              accountId: form.accountId,
              name: e.customField.key,
              value: e.controller.text,
              hintText: e.customField.hintText,
              typeField: e.customField.typeField.type,
            );
          }).toList(),
      totp:
          form.otpController.text.isNotEmpty
              ? TOTPDriftModelData(
                id: 0,
                accountId: form.accountId,
                secretKey: form.otpController.text.toUpperCase().trim(),
                isShowToHome: false,
                createdAt: now,
                updatedAt: now,
              )
              : null,
    );

    final result = await createOrUpdateAccount(newAccountDrift, isUpdate: form.accountId != 0);
    if (result) {
      form.resetForm();
    }
    return result;
  }

  Future<bool> createOrUpdateAccount(
    AccountAggregate accountDaoModel, {
    bool isUpdate = false,
  }) async {
    final stopwatch = Stopwatch()..start();

    if (accountDaoModel.account.title.trim().isEmpty) {
      throw Exception('Tên tài khoản không được để trống');
    }

    AccountDriftModelData? accountToSave;
    if (isUpdate) {
      AccountDriftModelData? currentAccount =
          accountDaoModel.account.id != 0
              ? await DriffDbManager.instance.accountAdapter.getById(accountDaoModel.account.id)
              : null;
      if (currentAccount == null) throw Exception('Account not found');

      String? newPassword;
      final currentPassword = await DataSecureService.decryptPassword(
        currentAccount.password ?? '',
      );
      final newPasswordFromForm = accountDaoModel.account.password ?? '';

      if (currentPassword != newPasswordFromForm && newPasswordFromForm.isNotEmpty) {
        newPassword = newPasswordFromForm;
        logInfo('Password changed for account ${accountDaoModel.account.id}: saving to history');
      }

      await DriffDbManager.instance.updateAccountWithEncriptData(
        account: accountDaoModel.account.toCompanion(true),
        customFields: accountDaoModel.customFields.map((e) => e.toCompanion(true)).toList(),
        totp: accountDaoModel.totp?.toCompanion(true),
        newPassword: newPassword ?? '',
      );
      accountToSave = currentAccount;
    } else {
      final accountCreated = await DriffDbManager.instance.createAccountWithEncriptData(
        account: accountDaoModel.account.toCompanion(true),
        customFields: accountDaoModel.customFields.map((e) => e.toCompanion(true)).toList(),
        totp: accountDaoModel.totp?.toCompanion(true),
      );
      accountToSave = accountCreated;
    }
    final elapsedTime = stopwatch.elapsed;
    logInfo(
      '${isUpdate ? "updateAccount" : "createAccount"}: _encryptAccount completed in: ${elapsedTime.inMilliseconds}ms',
    );

    // Update local cache
    _accounts[accountToSave!.id] = accountToSave;
    _basicInfoCache.remove(accountToSave.id);

    // Update grouped accounts by category
    await _updateGroupedAccountsAfterModification(accountToSave, isUpdate);

    logInfo(
      '${isUpdate ? "updateAccount" : "createAccount"}: Operation completed in: ${elapsedTime.inMilliseconds}ms',
    );
    return true;
  }

  Future<bool> createAccountOnlyOtp({
    required String secretKey,
    required String appName,
    required String accountName,
  }) async {
    if (!OTP.isKeyValid(secretKey)) {
      return false;
    }
    try {
      final normalizedSecretKey = secretKey.toUpperCase().trim();
      final now = DateTime.now();

      final results = await Future.wait([_getOrCreateOtpCategory(), _findMatchingIcon(appName)]);

      final categoryId = results[0] as int;
      final iconName = results[1] as String?;

      final newAccount = await DriffDbManager.instance.createAccountWithEncriptData(
        account: AccountDriftModelCompanion(
          title: Value(appName),
          icon: Value(iconName),
          username: Value(accountName),
          password: Value(normalizedSecretKey),
          categoryId: Value(categoryId),
          notes: const Value(""),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
        totp: TOTPDriftModelCompanion(
          secretKey: Value(normalizedSecretKey),
          isShowToHome: const Value(true),
        ),
      );

      return newAccount != null;
    } catch (e) {
      return false;
    }
  }

  Future<int> _getOrCreateOtpCategory() async {
    const categoryName = "OTP";
    final existingCategory = await DriffDbManager.instance.categoryAdapter.findByName(categoryName);
    if (existingCategory != null) {
      return existingCategory.id;
    }
    return await DriffDbManager.instance.categoryAdapter.insertCategory(categoryName);
  }

  Future<String?> _findMatchingIcon(String appName) async {
    final appNameLower = appName.toLowerCase();
    try {
      final matchingIcon = allBranchLogos.firstWhere((icon) {
        if (icon.keyWords == null || icon.keyWords!.isEmpty) return false;
        final pattern = icon.keyWords!.map((k) => RegExp.escape(k)).join('|');
        final regex = RegExp(pattern, caseSensitive: false);
        return regex.hasMatch(appNameLower);
      });
      return matchingIcon.branchLogoSlug;
    } catch (e) {
      return "";
    }
  }

  Future<bool> deleteAccount(AccountDriftModelData account) async {
    try {
      await DriffDbManager.instance.accountAdapter.deleteAccount(account.id);

      // Remove from local cache
      _accounts.remove(account.id);
      _basicInfoCache.remove(account.id);

      // Update grouped accounts after deletion
      await _updateGroupedAccountsAfterDeletion(account);

      return true;
    } catch (e) {
      logError('Error deleting account: $e');
      throw Exception('Cannot delete account');
    }
  }

  /// Delete multiple selected accounts (parallel)
  Future<bool> handleDeleteAllSelectedAccounts({
    required List<AccountDriftModelData> accountSelected,
  }) async {
    try {
      final listIds = accountSelected.map((e) => e.id).toList();
      final deletedCount = await DriffDbManager.instance.accountAdapter.deleteMany(listIds);

      if (deletedCount != listIds.length) {
        throw Exception('Cannot delete some accounts');
      }

      // Remove from local cache
      for (final account in accountSelected) {
        _accounts.remove(account.id);
        _basicInfoCache.remove(account.id);
      }

      return true;
    } catch (e) {
      logError('Error deleting multiple accounts: $e');
      throw Exception('Cannot delete some accounts');
    }
  }

  Future<List<AccountDriftModelData>> searchAccounts(String query) async {
    if (query.isEmpty) return <AccountDriftModelData>[];
    final queryLower = query.toLowerCase().trim();
    if (_decryptedAccountsCache.isEmpty) {
      await refreshDecryptedAccountsCache();
    }
    return _decryptedAccountsCache.where((account) {
      return _matchesSearchQuery(account, queryLower);
    }).toList();
  }

  bool _matchesSearchQuery(AccountDriftModelData account, String query) {
    final searchableContent = removeDiacritics(
      "${account.title} ${account.username ?? ''} ${account.notes ?? ''}".toLowerCase(),
    );
    return _fuzzyMatch(searchableContent, query);
  }

  bool _fuzzyMatch(String text, String query) {
    if (text.contains(query)) return true;
    final queryWords = query.split(' ').where((word) => word.isNotEmpty).toList();
    if (queryWords.isEmpty) return false;
    return queryWords.every((word) => text.contains(word));
  }

  Future<void> handleChangeCategory({
    required List<AccountDriftModelData> accountSelected,
    required CategoryDriftModelData category,
  }) async {
    final futures = accountSelected.map(
      (account) => DriffDbManager.instance.accountAdapter.updateAccount(
        account.id,
        AccountDriftModelCompanion(categoryId: Value(category.id)),
      ),
    );
    final updatedAccounts =
        (await Future.wait(futures)).whereType<AccountDriftModelData>().toList();
    await DriffDbManager.instance.accountAdapter.putMany(updatedAccounts);

    // Update local cache and grouped accounts
    for (final account in updatedAccounts) {
      _accounts[account.id] = account;
      _basicInfoCache.remove(account.id);
    }

    // Update grouped accounts for all affected accounts
    await _updateGroupedAccountsAfterCategoryChange(accountSelected, category.id);

    notifyListeners();
  }

  Future<List<AccountDriftModelData>> _processNewAccounts(
    int categoryId,
    List<AccountDriftModelData> newAccounts,
  ) async {
    final decryptedAccounts = await _getDecryptedBasicInfoMany(newAccounts);
    await Future.wait([
      Future.wait(
        newAccounts.map((account) async {
          _accounts[account.id] = account;
        }),
      ),
      Future.wait(
        newAccounts.asMap().entries.map((entry) async {
          final i = entry.key;
          final decryptedAccount = decryptedAccounts[i];
          _groupedCategoryIdAccounts.putIfAbsent(categoryId, () => []).add(decryptedAccount);
        }),
      ),
    ]);

    return decryptedAccounts;
  }

  Future<List<AccountDriftModelData>> _getDecryptedBasicInfoMany(
    List<AccountDriftModelData> accounts,
  ) async {
    final futures = accounts.map((account) => getDecryptedBasicInfo(account)).toList();
    return await Future.wait(futures);
  }

  Future<AccountDriftModelData> getDecryptedBasicInfo(AccountDriftModelData account) async {
    // Check cache first
    if (_basicInfoCache.containsKey(account.id)) {
      return _basicInfoCache[account.id]!;
    }
    final decryptedAccount = await AccountServices.instance.decryptBasicInfo(account);
    _basicInfoCache[account.id] = decryptedAccount;
    return decryptedAccount;
  }

  Future<AccountDriftModelData> getDecryptedAccount(AccountDriftModelData account) async {
    return getDecryptedBasicInfo(account);
  }

  void clearData() {
    _accounts.clear();
    _groupedCategoryIdAccounts.clear();
    _basicInfoCache.clear();
    _decryptedAccountsCache = [];
  }

  /// Update grouped accounts after creating or updating an account
  Future<void> _updateGroupedAccountsAfterModification(
    AccountDriftModelData account,
    bool isUpdate,
  ) async {
    final categoryId = account.categoryId;

    if (isUpdate) {
      // For updates, remove from old category and add to new category
      _removeAccountFromAllCategories(account.id);
    }

    // Add to the correct category
    final decryptedAccount = await getDecryptedBasicInfo(account);
    _groupedCategoryIdAccounts.putIfAbsent(categoryId, () => []).add(decryptedAccount);

    // Update category total count - get actual count from database
    final actualCount = await DriffDbManager.instance.accountAdapter.countByCategory(categoryId);
    mapCategoryIdTotalAccount[categoryId] = actualCount;

    // Refresh cache
    await refreshDecryptedAccountsCache();

    notifyListeners();
  }

  /// Update grouped accounts after deleting an account
  Future<void> _updateGroupedAccountsAfterDeletion(AccountDriftModelData account) async {
    _removeAccountFromAllCategories(account.id);

    // Update category total count - get actual count from database
    final categoryId = account.categoryId;
    final actualCount = await DriffDbManager.instance.accountAdapter.countByCategory(categoryId);
    mapCategoryIdTotalAccount[categoryId] = actualCount;

    // Refresh cache
    await refreshDecryptedAccountsCache();

    notifyListeners();
  }

  /// Remove account from all categories (helper method)
  void _removeAccountFromAllCategories(int accountId) {
    // Tạo danh sách categoryIds để tránh concurrent modification
    final categoryIds = _groupedCategoryIdAccounts.keys.toList();

    for (final categoryId in categoryIds) {
      final accounts = _groupedCategoryIdAccounts[categoryId];
      if (accounts != null) {
        accounts.removeWhere((account) => account.id == accountId);
        if (accounts.isEmpty) {
          _groupedCategoryIdAccounts.remove(categoryId);
        }
      }
    }
  }

  /// Update grouped accounts after category change
  Future<void> _updateGroupedAccountsAfterCategoryChange(
    List<AccountDriftModelData> accounts,
    int newCategoryId,
  ) async {
    // Remove accounts from all categories first
    for (final account in accounts) {
      _removeAccountFromAllCategories(account.id);
    }

    // Add accounts to new category
    final decryptedAccounts = await _getDecryptedBasicInfoMany(accounts);
    for (final decryptedAccount in decryptedAccounts) {
      _groupedCategoryIdAccounts.putIfAbsent(newCategoryId, () => []).add(decryptedAccount);
    }

    // Update category total counts - get actual counts from database
    final newCategoryCount = await DriffDbManager.instance.accountAdapter.countByCategory(
      newCategoryId,
    );
    mapCategoryIdTotalAccount[newCategoryId] = newCategoryCount;

    // Also update counts for old categories if needed
    final oldCategoryIds = accounts.map((a) => a.categoryId).toSet();
    for (final oldCategoryId in oldCategoryIds) {
      if (oldCategoryId != newCategoryId) {
        final oldCategoryCount = await DriffDbManager.instance.accountAdapter.countByCategory(
          oldCategoryId,
        );
        mapCategoryIdTotalAccount[oldCategoryId] = oldCategoryCount;
      }
    }

    // Refresh cache
    await refreshDecryptedAccountsCache();

    notifyListeners();
  }
}
