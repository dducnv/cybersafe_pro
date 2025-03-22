import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/widgets/secure_app/secure_app_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Khởi tạo SecureAppSwitcher để ngăn chặn chụp màn hình
  final _secureAppSwitcher = SecureAppSwitcher();

  @override
  void initState() {
    super.initState();
    // Khởi tạo SecureAppSwitcher với chặn chụp màn hình
    _secureAppSwitcher.initialize(blockScreenshot: true);
    initApp();
  }

  @override
  void dispose() {
    // Đảm bảo tắt chặn chụp màn hình khi app bị đóng
    _secureAppSwitcher.allowScreenshots();
    super.dispose();
  }

  Future<void> initApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) {
        return;
      }
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      // await accountProvider.generateFakeData();
      await categoryProvider.getCategories();
      await accountProvider.getAccounts();
      FlutterNativeSplash.remove();
    });
  }

  /// SecureAppSwitcher When the app is opened, the screen will be masked

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppLocale, ThemeProvider>(
      builder: (context, appLocale, themeProvider, child) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (details) => context.read<AppProvider>().handleUserInteraction(details),
          onPointerMove: (details) => context.read<AppProvider>().handleUserInteraction(details),
          onPointerUp: (details) => context.read<AppProvider>().handleUserInteraction(details),
          child: MaterialApp(
            title: 'CyberSafe Pro',
            debugShowCheckedModeBanner: false,
            locale: appLocale.locale,
            navigatorKey: GlobalKeys.appRootNavigatorKey,
            supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
            localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
            themeMode: themeProvider.themeMode,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            navigatorObservers: [secureAppSwitcherRouteObserver],
            initialRoute: widget.initialRoute,
            routes: AppRoutes.getRoutes(),
            onGenerateRoute: AppRoutes.onGenerateRoute,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
                child: Selector<AccountProvider, bool>(
                  selector: (context, provider) => provider.accountSelected.isNotEmpty,
                  builder: (_, value, _) {
                    return ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: AnnotatedRegion(
                        value: SystemUiOverlayStyle(
                          statusBarColor: Theme.of(context).colorScheme.surface,
                          statusBarBrightness: !context.darkMode ? Brightness.light : Brightness.dark,
                          statusBarIconBrightness: !context.darkMode ? Brightness.dark : Brightness.light,
                          systemNavigationBarColor: Theme.of(context).colorScheme.surface,
                          systemNavigationBarDividerColor: Theme.of(context).colorScheme.surface,
                          systemNavigationBarIconBrightness: !context.darkMode ? Brightness.dark : Brightness.light,
                        ),
                        child: child!,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
