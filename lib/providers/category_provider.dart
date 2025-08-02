import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProvider extends ChangeNotifier {
  final Map<int, CategoryDriftModelData> _categories = {};
  TextEditingController txtCategoryName = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool isChangedCategoryIndex = false;

  // Getters
  Map<int, CategoryDriftModelData> get mapCategoryIdCategory => Map.unmodifiable(_categories);
  List<CategoryDriftModelData> get categories => _categories.values.toList();

  Map<int, int> mapCategoryIdTotalAccount = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCategories => _categories.isNotEmpty;

  // Setter cho error với notify
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // Helper để quản lý trạng thái loading
  Future<T?> _handleAsync<T>(Future<T> Function() operation) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      return await operation();
    } catch (e) {
      _setError(e.toString());
      logError("Error: $e");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    txtCategoryName.dispose();
    _categories.clear();
    super.dispose();
  }

  /// Load all categories with parallel account counting for better performance
  Future<void> getCategories() async {
    await _handleAsync(() async {
      // Get all categories and sort by index position
      final categoryList = await DriffDbManager.instance.categoryAdapter.getAll();
      categoryList.sort((a, b) => b.indexPos.compareTo(a.indexPos));

      // Update categories cache
      _categories
        ..clear()
        ..addAll({for (var category in categoryList) category.id: category});

      // Count accounts for all categories in parallel for better performance
      final categoryIds = categoryList.map((c) => c.id).toList();
      final accountCounts = await DriffDbManager.instance.accountAdapter.countByCategories(categoryIds);

      // Update account counts map
      mapCategoryIdTotalAccount.clear();
      for (var category in categoryList) {
        mapCategoryIdTotalAccount[category.id] = accountCounts[category.id] ?? 0;
      }
    });
  }

  Future<void> initDataCategory(BuildContext context) async {
    logInfo("initDataCategory");
    List<String> listCategory = [CategoryText.bank, CategoryText.job, CategoryText.study, CategoryText.shopping, CategoryText.entertainment];
    for (var category in listCategory) {
      if (!context.mounted) return;
      await createCategory(context.read<AppLocale>().categoryLocale.getText(category));
    }
  }

  Future<bool> createCategory(String categoryName) async {
    final result = await _handleAsync(() async {
      if (categoryName.trim().isEmpty) {
        throwAppError(ErrorText.categoryNameEmpty);
      }

      // Kiểm tra trùng tên
      if (_categories.values.any((c) => c.categoryName.toLowerCase() == categoryName.toLowerCase())) {
        throwAppError(ErrorText.categoryExists);
      }

      final id = await DriffDbManager.instance.categoryAdapter.insertCategory(categoryName);
      final newCategory = CategoryDriftModelData(id: id, categoryName: categoryName, indexPos: 0, createdAt: DateTime.now(), updatedAt: DateTime.now());
      _categories[id] = newCategory;
      txtCategoryName.clear();
      return true;
    });

    return result ?? false;
  }

  Future<bool> updateCategory({required int id, required String categoryName}) async {
    final result = await _handleAsync(() async {
      if (categoryName.trim().isEmpty) {
        throwAppError(ErrorText.categoryNameEmpty);
      }
      // Kiểm tra trùng tên với các category khác
      if (_categories.values.any((c) => c.id != id && c.categoryName.toLowerCase() == categoryName.toLowerCase())) {
        throwAppError(ErrorText.categoryExists);
      }
      final newId = await DriffDbManager.instance.categoryAdapter.updateCategory(id, categoryName);
      _categories[newId] = _categories[id]!.copyWith(id: newId, categoryName: categoryName);
      _categories.remove(id);
      return true;
    });
    return result ?? false;
  }

  Future<bool> deleteCategory(CategoryDriftModelData category) async {
    final result = await _handleAsync(() async {
      if (!await DriffDbManager.instance.categoryAdapter.delete(category.id)) {
        throwAppError(ErrorText.cannotDeleteCategory);
      }
      _categories.remove(category.id);
      return true;
    });

    return result ?? false;
  }

  Future<void> reorderCategory(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Get sorted list by indexPos
    final List<CategoryDriftModelData> sortedList = categories..sort((a, b) => b.indexPos.compareTo(a.indexPos));

    // Remove and insert item
    final CategoryDriftModelData item = sortedList.removeAt(oldIndex);
    sortedList.insert(newIndex, item);

    // Update positions and cache
    _categories.clear();
    for (int i = 0; i < sortedList.length; i++) {
      final category = sortedList[i];
      category.copyWith(indexPos: sortedList.length - i);
      _categories[category.id] = category;
    }

    // Batch update to database
    await DriffDbManager.instance.categoryAdapter.putMany(sortedList);
    isChangedCategoryIndex = true;
    notifyListeners();
  }

  // Helper method để refresh data
  Future<void> refresh() async {
    _categories.clear();
    mapCategoryIdTotalAccount.clear();
    await getCategories();
    notifyListeners();
  }

  void clearAllData() {
    _categories.clear();
    mapCategoryIdTotalAccount.clear();
    notifyListeners();
  }
}
