import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enum định nghĩa các kiểu che giấu nội dung
enum SecureMaskStyle {
  /// Làm mờ nhẹ nội dung
  blurLight,
  
  /// Làm mờ mạnh nội dung
  blurHeavy,
  
  /// Che phủ hoàn toàn bằng màu đen
  blackout,
  
  /// Hiển thị màn hình giả
  fakePage,
}

/// RouteObserver để theo dõi các thay đổi route và xử lý việc che giấu nội dung
final RouteObserver<ModalRoute<void>> secureAppSwitcherRouteObserver = RouteObserver<ModalRoute<void>>();

/// Lớp quản lý việc che giấu nội dung khi ứng dụng chuyển sang chế độ nền
class SecureAppSwitcher with WidgetsBindingObserver {
  static final SecureAppSwitcher _instance = SecureAppSwitcher._internal();
  
  factory SecureAppSwitcher() => _instance;
  
  // MethodChannel để giao tiếp với mã native
  static const MethodChannel _methodChannel = MethodChannel('com.cybersafe_pro/secure_app');
  
  // Trạng thái chặn chụp màn hình
  bool _isScreenshotBlocked = false;
  
  SecureAppSwitcher._internal() {
    WidgetsBinding.instance.addObserver(this);
    // Mặc định bật chặn chụp màn hình khi khởi tạo
    blockScreenshots();
  }
  
  /// Callback được gọi khi ứng dụng thay đổi trạng thái
  VoidCallback? onAppHidden;
  
  /// Callback được gọi khi ứng dụng trở lại
  VoidCallback? onAppRevealed;
  
  /// Trạng thái hiện tại của ứng dụng
  bool _isHidden = false;
  
  /// Kiểm tra xem ứng dụng có đang bị che giấu không
  bool get isHidden => _isHidden;
  
  /// Kiểm tra xem chức năng chặn chụp màn hình có đang bật không
  bool get isScreenshotBlocked => _isScreenshotBlocked;
  
  /// Bật chặn chụp màn hình
  Future<void> blockScreenshots() async {
    try {
      await _methodChannel.invokeMethod('blockScreenshots');
      _isScreenshotBlocked = true;
    } catch (e) {
      debugPrint('Không thể bật chặn chụp màn hình: $e');
    }
  }
  
  /// Tắt chặn chụp màn hình
  Future<void> allowScreenshots() async {
    try {
      await _methodChannel.invokeMethod('allowScreenshots');
      _isScreenshotBlocked = false;
    } catch (e) {
      debugPrint('Không thể tắt chặn chụp màn hình: $e');
    }
  }
  
  /// Xử lý khi ứng dụng thay đổi trạng thái (chuyển sang nền hoặc trở lại)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Ứng dụng chuyển sang nền hoặc bị che khuất một phần
        if (!_isHidden) {
          _isHidden = true;
          onAppHidden?.call();
        }
        break;
      case AppLifecycleState.resumed:
        // Ứng dụng trở lại
        if (_isHidden) {
          _isHidden = false;
          onAppRevealed?.call();
          // Đảm bảo chặn chụp màn hình được bật lại khi ứng dụng trở lại
          if (_isScreenshotBlocked) {
            blockScreenshots();
          }
        }
        break;
      default:
        break;
    }
  }
  
  /// Hủy observer khi không cần thiết
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Tắt chặn chụp màn hình khi dispose
    allowScreenshots();
  }
  
  /// Khởi tạo SecureAppSwitcher với các callback
  void initialize({VoidCallback? onHidden, VoidCallback? onRevealed, bool blockScreenshot = true}) {
    onAppHidden = onHidden;
    onAppRevealed = onRevealed;
    
    if (blockScreenshot) {
      blockScreenshots();
    } else {
      allowScreenshots();
    }
  }
}