import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProvider extends ChangeNotifier {
  final Map<int, CategoryOjbModel> _categories = {};
  TextEditingController txtCategoryName = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool isChangedCategoryIndex = false;

  // Getters
  Map<int, CategoryOjbModel> get categories => Map.unmodifiable(_categories);
  List<CategoryOjbModel> get categoryList => _categories.values.toList();
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

  Future<void> getCategories() async {
    await _handleAsync(() async {
      final categoryList = await CategoryBox.getAllAsync();
      categoryList.sort((a, b) => b.indexPos.compareTo(a.indexPos));
      _categories
        ..clear()
        ..addAll({for (var category in categoryList) category.id: category});
    });
  }

  Future<void> initDataCategory(BuildContext context) async {
    logInfo("initDataCategory");
    List<String> listCategory = [CategoryText.bank, CategoryText.job, CategoryText.study, CategoryText.shopping, CategoryText.entertainment];
    for (var category in listCategory) {
      logInfo("category: $category");
      final newCategory = CategoryOjbModel(categoryName: context.read<AppLocale>().categoryLocale.getText(category));
      logInfo("newCategory: ${newCategory.categoryName}");
      await createCategory(newCategory);
    }
  }

  Future<bool> createCategory(CategoryOjbModel category) async {
    final result = await _handleAsync(() async {
      if (category.categoryName.trim().isEmpty) {
        throwAppError(ErrorText.categoryNameEmpty);
      }

      // Kiểm tra trùng tên
      if (_categories.values.any((c) => c.categoryName.toLowerCase() == category.categoryName.toLowerCase())) {
        throwAppError(ErrorText.categoryExists);
      }

      final id = CategoryBox.put(category);
      category.id = id;
      _categories[id] = category;
      txtCategoryName.clear();
      return true;
    });

    return result ?? false;
  }

  Future<bool> updateCategory(CategoryOjbModel category) async {
    final result = await _handleAsync(() async {
      if (category.categoryName.trim().isEmpty) {
        throwAppError(ErrorText.categoryNameEmpty);
      }

      // Kiểm tra trùng tên với các category khác
      if (_categories.values.any((c) => c.id != category.id && c.categoryName.toLowerCase() == category.categoryName.toLowerCase())) {
        throwAppError(ErrorText.categoryExists);
      }

      CategoryBox.put(category);
      _categories[category.id] = category;
      return true;
    });

    return result ?? false;
  }

  Future<bool> deleteCategory(CategoryOjbModel category) async {
    final result = await _handleAsync(() async {
      if (!await CategoryBox.delete(category.id)) {
        throwAppError(ErrorText.cannotDeleteCategory);
      }
      _categories.remove(category.id);
      return true;
    });

    return result ?? false;
  }

  Future<CategoryOjbModel?> getCategoryById(int id) async {
    return await _handleAsync<CategoryOjbModel?>(() async {
      // Kiểm tra trong cache
      if (_categories.containsKey(id)) {
        return _categories[id]!;
      }

      // Query từ database
      final category = await CategoryBox.getByIdAsync(id);
      if (category != null) {
        _categories[id] = category;
        return category;
      }
      throwAppError(ErrorText.categoryNotFound);
      throw Exception('Unreachable code');
    });
  }

  void reorderCategory(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Get sorted list by indexPos
    final List<CategoryOjbModel> sortedList = categoryList..sort((a, b) => b.indexPos.compareTo(a.indexPos));

    // Remove and insert item
    final CategoryOjbModel item = sortedList.removeAt(oldIndex);
    sortedList.insert(newIndex, item);

    // Update positions and cache
    _categories.clear();
    for (int i = 0; i < sortedList.length; i++) {
      final category = sortedList[i];
      category.indexPos = sortedList.length - i;
      _categories[category.id] = category;
    }

    // Batch update to database
    CategoryBox.putMany(sortedList);

    isChangedCategoryIndex = true;
    notifyListeners();
  }

  // Helper method để refresh data
  Future<void> refresh() async {
    _categories.clear();
    await getCategories();
    notifyListeners();
  }

  void clearAllData() {
    _categories.clear();
    categories.clear();
    categoryList.clear();

    notifyListeners();
  }
}
