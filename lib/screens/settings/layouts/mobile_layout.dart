import 'dart:io';

import 'package:cybersafe_pro/components/bottom_sheets/pro_intro_bottom_sheet.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/screens/register_master_pin/register_master_pin.dart';
import 'package:cybersafe_pro/screens/settings/widgets/change_lang_widget.dart';
import 'package:cybersafe_pro/screens/settings/widgets/set_theme_color.dart';
import 'package:cybersafe_pro/screens/settings/widgets/set_theme_mode_widget.dart';
import 'package:cybersafe_pro/screens/settings/widgets/use_biometric_login.dart';
import 'package:cybersafe_pro/services/data_manager_service.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/app_custom_switch/app_custom_switch.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/setting_item_widget/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingMobileLayout extends StatelessWidget {
  const SettingMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.appLocale.settingsLocale.getText(SettingsLocale.settings)), backgroundColor: Theme.of(context).colorScheme.surface, scrolledUnderElevation: 0, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(left: 16), child: Text(context.appLocale.settingsLocale.getText(SettingsLocale.general), style: settingTitleCardStyle)),
                const SizedBox(height: 5),
                const SetThemeModeWidget(),
                const SizedBox(height: 5),
                ChangeLangWidget(),
                const SizedBox(height: 5),
                const SetThemeColor(),
                const SizedBox(height: 16),
                Padding(padding: const EdgeInsets.only(left: 16), child: Text(context.appLocale.settingsLocale.getText(SettingsLocale.security), style: settingTitleCardStyle)),
                const SizedBox(height: 5),
                const UseBiometricLogin(),
                const SizedBox(height: 5),
                SettingItemWidget(
                  title: context.appLocale.settingsLocale.getText(SettingsLocale.changePin),
                  icon: Icons.pin,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const RegisterMasterPin(isChangePin: true);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),
                SettingItemWidget(
                  title: context.appLocale.settingsLocale.getText(SettingsLocale.autoLock),
                  suffix: Row(
                    children: [
                      Consumer<AppProvider>(
                        builder: (context, provider, child) {
                          return Text(provider.isOpenAutoLock ? "${provider.timeAutoLock}'" : "none", style: settingTitleItemStyle);
                        },
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.lock_clock, size: 24.sp),
                    ],
                  ),
                  onTap: () {
                    pickTimeAutoLock(context);
                  },
                ),
                const SizedBox(height: 5),
                // Consumer<AppProvider>(
                //   builder: (context, provider, child) {
                //     return SettingItemWidget(
                //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //       title: context.appLocale.settingsLocale.getText(SettingsLocale.lockOnBackground),
                //       suffix: AppCustomSwitch(
                //         value: provider.lockOnBackground,
                //         onChanged: (value) {
                //           provider.setLockOnBackground(value);
                //         },
                //       ),
                //       onTap: () {
                //         provider.setLockOnBackground(!provider.lockOnBackground);
                //       },
                //     );
                //   },
                // ),
                const SizedBox(height: 16),
                Padding(padding: const EdgeInsets.only(left: 16), child: Text(context.appLocale.settingsLocale.getText(SettingsLocale.backup), style: settingTitleCardStyle)),
                const SizedBox(height: 5),
                if (!AppConfig.isProApp && !Platform.isMacOS && !Platform.isWindows)
                  SettingItemWidget(
                    isGradientBg: true,
                    titleStyle: settingTitleItemStyle.copyWith(color: Colors.white),
                    title: context.appLocale.settingsLocale.getText(SettingsLocale.transferData),
                    icon: Icons.import_export_rounded,
                    onTap: () async {
                      showAppCustomDialog(
                        context,
                        AppCustomDialog(
                          title: context.trSafe(SettingsLocale.transferData),
                          message: context.trSafe(SettingsLocale.transferDataMessage),
                          confirmText: context.trSafe(SettingsLocale.confirm),
                          canConfirmInitially: true,
                          cancelText: context.trSafe(SettingsLocale.cancel),
                          onConfirm: () async {
                            try {
                              bool checkUri = await canLaunchUrlString("cybersafepro://transfer");
                              if (checkUri) {
                                DataManagerService.transferData(context);
                              } else {
                                openUrl(AppConfig.proPlayStoreUrl, context: context);
                              }
                            } catch (e) {
                              logError(e.toString());
                            }
                          },
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 5),
                SettingItemWidget(
                  title: context.appLocale.settingsLocale.getText(SettingsLocale.importDataFromBrowser),
                  icon: Icons.browser_updated_rounded,
                  onTap: () {
                    DataManagerService.importDataFromBrowser(context);
                  },
                ),
                const SizedBox(height: 5),
                SettingItemWidget(
                  title: context.appLocale.settingsLocale.getText(SettingsLocale.backupData),
                  icon: Icons.upload_file,
                  onTap: () {
                    if (!DataManagerService.checkData(context)) {
                      showToast(context.trSafe(SettingsLocale.dataIsEmpty), context: context);
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginMasterPassword(
                            isFromBackup: true,
                            showBiometric: false,
                            callBackLoginSuccess: ({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey}) async {
                              if (isLoginSuccess == true && pin != null) {
                                Navigator.of(context).pop();
                                bool status = await DataManagerService.backupData(GlobalKeys.appRootNavigatorKey.currentContext!, pin);
                                if (status && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup data successful'), backgroundColor: Colors.green, duration: const Duration(seconds: 3)));
                                }
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),
                SettingItemWidget(
                  title: context.appLocale.settingsLocale.getText(SettingsLocale.restore),
                  icon: Icons.restore,
                  onTap: () {
                    DataManagerService.restoreData(context);
                  },
                ),
        
                const SizedBox(height: 5),
                SettingItemWidget(
                  title: context.appLocale.settingsLocale.getText(SettingsLocale.deleteData),
                  suffix: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 24.sp),
                  titleStyle: settingTitleItemStyle.copyWith(color: Theme.of(context).colorScheme.error),
                  onTap: () async {
                    await DataManagerService.deleteAllDataPopup(context: context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickTimeAutoLock(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text(context.appLocale.settingsLocale.getText(SettingsLocale.autoLock), maxLines: 2, overflow: TextOverflow.ellipsis, style: settingTitleCardStyle)),
                      Consumer<AppProvider>(
                        builder: (context, provider, widget) {
                          return AppCustomSwitch(
                            value: provider.isOpenAutoLock,
                            onChanged: (value) {
                              context.read<AppProvider>().setAutoLock(value, context.read<AppProvider>().timeAutoLock);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Consumer<AppProvider>(
                    builder: (context, provider, widget) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: provider.isOpenAutoLock ? 1 : 0.5,
                            child: NumberPicker(
                              haptics: true,
                              zeroPad: true,
                              value: provider.timeAutoLock < 1 ? 0 : provider.timeAutoLock,
                              selectedTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 25.sp, fontWeight: FontWeight.bold),
                              itemCount: 5,
                              minValue: 0,
                              maxValue: 30,
                              itemWidth: 70.h,
                              itemHeight: 70.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2)),
                              axis: Axis.horizontal,
                              textMapper: (numberText) {
                                if (numberText == '0') return '30s';
                                return "$numberText'";
                              },
                              onChanged: (value) {
                                provider.setAutoLock(provider.isOpenAutoLock, value);
                              },
                            ),
                          ),
                          provider.isOpenAutoLock ? SizedBox(height: 70.h, width: double.infinity) : SizedBox(height: 70.h, width: double.infinity, child: const ModalBarrier(dismissible: true)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButtonWidget(
                    kMargin: 0,
                    onPressed: () {
                      context.read<AppProvider>().setAutoLock(context.read<AppProvider>().isOpenAutoLock, context.read<AppProvider>().timeAutoLock);
                      Navigator.pop(context);
                    },
                    text: context.appLocale.settingsLocale.getText(SettingsLocale.confirm),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
