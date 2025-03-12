import 'package:cybersafe_pro/my_app.dart';
import 'package:cybersafe_pro/providers/provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/objectbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo ObjectBox
  await ObjectBox.create();
  final encryptService = EncryptAppDataService.instance;
  final themeProvider = ThemeProvider();
  await themeProvider.initTheme();
  await encryptService.initialize();
  runApp(MultiProvider(providers: ListProvider.providers, child: MyApp(),),);
}


