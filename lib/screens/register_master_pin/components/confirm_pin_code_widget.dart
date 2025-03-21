import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmPinCodeWidget extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey;
  final GlobalKey<FormState> formConfirmKey;
  final PageController pageController;
  const ConfirmPinCodeWidget({super.key, required this.appPinCodeConfirmKey, required this.formConfirmKey, required this.pageController});

  @override
  State<ConfirmPinCodeWidget> createState() => _ConfirmPinCodeWidgetState();
}

class _ConfirmPinCodeWidgetState extends State<ConfirmPinCodeWidget> {
  TextEditingController pinCodeController = TextEditingController();
  int timeCorrect = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Xác nhận mã PIN", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          constraints: const BoxConstraints(maxWidth: 430),
          child: AppPinCodeFields(
            key: widget.appPinCodeConfirmKey,
            formKey: widget.formConfirmKey,
            onSubmitted: (value) {},
            onEnter: () {},
            textEditingController: pinCodeController,
            autoFocus: true,
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập mã PIN";
              }
              bool isVerified = Provider.of<LocalAuthProvider>(context, listen: false).verifyRegisterPinCode(value);
              if (!isVerified) {
                return "Mã PIN không khớp";
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
            widget.formConfirmKey.currentState!.validate();
            bool isVerified = Provider.of<LocalAuthProvider>(context, listen: false).verifyRegisterPinCode(pinCodeController.text);
            if (isVerified && pinCodeController.text.isNotEmpty && context.mounted) {
              Provider.of<LocalAuthProvider>(context, listen: false).savePinCode();
              AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
            } else {
              timeCorrect++;
              widget.appPinCodeConfirmKey.currentState!.triggerErrorAnimation();
              if (timeCorrect >= 3) {
                widget.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            }
          },
          text: "",
          child: Icon(Icons.check, size: 24.sp, color: Colors.white),
        ),
      ],
    );
  }
}
