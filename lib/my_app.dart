import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/screens/onboarding/onboarding_screen.dart';
import 'package:cybersafe_pro/screens/register_master_pin/register_master_pin.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application.dart';

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Đăng ký observer để theo dõi trạng thái ứng dụng
    WidgetsBinding.instance.addObserver(this);

    // Khởi tạo lại SecureApplicationUtil trước khi sử dụng
    SecureApplicationUtil.instance.init();
    initApp();
  }

  @override
  void dispose() {
    // Hủy đăng ký observer khi widget bị hủy
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      logInfo("Ứng dụng đang chạy nền");  
      context.read<AppProvider>().handleAppBackground();
      // Xóa orchestration key khi ứng dụng chuyển sang background
      EncryptAppDataService.instance.clearOrchestrationKey();
    } else if (state == AppLifecycleState.resumed) {
      logInfo("Ứng dụng đang chạy lại");
      SecureApplicationUtil.instance.init();
    }
  }

  Future<void> initApp() async {
    // Đợi cho việc khởi tạo SecureApplicationUtil hoàn tất
    await SecureApplicationUtil.instance.initDone;

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Đảm bảo đợi một khoảng thời gian ngắn để cho phép việc khởi tạo hoàn tất
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      _initLocale();

      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      // await accountProvider.generateFakeData();
      await categoryProvider.getCategories();
      await accountProvider.getAccounts();
    });
  }

  // Khởi tạo ngôn ngữ từ storage
  Future<void> _initLocale() async {
    final savedLang = await SecureStorage.instance.read(key: SecureStorageKey.appLang);

    if (savedLang != null && mounted) {
      final languageCode = savedLang.split('_').first;
      final countryCode = savedLang.split('_').last;
      final savedLocale = appLocales.firstWhere((locale) => locale.languageCode == languageCode && locale.countryCode == countryCode, orElse: () => appLocales.first);
      if (mounted) {
        context.read<AppLocale>().setLocale(Locale(savedLocale.languageCode, savedLocale.countryCode));
      }
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
        return const LoginMasterPassword();
      default:
        return const LoginMasterPassword();
    }
  }

  Widget _buildSecureApplication(Widget? child) {
    try {
      // Kiểm tra xem SecureApplicationUtil đã được khởi tạo chưa
      if (!SecureApplicationUtil.instance.isInitialized || SecureApplicationUtil.instance.secureApplicationController == null) {
        // Nếu chưa khởi tạo, trả về child trực tiếp
        return _buildListenerWidget(child);
      }

      // Sử dụng ValueListenableBuilder để lắng nghe thay đổi trạng thái mà không cần truy cập trực tiếp vào widget
      return ValueListenableBuilder<bool>(
        valueListenable: SecureApplicationUtil.instance.lockStateChanged,
        builder: (context, _, __) {
          return SecureApplication(nativeRemoveDelay: 800, secureApplicationController: SecureApplicationUtil.instance.secureApplicationController, child: _buildListenerWidget(child));
        },
      );
    } catch (e) {
      return _buildListenerWidget(child);
    }
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
