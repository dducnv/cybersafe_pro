import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/screens/register_master_pin/register_master_pin.dart';
import 'package:cybersafe_pro/screens/settings/widgets/change_lang_widget.dart';
import 'package:cybersafe_pro/screens/settings/widgets/set_theme_color.dart';
import 'package:cybersafe_pro/screens/settings/widgets/set_theme_mode_widget.dart';
import 'package:cybersafe_pro/screens/settings/widgets/use_biometric_login.dart';
import 'package:cybersafe_pro/services/data_manager_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_custom_switch/app_custom_switch.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/setting_item_widget/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: Theme.of(context).colorScheme.surface, scrolledUnderElevation: 0, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(left: 16), child: Text("Cài đặt chung", style: settingTitleCardStyle)),
              const SizedBox(height: 5),
              const SetThemeModeWidget(),
              const SizedBox(height: 5),
              ChangeLangWidget(onTap: () {}, locale: Locale('en')),
              const SizedBox(height: 5),
              const SetThemeColor(),
              const SizedBox(height: 16),
              Padding(padding: const EdgeInsets.only(left: 16), child: Text("Cài đặt bảo mật", style: settingTitleCardStyle)),
              const SizedBox(height: 5),
              const UseBiometricLogin(),
              const SizedBox(height: 5),
              SettingItemWidget(
                title: "Đổi mật khẩu",
                icon: Icons.pin,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginMasterPassword(
                          showBiometric: false,
                          callBackLoginSuccess: ({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey}) {
                            if (isLoginSuccess == true) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const RegisterMasterPin(isChangePin: true);
                                  },
                                ),
                              );
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
                title: "Thời gian tự động đăng xuất",
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
              const SizedBox(height: 16),
              Padding(padding: const EdgeInsets.only(left: 16), child: Text("Quản lý dữ liệu", style: settingTitleCardStyle)),
              const SizedBox(height: 5),
              SettingItemWidget(
                title: "Thêm dữ liệu từ trình duyệt",
                icon: Icons.browser_updated,
                onTap: () {
                  DataManagerService.importDataFromBrowser(context);
                },
              ),
              const SizedBox(height: 5),
              SettingItemWidget(
                title: "Sao lưu dữ liệu",
                icon: Icons.backup,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginMasterPassword(
                          showBiometric: false,
                          callBackLoginSuccess: ({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey}) {
                            if (isLoginSuccess == true && pin != null) {
                              DataManagerService.backupData(context, pin);
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
                title: "Khôi phục dữ liệu",
                icon: Icons.restore,
                onTap: () {
                  DataManagerService.restoreData(context);
                },
              ),

              const SizedBox(height: 5),
              SettingItemWidget(title: "Xóa dữ liệu", icon: Icons.delete, onTap: () {}),
            ],
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
                      Expanded(child: Text("Thời gian tự động đăng xuất", maxLines: 2, overflow: TextOverflow.ellipsis, style: settingTitleCardStyle)),
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
                              value: provider.timeAutoLock < 1 ? 1 : provider.timeAutoLock,
                              selectedTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 25.sp, fontWeight: FontWeight.bold),
                              itemCount: 5,
                              minValue: 1,
                              maxValue: 30,
                              itemWidth: 70.w,
                              itemHeight: 70.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2)),
                              axis: Axis.horizontal,
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
                    text: "Xác nhận",
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
