import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

InputBorder errorBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      this.widthTextField,
      this.suffixIconConstraintsMaxHeight,
      this.kPaddingPrefixIcon,
      this.kMarginTextField,
      this.cursorHeight,
      required this.controller,
      required this.textInputAction,
      this.textInputType,
      required this.textAlign,
      this.hintText,
      this.helperText,
      this.labelText,
      this.textError,
      this.titleTextField,
      this.obscuringCharacter = '•',
      this.hintStyle,
      this.textStyle,
      this.titleTextStyle,
      this.floatingLabelStyle,
      this.labelStyle,
      this.focusedBorder,
      this.enabledBorder,
      this.errorBorder,
      this.onChanged,
      this.onFieldSubmitted,
      this.validator,
      this.onTap,
      this.focusChanged,
      this.prefixIcon,
      this.suffixIcon,
      this.textColor,
      this.colorBackGround,
      this.cursorColor,
      this.borderColor,
      this.focusNode,
      this.margin,
      this.inputFormatters,
      this.isObscure = false,
      this.readOnly = false,
      this.autoFocus = false,
      this.focusTextField = true,
      this.maxLength,
      this.minLines,
      this.maxLines,
      this.contentPadding,
      this.requiredTextField = false,
      this.borderRadius,
      this.autofillHints});

  final double? widthTextField,
      suffixIconConstraintsMaxHeight,
      kPaddingPrefixIcon,
      kMarginTextField,
      cursorHeight;

  final bool isObscure, readOnly, autoFocus, focusTextField, requiredTextField;
  final int? maxLength, minLines, maxLines;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType? textInputType;
  final TextAlign textAlign;
  final String? hintText,
      labelText,
      textError,
      titleTextField,
      obscuringCharacter,
      helperText;
  final TextStyle? hintStyle,
      textStyle,
      titleTextStyle,
      floatingLabelStyle,
      labelStyle;
  final InputBorder? focusedBorder, enabledBorder, errorBorder;

  final Function(String)? onChanged, onFieldSubmitted;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final void Function(bool isFocus)? focusChanged;

  final Widget? prefixIcon, suffixIcon;
  final Color? textColor, colorBackGround, cursorColor, borderColor;

  final FocusNode? focusNode;
  final EdgeInsetsGeometry? margin, contentPadding;
  final BorderRadius? borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  void hideKeyBoard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.titleTextField != null,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 5),
              child: RichText(
                text: TextSpan(
                  text: widget.titleTextField ?? '',
                  style: widget.titleTextStyle ??
                      TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600]),
                  children: widget.requiredTextField
                      ? <TextSpan>[
                          TextSpan(
                              text: '*',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp)),
                        ]
                      : [],
                ),
              )

              // Text(
              //   widget.titleTextField ?? '',
              //   style: widget.titleTextStyle ??
              //       const TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w500,
              //           color: Color.fromARGB(255, 19, 19, 19)),
              // ),
              ),
        ),
        Focus(
          focusNode: widget.focusTextField ? widget.focusNode : null,
          onFocusChange: (value) {
            widget.focusChanged?.call(value);
          },
          child: TextFormField(
            onTapOutside: (event) {
              hideKeyBoard(context);
            },
            autofocus: widget.autoFocus,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            inputFormatters: widget.inputFormatters,
            onFieldSubmitted: widget.onFieldSubmitted,
            autocorrect: false,
            
            stylusHandwritingEnabled: false,
            textAlign: widget.textAlign,
            controller: widget.controller,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            maxLength: widget.maxLength,
            validator: widget.validator,
            obscuringCharacter: widget.obscuringCharacter!,
            keyboardType: widget.textInputType ?? TextInputType.text,
            textInputAction: widget.textInputAction,
            obscureText: widget.isObscure ? passwordVisible : widget.isObscure,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            autofillHints: widget.autofillHints,
            decoration: InputDecoration(
              filled: true,
              alignLabelWithHint: false,
              helperStyle: const TextStyle(color: Colors.green),
              counterText: '',
              fillColor: Theme.of(context).colorScheme.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest),
              ),
              isDense: true,
              hintText: widget.hintText,
              prefixIcon:widget.prefixIcon,
              suffixIconConstraints: BoxConstraints(
                maxHeight: widget.suffixIconConstraintsMaxHeight ?? 25.h,
              ),
              helperText: widget.helperText,
              contentPadding: widget.contentPadding ??
                  EdgeInsets.symmetric(horizontal: 9.w, vertical: 14.h),
              focusedBorder: widget.focusedBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.borderColor ??
                            Theme.of(context).colorScheme.primary),
                    borderRadius: widget.borderRadius ??
                        const BorderRadius.all(Radius.circular(10)),
                  ),
              enabledBorder: widget.enabledBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.borderColor ??
                            Theme.of(context).colorScheme.surfaceContainerHighest),
                    borderRadius: widget.borderRadius ??
                        const BorderRadius.all(Radius.circular(10)),
                  ),
              suffixIcon: widget.isObscure == true
                  ? IconButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        minimumSize:
                            WidgetStateProperty.all(Size(25.w, 25.h)),
                      ),
                      icon: passwordVisible
                          ? Icon(Icons.visibility, size: 18.sp)
                          : Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18.sp,
                            ),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    )
                  : widget.suffixIcon,
              errorBorder: widget.textError != '' || widget.focusNode!.hasFocus
                  ? OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: widget.borderRadius ??
                          const BorderRadius.all(Radius.circular(10)),
                    )
                  : errorBorder,
              errorText: widget.textError == '' ? null : widget.textError,
              errorStyle: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        )
      ],
    );
  }
}
