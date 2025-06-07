import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreatePinCodeWidget extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey;
  final GlobalKey<FormState> formCreateKey;
  final PageController pageController;
  final bool isChangePin;
  const CreatePinCodeWidget({super.key, required this.appPinCodeCreateKey, required this.formCreateKey, required this.pageController, this.isChangePin = false});

  @override
  State<CreatePinCodeWidget> createState() => _CreatePinCodeWidgetState();
}

class _CreatePinCodeWidgetState extends State<CreatePinCodeWidget> {
  TextEditingController pinCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          _handleSubmit();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.isChangePin ? context.trLogin(LoginText.changePinCode) : context.trCreatePinCode(LoginText.createPinCode), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: AppPinCodeFields(
              key: widget.appPinCodeCreateKey,
              formKey: widget.formCreateKey,
              textEditingController: pinCodeController,
              onSubmitted: (value) {},
              onEnter: () {},
              autoFocus: true,
              validator: (value) {
                if (value!.length < 6) {
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
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }

  _handleSubmit() {
    widget.formCreateKey.currentState!.validate();
    if (pinCodeController.text.length < 6) {
      widget.appPinCodeCreateKey.currentState!.triggerErrorAnimation();
    }
    if (pinCodeController.text.isNotEmpty && context.mounted) {
      Provider.of<LocalAuthProvider>(context, listen: false).setPinCodeToConfirm(pinCodeController.text);
      widget.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }
}
