import 'package:flutter/material.dart';

abstract class BaseLocale {
  String get languageCode;
  String get countryCode;
  String get languageName;
  String get languageNativeName;
  String get flagEmoji;

  // Getter để lấy locale hiện tại
  Locale get locale => Locale(languageCode, countryCode);

  // Abstract method để lấy bản dịch theo ngôn ngữ
  Map<String, String> get vi;
  Map<String, String> get en;  // Mặc định là en_US
  Map<String, String> get pt;  // Mặc định là pt_PT
  Map<String, String> get hi;
  Map<String, String> get ja;
  Map<String, String> get ru;
  Map<String, String> get id;
  Map<String, String> get en_GB => en;  // Fallback to default English
  Map<String, String> get en_US => en;  // Same as default en
  Map<String, String> get pt_PT => pt;  // Same as default pt
  Map<String, String> get pt_BR => pt;  // Fallback to default Portuguese

  // Helper method để lấy text theo key
  String getText(String key, {Map<String, String>? args}) {
    final translations = switch (locale.languageCode) {
      'vi' => vi,
      'hi' => hi,
      'ja' => ja,
      'ru' => ru,
      'id' => id,
      'en' when locale.countryCode == 'GB' => en_GB,
      'en' when locale.countryCode == 'US' => en_US,
      'pt' when locale.countryCode == 'BR' => pt_BR,
      'pt' when locale.countryCode == 'PT' => pt_PT,
      'pt' => pt,
      'en' => en,
      _ => en_US, // fallback to English
    };
    return translations[key] ?? key;
  }
}

// Danh sách các locale được hỗ trợ
final supportedLocales = [
  const Locale('vi', 'VN'), // Việt Nam
  const Locale('hi', 'IN'), // Tiếng Ấn Độ
  const Locale('ja', 'JP'), // Tiếng Nhật
  const Locale('ru', 'RU'), // Tiếng Nga
  const Locale('id', 'ID'), // Tiếng Indonesia
  const Locale('en', 'GB'), // Tiếng Anh (UK)
  const Locale('en', 'US'), // Tiếng Anh (US)
  const Locale('pt', 'PT'), // Tiếng Bồ Đào Nha (Portugal)
  const Locale('pt', 'BR'), // Tiếng Bồ Đào Nha (Brazil)
]; 