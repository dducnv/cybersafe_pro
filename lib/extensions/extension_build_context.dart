import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension BuildContextExtension<T> on BuildContext {
  bool get darkMode => watch<ThemeProvider>().isDarkMode;
  AppLocale get appLocale => GlobalKeys.appRootNavigatorKey.currentContext!.read<AppLocale>();
  Locale get locale => appLocale.locale;
  
  // Thêm phương thức tiện ích để lấy text đã dịch
  String tr(String key) => appLocale.getText(key);
  String trAuth(String key) => appLocale.authLocale.getText(key);
  String trHome(String key) => appLocale.homeLocale.getText(key);
  String trSettings(String key) => appLocale.settingsLocale.getText(key);
  
  // Các màn hình khác
  String trCategory(String key) => appLocale.categoryLocale.getText(key);
  String trCreateAccount(String key) => appLocale.createAccountLocale.getText(key);
  String trDetails(String key) => appLocale.detailsLocale.getText(key);
  String trOtp(String key) => appLocale.otpLocale.getText(key);
  String trPasswordGenerator(String key) => appLocale.passwordGeneratorLocale.getText(key);
  String trStatistic(String key) => appLocale.statisticLocale.getText(key);
  String trSidebar(String key) => appLocale.sidebarLocale.getText(key);
  String trOnboarding(String key) => appLocale.onboardingLocale.getText(key);
  String trLogin(String key) => appLocale.loginLocale.getText(key);
  String trError(String key) => appLocale.errorLocale.getText(key);
}
