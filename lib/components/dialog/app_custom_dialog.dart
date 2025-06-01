import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

Future<void> showAppCustomDialog(BuildContext context, AppCustomDialog dialog) {
  return showDialog<void>(context: context, builder: (BuildContext context) => dialog);
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
  final int? countDownTimer;
  final bool canConfirmInitially;
  final Widget? content;

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
    this.countDownTimer = 5,
    this.canConfirmInitially = false,
    this.content,
  });

  @override
  State<AppCustomDialog> createState() => _AppCustomDialogState();
}

class _AppCustomDialogState extends State<AppCustomDialog> {
  late bool canConfirm;
  late int countdown;

  @override
  void initState() {
    super.initState();
    canConfirm = widget.canConfirmInitially;
    countdown = widget.countDownTimer ?? 5;
    if (widget.isCountDownTimer && !widget.canConfirmInitially) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (countdown > 0 && mounted) {
        setState(() {
          countdown--;
        });
        if (countdown == 0) {
          setState(() {
            canConfirm = true;
          });
        } else {
          _startCountdown();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _buildCupertinoDialog(context);
    }
    return _buildMaterialDialog(context);
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title:
          widget.icon != null
              ? Column(children: [widget.icon!, const SizedBox(height: 8), Text(widget.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600))])
              : Text(widget.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      content:
          widget.content ??
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(widget.message, style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel))],
          ),
      actions: [
        if (widget.showCancelButton)
          CupertinoDialogAction(
            onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
            child: Text(widget.cancelText ?? context.trCategory(CategoryText.cancel), style: TextStyle(color: widget.cancelButtonColor ?? CupertinoColors.destructiveRed)),
          ),
        CupertinoDialogAction(
          onPressed:
              canConfirm
                  ? () {
                    widget.onConfirm?.call();
                  }
                  : null,
          child: Text(
            "${widget.confirmText ?? context.trSettings(SettingsLocale.confirm)} ${widget.isCountDownTimer && !canConfirm ? "($countdown)" : ""}",
            style: TextStyle(color: canConfirm ? (widget.confirmButtonColor ?? CupertinoColors.activeBlue) : CupertinoColors.inactiveGray, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(BuildContext context) {
    return AlertDialog(
      title:
          widget.icon != null
              ? Column(children: [widget.icon!, const SizedBox(height: 8), Text(widget.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600))])
              : Text(widget.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
      content:
          widget.content ??
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(widget.message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))],
          ),
      actions: [
        if (widget.showCancelButton)
          TextButton(
            onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: widget.cancelButtonColor ?? Theme.of(context).colorScheme.error),
            child: Text(widget.cancelText ?? context.trCategory(CategoryText.cancel)),
          ),
        TextButton(
          onPressed:
              canConfirm
                  ? () {
                    widget.onConfirm?.call();
                    Navigator.of(context).pop();
                  }
                  : null,
          style: TextButton.styleFrom(
            foregroundColor: canConfirm ? (widget.confirmButtonColor ?? Theme.of(context).colorScheme.primary) : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.38),
          ),
          child: Text(
            "${widget.confirmText ?? context.trSettings(SettingsLocale.confirm)} ${widget.isCountDownTimer && !canConfirm ? "($countdown)" : ""}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
