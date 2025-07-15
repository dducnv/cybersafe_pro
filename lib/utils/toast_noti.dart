import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showToastSuccess(String message, {BuildContext? context, StyledToastPosition? position}) {
  final safeContext = context ?? GlobalKeys.appRootNavigatorKey.currentContext;
  if (safeContext == null || !safeContext.mounted) return;
  showToast(
    message,
    context: safeContext,
    animation: StyledToastAnimation.fade,
    backgroundColor: Theme.of(safeContext).colorScheme.primary,
    textStyle: CustomTextStyle.regular(color: Colors.white),
    position: position ?? StyledToastPosition.center,
  );
}

void showToastError(String message, {BuildContext? context, StyledToastPosition? position}) {
  final safeContext = context ?? GlobalKeys.appRootNavigatorKey.currentContext;
  if (safeContext == null || !safeContext.mounted) return;
  showToast(
    message,
    context: safeContext,
    animation: StyledToastAnimation.fade,
    backgroundColor: Theme.of(safeContext).colorScheme.error,
    textStyle: CustomTextStyle.regular(color: Colors.white),
    position: position ?? StyledToastPosition.center,
  );
}

void showToastWarning(String message, {BuildContext? context, StyledToastPosition? position}) {
  final safeContext = context ?? GlobalKeys.appRootNavigatorKey.currentContext;
  if (safeContext == null || !safeContext.mounted) return;
  showToast(
    message,
    context: safeContext,
    animation: StyledToastAnimation.fade,
    backgroundColor: Colors.orange,
    textStyle: CustomTextStyle.regular(color: Colors.white),
    position: position ?? StyledToastPosition.center,
  );
}
