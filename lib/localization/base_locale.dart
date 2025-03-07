import 'package:flutter/material.dart';
import 'app_locale.dart';

abstract class BaseLocale {
  final AppLocale appLocale;
  
  BaseLocale(this.appLocale);

  // Getter để lấy locale hiện tại
  Locale get currentLocale => appLocale.locale;

  // Abstract method để lấy bản dịch theo ngôn ngữ
  Map<String, dynamic> get vi;
  Map<String, dynamic> get en;

  // Helper method để lấy text theo key
  String getText(String key) {
    final translations = currentLocale.languageCode == 'vi' ? vi : en;
    return translations[key] ?? key;
  }
} 