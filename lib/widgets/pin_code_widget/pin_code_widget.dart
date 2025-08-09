import 'dart:async';

import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/secure_numeric_keyboard/secure_numeric_keyboard.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

typedef PinCodeWidgetRef = GlobalKey<_PinCodeWidgetState>;

class PinCodeWidget extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final Function(String value) onDonePressed;
  final ValueNotifier<String>? validateMessage;
  final int validateMessageDuration;

  const PinCodeWidget({
    super.key,
    this.title,
    this.hintText,
    this.controller,
    this.validateMessage,
    this.validateMessageDuration = 2,
    required this.onDonePressed,
  });

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late ScrollController scrollController;
  final ValueNotifier<String> _internalValidateMessage = ValueNotifier('');
  Timer? _validateMessageTimer;

  late AnimationController _animationController;
  late Animation<double> _validateTextAnimation;

  void clearPincode() {
    _controller.clear();
  }

  void clearValidateMessage() {
    final notifier = widget.validateMessage ?? _internalValidateMessage;
    notifier.value = '';
    _cancelValidateTimer();
  }

  void setValidateMessage(String message) {
    final notifier = widget.validateMessage ?? _internalValidateMessage;
    notifier.value = message;
    _startValidateTimer();
    _animationController.forward();
  }

  void _startValidateTimer() {
    _cancelValidateTimer();
    _validateMessageTimer = Timer(
      Duration(seconds: widget.validateMessageDuration),
      clearValidateMessage,
    );
  }

  void _cancelValidateTimer() {
    _validateMessageTimer?.cancel();
    _validateMessageTimer = null;
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _validateTextAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    (widget.validateMessage ?? _internalValidateMessage).addListener(_onValidateMessageChanged);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_controller.text.isEmpty) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onValidateMessageChanged() {
    final message = (widget.validateMessage ?? _internalValidateMessage).value;
    if (message.isNotEmpty) {
      _startValidateTimer();
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _cancelValidateTimer();
    _internalValidateMessage.dispose();
    (widget.validateMessage ?? _internalValidateMessage).removeListener(_onValidateMessageChanged);
    _controller.removeListener(_onTextChanged);
    _animationController.dispose();
    scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: widget.validateMessage ?? _internalValidateMessage,
                  builder: (context, value, child) {
                    return value.isNotEmpty
                        ? FadeTransition(
                          opacity: _validateTextAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.5),
                              end: Offset.zero,
                            ).animate(_validateTextAnimation),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                value,
                                style: CustomTextStyle.regular(
                                  fontSize: 14.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                        : SizedBox(
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
                        );
                  },
                ),

                ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return value.text.isEmpty && widget.hintText != null
                        ? Text(
                          key: const ValueKey('hintText'),
                          widget.hintText!,
                          style: CustomTextStyle.regular(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        : const SizedBox.shrink(key: ValueKey('empty'));
                  },
                ),
              ],
            ),
          ),

          SecureNumericKeyboard(
            controller: widget.controller ?? _controller,
            scrollController: scrollController,
            buttonSize: 74.w,
            buttonRadius: 100,
            buttonSpacing: 18,
            buttonColor: context.darkMode ? Colors.white.withValues(alpha: 0.2) : Colors.white,
            backgroundColor: Colors.transparent,
            textColor: context.darkMode ? Colors.white : Colors.black87,
            iconColor: context.darkMode ? Colors.white : Colors.black87,
            onDonePressed: widget.onDonePressed,
          ),
        ],
      ),
    );
  }
}
