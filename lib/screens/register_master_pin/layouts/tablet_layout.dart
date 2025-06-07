import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../components/confirm_pin_code_widget.dart';
import '../components/create_pin_code_widget.dart';

class TabletLayout extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey;
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey;
  final GlobalKey<FormState> formCreateKey;
  final GlobalKey<FormState> formConfirmKey;
  final bool? isChangePin;
  
  const TabletLayout({
    super.key, 
    required this.appPinCodeCreateKey, 
    required this.appPinCodeConfirmKey, 
    required this.formCreateKey, 
    required this.formConfirmKey, 
    this.isChangePin
  });

  @override
  State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
  final PageController pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isChangePin == true 
        ? AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            scrolledUnderElevation: 0,
            title: const Text("Thay đổi mật khẩu chính"),
            centerTitle: true,
          ) 
        : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: PageView(
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}