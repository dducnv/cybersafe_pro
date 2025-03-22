import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:provider/provider.dart';

// Nhóm các thống kê liên quan vào một class riêng
class PasswordStatistics {
  final int totalWeak;
  final int totalStrong;
  final int totalSame;
  final List<List<AccountOjbModel>> sameGroups;
  final List<CategoryOjbModel> weakByCategories;

  PasswordStatistics({
    required this.totalWeak,
    required this.totalStrong,
    required this.totalSame,
    required this.sameGroups,
    required this.weakByCategories,
  });
}

class StatisticProvider extends ChangeNotifier {
  PasswordStatistics? statistics;
  int totalAccount = 0;
  bool isLoading = false;
  String? error;

  // Cache cho kết quả kiểm tra mật khẩu
  final Map<String, bool> _passwordStrengthCache = {};

  bool validateStructure(String value) {
    if (_passwordStrengthCache.containsKey(value)) {
      return _passwordStrengthCache[value]!;
    }

    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*()?£\-_=]).{12,}$';
    RegExp regExp = RegExp(pattern);
    final result = regExp.hasMatch(value);
    _passwordStrengthCache[value] = result;
    return result;
  }

  // Giải mã cả basic info và password cùng lúc
  Future<(AccountOjbModel, String?)?> _getDecryptedAccount(AccountOjbModel account, AccountProvider accountProvider) async {
    if (account.password == null || account.password!.isEmpty) return null;
    
    final encryptData = EncryptAppDataService.instance;
    final baseInfoAccount = await accountProvider.decryptBasicInfo(account);
    final decryptedPassword = await encryptData.decryptPassword(account.password!);
    
    return (baseInfoAccount, decryptedPassword);
  }

  Future<PasswordStatistics> processAccounts(List<AccountOjbModel> accounts, List<CategoryOjbModel> categories, AccountProvider accountProvider) async {
    Map<String, List<AccountOjbModel>> passwordGroups = {};
    Map<String, List<AccountOjbModel>> categoryWeakPasswords = {};
    int weakCount = 0;
    int strongCount = 0;

    // Xử lý từng account
    for (final account in accounts) {
      final decryptedResult = await _getDecryptedAccount(account, accountProvider);
      if (decryptedResult == null) continue;

      final (baseInfoAccount, password) = decryptedResult;
      if (password == null) continue;

      // Kiểm tra mật khẩu yếu/mạnh
      final isStrong = validateStructure(password);
      if (isStrong) {
        strongCount++;
      } else {
        weakCount++;
        final categoryId = account.getCategory?.id;
        if (categoryId != null) {
          categoryWeakPasswords.putIfAbsent(categoryId.toString(), () => []);
          categoryWeakPasswords[categoryId.toString()]!.add(baseInfoAccount);
        }
      }

      // Gom nhóm mật khẩu trùng
      passwordGroups.putIfAbsent(password, () => []);
      passwordGroups[password]!.add(baseInfoAccount);
    }

    // Xử lý mật khẩu trùng
    final samePasswordGroups = passwordGroups.values.where((group) => group.length > 1).toList();

    // Xử lý danh sách mật khẩu yếu theo category
    final weakCategories = categories.map((category) {
      final weakAccounts = categoryWeakPasswords[category.id.toString()] ?? [];
      if (weakAccounts.isEmpty) return null;

      return CategoryOjbModel(
        id: category.id,
        categoryName: category.categoryName,
        indexPos: category.indexPos,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      )..accounts.addAll(weakAccounts);
    }).whereType<CategoryOjbModel>().toList();

    return PasswordStatistics(
      totalWeak: weakCount,
      totalStrong: strongCount,
      totalSame: samePasswordGroups.length,
      sameGroups: samePasswordGroups,
      weakByCategories: weakCategories,
    );
  }

  Future<void> init(BuildContext context) async {
    try {
      showLoadingDialog();
      isLoading = true;
      error = null;
      notifyListeners();

      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);

      final categories = categoryProvider.categoryList;
      final accounts = await AccountBox.getAll();
      totalAccount = accounts.length;

      statistics = await processAccounts(accounts, categories, accountProvider);

      isLoading = false;
      notifyListeners();
      hideLoadingDialog();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      hideLoadingDialog();
    }
  }

  void reset() {
    statistics = null;
    totalAccount = 0;
    isLoading = false;
    error = null;
    _passwordStrengthCache.clear();
    notifyListeners();
  }

  void clearCache() {
    _passwordStrengthCache.clear();
  }

  // Getters để truy cập dễ dàng
  List<CategoryOjbModel> get accountPasswordWeakByCategories => 
      statistics?.weakByCategories ?? [];
  
  List<List<AccountOjbModel>> get accountSamePassword => 
      statistics?.sameGroups ?? [];
  
  int get totalAccountPasswordWeak => statistics?.totalWeak ?? 0;
  
  int get totalAccountPasswordStrong => statistics?.totalStrong ?? 0;
  
  int get totalAccountSamePassword => statistics?.totalSame ?? 0;
}
