import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:flutter/material.dart';

class SettingItemWidget extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final IconData? icon;
  final double? titleWidth;
  final Widget? suffix;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final bool isGradientBg;
  const SettingItemWidget({super.key, this.onTap, required this.title, this.icon, this.titleWidth, this.suffix, this.titleStyle, this.padding, this.isGradientBg = false});

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
      border: isGradientBg ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.4) : null,
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration:
              isGradientBg
                  ? BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withValues(alpha: .8), Theme.of(context).colorScheme.primary.withValues(alpha: .4)]))
                  : null,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: titleStyle ?? TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1)),
                  icon != null ? Icon(icon, size: 22.sp) : suffix ?? const SizedBox(),
                  //switch
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
