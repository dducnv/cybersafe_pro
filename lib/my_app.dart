import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/screens/home/home_screen.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      await themeProvider.initTheme();
      await categoryProvider.getCategories();
      await accountProvider.getAccounts();
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppLocale, ThemeProvider>(
      builder: (context, appLocale, themeProvider, child) {
        return MaterialApp(
          title: 'CyberSafe Pro',
          debugShowCheckedModeBanner: false,
          locale: appLocale.locale,
          navigatorKey: GlobalKeys.appRootNavigatorKey,
          supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
          themeMode: themeProvider.themeMode,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
