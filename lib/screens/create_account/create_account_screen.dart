import 'package:flutter/material.dart';
import '../../utils/device_type.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';
import 'layouts/desktop_layout.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

 @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const CreateAccountDesktopLayout();
      case DeviceType.tablet:
        return const CreateAccountTabletLayout();
      case DeviceType.mobile:
        return const CreateAccountMobileLayout();
    }
  }
}
