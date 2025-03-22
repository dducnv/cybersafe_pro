import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:flutter/material.dart';

class RequestPro extends StatelessWidget {
  final Widget child;
  const RequestPro({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (AppConfig.isProApp) {
      return child;
    }

    return Stack(
      children: [
        IgnorePointer(
          ignoring: true,
          child: child,
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              print("upgrade pro");
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
