import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
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
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginSuccess;
  const LoginMasterPassword({super.key, this.showBiometric = true, this.isFromBackup = false, this.callBackLoginSuccess});

  @override
  State<LoginMasterPassword> createState() => _LoginMasterPasswordState();
}

class _LoginMasterPasswordState extends State<LoginMasterPassword> {
  @override
  void initState() {
    context.read<AppProvider>().stopTimer();
    context.read<LocalAuthProvider>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const DesktopLayout();
      case DeviceType.tablet:
        return const TabletLayout();
      case DeviceType.mobile:
        return MobileLayout(showBiometric: widget.showBiometric, isFromBackup: widget.isFromBackup, callBackLoginSuccess: widget.callBackLoginSuccess);
    }
  }
}
