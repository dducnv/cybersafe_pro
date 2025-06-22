import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/toast_noti.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

class ConfirmPinCodeWidget extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey;
  final GlobalKey<FormState> formConfirmKey;
  final PageController pageController;
  final bool isChangePin;
  const ConfirmPinCodeWidget({super.key, required this.appPinCodeConfirmKey, required this.formConfirmKey, required this.pageController, this.isChangePin = false});

  @override
  State<ConfirmPinCodeWidget> createState() => _ConfirmPinCodeWidgetState();
}

class _ConfirmPinCodeWidgetState extends State<ConfirmPinCodeWidget> {
  TextEditingController pinCodeController = TextEditingController();
  int timeCorrect = 0;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          _handleSubmit();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.trCreatePinCode(LoginText.confirmPinCode), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: AppPinCodeFields(
              key: widget.appPinCodeConfirmKey,
              formKey: widget.formConfirmKey,
              onSubmitted: (value) {
                _handleSubmit();
              },
              onEnter: () {
                _handleSubmit();
              },
              textEditingController: pinCodeController,
              autoFocus: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return context.trSafe(LoginText.pinCodeRequired);
                }
                return null;
              },
              onCompleted: (value, state) {},
              onChanged: (value) {},
            ),
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 20),
          CustomButtonWidget(
            borderRaidus: 100,
            width: 75.h,
            height: 75.h,
            onPressed: () async {
              _handleSubmit();
            },
            text: "",
            child: Icon(Icons.check, size: 24.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  _handleSubmit() {
    widget.formConfirmKey.currentState!.validate();
    bool isVerified = Provider.of<LocalAuthProvider>(context, listen: false).verifyRegisterPinCode(pinCodeController.text);
    if (isVerified && pinCodeController.text.isNotEmpty && context.mounted) {
      Provider.of<LocalAuthProvider>(context, listen: false).savePinCode();
      context.read<AppProvider>().initializeTimer();
      AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
    } else {
      timeCorrect++;
      widget.appPinCodeConfirmKey.currentState!.triggerErrorAnimation();
      showToastWarning(context.trSafe(LoginText.pinCodeNotMatch), context: context, position: StyledToastPosition.top);

      if (timeCorrect >= 1) {
        focusNode.dispose();
        widget.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }
}
