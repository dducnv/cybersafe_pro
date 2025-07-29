import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/services/account/account_services.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class HomeProvider extends ChangeNotifier {
  late AccountProvider accountProvider;
  late CategoryProvider categoryProvider;

  HomeProvider({required this.accountProvider, required this.categoryProvider}) {
    // Listen to changes in AccountProvider
    accountProvider.addListener(_onAccountProviderChanged);
  }

  @override
  void dispose() {
    accountProvider.removeListener(_onAccountProviderChanged);
    super.dispose();
  }
  
  void _onAccountProviderChanged() {
    notifyListeners();
  }

  /// Refresh category counts when needed
  Future<void> refreshCategoryCounts() async {
    final categoryIds = categoryProvider.mapCategoryIdCategory.keys.toList();
    await accountProvider.getTotalAccountsByCategory(categoryIds: categoryIds);
  }

  // ==================== Constants ====================
  static const int INITIAL_ACCOUNTS_PER_CATEGORY = 5;
  static const int LOAD_MORE_ACCOUNTS_COUNT = 10;
  static const int BATCH_SIZE = 20;

  final Map<int, bool> _expandedCategories = {};
  final Map<int, int> _visibleAccountsPerCategory = {};

  // UI State
  final bool _isLoading = false;
  String? _error;
  int? _selectedCategoryId;
  List<AccountDriftModelData> accountSelected = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;

  /// Initialize data and update grouped accounts for UI
  Future<void> initData() async {
    _expandedCategories.clear();
    _visibleAccountsPerCategory.clear();
    await AccountServices.instance.getListIconCustom();
    await categoryProvider.getCategories();
    await accountProvider.getLimitAccountsByCategory(mapCategories: categoryProvider.mapCategoryIdCategory, limit: INITIAL_ACCOUNTS_PER_CATEGORY);

    for (final categoryId in categoryProvider.mapCategoryIdCategory.keys) {
      final totalAccounts = accountProvider.groupedAccountsByCategoryId[categoryId]?.length ?? 0;
      if (totalAccounts > INITIAL_ACCOUNTS_PER_CATEGORY) {
        _visibleAccountsPerCategory[categoryId] = INITIAL_ACCOUNTS_PER_CATEGORY;
      }
    }

    notifyListeners();
  }

  Future<void> refreshData() async {
    clearData();
    await initData();
  }

  Map<int, List<AccountDriftModelData>> get groupedAccounts {
    final result = <int, List<AccountDriftModelData>>{};

    if (_selectedCategoryId != null) {
      // Show only selected category
      if (accountProvider.groupedAccountsByCategoryId.containsKey(_selectedCategoryId)) {
        result[_selectedCategoryId!] = _getVisibleAccounts(_selectedCategoryId!, accountProvider.groupedAccountsByCategoryId[_selectedCategoryId!] ?? []);
      }
    } else {
      // Show all categories
      accountProvider.groupedAccountsByCategoryId.forEach((categoryId, accounts) {
        result[categoryId] = _getVisibleAccounts(categoryId, accounts);
      });
    }
    return Map.unmodifiable(result);
  }

  bool canExpandCategory(int categoryId) {
    final totalCount = categoryProvider.mapCategoryIdTotalAccount[categoryId] ?? 0;
    final currentCount = accountProvider.groupedAccountsByCategoryId[categoryId]?.length ?? 0;
    final visibleCount = _getVisibleAccounts(categoryId, accountProvider.groupedAccountsByCategoryId[categoryId] ?? []).length;
    final hasMoreToLoad = totalCount > currentCount;
    final hasMoreToShow = visibleCount < currentCount;
    final isNotExpanded = !(_expandedCategories[categoryId] == true);

    return (hasMoreToLoad || hasMoreToShow) && isNotExpanded;
  }

  /// Expand specific category
  void expandCategory(int categoryId) {
    if (!(_expandedCategories[categoryId] ?? false)) {
      _expandedCategories[categoryId] = true;
      notifyListeners();
    }
  }

  Future<void> loadMoreAccountsForCategory(int categoryId) async {
    final currentAccounts = accountProvider.groupedAccountsByCategoryId[categoryId] ?? [];
    final offset = currentAccounts.length;

    final moreAccounts = await accountProvider.loadMoreAccountsForCategory(categoryId: categoryId, limit: LOAD_MORE_ACCOUNTS_COUNT, offset: offset);

    if (moreAccounts.isEmpty) return;

    // AccountProvider đã filter duplicates rồi, không cần filter lại

    // Update visible count and expansion state
    _updateVisibleCountAndExpansion(categoryId);

    // Force UI update after loading more accounts
    notifyListeners();
  }

  void handleSelectAccount(AccountDriftModelData account) {
    if (accountSelected.contains(account)) {
      accountSelected = List.from(accountSelected)..remove(account);
    } else {
      accountSelected = List.from(accountSelected)..add(account);
    }
    notifyListeners();
  }

  void selectCategory(int? categoryId, {required BuildContext context}) {
    final accountFormProvider = Provider.of<AccountFormProvider>(context, listen: false);

    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null;
      accountFormProvider.setCategoryNull();
    } else {
      _selectedCategoryId = categoryId;
      accountFormProvider.setCategory(categoryProvider.mapCategoryIdCategory[categoryId]!);
    }
    notifyListeners();
  }

  void handleClearAccountsSelected() {
    accountSelected = [];
    notifyListeners();
  }

  void _updateVisibleCountAndExpansion(int categoryId) {
    final currentVisibleCount = _visibleAccountsPerCategory[categoryId] ?? INITIAL_ACCOUNTS_PER_CATEGORY;
    final newVisibleCount = currentVisibleCount + LOAD_MORE_ACCOUNTS_COUNT;
    _visibleAccountsPerCategory[categoryId] = newVisibleCount;

    final totalCount = categoryProvider.mapCategoryIdTotalAccount[categoryId] ?? 0;
    final currentCount = accountProvider.groupedAccountsByCategoryId[categoryId]?.length ?? 0;

    if (currentCount >= totalCount) {
      _markCategoryAsExpanded(categoryId);
    }
    notifyListeners();
  }

  /// Mark category as expanded
  void _markCategoryAsExpanded(int categoryId) {
    _expandedCategories[categoryId] = true;
    _visibleAccountsPerCategory.remove(categoryId);
    notifyListeners();
  }

  /// Get visible accounts for a category
  List<AccountDriftModelData> _getVisibleAccounts(int categoryId, List<AccountDriftModelData> accounts) {
    if (_expandedCategories[categoryId] == true) {
      return accounts;
    } else if (_visibleAccountsPerCategory.containsKey(categoryId)) {
      final visibleCount = _visibleAccountsPerCategory[categoryId]!;
      final visibleAccounts = accounts.take(visibleCount).toList();
      return visibleAccounts;
    } else if (accounts.length <= INITIAL_ACCOUNTS_PER_CATEGORY) {
      return accounts;
    } else {
      final visibleAccounts = accounts.take(INITIAL_ACCOUNTS_PER_CATEGORY).toList();
      return visibleAccounts;
    }
  }

  // ==================== Expansion Management Methods ====================

  /// Toggle category expansion state
  void toggleCategoryExpansion(int categoryId) {
    final currentState = _expandedCategories[categoryId] ?? false;
    _expandedCategories[categoryId] = !currentState;
    notifyListeners();
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
    for (var categoryId in accountProvider.groupedAccountsByCategoryId.keys) {
      _expandedCategories[categoryId] = true;
    }
    notifyListeners();
  }

  /// Collapse all categories
  void collapseAllCategories() {
    for (var categoryId in accountProvider.groupedAccountsByCategoryId.keys) {
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

  /// Check if category is expanded
  bool isCategoryExpanded(int categoryId) {
    return _expandedCategories[categoryId] == true;
  }

  /// Get visible accounts count for a category
  int getVisibleAccountsCount(int categoryId) {
    if (_expandedCategories[categoryId] == true) {
      return accountProvider.groupedAccountsByCategoryId[categoryId]?.length ?? 0;
    } else if (_visibleAccountsPerCategory.containsKey(categoryId)) {
      return _visibleAccountsPerCategory[categoryId]!;
    } else {
      return math.min(INITIAL_ACCOUNTS_PER_CATEGORY, accountProvider.groupedAccountsByCategoryId[categoryId]?.length ?? 0);
    }
  }

  /// Load all accounts for a category
  Future<void> loadAllAccountsForCategory(int categoryId) async {
    // Mark category as expanded to show all accounts
    _expandedCategories[categoryId] = true;
    _visibleAccountsPerCategory.remove(categoryId);
    notifyListeners();
  }

  void clearData() {
    _expandedCategories.clear();
    _visibleAccountsPerCategory.clear();
    accountSelected.clear();
    notifyListeners();
  }
}
