import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';

class AppCustomSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  const AppCustomSwitch(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.h,
      height: 50.h,
      child: FittedBox(
        child: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}
