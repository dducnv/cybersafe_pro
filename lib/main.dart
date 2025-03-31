import 'dart:io';

import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/my_app.dart';
import 'package:cybersafe_pro/providers/provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/resources/shared_preferences/constants.dart';
import 'package:cybersafe_pro/resources/shared_preferences/shared_preferences_helper.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'database/objectbox.dart';
import 'package:timezone/data/latest.dart' as timezone;

Future<void> initApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  timezone.initializeTimeZones();
  
  // Khởi tạo ObjectBox
  await SharedPreferencesHelper.init();
  await clearSecureStorageOnReinstall();
  await ObjectBox.create();
  LocalAuthConfig.instance.init();
  final encryptService = EncryptAppDataService.instance;
  final themeProvider = ThemeProvider();
  await themeProvider.initTheme();
  await encryptService.initialize();
  
  // Xác định route ban đầu
  final initialRoute = await _determineInitialRoute();
  
  // Khởi tạo locale
  final savedLang = await SecureStorage.instance.read(key: SecureStorageKey.appLang);
  Locale initialLocale;
  
  if (savedLang != null) {
    final languageCode = savedLang.split('_').first;
    final countryCode = savedLang.split('_').last;
    initialLocale = Locale(languageCode, countryCode);
  } else {
    final String defaultLocale = Platform.localeName;
    final languageCode = defaultLocale.split('_').first;
    final countryCode = defaultLocale.split('_').last;
    initialLocale = Locale(languageCode, countryCode);
  }
  
  await initializeDateFormatting(initialLocale.toString(), null);
  SecureApplicationUtil.instance.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  runApp(MultiProvider(
    providers: ListProvider.providers, 
    child: MyApp(
      initialRoute: initialRoute,
      initialLocale: initialLocale,
    )
  ));
}

void main() {
  initApp();
}

Future<String> _determineInitialRoute() async {
  // Kiểm tra lần đầu mở app
  String? isFirstTime = await SecureStorage.instance.read(key: SecureStorageKey.firstOpenApp);
  String? fistOpenApp = await SecureStorage.instance.read(key: SecureStorageKey.fistOpenAppOld);

  if (isFirstTime == null && fistOpenApp == null) {
    return AppRoutes.onboarding;
  }

  // Kiểm tra PIN
  final pinCode = await SecureStorage.instance.read(key: SecureStorageKey.pinCode);
  if (pinCode == null) {
    return AppRoutes.registerMasterPin;
  }

  return AppRoutes.loginMasterPin;
}

Future<void> clearSecureStorageOnReinstall() async {
  if (Platform.isIOS) {
    bool hasRunBefore = SharedPreferencesHelper.instance.getBool(Constants.hasRunBefore) ?? false;
    if (!hasRunBefore) {
      await SecureStorage.instance.reset();
      SharedPreferencesHelper.instance.setBool(Constants.hasRunBefore, true);
    }
  }
}
