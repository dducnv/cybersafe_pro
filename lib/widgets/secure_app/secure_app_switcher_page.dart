import 'dart:ui';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/widgets/secure_app/secure_app_switcher.dart';
import 'package:flutter/material.dart';

/// RouteObserver for screen widgets.
///
/// It is used to detect transition events of screen widgets.
final RouteObserver secureAppSwitcherRouteObserver = RouteObserver();

/// Screen mask function class for screen widgets.
///
/// [secureAppSwitcherRouteObserver] must be set to navigatorObservers.
///
/// It has MaterialPageRoute as its parent and wraps the screen widget with [SecureAppSwitcherPage].
/// For iOS, a mask style can be specified.
///
/// ```dart
/// MaterialPageRoute(builder: (context) {
///   return const SecureAppSwitcherPage(
///     style: SecureMaskStyle.blurLight,
///     child: ScreenA(),
///   );
/// )
/// ```
class SecureAppSwitcherPage extends StatefulWidget {
  /// Widget con sẽ được hiển thị khi ứng dụng đang hoạt động
  final Widget child;
  
  /// Kiểu che giấu nội dung
  final SecureMaskStyle style;
  
  /// Logo hiển thị trên màn hình che giấu (tùy chọn)
  final Widget? logo;
  
  /// Tiêu đề hiển thị trên màn hình che giấu (tùy chọn)
  final String? title;
  
  /// Thông báo hiển thị trên màn hình che giấu (tùy chọn)
  final String? message;

  const SecureAppSwitcherPage({
    super.key,
    required this.child,
    this.style = SecureMaskStyle.blurLight,
    this.logo,
    this.title,
    this.message,
  });

  @override
  State<SecureAppSwitcherPage> createState() => _SecureAppSwitcherPageState();
}

class _SecureAppSwitcherPageState extends State<SecureAppSwitcherPage> with RouteAware {
  /// Trạng thái hiển thị của màn hình che giấu
  bool _showMask = false;
  
  /// Đối tượng quản lý việc che giấu nội dung
  final _secureAppSwitcher = SecureAppSwitcher();

  @override
  void initState() {
    super.initState();
    // Khởi tạo SecureAppSwitcher với các callback
    _secureAppSwitcher.initialize(
      onHidden: _handleAppHidden,
      onRevealed: _handleAppRevealed,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đăng ký với RouteObserver để theo dõi các thay đổi route
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      secureAppSwitcherRouteObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    // Hủy đăng ký với RouteObserver
    secureAppSwitcherRouteObserver.unsubscribe(this);
    super.dispose();
  }

  /// Xử lý khi ứng dụng chuyển sang chế độ nền
  void _handleAppHidden() {
    if (mounted) {
      setState(() {
        _showMask = true;
      });
    }
  }

  /// Xử lý khi ứng dụng trở lại
  void _handleAppRevealed() {
    if (mounted) {
      setState(() {
        _showMask = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Widget con sẽ được hiển thị khi ứng dụng đang hoạt động
        widget.child,
        
        // Màn hình che giấu sẽ hiển thị khi ứng dụng chuyển sang chế độ nền
        if (_showMask)
          _buildMask(context),
      ],
    );
  }

  /// Xây dựng màn hình che giấu dựa trên kiểu đã chọn
  Widget _buildMask(BuildContext context) {
    switch (widget.style) {
      case SecureMaskStyle.blurLight:
        return _buildBlurMask(context, 10.0, Colors.white.withOpacity(0.5));
      case SecureMaskStyle.blurHeavy:
        return _buildBlurMask(context, 20.0, Colors.white.withOpacity(0.7));
      case SecureMaskStyle.blackout:
        return _buildSolidMask(context, Colors.black);
      case SecureMaskStyle.fakePage:
        return _buildFakePage(context);
    }
  }

  /// Xây dựng màn hình che giấu với hiệu ứng làm mờ
  Widget _buildBlurMask(BuildContext context, double sigma, Color overlayColor) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          color: overlayColor,
          child: _buildMaskContent(context),
        ),
      ),
    );
  }

  /// Xây dựng màn hình che giấu với màu đặc
  Widget _buildSolidMask(BuildContext context, Color color) {
    return Positioned.fill(
      child: Container(
        color: color,
        child: _buildMaskContent(context),
      ),
    );
  }

  /// Xây dựng màn hình giả
  Widget _buildFakePage(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                'Ứng dụng đã bị khóa',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Nhấn để mở khóa',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Xây dựng nội dung hiển thị trên màn hình che giấu
  Widget _buildMaskContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.logo != null) widget.logo!,
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          if (widget.message != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.message!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
        ],
      ),
    );
  }
}