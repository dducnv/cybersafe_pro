import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';

import 'package:cybersafe_pro/utils/device_type.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class RegisterMasterPin extends StatefulWidget {
  const RegisterMasterPin({super.key});

  @override
  State<RegisterMasterPin> createState() => _RegisterMasterPinState();
}

class _RegisterMasterPinState extends State<RegisterMasterPin> {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey = GlobalKey<AppPinCodeFieldsState>();
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey = GlobalKey<AppPinCodeFieldsState>();

    final GlobalKey<FormState> formCreateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formConfirmKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const DesktopLayout();
      case DeviceType.tablet:
        return const TabletLayout();
      case DeviceType.mobile:
        return MobileLayout(
          appPinCodeCreateKey: appPinCodeCreateKey,
          appPinCodeConfirmKey: appPinCodeConfirmKey,
          formCreateKey: formCreateKey,
          formConfirmKey: formConfirmKey,
        );
    }
  }
}
