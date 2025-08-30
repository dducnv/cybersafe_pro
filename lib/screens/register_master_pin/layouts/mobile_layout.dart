import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../components/confirm_pin_code_widget.dart';
import '../components/create_pin_code_widget.dart';

class MobileLayout extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey;
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey;
  final GlobalKey<FormState> formCreateKey;
  final GlobalKey<FormState> formConfirmKey;
  final bool? isChangePin;
  final String? oldPin;
  const MobileLayout({
    super.key,
    required this.appPinCodeCreateKey,
    required this.appPinCodeConfirmKey,
    required this.formCreateKey,
    required this.formConfirmKey,
    this.isChangePin,
    this.oldPin,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isChangePin == true
              ? AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surface,
                scrolledUnderElevation: 0,
              )
              : null,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CreatePinCodeWidget(
            appPinCodeCreateKey: widget.appPinCodeCreateKey,
            formCreateKey: widget.formCreateKey,
            pageController: pageController,
            isChangePin: widget.isChangePin ?? false,
          ),
          ConfirmPinCodeWidget(
            appPinCodeConfirmKey: widget.appPinCodeConfirmKey,
            formConfirmKey: widget.formConfirmKey,
            pageController: pageController,
            isChangePin: widget.isChangePin ?? false,
            oldPin: widget.oldPin,
          ),
        ],
      ),
    );
  }
}
