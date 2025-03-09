import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> showLoadingDialog() {
  return showDialog(
    barrierDismissible: false,
    context: GlobalKeys.appRootNavigatorKey.currentContext!,
    builder: (context) {
      return Center(child: Lottie.asset("assets/animations/loading.json", fit: BoxFit.contain, width: 350, height: 350, frameRate: const FrameRate(120)));
    },
  );
}

hideLoadingDialog() async {
  if (Navigator.canPop(GlobalKeys.appRootNavigatorKey.currentContext!)) {
    Navigator.of(GlobalKeys.appRootNavigatorKey.currentContext!).pop();
  }
}
