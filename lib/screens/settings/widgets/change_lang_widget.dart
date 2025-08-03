import 'package:cybersafe_pro/components/bottom_sheets/choose_lang_bottom_sheet.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/setting_item_widget/setting_item_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeLangWidget extends StatelessWidget {
  const ChangeLangWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AppLocale, (Locale, String)>(
      selector: (_, provider) => (
        provider.locale,
        provider.currentLocaleModel.languageNativeName
      ),
      shouldRebuild: (prev, next) => prev.$1 != next.$1,
      builder: (context, data, child) {
        final (locale, nativeName) = data;
        return SettingItemWidget(
          title: context.appLocale.settingsLocale.getText(SettingsLocale.language),
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(nativeName, style: settingTitleItemStyle),
              const SizedBox(width: 8),
              Text(
                _getLocaleFlag(context),
                style: CustomTextStyle.regular(fontSize: 20.sp)
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_drop_down, size: 20.sp)
            ]
          ),
          onTap: () => showLanguageBottomSheet(context),
        );
      },
    );
  }

 

  String _getLocaleFlag(BuildContext context) {
    return AppLocale.of(context).currentLocaleModel.flagEmoji;
  }
}
