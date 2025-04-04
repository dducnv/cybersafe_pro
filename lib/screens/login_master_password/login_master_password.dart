import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class LoginMasterPassword extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final bool isFromRestore;
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginSuccess;
  
  const LoginMasterPassword({
    super.key, 
    this.showBiometric = true, 
    this.isFromBackup = false, 
    this.isFromRestore = false, 
    this.callBackLoginSuccess
  });

  @override
  State<LoginMasterPassword> createState() => _LoginMasterPasswordState();
}

class _LoginMasterPasswordState extends State<LoginMasterPassword> {
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!_mounted) return;
    
    // Đảm bảo SecureApplicationUtil được khởi tạo
    SecureApplicationUtil.instance.init();
    FlutterNativeSplash.remove();

    try {
      // Sử dụng provider có sẵn thay vì tạo mới
      final authProvider = Provider.of<LocalAuthProvider>(context, listen: false);
      await authProvider.init(widget.showBiometric && !widget.isFromBackup && !widget.isFromRestore);
      // Dừng timer
      if (_mounted) {
        context.read<AppProvider>().stopTimer();
      }
    } catch (e) {
      logError('Error initializing login screen: $e');
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    
    // Sử dụng ChangeNotifierProvider.value để đảm bảo rằng provider không bị
    // tạo mới và không bị dispose khi widget này dispose
    return Consumer<LocalAuthProvider>(
      builder: (context, authProvider, _) {
        return _buildLayout(deviceType);
      },
    );
  }

  Widget _buildLayout(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return const DesktopLayout();
      case DeviceType.tablet:
        return MobileLayout(
          showBiometric: widget.showBiometric,
          isFromBackup: widget.isFromBackup,
          callBackLoginSuccess: widget.callBackLoginSuccess
        );
      case DeviceType.mobile:
        return MobileLayout(
          showBiometric: widget.showBiometric,
          isFromBackup: widget.isFromBackup,
          isFromRestore: widget.isFromRestore,
          callBackLoginSuccess: widget.callBackLoginSuccess
        );
    }
  }
}
