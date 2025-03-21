import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth/auth_locale.dart';
import 'screens/home/home_locale.dart';
import 'screens/settings/settings_locale.dart';

class AppLocale extends ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN');
  
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
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

  // Helper method để lấy locale từ context
  static AppLocale of(BuildContext context) {
    return Provider.of<AppLocale>(context, listen: false);
  }
}