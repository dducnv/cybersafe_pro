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
  bool _shouldLockOnBackground = true;

  Future<void> get initDone => _initCompleter.future;
  bool get isInitialized => _isInitialized;
  bool get shouldLockOnBackground => _shouldLockOnBackground;

  // Setter để kiểm soát việc lock khi vào background
  void setShouldLockOnBackground(bool shouldLock) {
    _shouldLockOnBackground = shouldLock;
  }

  // Phương thức reset instance
  void resetInstance() {
    dispose();
    _isInitialized = false;
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  Future<void> init({bool autoLock = true}) async {
    try {
      // Nếu controller đã bị dispose, tạo mới nó
      if (secureApplicationController == null || _isDisposed) {
        _isDisposed = false;
        secureApplicationController = SecureApplicationController(
          SecureApplicationState(),
        );
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

  void dispose() {
    lockStateChanged.dispose();
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
}
