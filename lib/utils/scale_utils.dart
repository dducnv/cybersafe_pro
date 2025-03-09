import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:flutter/material.dart';

extension ScaleUnit on int {
  /// tỷ lệ height
  double get h =>
      this *
      MediaQuery.sizeOf(GlobalKeys.appRootNavigatorKey.currentContext!).height /
      812;

  /// tỷ lệ widht
  double get w =>
      this *
      MediaQuery.sizeOf(GlobalKeys.appRootNavigatorKey.currentContext!).width /
      375;

  /// tỷ lệ textSize
  double get sp =>
      this *
      MediaQuery.sizeOf(GlobalKeys.appRootNavigatorKey.currentContext!).height /
      812;
}
