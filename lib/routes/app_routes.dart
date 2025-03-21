import 'package:cybersafe_pro/screens/create_account/create_account_screen.dart';
import 'package:cybersafe_pro/screens/details_account/details_account_screen.dart' show DetailsAccountScreen;
import 'package:cybersafe_pro/screens/home/home_screen.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/screens/onboarding/onboarding_screen.dart';
import 'package:cybersafe_pro/screens/otp/otp_list_screen.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/screens/register_master_pin/register_master_pin.dart';
import 'package:cybersafe_pro/screens/settings/setting_screen.dart';
import 'package:cybersafe_pro/widgets/secure_app/secure_app_switcher.dart';
import 'package:cybersafe_pro/widgets/secure_app/secure_app_switcher_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Route names
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String createAccount = '/create_account';
  static const String updateAccount = '/update_account';
  static const String detailsAccount = '/details_account';
  static const String passwordGenerator = '/password_generator';
  static const String otpList = '/otp_list';
  static const String settings = '/settings';
  static const String registerMasterPin = '/register_master_pin';
  static const String loginMasterPin = '/login_master_pin';

  // Route map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: const HomeScreen()),
      onboarding: (context) => const OnboardingScreen(),
      registerMasterPin: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: const RegisterMasterPin()),
      loginMasterPin: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: const LoginMasterPassword()),
      createAccount: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: const CreateAccountScreen()),
      passwordGenerator: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: const PasswordGenerateScreen()),
      otpList: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: const OtpListScreen()),
      settings: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: const SettingScreen()),
    };
  }

  // Navigation methods
  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateToReplacement<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, dynamic>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateAndRemoveUntil<T>(BuildContext context, String routeName, {Object? arguments, String? untilRouteName}) {
    return Navigator.pushNamedAndRemoveUntil<T>(context, routeName, untilRouteName != null ? ModalRoute.withName(untilRouteName) : (route) => false, arguments: arguments);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    if (Navigator.canPop(context)) {
      Navigator.pop<T>(context, result);
    }
  }

  // Route generator for handling dynamic routes and arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen(), settings: settings);
      case onboarding:
        return MaterialPageRoute(builder: (context) => const OnboardingScreen(), settings: settings);
      case loginMasterPin:
        return MaterialPageRoute(builder: (context) => const LoginMasterPassword(), settings: settings);
      case registerMasterPin:
        return MaterialPageRoute(builder: (context) => const RegisterMasterPin(), settings: settings);
      // Add cases for routes that need special handling or arguments
      case createAccount:
        return MaterialPageRoute(builder: (context) => const CreateAccountScreen(), settings: settings);
      case updateAccount:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => CreateAccountScreen(isUpdate: true, accountId: args["accountId"]), settings: settings);
      case detailsAccount:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => SecureAppSwitcherPage(style: SecureMaskStyle.blurLight, child: DetailsAccountScreen(accountId: args["accountId"])), settings: settings);
      default:
        // If the route is not found, return a 404 page or home page
        return MaterialPageRoute(builder: (context) => const OnboardingScreen(), settings: settings);
    }
  }
}
