import 'package:flutter/material.dart';

class ColorButtonCustom extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onTap;
  const ColorButtonCustom({
    super.key,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12),
          ),
        ),
      ),
    );
  }
}
