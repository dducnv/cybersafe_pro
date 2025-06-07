import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';

class CardCustomWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final BoxBorder? border;
  const CardCustomWidget({super.key, required this.child, this.padding, this.borderRadius, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: border ?? Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 1.4),
        borderRadius: BorderRadius.circular(borderRadius ?? 25),
      ),
      child: child,
    );
  }
}
