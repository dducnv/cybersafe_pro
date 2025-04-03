import 'dart:io';

import 'package:cybersafe_pro/screens/about_app/about_app_screen.dart';
import 'package:cybersafe_pro/screens/category_manager/category_manager_screen.dart';
import 'package:cybersafe_pro/screens/create_account/create_account_screen.dart';
import 'package:cybersafe_pro/screens/details_account/details_account_screen.dart' show DetailsAccountScreen;
import 'package:cybersafe_pro/screens/home/home_screen.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/screens/onboarding/onboarding_screen.dart';
import 'package:cybersafe_pro/screens/otp/otp_list_screen.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/screens/register_master_pin/register_master_pin.dart';
import 'package:cybersafe_pro/screens/settings/setting_screen.dart';
import 'package:cybersafe_pro/screens/statistic/statistic_screen.dart';
import 'package:cybersafe_pro/screens/statistic/sub_sceens/account_password_weak.dart';
import 'package:cybersafe_pro/screens/statistic/sub_sceens/same_passwords_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';

class AppRoutes {
  // Route names
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String createAccount = '/create_account';
  static const String updateAccount = '/update_account';
  static const String detailsAccount = '/details_account';
  static const String passwordGenerator = '/password_generator';
  static const String otpList = '/otp_list';
  static const String settingsRoute = '/settings';
  static const String categoryManager = '/category_manager';
  static const String registerMasterPin = '/register_master_pin';
  static const String loginMasterPin = '/login_master_pin';
  static const String statistic = '/statistic';
  static const String accountPasswordWeak = '/account_password_weak';
  static const String accountSamePassword = '/account_same_password';
  static const String aboutApp = '/about_app';
  // Danh sách các màn hình cần SecureAppSwitcher
  static const List<String> securedRoutes = [home, detailsAccount, statistic, accountPasswordWeak, accountSamePassword];

  // Navigation methods
  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    // Nếu điều hướng đến route được bảo mật, khởi tạo lại controller nếu cần
    if (securedRoutes.contains(routeName)) {
      SecureApplicationUtil.instance.init();
    }
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateToReplacement<T>(BuildContext context, String routeName, {Object? arguments}) {
    // Nếu điều hướng đến route được bảo mật, khởi tạo lại controller nếu cần
    if (securedRoutes.contains(routeName)) {
      SecureApplicationUtil.instance.init();
    }
    return Navigator.pushReplacementNamed<T, dynamic>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateAndRemoveUntil<T>(BuildContext context, String routeName, {Object? arguments}) {
    // Nếu điều hướng đến route được bảo mật, khởi tạo lại controller nếu cần
    if (securedRoutes.contains(routeName)) {
      SecureApplicationUtil.instance.init();
    }
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false, // Luôn xóa tất cả route trước đó
      arguments: arguments,
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    if (Navigator.canPop(context)) {
      Navigator.pop<T>(context, result);
    }
  }

  // Route generator for handling dynamic routes and arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget screen;

    switch (settings.name) {
      case onboarding:
        screen = const OnboardingScreen();
        break;
      case home:
        screen = const HomeScreen();
        break;
      case passwordGenerator:
        screen = const PasswordGenerateScreen();
        break;
      case otpList:
        screen = const OtpListScreen();
        break;
      case statistic:
        screen = const StatisticScreen();
        break;
      case settingsRoute:
        screen = const SettingScreen();
        break;
      case categoryManager:
        screen = const CategoryManagerScreen();
        break;
      case createAccount:
        screen = const CreateAccountScreen();
        break;
      case updateAccount:
        final args = settings.arguments as Map<String, dynamic>;
        screen = CreateAccountScreen(isUpdate: true, accountId: args["accountId"]);
        break;
      case detailsAccount:
        final args = settings.arguments as Map<String, dynamic>;
        screen = DetailsAccountScreen(accountId: args["accountId"]);
        break;
      case accountPasswordWeak:
        screen = const AccountPasswordWeak();
        break;
      case accountSamePassword:
        screen = const SamePasswordsView();
        break;
      case registerMasterPin:
        screen = const RegisterMasterPin();
        break;
      case loginMasterPin:
        screen = const LoginMasterPassword();
        break;
      case aboutApp:
        screen = const AboutAppScreen();
        break;
      default:
        screen = const LoginMasterPassword();
    }

    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (context) => screen, settings: settings);
    }

    return MaterialPageRoute(builder: (context) => screen, settings: settings);
  }
}
