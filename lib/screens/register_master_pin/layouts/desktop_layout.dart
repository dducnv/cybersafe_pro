import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/not_support/not_support_widget.dart';
import 'package:flutter/material.dart';

import '../components/confirm_pin_code_widget.dart';
import '../components/create_pin_code_widget.dart';

class DesktopLayout extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey;
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey;
  final GlobalKey<FormState> formCreateKey;
  final GlobalKey<FormState> formConfirmKey;
  final bool? isChangePin;
  
  const DesktopLayout({
    super.key, 
    required this.appPinCodeCreateKey, 
    required this.appPinCodeConfirmKey, 
    required this.formCreateKey, 
    required this.formConfirmKey, 
    this.isChangePin
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  final PageController pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return const NotSupportWidget();
  }
}