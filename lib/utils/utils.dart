import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:timezone/timezone.dart' as timezone;

Future<void> clipboardCustom({required BuildContext context, required String text}) async {
  await Clipboard.setData(ClipboardData(text: text)).then((value) {
    if (!context.mounted) return;
    showToast(context.trSafe(HomeLocale.copySuccess), context: context, backgroundColor: Theme.of(context).colorScheme.primary, textStyle: const TextStyle(color: Colors.white));
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
