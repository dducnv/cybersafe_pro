import 'dart:io';

import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as timezone;
import 'package:url_launcher/url_launcher.dart';

MethodChannel platform = const MethodChannel('cybersafe/nativeCalls');

Future<void> clipboardCustom({required BuildContext context, required String text}) async {
  await Clipboard.setData(ClipboardData(text: text)).then((value) {
    if (!context.mounted) return;
    showToast(
      context.trSafe(HomeLocale.copySuccess),
      context: context,
      animation: StyledToastAnimation.fade,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textStyle: CustomTextStyle.regular(color: Colors.white),
      position: StyledToastPosition.center,
    );
  });
}

String generateTOTPCode({required String keySecret}) {
  if (keySecret.isEmpty) {
    return "--- ---";
  }
  final now = DateTime.now();
  final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
  final date = timezone.TZDateTime.from(now, pacificTimeZone);
  return OTP.generateTOTPCodeString(keySecret, date.millisecondsSinceEpoch, algorithm: Algorithm.SHA1, isGoogle: true);
}

Future<bool> checkLocalAuth() async {
  String? enableLocalAuth = await SecureStorage.instance.read(key: SecureStorageKey.isEnableLocalAuth);

  if (enableLocalAuth == "false") {
    return false;
  }

  bool canCheckBiometrics = await LocalAuthConfig.instance.canCheckBiometrics;
  if (!canCheckBiometrics) {
    return false;
  }

  bool isAvailableBiometrics = LocalAuthConfig.instance.isAvailableBiometrics;

  if (!isAvailableBiometrics) {
    return false;
  }

  bool authenticated = await LocalAuthConfig.instance.authenticate();

  return authenticated;
}

void openUrl(String link, {LaunchMode? mode, required BuildContext context, Function(String)? onError}) async {
  try {
    await launchUrl(Uri.parse(link), mode: mode ?? LaunchMode.externalApplication);
  } catch (e) {
    logError(e.toString(), functionName: "openUrl");
    if (context.mounted) {
      showToast("Could not launch link", context: context, backgroundColor: Theme.of(context).colorScheme.primary, textStyle: const TextStyle(color: Colors.white));
    }
    onError?.call(e.toString());
  }
}

Future<bool> checkAppInstalled(String packageName) async {
  try {
    final bool installed = await platform.invokeMethod('isAppInstalled', {"packageName": packageName});
    return installed;
  } catch (e) {
    logError(e.toString(), functionName: "checkAppInstalled");
    return false;
  }
}

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  return "${DateFormat.yMMMd(Platform.localeName).format(dateTime)} ${DateFormat.Hm(Platform.localeName).format(dateTime)}";
}
