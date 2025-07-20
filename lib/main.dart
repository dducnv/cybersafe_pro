import 'dart:async';
import 'dart:io';

import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/my_app.dart';
import 'package:cybersafe_pro/providers/provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/resources/shared_preferences/constants.dart';
import 'package:cybersafe_pro/resources/shared_preferences/shared_preferences_helper.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'database/objectbox.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:in_app_review/in_app_review.dart';

final InAppReview inAppReview = InAppReview.instance;
late final PackageInfo packageInfo;

// Observer để xử lý thay đổi kích thước màn hình
class ScreenSizeObserver extends StatefulWidget {
  final Widget child;

  const ScreenSizeObserver({super.key, required this.child});

  @override
  State<ScreenSizeObserver> createState() => _ScreenSizeObserverState();
}

class _ScreenSizeObserverState extends State<ScreenSizeObserver> with WidgetsBindingObserver {
  DeviceType? _lastDeviceType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentDeviceType = DeviceInfo.getDeviceType(context);

      // Nếu trước đó không phải là desktop và bây giờ là desktop
      if (_lastDeviceType != DeviceType.desktop && currentDeviceType == DeviceType.desktop) {
        // Lưu màn hình hiện tại cho desktop_layout để mở modal side sheet
        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != null && currentRoute != AppRoutes.home) {
          DeviceInfo.currentScreen.value = currentRoute;
          // Chuyển về màn hình home
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      }

      _lastDeviceType = currentDeviceType;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo loại thiết bị ban đầu
    _lastDeviceType ??= DeviceInfo.getDeviceType(context);
    return widget.child;
  }
}

Future<void> initApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  timezone.initializeTimeZones();
  //only show status bar
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  await DriffDbManager.instance.init();
  await SharedPreferencesHelper.init();
  await clearSecureStorageOnReinstall();

  LocalAuthConfig.instance.init();
  final encryptService = EncryptAppDataService.instance;
  final themeProvider = ThemeProvider();
  await themeProvider.initTheme();
  await encryptService.initialize();
  packageInfo = await PackageInfo.fromPlatform();
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
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(providers: ListProvider.providers, child: ScreenSizeObserver(child: MyApp(initialRoute: initialRoute, initialLocale: initialLocale))));
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
