import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final Map<int, CategoryOjbModel> _categories = {};
  final TextEditingController txtCategoryName = TextEditingController();
  bool _isLoading = false;
  String? _error;
  
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
      debugPrint("$operation");
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
      _categories
        ..clear()
        ..addAll({for (var category in categoryList) category.id: category});
    });
  }

  Future<bool> createCategory(CategoryOjbModel category) async {
    final result = await _handleAsync(() async {
      if (category.categoryName.trim().isEmpty) {
        throw Exception('Tên danh mục không được để trống');
      }

      // Kiểm tra trùng tên
      if (_categories.values.any((c) => 
          c.categoryName.toLowerCase() == category.categoryName.toLowerCase())) {
        throw Exception('Danh mục này đã tồn tại');
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
        throw Exception('Tên danh mục không được để trống');
      }

      // Kiểm tra trùng tên với các category khác
      if (_categories.values.any((c) => 
          c.id != category.id && 
          c.categoryName.toLowerCase() == category.categoryName.toLowerCase())) {
        throw Exception('Tên danh mục đã tồn tại');
      }

      CategoryBox.put(category);
      _categories[category.id] = category;
      return true;
    });
    
    return result ?? false;
  }

  Future<bool> deleteCategory(CategoryOjbModel category) async {
    final result = await _handleAsync(() async {
      if (!CategoryBox.delete(category.id)) {
        throw Exception('Không thể xóa danh mục');
      }
      _categories.remove(category.id);
      return true;
    });
    
    return result ?? false;
  }

  Future<CategoryOjbModel?> getCategoryById(int id) async {
    return await _handleAsync(() async {
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
      throw Exception('Không tìm thấy danh mục');
    });
  }

  // Helper method để refresh data
  Future<void> refresh() async {
    _categories.clear();
    await getCategories();
  }
}
