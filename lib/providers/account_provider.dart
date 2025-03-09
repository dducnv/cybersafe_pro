import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/services/enscrypt_app_data.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/providers/create_account_form_provider.dart';

class AccountProvider extends ChangeNotifier {
  final Map<int, AccountOjbModel> _accounts = {};
  final Map<int, AccountOjbModel> _decryptedCache = {};
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtNote = TextEditingController();

  bool _isLoading = false;
  String? _error;

  // Map để lưu accounts theo category
  final Map<int, List<AccountOjbModel>> _groupedCategoryIdAccounts = {};

  // Thêm cache cho basic info
  final Map<int, AccountOjbModel> _basicInfoCache = {};

  // Thêm cache cho category để tránh query lại
  final Map<int, CategoryOjbModel> _categoryCache = {};

  // Thêm batch size để xử lý từng phần
  static const int BATCH_SIZE = 20;

  // Getters
  Map<int, AccountOjbModel> get accounts => Map.unmodifiable(_accounts);
  List<AccountOjbModel> get accountList => _accounts.values.toList();
  bool get hasAccounts => _accounts.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getter cho grouped accounts
  Map<int, List<AccountOjbModel>> get groupedAccounts => Map.unmodifiable(_groupedCategoryIdAccounts);

  void _setError(String? value) {
    _error = value;
    notifyListeners();
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

    final encryptData = EncryptAppData.instance;
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

  Future<void> getAccounts() async {
    await _handleAsync(funcName: "getAccounts", () async {
      final accounts = AccountBox.getAll();
      _accounts.clear();
      _groupedCategoryIdAccounts.clear();
      clearDecryptedCache();

      // Tạo cache cho category để tránh truy vấn lặp lại
      final categoryCache = <int, CategoryOjbModel>{};

      // Tối ưu: Chia thành các batch nhỏ để xử lý
      for (var i = 0; i < accounts.length; i += BATCH_SIZE) {
        final end = (i + BATCH_SIZE < accounts.length) ? i + BATCH_SIZE : accounts.length;
        final batch = accounts.sublist(i, end);

        // Xử lý song song các account trong batch
        final decryptedBatch = await Future.wait(batch.map((account) => _getDecryptedBasicInfo(account)));

        for (var j = 0; j < batch.length; j++) {
          final account = batch[j];
          final decryptedAccount = decryptedBatch[j];

          _accounts[account.id] = account;

          // Lấy category từ cache hoặc từ account
          final categoryId = account.category.targetId;
          var category = categoryCache[categoryId];
          if (category == null && account.category.target != null) {
            category = account.category.target!;
            categoryCache[categoryId] = category;
          }
          category ??= CategoryOjbModel(id: 0, categoryName: 'Không xác định');

          // Thêm vào grouped accounts
          _groupedCategoryIdAccounts.putIfAbsent(category.id, () => []).add(decryptedAccount);
        }

        // Thông báo sau mỗi batch để UI cập nhật dần
        notifyListeners();
      }
    });
  }

  // Lấy account đã giải mã với cache
  Future<AccountOjbModel> getDecryptedAccount(int id) async {
    // Kiểm tra cache trước
    if (_decryptedCache.containsKey(id)) {
      return _decryptedCache[id]!;
    }

    final account = _accounts[id];
    if (account == null) throw Exception('Account không tồn tại');

    final decrypted = await _decryptAccount(account);
    // Lưu vào cache
    _decryptedCache[id] = decrypted;
    return decrypted;
  }

  // Thêm account mới với mã hóa
  Future<bool> createAccount(AccountOjbModel account) async {
    final stopwatch = Stopwatch()..start();
    final result = await _handleAsync(funcName: "createAccount", () async {
      if (account.title.trim().isEmpty) {
        throw Exception('Tên tài khoản không được để trống');
      }
      final encryptedAccount = await _encryptAccount(account);
      final elapsedTime = stopwatch.elapsed;
      debugPrint('createAccount: _encryptAccount Thao tác hoàn thành trong: ${elapsedTime.inMilliseconds}ms');
      final id = AccountBox.put(encryptedAccount);
      debugPrint('createAccount: AccountBox.put $id Thao tác hoàn thành trong: ${elapsedTime.inMilliseconds}ms');
      encryptedAccount.id = id;
      _accounts.putIfAbsent(id, () => encryptedAccount);
      _clearForm();
      debugPrint('createAccount: Thao tác hoàn thành trong: ${elapsedTime.inMilliseconds}ms');
      return true;
    });

    if (result != null) {
      await getAccounts();
    }
    return result ?? false;
  }

  // Cập nhật account với mã hóa
  Future<bool> updateAccount(AccountOjbModel account) async {
    final result = await _handleAsync(
      funcName:"updateAccount",
      () async {
      if (account.title.trim().isEmpty) {
        throw Exception('Tên tài khoản không được để trống');
      }

      final encryptedAccount = await _encryptAccount(account);
      AccountBox.put(encryptedAccount);

      _accounts[account.id] = encryptedAccount;
      _decryptedCache.remove(account.id);
      _basicInfoCache.remove(account.id); // Xóa basic info cache
      return true;
    });

    return result ?? false;
  }

  // Xóa account
  Future<bool> deleteAccount(AccountOjbModel account) async {
    final result = await _handleAsync(
      funcName:"deleteAccount",
      () async {
      if (!AccountBox.delete(account.id)) {
        throw Exception('Không thể xóa tài khoản');
      }
      _accounts.remove(account.id);
      _decryptedCache.remove(account.id);
      _basicInfoCache.remove(account.id); // Xóa basic info cache
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

    final encryptData = EncryptAppData.instance;
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
    final encryptData = EncryptAppData.instance;
    final encryptedAccount = AccountOjbModel.fromModel(account);

    // Encrypt các trường cơ bản
    encryptedAccount.title = await encryptData.encryptInfo(account.title);
    if (account.email != null) {
      encryptedAccount.email = await encryptData.encryptInfo(account.email!);
    }
    if (account.password != null) {
      encryptedAccount.password = await encryptData.encryptPassword(account.password!);
    }
    if (account.notes != null) {
      encryptedAccount.notes = await encryptData.encryptInfo(account.notes!);
    }

    // Encrypt custom fields
    for (var field in encryptedAccount.customFields) {
      field.value = field.typeField == 'password' ? await encryptData.encryptPassword(field.value) : await encryptData.encryptInfo(field.value);
    }

    // Encrypt TOTP
    if (encryptedAccount.totp.target != null) {
      encryptedAccount.totp.target!.secretKey = await encryptData.encryptTOTPKey(encryptedAccount.totp.target!.secretKey);
    }

    return encryptedAccount;
  }

  // Giải mã dữ liệu account
  Future<AccountOjbModel> _decryptAccount(AccountOjbModel account) async {
    final encryptData = EncryptAppData.instance;
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

  void _clearForm() {
    txtTitle.clear();
    txtUsername.clear();
    txtPassword.clear();
    txtNote.clear();
  }

  // Xóa cache khi cần
  void clearDecryptedCache() {
    _decryptedCache.clear();
    _basicInfoCache.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    clearDecryptedCache();
    txtTitle.dispose();
    txtUsername.dispose();
    txtPassword.dispose();
    txtNote.dispose();
    _accounts.clear();
    super.dispose();
  }

  Future<bool> createAccountFromForm(CreateAccountFormProvider form) async {
    if (!form.validateForm()) {
      return false;
    }
    showLoadingDialog();
    final newAccount = AccountOjbModel(
      id: 0, // ID sẽ được tạo khi lưu vào database
      title: form.appNameController.text.trim(),
      email: form.usernameController.text.trim(),
      password: form.passwordController.text,
      notes: form.noteController.text.trim(),
      categoryOjbModel: form.selectedCategory!,
      totpOjbModel: form.otpController.text.isNotEmpty ? TOTPOjbModel(secretKey: form.otpController.text, algorithm: 'SHA1', digits: 6, period: 30) : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final result = await createAccount(newAccount);
    if (result) {
      form.resetForm();
    }
    await hideLoadingDialog();
    return result;
  }
}
