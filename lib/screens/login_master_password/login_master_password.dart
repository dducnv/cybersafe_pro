import 'package:flutter/material.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class LoginMasterPassword extends StatefulWidget {
  const LoginMasterPassword({super.key});

  @override
  State<LoginMasterPassword> createState() => _LoginMasterPasswordState();
}

class _LoginMasterPasswordState extends State<LoginMasterPassword> {

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const DesktopLayout();
      case DeviceType.tablet:
        return const TabletLayout();
      case DeviceType.mobile:
        return MobileLayout();
    }
  }
}
