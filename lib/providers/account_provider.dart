import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/DAO/account_dao_model.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

/// AccountProvider manages all account-related operations with parallel processing optimization
/// Handles CRUD operations, caching, search, and category-based grouping
class AccountProvider extends ChangeNotifier {
  // ==================== Constants ====================
  static const int INITIAL_ACCOUNTS_PER_CATEGORY = 5;
  static const int LOAD_MORE_ACCOUNTS_COUNT = 10;
  static const int BATCH_SIZE = 20;

  // ==================== State Management ====================
  final Map<int, AccountDriftModelData> _accounts = {};
  final Map<int, List<AccountDriftModelData>> _groupedCategoryIdAccounts = {};
  final Map<int, CategoryDriftModelData> _categoryCache = {};
  final Map<int, AccountDriftModelData> _basicInfoCache = {};
  final Map<int, int> _categoryAccountCounts = {};
  final Map<int, bool> _expandedCategories = {};
  final Map<int, int> _visibleAccountsPerCategory = {};

  // UI State
  bool _isLoading = false;
  String? _error;
  int? _selectedCategoryId;
  List<AccountDriftModelData> accountSelected = [];

  // ==================== Getters ====================
  Map<int, AccountDriftModelData> get accounts => Map.unmodifiable(_accounts);
  List<AccountDriftModelData> get accountList => _accounts.values.toList();
  bool get hasAccounts => _accounts.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;

  /// Returns grouped accounts based on selected category or all categories
  Map<int, List<AccountDriftModelData>> get groupedAccounts {
    final result = <int, List<AccountDriftModelData>>{};

    if (_selectedCategoryId != null) {
      // Show only selected category
      if (_groupedCategoryIdAccounts.containsKey(_selectedCategoryId)) {
        result[_selectedCategoryId!] = _getVisibleAccounts(_selectedCategoryId!, _groupedCategoryIdAccounts[_selectedCategoryId!] ?? []);
      }
    } else {
      // Show all categories
      _groupedCategoryIdAccounts.forEach((categoryId, accounts) {
        result[categoryId] = _getVisibleAccounts(categoryId, accounts);
      });
    }

    return Map.unmodifiable(result);
  }

  /// Check if category can be expanded (has more accounts to load)
  bool canExpandCategory(int categoryId) {
    final totalCount = _categoryAccountCounts[categoryId] ?? 0;
    final currentCount = _groupedCategoryIdAccounts[categoryId]?.length ?? 0;
    return totalCount > currentCount && !(_expandedCategories[categoryId] == true);
  }

  /// Get total number of accounts in a category
  int getTotalAccountsInCategory(int categoryId) {
    return _categoryAccountCounts[categoryId] ?? 0;
  }

  /// Get number of visible accounts in a category
  int getVisibleAccountsCount(int categoryId) {
    if (_expandedCategories[categoryId] == true) {
      return _groupedCategoryIdAccounts[categoryId]?.length ?? 0;
    } else if (_visibleAccountsPerCategory.containsKey(categoryId)) {
      return _visibleAccountsPerCategory[categoryId]!;
    } else {
      return math.min(INITIAL_ACCOUNTS_PER_CATEGORY, _groupedCategoryIdAccounts[categoryId]?.length ?? 0);
    }
  }

  /// Check if category is expanded
  bool isCategoryExpanded(int categoryId) {
    return _expandedCategories[categoryId] == true;
  }

  // ==================== Category Expansion Management ====================

  /// Toggle category expansion state
  void toggleCategoryExpansion(int categoryId) {
    final currentState = _expandedCategories[categoryId] ?? false;
    _expandedCategories[categoryId] = !currentState;
    notifyListeners();
  }

  /// Expand specific category
  void expandCategory(int categoryId) {
    if (!(_expandedCategories[categoryId] ?? false)) {
      _expandedCategories[categoryId] = true;
      notifyListeners();
    }
  }

  /// Collapse specific category
  void collapseCategory(int categoryId) {
    if (_expandedCategories[categoryId] ?? false) {
      _expandedCategories[categoryId] = false;
      notifyListeners();
    }
  }

  /// Expand all categories
  void expandAllCategories() {
    for (var categoryId in _groupedCategoryIdAccounts.keys) {
      _expandedCategories[categoryId] = true;
    }
    notifyListeners();
  }

  /// Collapse all categories
  void collapseAllCategories() {
    for (var categoryId in _groupedCategoryIdAccounts.keys) {
      _expandedCategories[categoryId] = false;
    }
    notifyListeners();
  }

  /// Reset expansion state for all categories
  void resetExpansionState() {
    _expandedCategories.clear();
    _visibleAccountsPerCategory.clear();
    notifyListeners();
  }

  /// Reset expansion state for specific category
  void resetCategoryExpansion(int categoryId) {
    _expandedCategories.remove(categoryId);
    _visibleAccountsPerCategory.remove(categoryId);
    notifyListeners();
  }

  // ==================== Data Loading Operations ====================

  /// Load all accounts with parallel processing optimization
  Future<void> getAccounts({bool resetExpansion = false}) async {
    await _handleAsync(funcName: "getAccounts", () async {
      // Clear old data
      _clearOldData(resetExpansion);

      // Load categories and cache them
      final categories = await _loadAndCacheCategories();

      // Load accounts for each category with limit (parallel)
      final accountsByCategory = await DriffDbManager.instance.accountAdapter.getByCategoriesWithLimit(categories, INITIAL_ACCOUNTS_PER_CATEGORY);

      // Process accounts for each category (parallel)
      await _processAccountsByCategory(accountsByCategory);

      // Load account counts for each category (parallel)
      await _updateAccountCountsForCategories(categories);
    });
  }

  /// Load more accounts for a specific category
  Future<void> loadMoreAccountsForCategory(int categoryId) async {
    showLoadingDialog();
    await _handleAsync(funcName: "loadMoreAccountsForCategory", () async {
      final currentAccounts = _groupedCategoryIdAccounts[categoryId] ?? [];
      final offset = currentAccounts.length;

      // Load more accounts
      final moreAccounts = await DriffDbManager.instance.accountAdapter.getBasicByCategoryWithLimit(categoryId: categoryId, limit: LOAD_MORE_ACCOUNTS_COUNT, offset: offset);

      if (moreAccounts.isEmpty) return;

      // Filter out existing accounts
      final existingAccountIds = currentAccounts.map((a) => a.id).toSet();
      final newAccounts = moreAccounts.where((a) => !existingAccountIds.contains(a.id)).toList();

      if (newAccounts.isEmpty) return;

      // Decrypt and update cache (parallel)
      await _processNewAccounts(categoryId, newAccounts);

      // Update visible count and check if fully loaded
      _updateVisibleCountAndExpansion(categoryId);

      notifyListeners();
    });
    hideLoadingDialog();
  }

  /// Load all accounts for a specific category
  Future<void> loadAllAccountsForCategory(int categoryId) async {
    await _handleAsync(funcName: "loadAllAccountsForCategory", () async {
      final category = _categoryCache[categoryId];
      if (category == null) return;

      // Load all accounts for category
      final allAccounts = await DriffDbManager.instance.accountAdapter.getBasicByCategoryWithLimit(categoryId: categoryId);

      // Filter out existing accounts
      final currentAccounts = _groupedCategoryIdAccounts[categoryId] ?? [];
      final currentAccountIds = currentAccounts.map((a) => a.id).toSet();
      final newAccounts = allAccounts.where((a) => !currentAccountIds.contains(a.id)).toList();

      if (newAccounts.isEmpty) {
        _markCategoryAsExpanded(categoryId);
        return;
      }

      // Process new accounts (parallel)
      await _processNewAccounts(categoryId, newAccounts);
      _markCategoryAsExpanded(categoryId);
    });
  }

  // ==================== Create & Update Account ====================

  Future<bool> createAccountFromForm(AccountFormProvider form) async {
    if (!form.validateForm()) {
      return false;
    }

    return await _handleAsync(funcName: "createAccountFromForm", () async {
          showLoadingDialog();
          final now = DateTime.now();
          final AccountDaoModel newAccountDrift = AccountDaoModel(
            account: AccountDriftModelData(
              id: form.accountId,
              icon: form.branchLogoSelected?.branchLogoSlug,
              title: form.appNameController.text.trim(),
              username: form.usernameController.text.trim(),
              password: form.passwordController.text,
              categoryId: form.selectedCategory!.id,
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
                    ? TOTPDriftModelData(id: 0, accountId: form.accountId, secretKey: form.otpController.text.toUpperCase().trim(), isShowToHome: false, createdAt: now, updatedAt: now)
                    : null,
          );

          final result = await createOrUpdateAccount(newAccountDrift, isUpdate: form.accountId != 0);
          if (result) {
            form.resetForm();
          }
          hideLoadingDialog();
          return result;
        }) ??
        false;
  }

  Future<bool> createAccountOnlyOtp({required String secretKey, required String appName, required String accountName}) async {
    if (!OTP.isKeyValid(secretKey)) {
      return false;
    }

    return await _handleAsync(funcName: "createAccountOnlyOtp", () async {
          showLoadingDialog();

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
              totp: TOTPDriftModelCompanion(secretKey: Value(normalizedSecretKey), isShowToHome: const Value(true)),
            );

            return newAccount != null;
          } finally {
            hideLoadingDialog();
          }
        }) ??
        false;
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

  Future<bool> createOrUpdateAccount(AccountDaoModel accountDaoModel, {bool isUpdate = false}) async {
    final stopwatch = Stopwatch()..start();
    final result = await _handleAsync(funcName: isUpdate ? "updateAccount" : "createAccount", () async {
      if (accountDaoModel.account.title.trim().isEmpty) {
        throw Exception('Tên tài khoản không được để trống');
      }

      AccountDriftModelData? accountToSave;
      if (isUpdate) {
        // Update logic
        AccountDriftModelData? currentAccount = accountDaoModel.account.id != 0 ? await DriffDbManager.instance.accountAdapter.getById(accountDaoModel.account.id) : null;
        if (currentAccount == null) throw Exception('Account not found');
        await DriffDbManager.instance.updateAccountWithEncriptData(
          account: accountDaoModel.account.toCompanion(true),
          customFields: accountDaoModel.customFields.map((e) => e.toCompanion(true)).toList(),
          totp: accountDaoModel.totp?.toCompanion(true),
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
      logInfo('${isUpdate ? "updateAccount" : "createAccount"}: _encryptAccount completed in: ${elapsedTime.inMilliseconds}ms');

      _accounts[accountToSave!.id] = accountToSave;
      _basicInfoCache.remove(accountToSave.id);
      logInfo('${isUpdate ? "updateAccount" : "createAccount"}: Operation completed in: ${elapsedTime.inMilliseconds}ms');
      return true;
    });

    if (result != null) {
      await getAccounts();
    }
    return result ?? false;
  }

  // ==================== Search Operations ====================

  /// Search accounts by query with parallel decryption
  Future<List<AccountDriftModelData>> searchAccounts(String query) async {
    final result = await _handleAsync<List<AccountDriftModelData>>(funcName: "searchAccounts", () async {
      if (query.isEmpty) return <AccountDriftModelData>[];

      final queryLower = query.toLowerCase();
      final accounts = await DriffDbManager.instance.accountAdapter.getAll();
      final decryptedAccounts = await _getDecryptedBasicInfoMany(accounts);

      // Search in decrypted data
      return decryptedAccounts.where((account) {
        final titleMatch = account.title.toLowerCase().contains(queryLower);
        final usernameMatch = account.username?.toLowerCase().contains(queryLower) ?? false;
        return titleMatch || usernameMatch;
      }).toList();
    });

    return result ?? <AccountDriftModelData>[];
  }

  // ==================== CRUD Operations ====================

  /// Delete a single account
  Future<bool> deleteAccount(AccountDriftModelData account) async {
    final result = await _handleAsync(funcName: "deleteAccount", () async {
      final isDeleted = await DriffDbManager.instance.accountAdapter.delete(account.id);
      if (!isDeleted) {
        throw Exception('Cannot delete account');
      }

      // Remove from cache
      _removeAccountFromCache(account);
      await refreshAccounts();
      return true;
    });
    return result ?? false;
  }

  /// Delete multiple selected accounts (parallel)
  Future<bool> handleDeleteAllSelectedAccounts() async {
    final result = await _handleAsync(funcName: "deleteAllAccount", () async {
      showLoadingDialog();
      try {
        final listIds = accountSelected.map((e) => e.id).toList();
        final deletedCount = await DriffDbManager.instance.accountAdapter.deleteMany(listIds);

        if (deletedCount != listIds.length) {
          throw Exception('Cannot delete some accounts');
        }

        // Remove from cache (parallel)
        await Future.wait(
          accountSelected.map((account) async {
            _removeAccountFromCache(account);
          }),
        );

        handleClearAccountsSelected();
        return true;
      } finally {
        hideLoadingDialog();
      }
    });

    return result ?? false;
  }

  // ==================== Category Management ====================

  /// Select or deselect a category
  void selectCategory(int? categoryId, {required BuildContext context}) {
    final accountFormProvider = Provider.of<AccountFormProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null;
      accountFormProvider.setCategoryNull();
    } else {
      _selectedCategoryId = categoryId;
      accountFormProvider.setCategory(categoryProvider.categories[categoryId]!);
    }
    notifyListeners();
  }

  /// Change category for selected accounts (parallel)
  Future<void> handleChangeCategory(CategoryDriftModelData category) async {
    final futures = accountSelected.map((account) => DriffDbManager.instance.accountAdapter.updateAccount(account.id, AccountDriftModelCompanion(categoryId: Value(category.id))));

    final updatedAccounts = (await Future.wait(futures)).whereType<AccountDriftModelData>().toList();
    await DriffDbManager.instance.accountAdapter.putMany(updatedAccounts);

    handleClearAccountsSelected();
    await refreshAccounts();
    notifyListeners();
  }

  // ==================== Account Selection ====================

  /// Select or remove account from selection
  void handleSelectOrRemoveAccount(AccountDriftModelData account) {
    if (accountSelected.contains(account)) {
      accountSelected = List.from(accountSelected)..remove(account);
    } else {
      accountSelected = List.from(accountSelected)..add(account);
    }
    notifyListeners();
  }

  /// Clear selected accounts
  void handleClearAccountsSelected() {
    accountSelected = [];
    notifyListeners();
  }

  // ==================== Parallel Operations ====================

  /// Load all accounts for multiple categories (parallel)
  Future<Map<int, List<AccountDriftModelData>>> loadAllAccountsForCategoriesParallel(List<int> categoryIds) async {
    final futures =
        categoryIds.map((categoryId) async {
          final accounts = await DriffDbManager.instance.accountAdapter.getByCategory(categoryId);
          final decryptedAccounts = await _getDecryptedBasicInfoMany(accounts);
          return MapEntry(categoryId, decryptedAccounts);
        }).toList();

    final results = await Future.wait(futures);
    return Map.fromEntries(results);
  }

  /// Load more accounts for multiple categories (parallel)
  Future<Map<int, List<AccountDriftModelData>>> loadMoreAccountsForCategoriesParallel(Map<int, int> categoryOffsets, int loadCount) async {
    final futures =
        categoryOffsets.entries.map((entry) async {
          final categoryId = entry.key;
          final offset = entry.value;

          final accounts = await DriffDbManager.instance.accountAdapter.getBasicByCategoryWithLimit(categoryId: categoryId, limit: loadCount, offset: offset);
          final decryptedAccounts = await _getDecryptedBasicInfoMany(accounts);
          return MapEntry(categoryId, decryptedAccounts);
        }).toList();

    final results = await Future.wait(futures);
    return Map.fromEntries(results);
  }

  /// Update cache for multiple categories (parallel)
  Future<void> updateCacheForCategoriesParallel(Map<int, List<AccountDriftModelData>> accountsByCategory) async {
    final futures =
        accountsByCategory.entries.map((entry) async {
          final categoryId = entry.key;
          final accounts = entry.value;

          // Update _accounts and _groupedCategoryIdAccounts (parallel)
          await Future.wait([
            Future.wait(
              accounts.map((account) async {
                _accounts[account.id] = account;
              }),
            ),
            Future.wait(
              accounts.map((account) async {
                _groupedCategoryIdAccounts.putIfAbsent(categoryId, () => []).add(account);
              }),
            ),
          ]);
        }).toList();

    await Future.wait(futures);
  }

  /// Load initial data (categories + accounts + counts) with parallel processing
  Future<void> loadInitialDataParallel() async {
    final futures = await Future.wait([
      DriffDbManager.instance.categoryAdapter.getAll(),
      DriffDbManager.instance.accountAdapter.getByCategoriesWithLimit(await DriffDbManager.instance.categoryAdapter.getAll(), INITIAL_ACCOUNTS_PER_CATEGORY),
      DriffDbManager.instance.accountAdapter.countByCategories((await DriffDbManager.instance.categoryAdapter.getAll()).map((c) => c.id).toList()),
    ]);

    final categories = futures[0] as List<CategoryDriftModelData>;
    final accountsByCategory = futures[1] as Map<int, List<AccountDriftModelData>>;
    final countsByCategory = futures[2] as Map<int, int>;

    // Update cache (parallel)
    await Future.wait([
      // Update category cache
      Future.wait(
        categories.map((category) async {
          _categoryCache[category.id] = category;
        }),
      ),
      // Update accounts cache and decrypt
      Future.wait(
        accountsByCategory.entries.map((entry) async {
          final categoryId = entry.key;
          final accounts = entry.value;
          final decryptedAccounts = await _getDecryptedBasicInfoMany(accounts);

          await Future.wait([
            Future.wait(
              accounts.map((account) async {
                _accounts[account.id] = account;
              }),
            ),
            Future.wait(
              decryptedAccounts.map((account) async {
                _groupedCategoryIdAccounts.putIfAbsent(categoryId, () => []).add(account);
              }),
            ),
          ]);
        }),
      ),
      // Update counts
      Future.wait(
        countsByCategory.entries.map((entry) async {
          _categoryAccountCounts[entry.key] = entry.value;
        }),
      ),
    ]);
  }

  // ==================== Statistics Operations ====================

  /// Get account statistics by categories (parallel)
  Future<Map<int, Map<String, dynamic>>> getAccountStatisticsByCategories(List<int> categoryIds) async {
    return await DriffDbManager.instance.accountAdapter.getStatisticsByCategories(categoryIds);
  }

  /// Delete multiple accounts (parallel)
  Future<int> deleteManyAccountsParallel(List<int> accountIds) async {
    return await DriffDbManager.instance.accountAdapter.deleteManyParallel(accountIds);
  }

  // ==================== Utility Operations ====================

  /// Refresh accounts with optional expansion reset
  Future<void> refreshAccounts({bool resetExpansion = false}) async {
    showLoadingDialog();
    await getAccounts(resetExpansion: resetExpansion);
    hideLoadingDialog();
  }

  /// Clear all cached data
  void clearDecryptedCache() {
    _basicInfoCache.clear();
    notifyListeners();
  }

  // ==================== Private Helper Methods ====================

  /// Clear old data and reset state
  void _clearOldData(bool resetExpansion) {
    _accounts.clear();
    _groupedCategoryIdAccounts.clear();
    _categoryCache.clear();
    _basicInfoCache.clear();
    _visibleAccountsPerCategory.clear();

    if (resetExpansion) {
      _expandedCategories.clear();
    }
  }

  /// Load and cache categories
  Future<List<CategoryDriftModelData>> _loadAndCacheCategories() async {
    final categories = await DriffDbManager.instance.categoryAdapter.getAll();
    categories.sort((a, b) => b.indexPos.compareTo(a.indexPos));

    for (var category in categories) {
      _categoryCache[category.id] = category;
    }

    return categories;
  }

  /// Process accounts for each category (parallel)
  Future<void> _processAccountsByCategory(Map<int, List<AccountDriftModelData>> accountsByCategory) async {
    for (var categoryId in accountsByCategory.keys) {
      final accounts = accountsByCategory[categoryId] ?? [];
      final category = _categoryCache[categoryId] ?? CategoryDriftModelData(id: 0, categoryName: 'Unknown', indexPos: 0, createdAt: DateTime.now(), updatedAt: DateTime.now());

      // Decrypt accounts (parallel)
      final decryptedAccounts = await _getDecryptedBasicInfoMany(accounts);

      // Update cache
      for (var i = 0; i < accounts.length; i++) {
        final account = accounts[i];
        final decryptedAccount = decryptedAccounts[i];

        _accounts[account.id] = account;
        _groupedCategoryIdAccounts.putIfAbsent(category.id, () => []).add(decryptedAccount);
      }

      notifyListeners();
    }
  }

  /// Process new accounts (parallel)
  Future<void> _processNewAccounts(int categoryId, List<AccountDriftModelData> newAccounts) async {
    final decryptedAccounts = await _getDecryptedBasicInfoMany(newAccounts);

    // Update cache (parallel)
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
  }

  /// Update visible count and check expansion
  void _updateVisibleCountAndExpansion(int categoryId) {
    final currentVisibleCount = _visibleAccountsPerCategory[categoryId] ?? INITIAL_ACCOUNTS_PER_CATEGORY;
    _visibleAccountsPerCategory[categoryId] = currentVisibleCount + LOAD_MORE_ACCOUNTS_COUNT;

    final totalCount = _categoryAccountCounts[categoryId] ?? 0;
    final currentCount = _groupedCategoryIdAccounts[categoryId]?.length ?? 0;

    if (currentCount >= totalCount) {
      _markCategoryAsExpanded(categoryId);
    }
  }

  /// Mark category as expanded
  void _markCategoryAsExpanded(int categoryId) {
    _expandedCategories[categoryId] = true;
    _visibleAccountsPerCategory.remove(categoryId);
    notifyListeners();
  }

  /// Remove account from cache
  void _removeAccountFromCache(AccountDriftModelData account) {
    _accounts.remove(account.id);
    _basicInfoCache.remove(account.id);
    _groupedCategoryIdAccounts[account.categoryId]?.remove(account);
    _categoryAccountCounts[account.categoryId] = _groupedCategoryIdAccounts[account.categoryId]?.length ?? 0;
  }

  /// Update account counts for categories (parallel)
  Future<void> _updateAccountCountsForCategories(List<CategoryDriftModelData> categories) async {
    final categoryIds = categories.map((c) => c.id).toList();
    final countsByCategory = await DriffDbManager.instance.accountAdapter.countByCategories(categoryIds);
    _categoryAccountCounts.addAll(countsByCategory);
  }

  /// Get visible accounts for a category
  List<AccountDriftModelData> _getVisibleAccounts(int categoryId, List<AccountDriftModelData> accounts) {
    if (_expandedCategories[categoryId] == true) {
      return accounts;
    } else if (_visibleAccountsPerCategory.containsKey(categoryId)) {
      final visibleCount = _visibleAccountsPerCategory[categoryId]!;
      return accounts.take(visibleCount).toList();
    } else if (accounts.length <= INITIAL_ACCOUNTS_PER_CATEGORY) {
      return accounts;
    } else {
      return accounts.take(INITIAL_ACCOUNTS_PER_CATEGORY).toList();
    }
  }

  /// Decrypt basic info for a single account
  Future<AccountDriftModelData> _getDecryptedBasicInfo(AccountDriftModelData account) async {
    // Check cache first
    if (_basicInfoCache.containsKey(account.id)) {
      return _basicInfoCache[account.id]!;
    }

    final titleDecrypted = await DataSecureService.decryptInfo(account.title);
    final usernameDecrypted = await DataSecureService.decryptInfo(account.username ?? '');

    final decryptedAccount = AccountDriftModelData(
      id: account.id,
      title: titleDecrypted,
      username: usernameDecrypted,
      categoryId: account.categoryId,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );

    // Cache the result
    _basicInfoCache[account.id] = decryptedAccount;
    return decryptedAccount;
  }

  /// Decrypt basic info for multiple accounts (parallel)
  Future<List<AccountDriftModelData>> _getDecryptedBasicInfoMany(List<AccountDriftModelData> accounts) async {
    final futures = accounts.map((account) => _getDecryptedBasicInfo(account)).toList();
    return await Future.wait(futures);
  }

  /// Decrypt full account data
  Future<AccountDriftModelData> decryptAccount(AccountDriftModelData account) async {
    final titleDecrypted = await DataSecureService.decryptInfo(account.title);
    final usernameDecrypted = await DataSecureService.decryptInfo(account.username ?? '');
    final passwordDecrypted = await DataSecureService.decryptPassword(account.password ?? '');
    final notesDecrypted = await DataSecureService.decryptInfo(account.notes ?? '');

    return account.copyWith(title: titleDecrypted, username: Value(usernameDecrypted), password: Value(passwordDecrypted), notes: Value(notesDecrypted));
  }

  /// Decrypt basic info for display
  Future<AccountDriftModelData> decryptBasicInfo(AccountDriftModelData account) async {
    return await _getDecryptedBasicInfo(account);
  }

  /// Set error state
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  /// Handle async operations with loading state and error handling
  Future<T?> _handleAsync<T>(Future<T> Function() operation, {required String funcName}) async {
    final stopwatch = Stopwatch()..start();
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await operation();

      final elapsedTime = stopwatch.elapsed;
      logInfo('$funcName: Operation completed in: ${elapsedTime.inMilliseconds}ms');

      // Add small delay if operation is too fast for user to see loading
      if (elapsedTime.inMilliseconds < 300) {
        await Future.delayed(Duration(milliseconds: 300 - elapsedTime.inMilliseconds));
      }

      return result;
    } catch (e) {
      final elapsedTime = stopwatch.elapsed;
      _setError(e.toString());
      logError('$funcName: Error after ${elapsedTime.inMilliseconds}ms: $e');
      return null;
    } finally {
      stopwatch.stop();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Lifecycle ====================

  @override
  void dispose() {
    _basicInfoCache.clear();
    _categoryCache.clear();
    _accounts.clear();
    _expandedCategories.clear();
    _categoryAccountCounts.clear();
    _visibleAccountsPerCategory.clear();
    super.dispose();
  }
}
