import 'dart:async';
import 'dart:io' show Platform;

import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAppCustomDialog(BuildContext context, AppCustomDialog dialog) {
  return showDialog<bool>(context: context, builder: (BuildContext context) => dialog);
}

class AppCustomDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showCancelButton;
  final Widget? icon;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool isCountDownTimer;
  final int? countdownSeconds;
  final bool canConfirmInitially;
  final Widget? content;
  final bool showMessageWithContent;

  const AppCustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showCancelButton = true,
    this.icon,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.isCountDownTimer = false,
    this.countdownSeconds = 5,
    this.canConfirmInitially = false,
    this.content,
    this.showMessageWithContent = false,
  });

  @override
  State<AppCustomDialog> createState() => _AppCustomDialogState();
}

class _AppCustomDialogState extends State<AppCustomDialog> {
  late bool canConfirm;
  late int countdown;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    canConfirm = widget.canConfirmInitially;
    countdown = widget.countdownSeconds ?? 5;
    if (widget.isCountDownTimer && !widget.canConfirmInitially) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer(const Duration(seconds: 1), () {
      if (countdown > 0 && mounted) {
        setState(() {
          countdown--;
          if (countdown == 0) {
            canConfirm = true;
          }
        });
        if (countdown > 0) {
          _startCountdown();
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _buildCupertinoDialog();
    }
    return _buildMaterialDialog();
  }

  Widget _buildCupertinoDialog() {
    return CupertinoAlertDialog(
      title:
          widget.icon != null
              ? Column(
                children: [
                  widget.icon!,
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: CustomTextStyle.regular(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ],
              )
              : Text(
                widget.title,
                style: CustomTextStyle.regular(fontSize: 17, fontWeight: FontWeight.w600),
              ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.content != null) widget.content!,
          if (widget.message.isNotEmpty &&
              (widget.content == null || widget.showMessageWithContent))
            Text(
              widget.message,
              style: CustomTextStyle.regular(fontSize: 13, color: CupertinoColors.secondaryLabel),
            ),
        ],
      ),
      actions: [
        if (widget.showCancelButton)
          CupertinoDialogAction(
            onPressed: widget.onCancel ?? () => Navigator.of(context).pop(false),
            child: Text(
              widget.cancelText ?? context.trCategory(CategoryText.cancel),
              style: CustomTextStyle.regular(
                color: widget.cancelButtonColor ?? CupertinoColors.destructiveRed,
              ),
            ),
          ),
        CupertinoDialogAction(
          onPressed:
              !canConfirm
                  ? null
                  : () {
                    if (widget.onConfirm != null) {
                      widget.onConfirm!.call();
                    }
                    Navigator.of(context).pop(true);
                  },
          isDefaultAction: canConfirm,
          child: Text(
            "${widget.confirmText ?? context.trSettings(SettingsLocale.confirm)} ${widget.isCountDownTimer && !canConfirm ? "($countdown)" : ""}",
            style: CustomTextStyle.regular(
              color:
                  canConfirm
                      ? (widget.confirmButtonColor ?? CupertinoColors.activeBlue)
                      : CupertinoColors.inactiveGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog() {
    return AlertDialog(
      title:
          widget.icon != null
              ? Column(
                children: [
                  widget.icon!,
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              )
              : Text(
                widget.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.content != null) widget.content!,
          if (widget.message.isNotEmpty &&
              (widget.content == null || widget.showMessageWithContent))
            Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      actions: [
        if (widget.showCancelButton)
          TextButton(
            onPressed: widget.onCancel ?? () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: widget.cancelButtonColor ?? Theme.of(context).colorScheme.error,
            ),
            child: Text(widget.cancelText ?? context.trCategory(CategoryText.cancel)),
          ),
        TextButton(
          onPressed:
              !canConfirm
                  ? null
                  : () {
                    if (widget.onConfirm != null) {
                      widget.onConfirm!.call();
                    }
                    Navigator.of(context).pop(true);
                  },
          style: TextButton.styleFrom(
            foregroundColor:
                canConfirm
                    ? (widget.confirmButtonColor ?? Theme.of(context).colorScheme.primary)
                    : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.38),
          ),
          child: Text(
            "${widget.confirmText ?? context.trSettings(SettingsLocale.confirm)} ${widget.isCountDownTimer && !canConfirm ? "($countdown)" : ""}",
            style: CustomTextStyle.regular(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
