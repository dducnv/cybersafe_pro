import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';
import 'layouts/desktop_layout.dart';
class PasswordGenerateScreen extends StatelessWidget {
const PasswordGenerateScreen({ super.key });


 @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const PasswordGenerateDesktopLayout();
      case DeviceType.tablet:
        return const PasswordGenarateTabletLayout();
      case DeviceType.mobile:
        return const PasswordGenerateMobileLayout();
    }
  }
}

