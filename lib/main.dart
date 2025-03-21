import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/my_app.dart';
import 'package:cybersafe_pro/providers/provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/objectbox.dart';
import 'package:timezone/data/latest.dart' as timezone;

String initialRoute = AppRoutes.loginMasterPin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone.initializeTimeZones();
  // Khởi tạo ObjectBox
  await ObjectBox.create();
  LocalAuthConfig.instance.init();
  final encryptService = EncryptAppDataService.instance;
  final themeProvider = ThemeProvider();
  await themeProvider.initTheme();
  await encryptService.initialize();
  String initialRoute = await getInitialRoute();
  runApp(MultiProvider(providers: ListProvider.providers, child: MyApp(initialRoute: initialRoute)));
}

Future<String> getInitialRoute() async {
  String? isFirstTime = await SecureStorage.instance.read(key: SecureStorageKey.firstOpenApp);
  //this is from old app, wrong key
  String? fistOpenApp = await SecureStorage.instance.read(key: SecureStorageKey.fistOpenAppOld);
  if (isFirstTime == null && fistOpenApp == null) {
    return AppRoutes.onboarding;
  }
  final pinCode = await SecureStorage.instance.read(key: SecureStorageKey.pinCode);
  if (pinCode == null) {
    return AppRoutes.registerMasterPin;
  }
  return AppRoutes.loginMasterPin;
}
