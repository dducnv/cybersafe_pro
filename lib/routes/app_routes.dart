import 'dart:io';

import 'package:cybersafe_pro/screens/about_app/about_app_screen.dart';
import 'package:cybersafe_pro/screens/category_manager/category_manager_screen.dart';
import 'package:cybersafe_pro/screens/create_account/create_account_screen.dart';
import 'package:cybersafe_pro/screens/details_account/details_account_screen.dart'
    show DetailsAccountScreen;
import 'package:cybersafe_pro/screens/home/home_screen.dart';
import 'package:cybersafe_pro/screens/login_master_password/login_master_password.dart';
import 'package:cybersafe_pro/screens/note_editor/note_editor.dart';
import 'package:cybersafe_pro/screens/note_list/note_list.dart';
import 'package:cybersafe_pro/screens/onboarding/onboarding_screen.dart';
import 'package:cybersafe_pro/screens/otp/otp_list_screen.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/screens/register_master_pin/register_master_pin.dart';
import 'package:cybersafe_pro/screens/settings/setting_screen.dart';
import 'package:cybersafe_pro/screens/statistic/statistic_screen.dart';
import 'package:cybersafe_pro/screens/statistic/sub_sceens/account_password_weak.dart';
import 'package:cybersafe_pro/screens/statistic/sub_sceens/same_passwords_view.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:cybersafe_pro/widgets/modal_side_sheet/modal_side_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_application/secure_gate.dart';

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
  static const String notes = '/notes';
  static const String noteEditor = "/note_editor";

  // Danh sách các màn hình sẽ hiển thị dưới dạng ModalSideSheet khi ở desktop
  static const List<String> modalSideSheetRoutes = [
    createAccount,
    updateAccount,
    detailsAccount,
    passwordGenerator,
    otpList,
    settingsRoute,
    categoryManager,
    statistic,
    accountPasswordWeak,
    accountSamePassword,
    aboutApp,
  ];

  // Navigation methods
  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    // Cập nhật màn hình hiện tại để desktop mode có thể xử lý
    DeviceInfo.currentScreen.value = routeName;
    final deviceType = DeviceInfo.getDeviceType(context);
    // Kiểm tra nếu đang ở desktop mode và route nằm trong danh sách modalSideSheetRoutes
    if (deviceType == DeviceType.desktop && modalSideSheetRoutes.contains(routeName)) {
      return showModalSideSheet<T>(context: context, body: _buildScreen(routeName, arguments));
    }

    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateToReplacement<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    // Cập nhật màn hình hiện tại để desktop mode có thể xử lý
    DeviceInfo.currentScreen.value = routeName;
    final deviceType = DeviceInfo.getDeviceType(context);
    // Kiểm tra nếu đang ở desktop mode và route nằm trong danh sách modalSideSheetRoutes
    if (deviceType == DeviceType.desktop && modalSideSheetRoutes.contains(routeName)) {
      return showModalSideSheet<T>(context: context, body: _buildScreen(routeName, arguments));
    }

    return Navigator.pushReplacementNamed<T, dynamic>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    // Cập nhật màn hình hiện tại để desktop mode có thể xử lý
    DeviceInfo.currentScreen.value = routeName;
    final deviceType = DeviceInfo.getDeviceType(context);

    // Kiểm tra nếu đang ở desktop mode và route nằm trong danh sách modalSideSheetRoutes
    if (deviceType == DeviceType.desktop && modalSideSheetRoutes.contains(routeName)) {
      return showModalSideSheet<T>(context: context, body: _buildScreen(routeName, arguments));
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

  // Helper method to build screen based on route name
  static Widget _buildScreen(String routeName, Object? arguments) {
    switch (routeName) {
      case onboarding:
        return const OnboardingScreen();
      case home:
        return const HomeScreen();
      case passwordGenerator:
        return const PasswordGenerateScreen();
      case otpList:
        return const OtpListScreen();
      case statistic:
        return const StatisticScreen();
      case settingsRoute:
        return const SettingScreen();
      case categoryManager:
        return const CategoryManagerScreen();
      case createAccount:
        return const CreateAccountScreen();
      case updateAccount:
        final args = arguments as Map<String, dynamic>;
        return CreateAccountScreen(isUpdate: true, accountId: args["accountId"]);
      case detailsAccount:
        final args = arguments as Map<String, dynamic>;
        return DetailsAccountScreen(accountId: args["accountId"]);
      case accountPasswordWeak:
        return const AccountPasswordWeak();
      case accountSamePassword:
        return const SamePasswordsView();
      case registerMasterPin:
        final args = arguments as Map<String, dynamic>;
        return RegisterMasterPin(isChangePin: args["isChangePin"] ?? false, oldPin: args["oldPin"]);
      case loginMasterPin:
        return const LoginMasterPassword();
      case aboutApp:
        return const AboutAppScreen();
      case notes:
        return NoteList();
      case noteEditor:
        final args = arguments is Map<String, dynamic> ? arguments : {};
        final noteId = args["noteId"];
        return NoteEditor(noteId: noteId);
      default:
        return const LoginMasterPassword();
    }
  }

  static Widget _secureGateWraper(Widget child) {
    return SecureGate(
      blurr: 60,
      opacity: 0.8,
      lockedBuilder:
          (context, controller) => LoginMasterPassword(secureApplicationController: controller),
      child: child,
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget screen = _secureGateWraper(_buildScreen(settings.name ?? '', settings.arguments));

    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (context) => screen, settings: settings);
    }
    return MaterialPageRoute(builder: (context) => screen, settings: settings);
  }
}
