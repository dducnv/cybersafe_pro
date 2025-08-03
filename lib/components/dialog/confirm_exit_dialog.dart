import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

Future<bool?> showConfirmExitDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                context.trSafe(LoginText.confirmExit),
                style: CustomTextStyle.regular(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          content: Text(
            context.trSafe(LoginText.confirmExitMessage),
            style: CustomTextStyle.regular(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                context.trSafe(LoginText.cancel),
                style: CustomTextStyle.regular(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                context.trSafe(LoginText.exit),
                style: CustomTextStyle.regular(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
} 