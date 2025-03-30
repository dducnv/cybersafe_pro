import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:provider/provider.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class LoginMasterPassword extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final bool isFromRestore;
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginSuccess;
  const LoginMasterPassword({super.key, this.showBiometric = true, this.isFromBackup = false, this.isFromRestore = false, this.callBackLoginSuccess});

  @override
  State<LoginMasterPassword> createState() => _LoginMasterPasswordState();
}

class _LoginMasterPasswordState extends State<LoginMasterPassword> {
  bool _mounted = true;

  @override
  void initState() {
    super.initState();

    // Đảm bảo SecureApplicationUtil được khởi tạo
    SecureApplicationUtil.instance.init();
    // Tạo mới provider
    final provider = Provider.of<LocalAuthProvider>(context, listen: false);
    provider.init(widget.showBiometric && widget.isFromBackup == false);

    // Khởi tạo LocalAuthProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_mounted) return;
      try {
        // Dừng timer
        context.read<AppProvider>().stopTimer();
      } catch (e) {
        logError('Error initializing login screen: $e');
      }
    });
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const DesktopLayout();
      case DeviceType.tablet:
        return  TabletLayout(showBiometric: widget.showBiometric, isFromBackup: widget.isFromBackup, callBackLoginSuccess: widget.callBackLoginSuccess);
      case DeviceType.mobile:
        return MobileLayout(showBiometric: widget.showBiometric, isFromBackup: widget.isFromBackup, isFromRestore: widget.isFromRestore, callBackLoginSuccess: widget.callBackLoginSuccess);
    }
  }
}
