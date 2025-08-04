import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:flutter/material.dart';

class IconToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  const IconToolbarButton({super.key, required this.icon, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color:
          isActive
              ? Theme.of(context).colorScheme.primary
              : context.darkMode
              ? Colors.white.withValues(alpha: 0.4)
              : Colors.black,
      onPressed: onTap,
    );
  }
}
