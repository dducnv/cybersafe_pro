import 'dart:async';

import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  static final instance = AppProvider._internal();
  AppProvider._internal();

  final _secureStorage = SecureStorage.instance;

  final int _durationRotateKey = 30;

  bool isShowRequestRotateKey = false;

  //time login
  Timer _rootTimer = Timer(Duration.zero, () {});
  bool _isOpenAutoLock = false;
  bool get isOpenAutoLock => _isOpenAutoLock;
  int _timeAutoLock = 5;
  int get timeAutoLock => _timeAutoLock;
  
  // Thêm biến cho tính năng khóa tự động khi ứng dụng ở chế độ nền
  bool _lockOnBackground = false;
  bool get lockOnBackground => _lockOnBackground;

  // Quản lý timer tốt hơn trong dispose
  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  Future<void> checkRotateKey() async {
    final keyCreationTime = await _secureStorage.read(key: SecureStorageKey.encryptionKeyCreationTime);
    if (keyCreationTime == null || DateTime.now().difference(DateTime.parse(keyCreationTime)) > Duration(days: _durationRotateKey)) {
      isShowRequestRotateKey = true;
    }
  }

  Future<void> initializeTimer() async {
    _rootTimer.cancel();
    final autoLock = await SecureStorage.instance.readBool(SecureStorageKey.isAutoLock);
    final timeAutoLock = await SecureStorage.instance.readInt(SecureStorageKey.timeAutoLock) ?? 5;
    final lockOnBackground = await SecureStorage.instance.readBool(SecureStorageKey.lockOnBackground) ?? false;
    
    _timeAutoLock = timeAutoLock;
    _lockOnBackground = lockOnBackground;
    if (autoLock == null || !autoLock) {
      _isOpenAutoLock = false;
      return;
    }
    _isOpenAutoLock = true;
    // Chuyển từ phút sang giây nếu thời gian dưới 1 phút
    Duration time = _timeAutoLock < 1 
        ? Duration(seconds: 30) 
        : Duration(minutes: _timeAutoLock);
    _rootTimer = Timer(time, () {

      logInfo('Auto lock timer expired');
      logOutUser();
    });
    
  }

  void stopTimer() {
    _rootTimer.cancel();
  }

  void logOutUser() {
    _rootTimer.cancel();
    AppRoutes.navigateAndRemoveUntil(GlobalKeys.appRootNavigatorKey.currentContext!, AppRoutes.loginMasterPin);
  }

  void handleUserInteraction([_]) {
    if (!_rootTimer.isActive) {
      return;
    }
    _rootTimer.cancel();
    initializeTimer();
  }

  void setAutoLock(bool isOpen, int time) {
    _isOpenAutoLock = isOpen;
    _timeAutoLock = time;
    SecureStorage.instance.saveBool(SecureStorageKey.isAutoLock, isOpen);
    SecureStorage.instance.saveInt(SecureStorageKey.timeAutoLock, time);
    initializeTimer();
    notifyListeners();
  }
  
  // Phương thức để cài đặt khóa khi ứng dụng ở nền
  void setLockOnBackground(bool value) {
    _lockOnBackground = value;
    SecureStorage.instance.saveBool(SecureStorageKey.lockOnBackground, value);
    // Cập nhật secure_application
    notifyListeners();
  }
  
  // Xử lý khi ứng dụng chuyển sang chế độ nền
  void handleAppBackground() {
    if (_lockOnBackground) {
      logAction('Khóa ứng dụng do chạy nền');
      
      try {
        // Dừng bộ đếm thời gian
        _rootTimer.cancel();
        // Tạo trễ ngắn để đảm bảo giao diện cập nhật trước khi đăng xuất
        Future.delayed(const Duration(milliseconds: 100), () {
          logOutUser();
        });
      } catch (e) {
        logError('Lỗi khi xử lý ứng dụng chạy nền: $e');
      }
    }
  }
  
  // Log các hành động quan trọng
  void logAction(String message) {
    logInfo('[AppProvider] $message');
  }
}
