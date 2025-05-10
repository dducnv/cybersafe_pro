import 'package:cybersafe_pro/utils/logger.dart';
import 'package:secure_application/secure_application.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class SecureApplicationUtil {
  static final instance = SecureApplicationUtil._internal();

  SecureApplicationUtil._internal();

  SecureApplicationController? secureApplicationController;
  bool _isDisposed = false;
  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitialized = false;
  final ValueNotifier<bool> lockStateChanged = ValueNotifier<bool>(false);

  Future<void> get initDone => _initCompleter.future;
  bool get isInitialized => _isInitialized;

  // Phương thức reset instance
  void resetInstance() {
    dispose();
    _isInitialized = false;
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  Future<void> init() async {
    try {
      // Nếu controller đã bị dispose, tạo mới nó
      if (secureApplicationController == null || _isDisposed) {
        _isDisposed = false;
        secureApplicationController = SecureApplicationController(SecureApplicationState());
        secureApplicationController?.open();
        _setupListeners();
        _isInitialized = true;
        if (!_initCompleter.isCompleted) {
          _initCompleter.complete();
        }
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
      // Thông báo sự thay đổi trạng thái mà không truy cập trực tiếp widget
      lockStateChanged.value = !lockStateChanged.value;
    });
  }

  void lock() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.lock();
      } catch (e) {
        logError('Error in lock(): $e');
      }
    }
  }

  void unlock() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.unlock();
      } catch (e) {
        logError('Error in unlock(): $e');
      }
    }
  }

  void secure() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.secure();
      } catch (e) {
        logError('Error in secure(): $e');
      }
    }
  }

  void open() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.open();
      } catch (e) {
        logError('Error in open(): $e');
      }
    }
  }

  void pause() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.pause();
      } catch (e) {
        logError('Error in pause(): $e');
      }
    }
  }

  void unpause() {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.unpause();
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
      } catch (e) {
        logError('Error in authSuccess(): $e');
      }
    }
  }

  void authFailed({bool unlock = false}) {
    if (!_isDisposed && secureApplicationController != null) {
      try {
        secureApplicationController?.authFailed(unlock: unlock);
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
      } catch (e) {
        logError('Error disposing SecureApplicationController: $e');
      } finally {
        secureApplicationController = null;
      }
    }
  }
}
