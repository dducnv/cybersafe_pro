import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SetThemeModeWidget extends StatelessWidget {
  const SetThemeModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                value.toggleTheme();
                HapticFeedback.mediumImpact();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.appLocale.settingsLocale.getText(SettingsLocale.darkMode), style: settingTitleItemStyle),
                    SizedBox(child: value.themeMode == ThemeMode.dark ? Icon(Icons.light_mode, size: 24.sp) : Icon(Icons.dark_mode, size: 24.sp)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
