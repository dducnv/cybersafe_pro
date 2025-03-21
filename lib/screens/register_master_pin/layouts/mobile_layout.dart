import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../components/confirm_pin_code_widget.dart';
import '../components/create_pin_code_widget.dart';

class MobileLayout extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey;
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey;
  final GlobalKey<FormState> formCreateKey;
  final GlobalKey<FormState> formConfirmKey;
  const MobileLayout({ super.key, required this.appPinCodeCreateKey, required this.appPinCodeConfirmKey, required this.formCreateKey, required this.formConfirmKey });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CreatePinCodeWidget(
            appPinCodeCreateKey: widget.appPinCodeCreateKey,
            formCreateKey: widget.formCreateKey,
            pageController: pageController,
          ),
          ConfirmPinCodeWidget(
            appPinCodeConfirmKey: widget.appPinCodeConfirmKey,
            formConfirmKey: widget.formConfirmKey,
            pageController: pageController,
          ),
        ],
      ),
    );
  }
}