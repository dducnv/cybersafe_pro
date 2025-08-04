import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:flutter/material.dart';

class TextToolbarButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const TextToolbarButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(32, 32),
          // ...existing code...
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.darkMode ? Colors.white.withValues(alpha: 0.4) : Colors.black,
          ),
        ),
      ),
    );
  }
}
