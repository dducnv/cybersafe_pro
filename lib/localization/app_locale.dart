import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/localization/screens/about/about_locale.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth/auth_locale.dart';
import 'screens/home/home_locale.dart';
import 'screens/settings/settings_locale.dart';
import 'screens/category/category_locale.dart';
import 'screens/sidebar/sidebar_locale.dart';
import 'screens/password_generator/password_generator_locale.dart';
import 'screens/statistic/statistic_locale.dart';
import 'screens/otp/otp_locale.dart';
import 'screens/onboarding/onboarding_locale.dart';
import 'screens/login/login_locale.dart';
import 'screens/create_account/create_account_locale.dart';
import 'screens/details_account/details_account_locale.dart';
import 'log/error_locale.dart';
import 'base_locale.dart';

class AppLocaleModel extends BaseLocale {
  @override
  final String languageCode;
  @override
  final String countryCode;
  @override
  final String languageName;
  @override
  final String languageNativeName;
  @override
  final String flagEmoji;

  AppLocaleModel({required this.languageCode, required this.countryCode, required this.languageName, required this.languageNativeName, required this.flagEmoji});

  @override
  Map<String, String> get vi => {};
  @override
  Map<String, String> get en => {};
  @override
  Map<String, String> get pt => {};
  @override
  Map<String, String> get hi => {};
  @override
  Map<String, String> get ja => {};
  @override
  Map<String, String> get ru => {};
  @override
  Map<String, String> get id => {};
  @override
  Map<String, String> get tr => {};
}

final List<AppLocaleModel> appLocales = [
  AppLocaleModel(languageCode: 'vi', countryCode: 'VN', languageName: 'Vietnamese', languageNativeName: 'Tiếng Việt', flagEmoji: '🇻🇳'),
  AppLocaleModel(languageCode: 'ru', countryCode: 'RU', languageName: 'Russian', languageNativeName: 'Русский', flagEmoji: '🇷🇺'),
  AppLocaleModel(languageCode: 'en', countryCode: 'US', languageName: 'English (US)', languageNativeName: 'English (US)', flagEmoji: '🇺🇸'),
  AppLocaleModel(languageCode: 'en', countryCode: 'GB', languageName: 'English (UK)', languageNativeName: 'English (UK)', flagEmoji: '🇬🇧'),
  AppLocaleModel(languageCode: 'pt', countryCode: 'PT', languageName: 'Portuguese (Portugal)', languageNativeName: 'Português (Portugal)', flagEmoji: '🇵🇹'),
  AppLocaleModel(languageCode: 'pt', countryCode: 'BR', languageName: 'Portuguese (Brazil)', languageNativeName: 'Português (Brasil)', flagEmoji: '🇧🇷'),
  AppLocaleModel(languageCode: 'hi', countryCode: 'IN', languageName: 'Hindi', languageNativeName: 'हिन्दी', flagEmoji: '🇮🇳'),
  AppLocaleModel(languageCode: 'ja', countryCode: 'JP', languageName: 'Japanese', languageNativeName: '日本語', flagEmoji: '🇯🇵'),
  AppLocaleModel(languageCode: 'id', countryCode: 'ID', languageName: 'Indonesian', languageNativeName: 'Bahasa Indonesia', flagEmoji: '🇮🇩'),
  AppLocaleModel(languageCode: 'tr', countryCode: 'TR', languageName: 'Turkish', languageNativeName: 'Türkçe', flagEmoji: '🇹🇷'),
];

class AppLocale extends ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    SecureStorage.instance.save(key: SecureStorageKey.appLang, value: '${locale.languageCode}_${locale.countryCode}');
    notifyListeners();
  }

  // Singleton pattern
  static final AppLocale _instance = AppLocale._internal();
  factory AppLocale() => _instance;
  AppLocale._internal();

  // Các màn hình locale
  late final authLocale = AuthLocale(this);
  late final homeLocale = HomeLocale(this);
  late final settingsLocale = SettingsLocale(this);

  // Thêm các màn hình locale khác
  late final categoryLocale = CategoryLocale(this);
  late final sidebarLocale = SidebarLocale(this);
  late final passwordGeneratorLocale = PasswordGeneratorLocale(this);
  late final statisticLocale = StatisticLocale(this);
  late final otpLocale = OtpLocale(this);
  late final onboardingLocale = OnboardingLocale(this);
  late final loginLocale = LoginLocale(this);
  late final createAccountLocale = CreateAccountLocale(this);
  late final detailsLocale = DetailsAccountLocale(this);
  late final errorLocale = ErrorLocale(this);
  late final aboutLocale = AboutLocale(this);
  // Helper method để lấy locale từ context
  static AppLocale of(BuildContext context) {
    return Provider.of<AppLocale>(context, listen: false);
  }

  String getText(String key) {
    final translations = switch (locale.languageCode) {
      'vi' => currentLocaleModel.vi,
      'hi' => currentLocaleModel.hi,
      'ja' => currentLocaleModel.ja,
      'ru' => currentLocaleModel.ru,
      'id' => currentLocaleModel.id,
      'pt' when locale.countryCode == 'PT' => currentLocaleModel.pt_PT,
      'pt' when locale.countryCode == 'BR' => currentLocaleModel.pt_BR,
      'en' when locale.countryCode == 'GB' => currentLocaleModel.en_GB,
      'en' when locale.countryCode == 'US' => currentLocaleModel.en_US,
      'pt' => currentLocaleModel.pt,
      'en' => currentLocaleModel.en,
      'tr' => currentLocaleModel.tr,
      _ => currentLocaleModel.en, // fallback to English
    };
    return translations[key] ?? key;
  }

  // Lấy AppLocaleModel hiện tại
  AppLocaleModel get currentLocaleModel {
    return appLocales.firstWhere((locale) => locale.languageCode == _locale.languageCode && locale.countryCode == _locale.countryCode, orElse: () => appLocales.first);
  }
}
