import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';

import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class RegisterMasterPin extends StatefulWidget {
  final bool? isChangePin;
  const RegisterMasterPin({super.key, this.isChangePin = false});

  @override
  State<RegisterMasterPin> createState() => _RegisterMasterPinState();
}

class _RegisterMasterPinState extends State<RegisterMasterPin> {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey = GlobalKey<AppPinCodeFieldsState>();
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey = GlobalKey<AppPinCodeFieldsState>();

  final GlobalKey<FormState> formCreateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formConfirmKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      appPinCodeCreateKey: appPinCodeCreateKey,
      appPinCodeConfirmKey: appPinCodeConfirmKey,
      formCreateKey: formCreateKey,
      formConfirmKey: formConfirmKey,
      isChangePin: widget.isChangePin,
    );
  }
}
