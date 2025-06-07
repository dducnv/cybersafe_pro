import 'dart:async';

import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppPinCodeFields extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final Function(String, AppPinCodeFieldsState state) onCompleted;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Function() onEnter;
  final TextEditingController? textEditingController;
  final Key formKey;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final bool autoDismissKeyboard;

  const AppPinCodeFields({
    super.key,
    required this.validator,
    required this.onCompleted,
    required this.onChanged,
    required this.onEnter,
    required this.onSubmitted,
    this.textEditingController,
    required this.formKey,
    this.autoFocus,
    this.focusNode,
    this.autoDismissKeyboard = true,
  });

  @override
  State<AppPinCodeFields> createState() => AppPinCodeFieldsState();
}

class AppPinCodeFieldsState extends State<AppPinCodeFields> {
  late StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    widget.textEditingController?.clear();
    HardwareKeyboard.instance.addHandler((event) => _keyboardCallback(event));
  }

  bool _keyboardCallback(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      widget.onEnter();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    errorController.close();
    HardwareKeyboard.instance.removeHandler(_keyboardCallback);
    super.dispose();
  }

  void triggerErrorAnimation() {
    try {
      if (mounted) {
        widget.textEditingController?.clear();
        widget.focusNode?.requestFocus();
        errorController.add(ErrorAnimationType.shake);
      }
    } catch (e) {
      logError('Error triggering animation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.textEditingController == null || !mounted) {
      return const SizedBox.shrink();
    }

    return Form(
      key: widget.formKey,
      child: PinCodeTextField(
        appContext: context,
        focusNode: widget.focusNode,
        pastedTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
        length: 6,
        autoFocus: widget.autoFocus ?? false,
        obscureText: true,
        obscuringCharacter: '*',
        blinkWhenObscuring: false,
        showCursor: true,
        animationType: AnimationType.fade,
        autoDismissKeyboard: DeviceInfo.isMobile(context),
        validator: widget.validator,
        onSubmitted: (value) {
          widget.onSubmitted(value);
        },
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 60,
          fieldWidth: 40,
          borderWidth: 10,
          inactiveFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          selectedColor: Theme.of(context).colorScheme.primary,
          selectedFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          activeFillColor: Theme.of(context).colorScheme.surface,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        cursorColor: Theme.of(context).colorScheme.primary,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: widget.textEditingController,
        keyboardType: TextInputType.number,
        errorTextMargin: const EdgeInsets.only(top: 10),
        boxShadows: const [BoxShadow(offset: Offset(0, 1), color: Colors.black12, blurRadius: 10)],
        onCompleted: (v) {
          widget.onCompleted(v, this);
        },
        onChanged: widget.onChanged,
        autoDisposeControllers: false,
      ),
    );
  }
}
