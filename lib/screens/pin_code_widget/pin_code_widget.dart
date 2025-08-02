import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/secure_numeric_keyboard/secure_numeric_keyboard.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

class PinCodeWidget extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  const PinCodeWidget({super.key, this.title, this.hintText, this.controller});

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  final TextEditingController _controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: widget.controller ?? _controller,
                  scrollController: scrollController,
                  obscureText: true,
                  obscuringCharacter: '●',
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.none,
                  readOnly: true,
                  style: CustomTextStyle.regular(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                  showCursor: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: context.trLogin(LoginText.enterPin),
                    hintFadeDuration: const Duration(milliseconds: 300),
                    hintStyle: CustomTextStyle.regular(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ),
            if (widget.hintText != null)
              Text(
                widget.hintText!,
                style: CustomTextStyle.regular(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),

            SecureNumericKeyboard(
              controller: widget.controller ?? _controller,
              scrollController: scrollController,
              shuffleNumbers: true,
              buttonSize: 74.w,
              buttonRadius: 100,
              buttonSpacing: 18,
              buttonColor: context.darkMode ? Colors.white.withValues(alpha: 0.2) : Colors.white,
              backgroundColor: Colors.transparent,
              textColor: context.darkMode ? Colors.white : Colors.black87,
              iconColor: context.darkMode ? Colors.white : Colors.black87,
              onDonePressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
