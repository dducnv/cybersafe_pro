import 'package:flutter/material.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';

class CreateAccountFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  CategoryOjbModel? selectedCategory;
  String? appNameError;
  String? categoryError;

  // Validate từng trường
  bool validateAppName() {
    if (appNameController.text.trim().isEmpty) {
      appNameError = 'Vui lòng nhập tên ứng dụng';
      notifyListeners();
      return false;
    }
    appNameError = null;
    notifyListeners();
    return true;
  }

  bool validateCategory() {
    if (selectedCategory == null) {
      categoryError = 'Vui lòng chọn danh mục';
      notifyListeners();
      return false;
    }
    categoryError = null;
    notifyListeners();
    return true;
  }

  // Validate toàn bộ form
  bool validateForm() {
    bool isValid = true;
    
    if (!validateAppName()) isValid = false;
    if (!validateCategory()) isValid = false;

    return isValid;
  }

  // Xử lý khi chọn category
  void setCategory(CategoryOjbModel category) {
    selectedCategory = category;
    categoryController.text = category.categoryName;
    validateCategory();
  }

  // Reset form
  void resetForm() {
    appNameController.clear();
    usernameController.clear();
    passwordController.clear();
    categoryController.clear();
    otpController.clear();
    noteController.clear();
    selectedCategory = null;
    appNameError = null;
    categoryError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    appNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    categoryController.dispose();
    otpController.dispose();
    noteController.dispose();
    super.dispose();
  }
} 