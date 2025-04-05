import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showLanguageBottomSheet(BuildContext context) {
  // Pre-compute các item để tránh tính toán lại
  final items =
      appLocales.map((locale) {
        return _buildLanguageItem(locale);
      }).toList();

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Consumer<AppLocale>(
          builder: (context, appLocale, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appLocale.settingsLocale.getText(SettingsLocale.chooseLanguage), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(child: ListView(children: items)),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

Widget _buildLanguageItem(AppLocaleModel locale) {
  return Builder(
    builder: (context) {
      final appLocale = context.read<AppLocale>();
      final isSelected = appLocale.locale.languageCode == locale.languageCode && appLocale.locale.countryCode == locale.countryCode;

      return ListTile(
        leading: Text(locale.flagEmoji, style: TextStyle(fontSize: 24.sp)),
        title: Text(locale.languageNativeName),
        subtitle: Text(locale.languageName),
        selected: isSelected,
        onTap: () {
          appLocale.setLocale(Locale(locale.languageCode, locale.countryCode));
          Navigator.pop(context);
        },
      );
    },
  );
}
