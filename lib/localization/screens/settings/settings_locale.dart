import '../../base_locale.dart';
import '../../app_locale.dart';

class SettingsLocale extends BaseLocale {
  SettingsLocale(super.appLocale);

  // Keys cho màn hình settings
  static const String settings = 'settings';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String notifications = 'notifications';
  static const String security = 'security';

  @override
  Map<String, dynamic> get vi => {
    settings: 'Cài đặt',
    language: 'Ngôn ngữ',
    theme: 'Giao diện',
    notifications: 'Thông báo',
    security: 'Bảo mật',
  };

  @override
  Map<String, dynamic> get en => {
    settings: 'Settings',
    language: 'Language',
    theme: 'Theme',
    notifications: 'Notifications',
    security: 'Security',
  };
} 