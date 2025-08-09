import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

class SecureNumericKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final Function(String value)? onDonePressed;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final Color iconColor;
  final double buttonSize;
  final double buttonSpacing;
  final double buttonRadius;
  final Widget? centerButton;

  const SecureNumericKeyboard({
    super.key,
    required this.controller,
    required this.scrollController,
    this.onDonePressed,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.iconColor = const Color(0xFF000000),
    this.buttonSize = 65.0,
    this.buttonSpacing = 10.0,
    this.buttonRadius = 10.0,
    this.centerButton,
  });

  @override
  State<SecureNumericKeyboard> createState() => _SecureNumericKeyboardState();
}

class _SecureNumericKeyboardState extends State<SecureNumericKeyboard> {
  @override
  void initState() {
    super.initState();
  }

  void _onKeyPressed(String value) {
    final currentText = widget.controller.text;
    widget.controller.text = currentText + value;

    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
  }

  void _onBackspacePressed() {
    if (widget.controller.text.isNotEmpty) {
      final currentText = widget.controller.text;
      widget.controller.text = currentText.substring(0, currentText.length - 1);

      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    }
  }

  void _onDonePressed() {
    if (widget.onDonePressed != null) {
      widget.onDonePressed!(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.buttonSpacing),
      color: widget.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildKeyboardRow([1, 2, 3]),
          SizedBox(height: widget.buttonSpacing),
          _buildKeyboardRow([4, 5, 6]),
          SizedBox(height: widget.buttonSpacing),
          _buildKeyboardRow([7, 8, 9]),
          SizedBox(height: widget.buttonSpacing),
          _buildKeyboardRow([-1, 0, -2]),
          SizedBox(height: widget.buttonSpacing),
          if (widget.centerButton != null) widget.centerButton!,
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<int> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          values.map((value) {
            if (value == -1) {
              // Empty button
              return _buildButton(
                child: Icon(Icons.backspace, color: widget.iconColor, size: 24),
                bgColor: Colors.transparent,
                onPressed: _onBackspacePressed,
              );
            } else if (value == -2) {
              // Backspace button
              return _buildButton(
                child: Icon(Icons.done, color: widget.iconColor, size: 24),
                bgColor: Colors.transparent,
                onPressed: _onDonePressed,
              );
            } else if (value == -3) {
              return SizedBox(width: widget.buttonSize);
            } else {
              // Number button
              return _buildButton(
                child: Text(
                  value.toString(),
                  style: CustomTextStyle.regular(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.textColor,
                  ),
                ),
                onPressed: () => _onKeyPressed(value.toString()),
              );
            }
          }).toList(),
    );
  }

  Widget _buildButton({required Widget child, required VoidCallback onPressed, Color? bgColor}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.buttonSpacing / 2),
      width: widget.buttonSize,
      height: widget.buttonSize,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: bgColor ?? widget.buttonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.buttonRadius)),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
