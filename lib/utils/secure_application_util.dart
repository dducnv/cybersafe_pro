import 'package:cybersafe_pro/utils/secure_app_state.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:secure_application/secure_application.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SecureApplicationUtil {
  static final instance = SecureApplicationUtil._internal();

  SecureApplicationUtil._internal();

  SecureApplicationController? secureApplicationController;
  bool _isDisposed = false;
  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitialized = false;
  final ValueNotifier<bool> lockStateChanged = ValueNotifier<bool>(false);
  final ValueNotifier<SecureAppState> currentState = ValueNotifier<SecureAppState>(SecureAppState.secured);
  bool _shouldLockOnBackground = true;
  Timer? _resumeTimer;

  // Danh sách các route không cần bảo mật hoặc cần bảo mật một phần

  Future<void> get initDone => _initCompleter.future;
  bool get isInitialized => _isInitialized;
  bool get shouldLockOnBackground => _shouldLockOnBackground;

  // Setter để kiểm soát việc lock khi vào background
  void setShouldLockOnBackground(bool shouldLock) {
    _shouldLockOnBackground = shouldLock;
  }

  // Phương thức để thay đổi trạng thái bảo mật
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

  // Áp dụng bảo mật một phần
  void _applyPartialSecurity() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        // Tạm thời mở khóa để thực hiện các tác vụ
        secureApplicationController?.open();
        print("hehe hehehe");

        // Đặt timer để khôi phục bảo mật sau một khoảng thời gian
        _resumeTimer?.cancel();
        _resumeTimer = Timer(const Duration(minutes: 3), () {
          if (currentState.value == SecureAppState.partial) {
            setSecureState(SecureAppState.secured);
          }
        });
      } catch (e) {
        logError('Error in _applyPartialSecurity: $e');
      }
    }
  }


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
        logError('Error disposing SecureApplicationController: $e');
      } finally {
        secureApplicationController = null;
      }
    }
  }

  Future<void> init({bool autoLock = true}) async {
    try {
      // Nếu controller đã bị dispose, tạo mới nó
      if (secureApplicationController == null || _isDisposed) {
        _isDisposed = false;
        secureApplicationController = SecureApplicationController(SecureApplicationState());
        _setupListeners();
        secureApplicationController?.secure();
        _isInitialized = true;
        _shouldLockOnBackground = autoLock;

        if (!_initCompleter.isCompleted) {
          _initCompleter.complete();
        }
        logInfo('SecureApplicationUtil initialized successfully');
      }
    } catch (e) {
      logError('Error in init(): $e');
      // Nếu có lỗi, vẫn đánh dấu là đã hoàn thành để không chặn UI
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  void _setupListeners() {
    secureApplicationController?.addListener(() {
      // Thông báo sự thay đổi trạng thái ngay lập tức
      WidgetsBinding.instance.addPostFrameCallback((_) {
        lockStateChanged.value = !lockStateChanged.value;
        logInfo('SecureApplication state changed - Locked: $isLocked, Secured: $isSecured');
      });
    });
  }

  // Lock ứng dụng khi vào background - nhanh hơn
  void lockOnBackground() {
    if (!_isDisposed && secureApplicationController != null && _shouldLockOnBackground) {
      try {
        // Lock ngay lập tức khi vào background
        secureApplicationController?.lock();
        logInfo('Application locked due to background state');
      } catch (e) {
        logError('Error in lockOnBackground(): $e');
      }
    }
  }

  // Unlock ứng dụng khi xác thực thành công - nhanh hơn
  void unlockOnForeground() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        // Unlock ngay lập tức
        secureApplicationController?.unlock();
        logInfo('Application unlocked due to foreground state');
      } catch (e) {
        logError('Error in unlockOnForeground(): $e');
      }
    }
  }

  void lock() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.lock();
        logInfo('Application locked manually');
      } catch (e) {
        logError('Error in lock(): $e');
      }
    }
  }

  void unlock() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.unlock();
        logInfo('Application unlocked manually');
      } catch (e) {
        logError('Error in unlock(): $e');
      }
    }
  }

  void secure() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.secure();
        logInfo('Application secured');
      } catch (e) {
        logError('Error in secure(): $e');
      }
    }
  }

  void open() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.open();
        logInfo('Application opened');
      } catch (e) {
        logError('Error in open(): $e');
      }
    }
  }

  void pause() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.pause();
        logInfo('Application paused');
      } catch (e) {
        logError('Error in pause(): $e');
      }
    }
  }

  void unpause() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.unpause();
        logInfo('Application unpaused');
      } catch (e) {
        logError('Error in unpause(): $e');
      }
    }
  }

  bool get isLocked {
    try {
      return !_isDisposed && secureApplicationController != null && secureApplicationController!.value.locked;
    } catch (e) {
      logError('Error in isLocked getter: $e');
      return false;
    }
  }

  bool get isSecured {
    try {
      if (_isDisposed || secureApplicationController == null) {
        return false;
      }
      return secureApplicationController!.secured;
    } catch (e) {
      logError('Error in isSecured getter: $e');
      return false;
    }
  }

  void authSuccess({bool unlock = true}) {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.authSuccess(unlock: unlock);
        logInfo('Authentication success - unlock: $unlock');
      } catch (e) {
        logError('Error in authSuccess(): $e');
      }
    }
  }

  void authFailed({bool unlock = false}) {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.authFailed(unlock: unlock);
        logInfo('Authentication failed - unlock: $unlock');
      } catch (e) {
        logError('Error in authFailed(): $e');
      }
    }
  }
}
