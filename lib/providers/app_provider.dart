import 'dart:async';

import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
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
    _timeAutoLock = timeAutoLock;
    if (autoLock == null || !autoLock) {
      _isOpenAutoLock = false;
      return;
    }
    _isOpenAutoLock = true;
    Duration time = Duration(minutes: _timeAutoLock);
    _rootTimer = Timer(time, () {
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
}
