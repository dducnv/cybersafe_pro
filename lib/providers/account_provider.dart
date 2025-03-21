import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/database/models/account_custom_field.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/database/models/password_history_model.dart';
import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class AccountProvider extends ChangeNotifier {
  final Map<int, AccountOjbModel> _accounts = {};

  bool _isLoading = false;
  String? _error;

  // Map để lưu accounts theo category
  final Map<int, List<AccountOjbModel>> _groupedCategoryIdAccounts = {};

  // Map để lưu trạng thái hiển thị của mỗi category (true = hiển thị tất cả, false = hiển thị giới hạn)
  final Map<int, bool> _expandedCategories = {};

  // Số lượng account hiển thị ban đầu cho mỗi category
  static const int INITIAL_ACCOUNTS_PER_CATEGORY = 5;

  // Số lượng account tải thêm mỗi lần nhấn "Xem thêm"
  static const int LOAD_MORE_ACCOUNTS_COUNT = 10;

  // Thêm cache cho basic info
  final Map<int, AccountOjbModel> _basicInfoCache = {};

  // Thêm cache cho category để tránh query lại
  final Map<int, CategoryOjbModel> _categoryCache = {};

  // Thêm batch size để xử lý từng phần
  static const int BATCH_SIZE = 20;

  // Map để lưu số lượng tài khoản trong mỗi category
  final Map<int, int> _categoryAccountCounts = {};

  // Thêm map để lưu số lượng tài khoản hiển thị cho mỗi category
  final Map<int, int> _visibleAccountsPerCategory = {};

  // Thêm thuộc tính để lưu category đang được chọn
  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  // Getters
  Map<int, AccountOjbModel> get accounts => Map.unmodifiable(_accounts);
  List<AccountOjbModel> get accountList => _accounts.values.toList();
  bool get hasAccounts => _accounts.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getter cho accounts đã được lọc
  Map<int, List<AccountOjbModel>> get groupedAccounts {
    final result = <int, List<AccountOjbModel>>{};

    // Nếu có category được chọn, chỉ hiển thị accounts của category đó
    if (_selectedCategoryId != null) {
      if (_groupedCategoryIdAccounts.containsKey(_selectedCategoryId)) {
        result[_selectedCategoryId!] = _getVisibleAccounts(_selectedCategoryId!, _groupedCategoryIdAccounts[_selectedCategoryId!] ?? []);
      }
    } else {
      // Nếu không có category được chọn, hiển thị tất cả
      _groupedCategoryIdAccounts.forEach((categoryId, accounts) {
        result[categoryId] = _getVisibleAccounts(categoryId, accounts);
      });
    }

    return Map.unmodifiable(result);
  }

  // Helper method để lấy số lượng accounts hiển thị
  List<AccountOjbModel> _getVisibleAccounts(int categoryId, List<AccountOjbModel> accounts) {
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

  // Getter để biết category có thể xem thêm không
  bool canExpandCategory(int categoryId) {
    final totalCount = _categoryAccountCounts[categoryId] ?? 0;
    final currentCount = _groupedCategoryIdAccounts[categoryId]?.length ?? 0;
    return totalCount > currentCount && (_expandedCategories[categoryId] != true);
  }

  // Getter để lấy tổng số account trong category
  int getTotalAccountsInCategory(int categoryId) {
    return _categoryAccountCounts[categoryId] ?? 0;
  }

  // Phương thức để mở rộng/thu gọn category
  void toggleCategoryExpansion(int categoryId) {
    final currentState = _expandedCategories[categoryId] ?? false;
    _expandedCategories[categoryId] = !currentState;
    notifyListeners();
  }

  // Phương thức để mở rộng category
  void expandCategory(int categoryId) {
    if (!(_expandedCategories[categoryId] ?? false)) {
      _expandedCategories[categoryId] = true;
      notifyListeners();
    }
  }

  // Phương thức để thu gọn category
  void collapseCategory(int categoryId) {
    if (_expandedCategories[categoryId] ?? false) {
      _expandedCategories[categoryId] = false;
      notifyListeners();
    }
  }

  // Phương thức để mở rộng tất cả các category
  void expandAllCategories() {
    for (var categoryId in _groupedCategoryIdAccounts.keys) {
      _expandedCategories[categoryId] = true;
    }
    notifyListeners();
  }

  // Phương thức để thu gọn tất cả các category
  void collapseAllCategories() {
    for (var categoryId in _groupedCategoryIdAccounts.keys) {
      _expandedCategories[categoryId] = false;
    }
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<List<AccountOjbModel>> searchAccounts(String query) async {
    final result = await _handleAsync<List<AccountOjbModel>>(funcName: "searchAccounts", () async {
      if (query.isEmpty) return <AccountOjbModel>[];

      final queryLower = query.toLowerCase();
      // Lấy tất cả tài khoản và giải mã
      final accounts = await AccountBox.getAll();
      final decryptedAccounts = await Future.wait(accounts.map((account) => _getDecryptedBasicInfo(account)));

      // Tìm kiếm trong dữ liệu đã giải mã
      return decryptedAccounts.where((account) {
        final titleMatch = account.title.toLowerCase().contains(queryLower);
        final emailMatch = account.email?.toLowerCase().contains(queryLower) ?? false;
        return titleMatch || emailMatch;
      }).toList();
    });

    return result ?? <AccountOjbModel>[];
  }

  // Helper để quản lý trạng thái loading
  Future<T?> _handleAsync<T>(Future<T> Function() operation, {required String funcName}) async {
    final stopwatch = Stopwatch()..start();
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await operation();

      // Kiểm tra thời gian thực thi
      final elapsedTime = stopwatch.elapsed;
      debugPrint('$funcName: Thao tác hoàn thành trong: ${elapsedTime.inMilliseconds}ms');

      // Nếu thao tác quá nhanh (dưới 300ms), thêm độ trễ nhỏ để người dùng thấy loading
      if (elapsedTime.inMilliseconds < 300) {
        await Future.delayed(Duration(milliseconds: 300 - elapsedTime.inMilliseconds));
      }

      return result;
    } catch (e) {
      final elapsedTime = stopwatch.elapsed;
      _setError(e.toString());
      debugPrint('$funcName: Lỗi sau ${elapsedTime.inMilliseconds}ms: $e');
      return null;
    } finally {
      stopwatch.stop();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tối ưu decrypt basic info bằng cách cache key
  Future<AccountOjbModel> _getDecryptedBasicInfo(AccountOjbModel account) async {
    // Kiểm tra cache trước
    if (_basicInfoCache.containsKey(account.id)) {
      return _basicInfoCache[account.id]!;
    }

    final encryptData = EncryptAppDataService.instance;
    final decryptedAccount = AccountOjbModel.fromModel(account);

    // Giải mã title và email riêng biệt để tránh lỗi kiểu dữ liệu
    decryptedAccount.title = await encryptData.decryptInfo(account.title);

    if (account.email != null) {
      decryptedAccount.email = await encryptData.decryptInfo(account.email!);
    }

    // Lưu vào cache
    _basicInfoCache[account.id] = decryptedAccount;
    return decryptedAccount;
  }

  Future<void> getAccounts({bool resetExpansion = false}) async {
    await _handleAsync(funcName: "getAccounts", () async {
      // Lấy tất cả các category trước
      final categories = CategoryBox.getAll();

      // Xóa dữ liệu cũ
      _accounts.clear();
      _groupedCategoryIdAccounts.clear();

      // Reset trạng thái mở rộng nếu được yêu cầu
      if (resetExpansion) {
        _expandedCategories.clear();
      }

      clearDecryptedCache();

      // Reset số lượng tài khoản hiển thị
      _visibleAccountsPerCategory.clear();

      // Tạo cache cho category để tránh truy vấn lặp lại
      _categoryCache.clear();

      // Lưu tất cả category vào cache
      for (var category in categories) {
        _categoryCache[category.id] = category;
      }

      // Lấy tài khoản cho mỗi category với giới hạn số lượng
      final accountsByCategory = AccountBox.getByCategoriesWithLimit(categories, INITIAL_ACCOUNTS_PER_CATEGORY);

      // Xử lý từng category
      for (var categoryId in accountsByCategory.keys) {
        final accounts = accountsByCategory[categoryId] ?? [];
        final category = _categoryCache[categoryId] ?? CategoryOjbModel(id: 0, categoryName: 'Không xác định');

        // Xử lý song song các account trong category
        final decryptedAccounts = await Future.wait(accounts.map((account) => _getDecryptedBasicInfo(account)));

        // Lưu vào _accounts và _groupedCategoryIdAccounts
        for (var i = 0; i < accounts.length; i++) {
          final account = accounts[i];
          final decryptedAccount = decryptedAccounts[i];

          _accounts[account.id] = account;
          _groupedCategoryIdAccounts.putIfAbsent(category.id, () => []).add(decryptedAccount);
        }

        // Thông báo sau mỗi category để UI cập nhật dần
        notifyListeners();
      }

      // Lấy số lượng tài khoản cho mỗi category để hiển thị "Xem thêm"
      _updateAccountCountsForCategories(categories);
    });
  }

  // // Lấy account đã giải mã với cache
  // Future<AccountOjbModel> getDecryptedAccount(int id) async {
  //   // Kiểm tra cache trước
  //   if (_decryptedCache.containsKey(id)) {
  //     return _decryptedCache[id]!;
  //   }

  //   final account = _accounts[id];
  //   if (account == null) throw Exception('Account không tồn tại');

  //   final decrypted = await _decryptAccount(account);
  //   // Lưu vào cache
  //   _decryptedCache[id] = decrypted;
  //   return decrypted;
  // }

  // Thêm account mới với mã hóa
  Future<bool> createOrUpdateAccount(AccountOjbModel account, {bool isUpdate = false}) async {
    final stopwatch = Stopwatch()..start();
    final result = await _handleAsync(funcName: isUpdate ? "updateAccount" : "createAccount", () async {
      if (account.title.trim().isEmpty) {
        throw Exception('Tên tài khoản không được để trống');
      }

      AccountOjbModel accountToSave;
      if (isUpdate) {
        // Update logic
        AccountOjbModel? currentAccount = account.id != 0 ? await AccountBox.getById(account.id) : null;
        if (currentAccount == null) throw Exception('Tài khoản không được để chống');
        AccountOjbModel decryptedAccount = await decryptAccount(currentAccount);

        // Update existing account fields
        currentAccount.icon = account.icon;
        currentAccount.setIconCustom = account.getIconCustom;
        currentAccount.title = account.title;
        currentAccount.email = account.email;
        if (decryptedAccount.password != null && decryptedAccount.password!.isNotEmpty && decryptedAccount.password != account.password) {
          currentAccount.passwordHistories.add(PasswordHistory(password: decryptedAccount.password!, createdAt: DateTime.now(), updatedAt: DateTime.now()));
          currentAccount.password = account.password;
        } else {
          currentAccount.password = account.password;
        }
        currentAccount.notes = account.notes;
        currentAccount.setCategory = account.getCategory;
        currentAccount.customFields.clear();
        currentAccount.customFields.addAll(account.getCustomFields);
        currentAccount.updatedAt = DateTime.now();
        accountToSave = currentAccount;
      } else {
        // Create logic
        accountToSave = account;
      }

      final encryptedAccount = await _encryptAccount(accountToSave);
      final elapsedTime = stopwatch.elapsed;
      debugPrint('${isUpdate ? "updateAccount" : "createAccount"}: _encryptAccount completed in: ${elapsedTime.inMilliseconds}ms');

      final id = await AccountBox.put(encryptedAccount);
      if (!isUpdate) {
        encryptedAccount.id = id;
      }

      _accounts[isUpdate ? account.id : id] = encryptedAccount;
      _basicInfoCache.remove(isUpdate ? account.id : id);

      debugPrint('${isUpdate ? "updateAccount" : "createAccount"}: Operation completed in: ${elapsedTime.inMilliseconds}ms');
      return true;
    });

    if (result != null) {
      await getAccounts();
    }
    return result ?? false;
  }

  // Xóa account
  Future<bool> deleteAccount(AccountOjbModel account) async {
    final result = await _handleAsync(funcName: "deleteAccount", () async {
      if (!AccountBox.delete(account.id)) {
        throw Exception('Không thể xóa tài khoản');
      }
      _accounts.remove(account.id);
      // _decryptedCache.remove(account.id);
      _basicInfoCache.remove(account.id);
      if (account.getCategory != null) {
        _groupedCategoryIdAccounts[account.getCategory!.id]?.remove(account);
        _categoryAccountCounts[account.getCategory!.id] = _groupedCategoryIdAccounts[account.getCategory!.id]?.length ?? 0;
        refreshAccounts();
      }
      return true;
    });

    return result ?? false;
  }

  //only decrypt title và email
  Future<AccountOjbModel> decryptBasicInfo(AccountOjbModel account) async {
    // Kiểm tra cache trước
    if (_basicInfoCache.containsKey(account.id)) {
      return _basicInfoCache[account.id]!;
    }

    final encryptData = EncryptAppDataService.instance;
    final decryptedBasic = AccountOjbModel(
      id: account.id,
      title: await encryptData.decryptInfo(account.title),
      email: account.email != null ? await encryptData.decryptInfo(account.email!) : null,
      categoryOjbModel: account.getCategory,
    );

    // Lưu vào cache
    _basicInfoCache[account.id] = decryptedBasic;
    return decryptedBasic;
  }

  // Mã hóa dữ liệu account
  Future<AccountOjbModel> _encryptAccount(AccountOjbModel account) async {
    final encryptData = EncryptAppDataService.instance;

    // Encrypt các trường cơ bản
    account.title = await encryptData.encryptInfo(account.title);
    if (account.email != null) {
      account.email = await encryptData.encryptInfo(account.email!);
    }
    if (account.password != null) {
      account.password = await encryptData.encryptPassword(account.password!);
    }
    if (account.notes != null) {
      account.notes = await encryptData.encryptInfo(account.notes!);
    }

    // Encrypt custom fields
    for (var field in account.customFields) {
      field.value = field.typeField == 'password' ? await encryptData.encryptPassword(field.value) : await encryptData.encryptInfo(field.value);
    }

    // Encrypt TOTP
    if (account.totp.target != null) {
      account.totp.target!.secretKey = await encryptData.encryptTOTPKey(account.totp.target!.secretKey);
    }

    return account;
  }

  //Giải mã dữ liệu account
  Future<AccountOjbModel> decryptAccount(AccountOjbModel account) async {
    final encryptData = EncryptAppDataService.instance;
    final decryptedAccount = AccountOjbModel.fromModel(account);

    // Decrypt các trường cơ bản
    decryptedAccount.title = await encryptData.decryptInfo(account.title);
    if (account.email != null) {
      decryptedAccount.email = await encryptData.decryptInfo(account.email!);
    }
    if (account.password != null) {
      decryptedAccount.password = await encryptData.decryptPassword(account.password!);
    }
    if (account.notes != null) {
      decryptedAccount.notes = await encryptData.decryptInfo(account.notes!);
    }

    // Decrypt custom fields
    for (var field in decryptedAccount.customFields) {
      field.value = field.typeField == 'password' ? await encryptData.decryptPassword(field.value) : await encryptData.decryptInfo(field.value);
    }

    // Decrypt TOTP
    if (decryptedAccount.totp.target != null) {
      decryptedAccount.totp.target!.secretKey = await encryptData.decryptTOTPKey(decryptedAccount.totp.target!.secretKey);
    }

    return decryptedAccount;
  }

  // Xóa cache khi cần
  void clearDecryptedCache() {
    // _decryptedCache.clear();
    _basicInfoCache.clear();
    // Không xóa _expandedCategories để giữ trạng thái mở rộng
    notifyListeners();
  }

  @override
  void dispose() {
    _basicInfoCache.clear();
    _categoryCache.clear();
    clearDecryptedCache();
    _accounts.clear();
    _expandedCategories.clear();
    _categoryAccountCounts.clear();
    _visibleAccountsPerCategory.clear();
    super.dispose();
  }

  Future<bool> createAccountFromForm(AccountFormProvider form) async {
    if (!form.validateForm()) {
      return false;
    }

    return await _handleAsync(funcName: "createAccountFromForm", () async {
          showLoadingDialog();
          final customFields =
              form.dynamicTextFieldNotifier.map((e) {
                return AccountCustomFieldOjbModel(name: e.customField.key, value: e.controller.text, hintText: e.customField.hintText, typeField: e.customField.typeField.type);
              }).toList();

          final now = DateTime.now();
          final newAccount = AccountOjbModel(
            id: form.accountId,
            icon: form.branchLogoSelected?.branchLogoSlug,
            title: form.appNameController.text.trim(),
            email: form.usernameController.text.trim(),
            password: form.passwordController.text,
            notes: form.noteController.text.trim(),
            categoryOjbModel: form.selectedCategory!,
            totpOjbModel: form.otpController.text.isNotEmpty ? TOTPOjbModel(secretKey: form.otpController.text.toUpperCase(), algorithm: 'SHA1', digits: 6, period: 30) : null,
            customFieldOjbModel: customFields,
            iconCustomModel: form.selectedIconCustom,
            createdAt: form.accountId == 0 ? now : null,
            updatedAt: now,
          );
          final result = await createOrUpdateAccount(newAccount, isUpdate: form.accountId != 0);
          if (result) {
            form.resetForm();
          }
          hideLoadingDialog();
          return result;
        }) ??
        false;
  }

  // Hàm tạo dữ liệu giả với 9 category, mỗi category có 40 account
  Future<bool> generateFakeData() async {
    final stopwatch = Stopwatch()..start();

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Danh sách tên category
      final categoryNames = ['Mạng xã hội', 'Ngân hàng', 'Email', 'Mua sắm', 'Giải trí', 'Công việc', 'Học tập', 'Trò chơi', 'Khác'];

      // Danh sách tên dịch vụ phổ biến cho mỗi category
      final servicesByCategory = {
        'Mạng xã hội': ['Facebook', 'Instagram', 'Twitter', 'LinkedIn', 'TikTok', 'Pinterest', 'Reddit', 'Snapchat', 'Tumblr', 'Discord'],
        'Ngân hàng': ['Vietcombank', 'Techcombank', 'BIDV', 'VPBank', 'ACB', 'MBBank', 'TPBank', 'VIB', 'Sacombank', 'HDBank'],
        'Email': ['Gmail', 'Outlook', 'Yahoo Mail', 'Zoho Mail', 'ProtonMail', 'Mail.com', 'iCloud Mail', 'AOL Mail', 'GMX Mail', 'Yandex Mail'],
        'Mua sắm': ['Shopee', 'Lazada', 'Tiki', 'Amazon', 'Sendo', 'Alibaba', 'eBay', 'Zalora', 'Fado', 'Tiki'],
        'Giải trí': ['Netflix', 'Spotify', 'YouTube', 'Disney+', 'HBO', 'Apple TV+', 'Amazon Prime', 'VieON', 'FPT Play', 'Galaxy Play'],
        'Công việc': ['Slack', 'Trello', 'Asana', 'Jira', 'Microsoft Teams', 'Notion', 'Monday.com', 'ClickUp', 'Basecamp', 'Todoist'],
        'Học tập': ['Coursera', 'Udemy', 'edX', 'Khan Academy', 'Duolingo', 'Quizlet', 'Memrise', 'Brilliant', 'Skillshare', 'Codecademy'],
        'Trò chơi': ['Steam', 'Epic Games', 'Origin', 'Ubisoft Connect', 'Battle.net', 'PlayStation Network', 'Xbox Live', 'Nintendo', 'Garena', 'Riot Games'],
        'Khác': ['Dropbox', 'Google Drive', 'OneDrive', 'iCloud', 'Evernote', 'LastPass', 'NordVPN', 'ExpressVPN', 'Adobe', 'Canva'],
      };

      // Tạo các category
      final categories = <CategoryOjbModel>[];
      for (var i = 0; i < categoryNames.length; i++) {
        final category = CategoryOjbModel(
          categoryName: categoryNames[i],
          color: 0xFF000000 + (i * 1000000), // Màu ngẫu nhiên
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final categoryId = CategoryBox.put(category);
        category.id = categoryId;
        categories.add(category);

        debugPrint('Đã tạo category: ${category.categoryName} với ID: $categoryId');
      }

      // Tạo account cho mỗi category
      for (var category in categories) {
        final services = servicesByCategory[category.categoryName] ?? [];
        final accountsToCreate = <AccountOjbModel>[];

        // Tạo 40 account cho mỗi category
        for (var i = 0; i < 40; i++) {
          // Chọn dịch vụ từ danh sách hoặc tạo tên ngẫu nhiên
          final serviceName = i < services.length ? services[i] : '${category.categoryName} Account ${i + 1}';

          final account = AccountOjbModel(
            title: serviceName,
            email: 'user${i + 1}@${serviceName.toLowerCase().replaceAll(' ', '')}.com',
            password: 'Password${i + 1}@${DateTime.now().year}',
            notes: 'Tài khoản $serviceName được tạo tự động.',
            categoryOjbModel: category,
            createdAt: DateTime.now().subtract(Duration(days: i % 30)),
            updatedAt: DateTime.now().subtract(Duration(hours: i % 24)),
          );

          accountsToCreate.add(account);
        }

        // Lưu hàng loạt account
        final accountIds = await AccountBox.putMany(accountsToCreate);
        debugPrint('Đã tạo ${accountIds.length} account cho category: ${category.categoryName}');
      }

      final elapsedTime = stopwatch.elapsed;
      debugPrint('generateFakeData: Thao tác hoàn thành trong: ${elapsedTime.inMilliseconds}ms');

      // Cập nhật lại danh sách account
      await getAccounts();

      return true;
    } catch (e) {
      final elapsedTime = stopwatch.elapsed;
      _setError(e.toString());
      debugPrint('generateFakeData: Lỗi sau ${elapsedTime.inMilliseconds}ms: $e');
      return false;
    } finally {
      stopwatch.stop();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Phương thức để cập nhật số lượng tài khoản cho mỗi category
  Future<void> _updateAccountCountsForCategories(List<CategoryOjbModel> categories) async {
    for (var category in categories) {
      final count = AccountBox.countByCategory(category);
      // Lưu vào cache để sử dụng cho canExpandCategory
      _categoryAccountCounts[category.id] = count;
    }
  }

  // Phương thức để tải thêm tài khoản cho một category cụ thể
  Future<void> loadMoreAccountsForCategory(int categoryId) async {
    showLoadingDialog();
    await _handleAsync(funcName: "loadMoreAccountsForCategory", () async {
      // Kiểm tra xem category có tồn tại không
      final category = _categoryCache[categoryId];
      if (category == null) return;

      // Lấy số lượng tài khoản hiện tại
      final currentAccounts = _groupedCategoryIdAccounts[categoryId] ?? [];
      final offset = currentAccounts.length;

      // Lấy thêm tài khoản (10 tài khoản mỗi lần)
      final moreAccounts = AccountBox.getByCategoryWithLimit(category, LOAD_MORE_ACCOUNTS_COUNT, offset);

      // Nếu không có thêm tài khoản nào, thoát
      if (moreAccounts.isEmpty) return;

      // Tạo set chứa ID của các tài khoản hiện tại để kiểm tra trùng lặp
      final existingAccountIds = currentAccounts.map((a) => a.id).toSet();

      // Lọc ra những tài khoản chưa có trong danh sách
      final newAccounts = moreAccounts.where((a) => !existingAccountIds.contains(a.id)).toList();

      // Nếu không có tài khoản mới, thoát
      if (newAccounts.isEmpty) return;

      // Giải mã tài khoản mới
      final decryptedMoreAccounts = await Future.wait(newAccounts.map((account) => _getDecryptedBasicInfo(account)));

      // Thêm vào danh sách hiện tại
      for (var i = 0; i < newAccounts.length; i++) {
        final account = newAccounts[i];
        final decryptedAccount = decryptedMoreAccounts[i];

        _accounts[account.id] = account;
        _groupedCategoryIdAccounts.putIfAbsent(categoryId, () => []).add(decryptedAccount);
      }

      // Không sắp xếp lại danh sách để giữ nguyên thứ tự các tài khoản mới được thêm vào cuối
      // _groupedCategoryIdAccounts[categoryId]?.sort((a, b) => a.title.compareTo(b.title));

      // Cập nhật số lượng tài khoản hiển thị
      final currentVisibleCount = _visibleAccountsPerCategory[categoryId] ?? INITIAL_ACCOUNTS_PER_CATEGORY;
      _visibleAccountsPerCategory[categoryId] = currentVisibleCount + LOAD_MORE_ACCOUNTS_COUNT;

      // Kiểm tra xem đã tải hết tài khoản chưa
      final totalCount = _categoryAccountCounts[categoryId] ?? 0;
      final currentCount = _groupedCategoryIdAccounts[categoryId]?.length ?? 0;

      // Nếu đã tải hết, đánh dấu là đã mở rộng
      if (currentCount >= totalCount) {
        _expandedCategories[categoryId] = true;
        // Không cần giới hạn số lượng hiển thị nữa
        _visibleAccountsPerCategory.remove(categoryId);
      }

      notifyListeners();
    });
    hideLoadingDialog();
  }

  // Phương thức để tải tất cả tài khoản cho một category
  Future<void> loadAllAccountsForCategory(int categoryId) async {
    await _handleAsync(funcName: "loadAllAccountsForCategory", () async {
      // Kiểm tra xem category có tồn tại không
      final category = _categoryCache[categoryId];
      if (category == null) return;

      // Lấy tất cả tài khoản trong category
      final allAccounts = AccountBox.getByCategory(category);

      // Lấy danh sách tài khoản hiện tại
      final currentAccounts = _groupedCategoryIdAccounts[categoryId] ?? [];
      final currentAccountIds = currentAccounts.map((a) => a.id).toSet();

      // Lọc ra những tài khoản chưa được tải
      final newAccounts = allAccounts.where((a) => !currentAccountIds.contains(a.id)).toList();

      // Nếu không có tài khoản mới, thoát
      if (newAccounts.isEmpty) {
        // Đánh dấu category đã được mở rộng ngay cả khi không có tài khoản mới
        _expandedCategories[categoryId] = true;
        // Xóa giới hạn hiển thị
        _visibleAccountsPerCategory.remove(categoryId);
        notifyListeners();
        return;
      }

      // Giải mã tài khoản mới
      final decryptedNewAccounts = await Future.wait(newAccounts.map((account) => _getDecryptedBasicInfo(account)));

      // Thêm vào danh sách hiện tại
      for (var i = 0; i < newAccounts.length; i++) {
        final account = newAccounts[i];
        final decryptedAccount = decryptedNewAccounts[i];

        _accounts[account.id] = account;
        _groupedCategoryIdAccounts.putIfAbsent(categoryId, () => []).add(decryptedAccount);
      }

      // Không sắp xếp lại danh sách để giữ nguyên thứ tự các tài khoản mới được thêm vào cuối
      // _groupedCategoryIdAccounts[categoryId]?.sort((a, b) => a.title.compareTo(b.title));

      // Đánh dấu category đã được mở rộng
      _expandedCategories[categoryId] = true;
      // Xóa giới hạn hiển thị
      _visibleAccountsPerCategory.remove(categoryId);

      notifyListeners();
    });
  }

  // Phương thức để reset trạng thái mở rộng của tất cả các danh mục
  void resetExpansionState() {
    _expandedCategories.clear();
    _visibleAccountsPerCategory.clear();
    notifyListeners();
  }

  // Phương thức để reset trạng thái mở rộng của một danh mục cụ thể
  void resetCategoryExpansion(int categoryId) {
    _expandedCategories.remove(categoryId);
    _visibleAccountsPerCategory.remove(categoryId);
    notifyListeners();
  }

  // Phương thức để kiểm tra xem một danh mục có đang được mở rộng không
  bool isCategoryExpanded(int categoryId) {
    return _expandedCategories[categoryId] == true;
  }

  // Phương thức để lấy số lượng tài khoản đang hiển thị trong một danh mục
  int getVisibleAccountsCount(int categoryId) {
    if (_expandedCategories[categoryId] == true) {
      return _groupedCategoryIdAccounts[categoryId]?.length ?? 0;
    } else if (_visibleAccountsPerCategory.containsKey(categoryId)) {
      return _visibleAccountsPerCategory[categoryId]!;
    } else {
      return math.min(INITIAL_ACCOUNTS_PER_CATEGORY, _groupedCategoryIdAccounts[categoryId]?.length ?? 0);
    }
  }

  // Phương thức để tải lại danh sách tài khoản
  Future<void> refreshAccounts({bool resetExpansion = false}) async {
    showLoadingDialog();
    await getAccounts(resetExpansion: resetExpansion);
    hideLoadingDialog();
  }

  // Phương thức để chọn/bỏ chọn category
  void selectCategory(int? categoryId, {required BuildContext context}) {
    final accountFormProvider = Provider.of<AccountFormProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null; // Bỏ chọn nếu đã chọn
      accountFormProvider.setCategoryNull();
    } else {
      _selectedCategoryId = categoryId; // Chọn category mới
      accountFormProvider.setCategory(categoryProvider.categories[categoryId]!);
    }
    notifyListeners();
  }
}
