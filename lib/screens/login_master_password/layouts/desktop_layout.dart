
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/not_support/not_support_widget.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginSuccess;

  const DesktopLayout({super.key, this.showBiometric = true, this.isFromBackup = false, this.callBackLoginSuccess});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return const NotSupportWidget();
  }
}
