import 'dart:async';

import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:secure_application/secure_application.dart';

class SecureApplicationUtil {
  static final instance = SecureApplicationUtil._internal();

  SecureApplicationUtil._internal();

  SecureApplicationController? secureApplicationController;
  bool _isDisposed = false;
  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitialized = false;
  final ValueNotifier<bool> lockStateChanged = ValueNotifier<bool>(false);
  final ValueNotifier<SecureAppState> currentState = ValueNotifier<SecureAppState>(
    SecureAppState.secured,
  );

  bool _shouldLockOnBackground = true;
  Timer? _resumeTimer;

  Future<void> get initDone => _initCompleter.future;
  bool get isInitialized => _isInitialized;
  bool get shouldLockOnBackground => _shouldLockOnBackground;

  /// Bật/tắt tự lock khi background
  void setShouldLockOnBackground(bool shouldLock) {
    _shouldLockOnBackground = shouldLock;
  }

  /// Thay đổi trạng thái bảo mật
  void setSecureState(SecureAppState state) {
    if (currentState.value != state) {
      currentState.value = state;
      switch (state) {
        case SecureAppState.secured:
          secure();
          break;
        case SecureAppState.partial:
          _applyPartialSecurity();
          break;
        case SecureAppState.none:
          open();
          break;
      }
    }
  }

  /// Áp dụng bảo mật một phần
  void _applyPartialSecurity() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.open();
        _resumeTimer?.cancel();
        _resumeTimer = Timer(const Duration(minutes: 3), () {
          if (currentState.value == SecureAppState.partial) {
            setSecureState(SecureAppState.secured);
          }
        });
      } catch (e) {
        logError(
          'Error in _applyPartialSecurity: $e',
          functionName: "SecureApplicationUtil._applyPartialSecurity",
        );
      }
    }
  }

  /// Hủy
  void dispose() {
    _resumeTimer?.cancel();
    lockStateChanged.dispose();
    currentState.dispose();
    if (!_isDisposed && secureApplicationController != null) {
      _isDisposed = true;
      try {
        secureApplicationController?.dispose();
        logInfo('SecureApplicationUtil disposed');
      } catch (e) {
        logError(
          'Error disposing SecureApplicationController: $e',
          functionName: "SecureApplicationUtil.dispose",
        );
      } finally {
        secureApplicationController = null;
      }
    }
  }

  /// Init chỉ để chặn screenshot, không khóa app
  Future<void> init({bool autoLock = true}) async {
    try {
      if (secureApplicationController == null || _isDisposed) {
        _isDisposed = false;
        secureApplicationController = SecureApplicationController(
          SecureApplicationState(secured: true),
        );
        _setupListeners();
        secureApplicationController?.secure();
        _isInitialized = true;
        _shouldLockOnBackground = autoLock;
        if (!_initCompleter.isCompleted) {
          _initCompleter.complete();
        }
        logInfo('SecureApplicationUtil initialized for screenshot protection only');
      }
    } catch (e) {
      logError('Error in init(): $e', functionName: "SecureApplicationUtil.init");
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  void _setupListeners() {
    secureApplicationController?.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        lockStateChanged.value = !lockStateChanged.value;
        logInfo('SecureApplication state changed - Locked: $isLocked, Secured: $isSecured');
      });
    });
  }

  /// Lock khi background (nếu được bật)
  void lockOnBackground() {
    if (!_isDisposed && secureApplicationController != null && _shouldLockOnBackground) {
      try {
        secureApplicationController?.lock();
        logInfo('Application locked due to background state');
      } catch (e) {
        logError(
          'Error in lockOnBackground(): $e',
          functionName: "SecureApplicationUtil.lockOnBackground",
        );
      }
    }
  }

  /// Unlock khi foreground
  void unlockOnForeground() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.unlock();
        logInfo('Application unlocked due to foreground state');
      } catch (e) {
        logError(
          'Error in unlockOnForeground(): $e',
          functionName: "SecureApplicationUtil.unlockOnForeground",
        );
      }
    }
  }

  /// Thao tác thủ công
  void lock() {
    secureApplicationController?.lock();
    logInfo('Application locked manually');
  }

  void unlock() {
    secureApplicationController?.unlock();
    logInfo('Application unlocked manually');
  }

  void secure() {
    secureApplicationController?.secure();
    logInfo('Application secured');
  }

  void open() {
    secureApplicationController?.open();
    logInfo('Application opened');
  }

  void pause() {
    secureApplicationController?.pause();
    logInfo('Application paused');
  }

  void unpause() {
    secureApplicationController?.unpause();
  }

  bool get isLocked => !_isDisposed && secureApplicationController?.value.locked == true;

  bool get isSecured => !_isDisposed && (secureApplicationController?.secured ?? false);

  void authSuccess({bool unlock = true}) {
    secureApplicationController?.authSuccess(unlock: unlock);
    secureApplicationController?.unpause();
    secureApplicationController?.resumed();
  }

  void authFailed({bool unlock = false}) {
    secureApplicationController?.authFailed(unlock: unlock);
  }
}
