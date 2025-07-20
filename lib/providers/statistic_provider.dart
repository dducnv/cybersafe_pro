import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Nhóm các thống kê liên quan vào một class riêng
class PasswordStatistics {
  final int totalWeak;
  final int totalStrong;
  final int totalSame;
  final List<List<AccountDriftModelData>> sameGroups;
  final List<CategoryDriftModelData> weakByCategories;

  PasswordStatistics({required this.totalWeak, required this.totalStrong, required this.totalSame, required this.sameGroups, required this.weakByCategories});
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
  Future<(AccountDriftModelData, String?)?> _getDecryptedAccount(AccountDriftModelData account, AccountProvider accountProvider) async {
    if (account.password == null || account.password!.isEmpty) return null;

    final encryptData = EncryptAppDataService.instance;
    final baseInfoAccount = await accountProvider.decryptBasicInfo(account);
    final decryptedPassword = await encryptData.decryptPassword(account.password!);

    return (baseInfoAccount, decryptedPassword);
  }

  Future<PasswordStatistics> processAccounts(
    List<AccountDriftModelData> accounts,
    List<CategoryDriftModelData> categories,
    AccountProvider accountProvider, {
    void Function(double progress)? onProgress,
  }) async {
    List<Map<String, dynamic>> decryptedList = [];
    const batchSize = 20;
    for (var i = 0; i < accounts.length; i += batchSize) {
      final batch = accounts.skip(i).take(batchSize);
      final batchResults = await Future.wait(
        batch.map((account) async {
          final decrypted = await _getDecryptedAccount(account, accountProvider);
          if (decrypted == null) return null;
          final (baseInfoAccount, password) = decrypted;
          if (password == null) return null;
          return {'account': baseInfoAccount, 'password': password};
        }),
      );
      decryptedList.addAll(batchResults.whereType<Map<String, dynamic>>());
      // Cập nhật progress nếu có callback
      if (onProgress != null) {
        onProgress((i + batchSize).clamp(0, accounts.length) / accounts.length);
      }
      // Nhường quyền cho UI thread
      await Future.delayed(const Duration(milliseconds: 1));
    }

    final result = await compute(_processAccountsInIsolate, {'decryptedList': decryptedList, 'categories': categories});
    return PasswordStatistics(
      totalWeak: result['totalWeak'],
      totalStrong: result['totalStrong'],
      totalSame: result['totalSame'],
      sameGroups: (result['sameGroups'] as List).map<List<AccountDriftModelData>>((group) => (group as List).cast<AccountDriftModelData>()).toList(),
      weakByCategories: [],
    );
  }

  // Hàm isolate: chỉ xử lý gom nhóm/thống kê, không giải mã
  static Map<String, dynamic> _processAccountsInIsolate(Map<String, dynamic> args) {
    final List<Map<String, dynamic>> decryptedList = List<Map<String, dynamic>>.from(args['decryptedList']);
    final List<CategoryDriftModelData> categories = List<CategoryDriftModelData>.from(args['categories']);
    Map<String, List<AccountDriftModelData>> passwordGroups = {};
    Map<String, List<AccountDriftModelData>> categoryWeakPasswords = {};
    int weakCount = 0;
    int strongCount = 0;
    final String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*()?£\-_=]).{12,}$';
    final regExp = RegExp(pattern);

    for (var item in decryptedList) {
      final AccountDriftModelData account = item['account'];
      final String password = item['password'];
      final bool isStrong = regExp.hasMatch(password);
      if (isStrong) {
        strongCount++;
      } else {
        weakCount++;
        final categoryId = account.categoryId;
        categoryWeakPasswords.putIfAbsent(categoryId.toString(), () => []);
        categoryWeakPasswords[categoryId.toString()]!.add(account);
      }
      passwordGroups.putIfAbsent(password, () => []);
      passwordGroups[password]!.add(account);
    }

    final samePasswordGroups = passwordGroups.values.where((group) => group.length > 1).toList();
    final weakCategories =
        categories
            .map((category) {
              final weakAccounts = categoryWeakPasswords[category.id.toString()] ?? [];
              if (weakAccounts.isEmpty) return null;
              return CategoryDriftModelData(id: category.id, categoryName: category.categoryName, indexPos: category.indexPos, createdAt: category.createdAt, updatedAt: category.updatedAt);
            })
            .whereType<CategoryDriftModelData>()
            .toList();

    return {'totalWeak': weakCount, 'totalStrong': strongCount, 'totalSame': samePasswordGroups.length, 'sameGroups': samePasswordGroups, 'weakByCategories': weakCategories};
  }

  Future<void> init(BuildContext context) async {
    try {
      showLoadingDialog();
      isLoading = true;
      error = null;
      notifyListeners();

      final accountProvider = Provider.of<AccountProvider>(context, listen: false);

      final categories = await DriffDbManager.instance.categoryAdapter.getAll();
      final accounts = await DriffDbManager.instance.accountAdapter.getAll();
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
  List<CategoryDriftModelData> get accountPasswordWeakByCategories => statistics?.weakByCategories ?? [];

  List<List<AccountDriftModelData>> get accountSamePassword => statistics?.sameGroups ?? [];

  int get totalAccountPasswordWeak => statistics?.totalWeak ?? 0;

  int get totalAccountPasswordStrong => statistics?.totalStrong ?? 0;

  int get totalAccountSamePassword => statistics?.totalSame ?? 0;
}
