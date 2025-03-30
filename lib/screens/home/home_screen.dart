import 'package:flutter/material.dart';
import '../../utils/device_type.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';
import 'layouts/desktop_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const HomeDesktopLayout();
      case DeviceType.tablet:
        return const HomeMobileLayout();
      case DeviceType.mobile:
        return const HomeMobileLayout();
    }
  }
}
