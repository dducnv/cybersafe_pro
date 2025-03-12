import 'package:cybersafe_pro/screens/create_account/create_account_screen.dart';
import 'package:cybersafe_pro/screens/home/home_screen.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/widgets/secure_app/secure_app_switcher.dart';
import 'package:cybersafe_pro/widgets/secure_app/secure_app_switcher_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Route names
  static const String home = '/';
  static const String createAccount = '/create_account';
  static const String passwordGenerator = '/password_generator';
  static const String secureAppSwitcher = '/secure_app_switcher';

  // Route map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => SecureAppSwitcherPage(
        style: SecureMaskStyle.blurLight,
        child: const HomeScreen()),
      createAccount: (context) => SecureAppSwitcherPage(
        style: SecureMaskStyle.blurLight,
        child: const CreateAccountScreen()),
      passwordGenerator: (context) => SecureAppSwitcherPage(
        style: SecureMaskStyle.blurLight,
        child: const PasswordGenerateScreen()),
      secureAppSwitcher: (context) => SecureAppSwitcherPage(
            child: Container(),
          ),
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
    return Navigator.pushNamedAndRemoveUntil<T>(
      context, 
      routeName, 
      untilRouteName != null 
        ? ModalRoute.withName(untilRouteName) 
        : (route) => false,
      arguments: arguments
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  // Route generator for handling dynamic routes and arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Extract route arguments if any
    final args = settings.arguments;

    switch (settings.name) {
      // Add cases for routes that need special handling or arguments
      case createAccount:
        return MaterialPageRoute(
          builder: (context) => const CreateAccountScreen(),
          settings: settings,
        );
      
      // Add more cases as needed
      
      default:
        // If the route is not found, return a 404 page or home page
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: settings,
        );
    }
  }
} 