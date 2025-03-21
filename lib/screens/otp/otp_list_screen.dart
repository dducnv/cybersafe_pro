import 'package:cybersafe_pro/screens/otp/layouts/desktop_layout.dart';
import 'package:cybersafe_pro/screens/otp/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/otp/layouts/tablet_layout.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:flutter/material.dart';

class OtpListScreen extends StatelessWidget {
  const OtpListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.desktop:
        return const OtpDesktopLayout();
      case DeviceType.tablet:
        return const OtpTabletLayout();
      case DeviceType.mobile:
        return const OtpMobileLayout();
    }
  }
}
