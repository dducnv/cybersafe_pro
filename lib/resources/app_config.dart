import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/onboarding_text.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static final instance = AppConfig._internal();
  AppConfig._internal();

  static bool isProApp = true;
  static String proPackageId = "com.duc_app_lab_ind.cyber_safe";
  static String proPlayStoreUrl =
      "https://play.google.com/store/apps/details?id=com.duc_app_lab_ind.cyber_safe";
  static String proUriSchemeTransfer = "cybersafepro://";

  static String privacyPolicyUrl(String languageCode) {
    if (languageCode == "vi") {
      return "https://dducnv.github.io/cybersafe/vi/privacy-policy";
    } else {
      return "https://dducnv.github.io/cybersafe/en/privacy-policy";
    }
  }

  static String termsOfServiceUrl(String languageCode) {
    if (languageCode == "vi") {
      return "https://dducnv.github.io/cybersafe/vi/terms-of-service";
    } else {
      return "https://dducnv.github.io/cybersafe/en/terms-of-service";
    }
  }

  static String contactUrl() {
    return "https://dducnv.github.io/onelink";
  }

  static Future<bool?> showDialogRedirectLink(BuildContext context, {required String url}) async {
    return showAppCustomDialog(
      context,
      AppCustomDialog(
        title: context.trSafe(OnboardingText.agreeRedirectLink),
        message: "",
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.trSafe(OnboardingText.doNotAgreeRedirectLink)),
            const SizedBox(height: 5),
            ExpansionTile(
              title: Text(context.trSafe(OnboardingText.showLink)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    url,
                    style: CustomTextStyle.regular(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
        canConfirmInitially: true,
        confirmText: context.trSafe(OnboardingText.agree),
        cancelText: context.trSafe(HomeLocale.cancel),
        onConfirm: () {
          openUrl(url, context: context);
        },
      ),
    );
  }
}
