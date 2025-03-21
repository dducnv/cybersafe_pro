import 'package:flutter/material.dart';

class CardCustomWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  const CardCustomWidget(
      {super.key, required this.child, this.padding, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest),
          borderRadius: BorderRadius.circular(borderRadius ?? 25)),
      child: child,
    );
  }
}
