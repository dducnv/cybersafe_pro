import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget(
      {super.key,
      required this.onPressed,
      required this.text,
      this.style,
      this.backgroundColor,
      this.shadowColor,
      this.foregroundColor,
      this.isBoxShadow = false,
      this.boxShadow,
      this.borderRaidus,
      this.kPadding,
      this.kMargin,
      this.padding,
      this.margin,
      this.border,
      this.miniumSize,
      this.tapTargetSize,
      this.height,
      this.width,
      this.borderSide,
      this.borderRadiusGeometry,
      this.child,
      this.splashFactory,
      this.isLoadingButton = false,
      this.isDisabled = false});
  final void Function()? onPressed;
  final String? text;
  final TextStyle? style;

  final Color? backgroundColor, shadowColor, foregroundColor;
  final bool? isBoxShadow;
  final BoxShadow? boxShadow;

  final double? borderRaidus, kPadding, kMargin;
  final EdgeInsets? padding, margin;
  final Border? border;

  final Size? miniumSize;
  final MaterialTapTargetSize? tapTargetSize;
  final double? height, width;
  final BorderSide? borderSide;
  final BorderRadiusGeometry? borderRadiusGeometry;

  final Widget? child;
  final InteractiveInkFeatureFactory? splashFactory;

  final bool isLoadingButton;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: kMargin ?? 30),
      padding: padding ?? EdgeInsets.all(kPadding ?? 0),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isLoadingButton || isDisabled
                ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                : Theme.of(context).colorScheme.primary),
        boxShadow: !isBoxShadow!
            ? null
            : <BoxShadow>[
                boxShadow ??
                    const BoxShadow(
                      color: Color.fromRGBO(151, 151, 151, 0.1),
                      blurRadius: 8,
                      spreadRadius: 0.5,
                      offset: Offset(0, 5),
                    ),
              ],
        borderRadius:
            borderRadiusGeometry ?? BorderRadius.circular(borderRaidus ?? 6),
        border: border,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ??
              (isDisabled ? Theme.of(context).colorScheme.primary.withOpacity(0.7) : Theme.of(context).colorScheme.primary),
          shadowColor: Colors.transparent,
          foregroundColor: foregroundColor ?? Colors.white,
          padding: const EdgeInsets.all(0),
          minimumSize: miniumSize ??
              Size(width ?? MediaQuery.of(context).size.width, height ?? 50.h),
          shape: RoundedRectangleBorder(
            side: borderSide ?? BorderSide.none,
            borderRadius: borderRadiusGeometry ??
                BorderRadius.circular(borderRaidus ?? 6),
          ),
          tapTargetSize: tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
          splashFactory: splashFactory,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: child ??
            Text(
              text ?? '',
              style: style ?? TextStyle(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}
