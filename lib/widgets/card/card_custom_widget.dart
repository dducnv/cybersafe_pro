import 'package:flutter/material.dart';

class CardCustomWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final BoxBorder? border;
  final Color? backgroundColor;

  const CardCustomWidget({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.border,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 25);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
          border:
              border ??
              Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 1.4),
          borderRadius: radius,
        ),
        child: child,
      ),
    );
  }
}
