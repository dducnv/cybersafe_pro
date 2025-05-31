import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class LocalAuthProvider extends ChangeNotifier {
  final encryptAppDataService = EncryptAppDataService.instance;

  // Controllers
  late FocusNode focusNode;
  late TextEditingController textEditingController;
  late GlobalKey<AppPinCodeFieldsState> appPinCodeKey;
  late GlobalKey<FormState> formKey;

  // State variables
  bool isAuthenticated = false;
  String _pinCodeConfirm = '';

  // Lock related variables
  int _loginFailCount = 0;
  bool _isLocked = false;
  DateTime? _lockUntil;
  int _lockDurationMultiplier = 1;

  // Configuration
  static const int _maxLoginAttempts = 3;
  static const int _baseLockDurationMinutes = 1;
  static const int _maxLockDurationMinutes = 30;

  Timer? _lockTimer;

  LocalAuthProvider() {
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    appPinCodeKey = GlobalKey<AppPinCodeFieldsState>();
    formKey = GlobalKey<FormState>();
  }

  Future<void> init(bool canUseBiometric, Function() biometricLoginCallBack, {bool isNavigateToHome = true}) async {
    await _checkLockStatus();
    await checkAndUpdateLockStatus();
    if (_shouldUseBiometric(canUseBiometric)) {
      await _handleBiometricAuth(biometricLoginCallBack, isNavigateToHome: isNavigateToHome);
    } else {
      await _focusPinInput();
    }
  }

  bool _shouldUseBiometric(bool canUseBiometric) {
    return LocalAuthConfig.instance.isAvailableBiometrics && LocalAuthConfig.instance.isOpenUseBiometric && canUseBiometric;
  }

  Future<void> _handleBiometricAuth(Function() biometricLoginCallBack, {bool isNavigateToHome = true}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    bool isAuth = await checkLocalAuth();

    if (isAuth) {
      if (isNavigateToHome) navigatorToHome();
      biometricLoginCallBack.call();
    } else {
      await _focusPinInput();
    }
  }

  Future<void> _focusPinInput() async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (focusNode.hasFocus) return;
    focusNode.requestFocus();
  }

  // Getter để kiểm tra trạng thái khoá
  bool get isLocked {
    return _checkCurrentLockStatus();
  }

  // Phương thức kiểm tra trạng thái khóa hiện tại
  bool _checkCurrentLockStatus() {
    // Nếu không bị khóa hoặc không có thời gian khóa
    if (!_isLocked || _lockUntil == null) {
      return false;
    }

    // Kiểm tra xem thời gian khóa đã hết chưa
    bool stillLocked = DateTime.now().isBefore(_lockUntil!);

    // Nếu thời gian đã hết nhưng trạng thái vẫn là khóa
    if (!stillLocked && _isLocked) {
      // Đặt lịch để reset trạng thái khóa
      _scheduleLockStatusReset();
      return false;
    }

    return stillLocked;
  }

  // Phương thức để cập nhật và thông báo về trạng thái khóa
  void updateLockStatus() {
    final oldStatus = _isLocked;
    final newStatus = _checkCurrentLockStatus();

    if (oldStatus != newStatus) {
      _isLocked = newStatus;
      notifyListeners();
    }
  }

  // Thời gian còn lại (giây)
  int get remainingLockTimeSeconds {
    if (!isLocked || _lockUntil == null) return 0;
    return _lockUntil!.difference(DateTime.now()).inSeconds;
  }

  // Định dạng thời gian còn lại
  String get formattedRemainingTime {
    final seconds = remainingLockTimeSeconds;
    // Nếu thời gian đã hết, thì trả về 0:00
    if (seconds <= 0) {
      return '0:00';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void authenticate() {
    isAuthenticated = true;
  }

  void setPinCodeToConfirm(String pinCode) async {
    if (pinCode.isEmpty) return;
    _pinCodeConfirm = pinCode;
    notifyListeners();
  }

  // save pin code
  Future<bool> savePinCode() async {
    if (_pinCodeConfirm.isEmpty) return false;
    String pinCodeEncrypted = await encryptAppDataService.encryptPinCode(_pinCodeConfirm);
    await SecureStorage.instance.save(key: SecureStorageKey.pinCode, value: pinCodeEncrypted);
    return true;
  }

  bool verifyRegisterPinCode(String pinCode) {
    if (_pinCodeConfirm.isEmpty) return false;
    return _pinCodeConfirm == pinCode;
  }

  Future<bool> handleLogin() async {
    try {
      if (isLocked) {
        _triggerErrorAnimation();
        return false;
      }

      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }

      String pinCode = textEditingController.text;
      if (pinCode.length == 6) {
        bool verify = await verifyLoginPinCode(pinCode);
        if (!verify) {
          await _handleLoginFailure();
          return false;
        }
        await _resetLockStatus();
        return true;
      }
      _triggerErrorAnimation();
    } catch (e) {
      logError('Error handling login: $e');
    }
    return false;
  }

  Future<void> _handleLoginFailure() async {
    await _incrementFailCount();
    _triggerErrorAnimation();
    _clearAndFocusInput();
  }

  void _triggerErrorAnimation() {
    if (appPinCodeKey.currentState != null) {
      try {
        appPinCodeKey.currentState!.triggerErrorAnimation();
      } catch (e) {
        logError('Error triggering animation: $e');
      }
    }
  }

  void _clearAndFocusInput() {
    try {
      textEditingController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
    } catch (e) {
      logError('Error clearing text and focusing: $e');
    }
  }

  void onBiometric() async {
    try {
      bool isAuth = await checkLocalAuth();
      if (isAuth) {
        navigatorToHome();
      }
    } catch (e) {
      logError('Error using biometric: $e');
    }
  }

  Future<bool> verifyLoginPinCode(String pinCode) async {
    try {
      String? pinCodeEncryptedFromStorage = await SecureStorage.instance.read(key: SecureStorageKey.pinCode);
      if (pinCodeEncryptedFromStorage == null) return false;
      String pinCodeEncrypted = await encryptAppDataService.decryptPinCode(pinCodeEncryptedFromStorage);
      return pinCodeEncrypted == pinCode;
    } catch (e) {
      logError('Error verifying pin code: $e');
      return false;
    }
  }

  void navigatorToHome() {
    try {
      var context = GlobalKeys.appRootNavigatorKey.currentContext;
      if (context != null) {
        context.read<AppProvider>().initializeTimer();
        AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
      }
    } catch (e) {
      logError('Error navigating to home: $e');
    }
  }

  // Kiểm tra trạng thái khóa từ bộ nhớ
  Future<void> _checkLockStatus() async {
    try {
      final lockUntilStr = await SecureStorage.instance.read(key: SecureStorageKey.lockUntil);
      final failCount = await SecureStorage.instance.read(key: SecureStorageKey.loginFailCount);
      final multiplierStr = await SecureStorage.instance.read(key: SecureStorageKey.lockDurationMultiplier);

      if (lockUntilStr != null) {
        final lockUntil = DateTime.parse(lockUntilStr);
        _lockUntil = lockUntil;
        _isLocked = DateTime.now().isBefore(lockUntil);

        // Nếu thời gian khóa đã hết
        if (!_isLocked) {
          await _resetLockStatus();
        } else {
          notifyListeners();
        }
      }

      if (failCount != null) {
        _loginFailCount = int.parse(failCount);
      }

      if (multiplierStr != null) {
        _lockDurationMultiplier = int.parse(multiplierStr);
      }
    } catch (e) {
      logError('Lỗi khi kiểm tra trạng thái khóa: $e');
      await _resetLockStatus();
    }
  }

  // Đặt lại trạng thái khóa khi đăng nhập thành công
  Future<void> _resetLockStatus() async {
    _lockTimer?.cancel();
    _loginFailCount = 0;
    _isLocked = false;
    _lockUntil = null;
    // Không reset _lockDurationMultiplier khi đăng nhập thành công
    await SecureStorage.instance.delete(key: SecureStorageKey.lockUntil);
    await SecureStorage.instance.delete(key: SecureStorageKey.loginFailCount);
    await SecureStorage.instance.delete(key: SecureStorageKey.lockDurationMultiplier);
    notifyListeners();
  }

  // Khóa tài khoản và tăng thời gian khóa nếu đã khóa trước đó
  Future<void> _lockAccount() async {
    _isLocked = true;

    // Tính toán thời gian khóa với hệ số nhân
    int lockDurationMinutes = _baseLockDurationMinutes * _lockDurationMultiplier;

    // Giới hạn thời gian khóa tối đa
    if (lockDurationMinutes > _maxLockDurationMinutes) {
      lockDurationMinutes = _maxLockDurationMinutes;
    }

    _lockUntil = DateTime.now().add(Duration(minutes: lockDurationMinutes));

    // Lưu thông tin khóa vào bộ nhớ
    await SecureStorage.instance.save(key: SecureStorageKey.lockUntil, value: _lockUntil!.toIso8601String());
    await SecureStorage.instance.save(key: SecureStorageKey.loginFailCount, value: _loginFailCount.toString());
    await SecureStorage.instance.save(key: SecureStorageKey.lockDurationMultiplier, value: _lockDurationMultiplier.toString());

    _startLockTimer();
    notifyListeners();
  }

  // Tăng số lần đăng nhập thất bại
  Future<void> _incrementFailCount() async {
    _loginFailCount++;
    await SecureStorage.instance.save(key: SecureStorageKey.loginFailCount, value: _loginFailCount.toString());

    // Nếu vượt quá số lần thử tối đa, khóa tài khoản
    if (_loginFailCount >= _maxLoginAttempts) {
      // Tăng hệ số thời gian khóa mỗi khi khóa tài khoản
      _lockDurationMultiplier *= 2;

      // Lưu hệ số mới
      await SecureStorage.instance.save(key: SecureStorageKey.lockDurationMultiplier, value: _lockDurationMultiplier.toString());

      await _lockAccount();
      _loginFailCount = 0; // Reset lại đếm số lần đăng nhập sai
    }
  }

  // Lên lịch reset trạng thái khóa
  void _scheduleLockStatusReset() {
    // Sử dụng Future.microtask để tránh setState khi đang build
    Future.microtask(() async {
      await _resetLockStatus();
    });
  }

  // Hàm này có thể được gọi để kiểm tra và cập nhật trạng thái khóa
  Future<void> checkAndUpdateLockStatus() async {
    // Kiểm tra xem tài khoản còn bị khóa không
    if (_isLocked && _lockUntil != null && DateTime.now().isAfter(_lockUntil!)) {
      // Thời gian khóa đã hết, reset trạng thái
      await _resetLockStatus();
    }
  }

  void _startLockTimer() {
    _lockTimer?.cancel();
    if (_lockUntil == null) return;
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isLocked) {
        timer.cancel();
        notifyListeners();
        return;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    // Chỉ dispose các controller khi provider thực sự bị dispose
    // và các controller này không được quản lý bởi một widget khác
    if (!_isDisposed) {
      try {
        // Kiểm tra xem các controller còn tồn tại trước khi dispose
        if (focusNode.hasListeners) {
          focusNode.dispose();
        }

        if (textEditingController.hasListeners) {
          textEditingController.dispose();
        }

        _isDisposed = true;
      } catch (e) {
        logError('Error disposing controllers in LocalAuthProvider: $e');
      }
    }
    super.dispose();
  }

  bool _isDisposed = false;
}
