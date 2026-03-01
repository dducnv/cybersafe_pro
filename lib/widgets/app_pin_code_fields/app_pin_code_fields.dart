//
import 'dart:math';

//
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class ObscuringTextEditingController extends TextEditingController {
  ObscuringTextEditingController({super.text});

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    var displayValue = '●' * value.text.length;
    if (!withComposing) {
      return TextSpan(style: style, text: displayValue);
    }
    final composingRegion = value.composing;
    if (composingRegion.isValid) {
      return TextSpan(
        style: style,
        children: <TextSpan>[
          TextSpan(text: displayValue.substring(0, composingRegion.start)),
          TextSpan(
            style: style?.merge(const TextStyle(decoration: TextDecoration.underline)),
            text: displayValue.substring(composingRegion.start, composingRegion.end),
          ),
          TextSpan(text: displayValue.substring(composingRegion.end)),
        ],
      );
    }
    return TextSpan(style: style, text: displayValue);
  }
}

class AppPinCodeFieldsState extends State<AppPinCodeFields> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late ObscuringTextEditingController _obscuringController;
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _obscuringController = ObscuringTextEditingController(text: widget.textEditingController?.text);
    _internalFocusNode = widget.focusNode ?? FocusNode();

    if (widget.textEditingController != null) {
      _obscuringController.addListener(() {
        if (widget.textEditingController!.text != _obscuringController.text) {
          widget.textEditingController!.text = _obscuringController.text;
        }
      });
      widget.textEditingController!.addListener(() {
        if (_obscuringController.text != widget.textEditingController!.text) {
          _obscuringController.text = widget.textEditingController!.text;
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.textEditingController?.clear();
      HardwareKeyboard.instance.addHandler(_keyboardCallback);
    });
  }

  bool _keyboardCallback(KeyEvent event) {
    if (!mounted) return false;
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      widget.onEnter();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _obscuringController.dispose();
    HardwareKeyboard.instance.removeHandler(_keyboardCallback);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void requestFocus() {
    try {
      if (mounted) {
        _internalFocusNode.requestFocus();
      }
    } catch (e) {
      logError('Error requesting focus: $e', functionName: "AppPinCodeFieldsState.requestFocus");
    }
  }

  void triggerErrorAnimation() {
    try {
      if (mounted) {
        widget.textEditingController?.clear();
        widget.focusNode?.requestFocus();
        _shakeController.forward(from: 0.0);
      }
    } catch (e) {
      logError('Error triggering animation: $e', functionName: "AppPinCodeFieldsState.triggerErrorAnimation");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.textEditingController == null || !mounted) {
      return const SizedBox.shrink();
    }

    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (context, child) {
        final sineValue = sin(offsetAnimation.value * pi * 4);
        return Transform.translate(offset: Offset(sineValue * 10, 0), child: child);
      },
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          focusNode: _internalFocusNode,
          controller: _obscuringController,
          autofocus: widget.autoFocus ?? false,
          obscureText: false,
          keyboardType: TextInputType.visiblePassword,
          enableSuggestions: false,
          autocorrect: false,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\x20-\x7E]'))],
          style: CustomTextStyle.regular(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 8.0),
          cursorColor: Theme.of(context).colorScheme.primary,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
            ),
          ),
          validator: widget.validator,
          onFieldSubmitted: (value) {
            widget.onSubmitted(value);
            widget.onCompleted(value, this);
          },
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
