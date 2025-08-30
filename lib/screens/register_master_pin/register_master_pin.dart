import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'layouts/mobile_layout.dart';

class RegisterMasterPin extends StatefulWidget {
  final bool? isChangePin;
  final String? oldPin;
  const RegisterMasterPin({super.key, this.isChangePin = false, this.oldPin});

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
    SecureApplicationUtil.instance.pause();
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      appPinCodeCreateKey: appPinCodeCreateKey,
      appPinCodeConfirmKey: appPinCodeConfirmKey,
      formCreateKey: formCreateKey,
      formConfirmKey: formConfirmKey,
      isChangePin: widget.isChangePin,
      oldPin: widget.oldPin,
    );
  }
}
