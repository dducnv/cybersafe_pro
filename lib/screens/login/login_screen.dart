import 'package:cybersafe_pro/widgets/pin_code_widget/pin_code_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final pinCodeRef = PinCodeWidgetRef();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinCodeWidget(
        key: pinCodeRef,
        hintText: "Nhập mật khẩu",
        onDonePressed: (value) async {
          if (value.length < 6) {
            pinCodeRef.currentState?.setValidateMessage('Mã pin phải có ít nhất 6 ký tự');
            await Future.delayed(const Duration(seconds: 2));
            pinCodeRef.currentState?.clearPincode();
          }
        },
      ),
    );
  }
}
