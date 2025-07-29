import 'dart:async';
import 'dart:io';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/home_provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/screens/onboarding/onboarding_screen.dart';
import 'package:cybersafe_pro/screens/register_master_pin/register_master_pin.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application.dart';

class MyApp extends StatefulWidget {
  final String initialRoute;
  final Locale initialLocale;

  const MyApp({super.key, required this.initialRoute, required this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initApp();
    SecureApplicationUtil.instance.init();
    _initSecureApplication();
  }

  @override
  void dispose() {
    // Hủy đăng ký observer khi widget bị hủy
    WidgetsBinding.instance.removeObserver(this);
    SecureApplicationUtil.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<AppProvider>().handleAppBackground(context);
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != AppRoutes.loginMasterPin && currentRoute != AppRoutes.registerMasterPin) {
        SecureApplicationUtil.instance.lockOnBackground();
      }
    } else if (state == AppLifecycleState.resumed) {
      context.read<AppProvider>().handleAppResume(context);

      if (!SecureApplicationUtil.instance.isInitialized) {
        SecureApplicationUtil.instance.init();
      }

      // Kiểm tra xem có sự thay đổi về loại thiết bị không
      final deviceType = DeviceInfo.getDeviceType(context);
      if (deviceType == DeviceType.desktop) {
        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != null && currentRoute != AppRoutes.home) {
          DeviceInfo.currentScreen.value = currentRoute;
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      }
    }
  }

  Future<void> initApp() async {
    _initLocale();
  }

  // Khởi tạo ngôn ngữ từ storage
  Future<void> _initLocale() async {
    final savedLang = await SecureStorage.instance.read(key: SecureStorageKey.appLang);
    if (!mounted) return;
    if (savedLang != null) {
      final languageCode = savedLang.split('_').first;
      final countryCode = savedLang.split('_').last;
      final savedLocale = appLocales.firstWhere((locale) => locale.languageCode == languageCode && locale.countryCode == countryCode, orElse: () => appLocales.first);
      context.read<AppLocale>().setLocale(Locale(savedLocale.languageCode, savedLocale.countryCode));
      setState(() {});
    } else {
      final String defaultLocale = Platform.localeName;
      final languageCode = defaultLocale.split('_').first;
      final countryCode = defaultLocale.split('_').last;
      final savedLocale = appLocales.firstWhere((locale) => locale.languageCode == languageCode && locale.countryCode == countryCode, orElse: () => appLocales.first);
      context.read<AppLocale>().setLocale(Locale(savedLocale.languageCode, savedLocale.countryCode));
      setState(() {});
    }
  }

  Future<void> _initSecureApplication() async {
    try {
      await SecureApplicationUtil.instance.init();
    } catch (e) {
      logError('Failed to initialize SecureApplication: $e', functionName: "_initSecureApplication");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppLocale, ThemeProvider>(
      builder: (context, appLocale, themeProvider, child) {
        return MaterialApp(
          title: 'CyberSafe Pro',
          debugShowCheckedModeBanner: false,
          locale: appLocale.locale,
          supportedLocales: appLocales.map((e) => Locale(e.languageCode, e.countryCode)).toList(),
          navigatorKey: GlobalKeys.appRootNavigatorKey,
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
          themeMode: themeProvider.themeMode,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          home: _buildInitialScreen(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
              child: Selector<HomeProvider, bool>(
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
                      child: _buildSecureApplication(child),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInitialScreen() {
    return _buildInitialRoute();
  }

  Widget _buildInitialRoute() {
    switch (widget.initialRoute) {
      case AppRoutes.onboarding:
        return const OnboardingScreen();
      case AppRoutes.registerMasterPin:
        return const RegisterMasterPin();
      case AppRoutes.loginMasterPin:
        return const LoginMasterPassword(showBiometric: true);
      default:
        return const LoginMasterPassword(showBiometric: true);
    }
  }

  Widget _buildSecureApplication(Widget? child) {
    // Luôn bọc app bằng SecureApplication để chặn screenshot
    if (!SecureApplicationUtil.instance.isInitialized || SecureApplicationUtil.instance.secureApplicationController == null) {
      return _buildListenerWidget(child);
    }
    return SecureApplication(nativeRemoveDelay: 200, secureApplicationController: SecureApplicationUtil.instance.secureApplicationController, child: _buildListenerWidget(child));
  }

  Widget _buildListenerWidget(Widget? child) {
    if (child == null) return const SizedBox.shrink();

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (details) {
        if (mounted) {
          context.read<AppProvider>().handleUserInteraction(details);
        }
      },
      onPointerMove: (details) {
        if (mounted) {
          context.read<AppProvider>().handleUserInteraction(details);
        }
      },
      onPointerUp: (details) {
        if (mounted) {
          context.read<AppProvider>().handleUserInteraction(details);
        }
      },
      child: child,
    );
  }
}
