import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension BuildContextExtension<T> on BuildContext {
  // Các phương thức watch - chỉ sử dụng trong build method
  bool get darkMode => watch<ThemeProvider>().isDarkMode;
  AppLocale get appLocale => watch<AppLocale>();
  AppLocale get appLocaleRead => read<AppLocale>();
  Locale get locale => appLocale.locale;  
  Locale get localeRead => appLocaleRead.locale;
  // Các phương thức read - an toàn để sử dụng trong callbacks, async functions
  bool get readDarkMode => read<ThemeProvider>().isDarkMode;
  
  // Thêm phương thức tiện ích để lấy text đã dịch
  String tr(String key) => appLocale.getText(key);
  String trAuth(String key) => appLocale.authLocale.getText(key);
  String trHome(String key) => appLocale.homeLocale.getText(key);
  String trSettings(String key) => appLocale.settingsLocale.getText(key);
  
  // Phương thức tr an toàn cho async/callbacks (sử dụng read thay vì watch)
  String trSafe(String key) {
    final appLocaleRead = read<AppLocale>();
    // Tìm trong tất cả các locale theo thứ tự ưu tiên
    final translations = {
      ...appLocaleRead.authLocale.getText(key) != key ? {key: appLocaleRead.authLocale.getText(key)} : {},
      ...appLocaleRead.homeLocale.getText(key) != key ? {key: appLocaleRead.homeLocale.getText(key)} : {},
      ...appLocaleRead.settingsLocale.getText(key) != key ? {key: appLocaleRead.settingsLocale.getText(key)} : {},
      ...appLocaleRead.categoryLocale.getText(key) != key ? {key: appLocaleRead.categoryLocale.getText(key)} : {},
      ...appLocaleRead.createAccountLocale.getText(key) != key ? {key: appLocaleRead.createAccountLocale.getText(key)} : {},
      ...appLocaleRead.detailsLocale.getText(key) != key ? {key: appLocaleRead.detailsLocale.getText(key)} : {},
      ...appLocaleRead.otpLocale.getText(key) != key ? {key: appLocaleRead.otpLocale.getText(key)} : {},
      ...appLocaleRead.passwordGeneratorLocale.getText(key) != key ? {key: appLocaleRead.passwordGeneratorLocale.getText(key)} : {},
      ...appLocaleRead.statisticLocale.getText(key) != key ? {key: appLocaleRead.statisticLocale.getText(key)} : {},
      ...appLocaleRead.sidebarLocale.getText(key) != key ? {key: appLocaleRead.sidebarLocale.getText(key)} : {},
      ...appLocaleRead.onboardingLocale.getText(key) != key ? {key: appLocaleRead.onboardingLocale.getText(key)} : {},
      ...appLocaleRead.loginLocale.getText(key) != key ? {key: appLocaleRead.loginLocale.getText(key)} : {},
      ...appLocaleRead.errorLocale.getText(key) != key ? {key: appLocaleRead.errorLocale.getText(key)} : {},
      ...appLocaleRead.aboutLocale.getText(key) != key ? {key: appLocaleRead.aboutLocale.getText(key)} : {},
    };
    
    return translations[key] ?? key;
  }
  
  // Các phương thức truy cập trực tiếp vào một locale cụ thể - an toàn cho async
  String trAuthSafe(String key) => read<AppLocale>().authLocale.getText(key);
  String trHomeSafe(String key) => read<AppLocale>().homeLocale.getText(key);
  String trSettingsSafe(String key) => read<AppLocale>().settingsLocale.getText(key);
  
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
  String trCreatePinCode(String key) => appLocale.authLocale.getText(key);
  String trAbout(String key) => appLocale.aboutLocale.getText(key);
}
