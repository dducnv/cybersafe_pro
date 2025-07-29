import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/providers/desktop_home_provider.dart';
import 'package:cybersafe_pro/providers/details_account_provider.dart';
import 'package:cybersafe_pro/providers/home_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/providers/password_generate_provider.dart';
import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ListProvider {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => AppLocale()),
    ChangeNotifierProvider(create: (_) => LocalAuthProvider()),
    ChangeNotifierProvider(create: (_) => AppProvider.instance),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => AccountProvider()),
    ChangeNotifierProvider(create: (_) => AccountFormProvider()),
    ChangeNotifierProvider(create: (_) => PasswordGenerateProvider()),
    ChangeNotifierProvider(create: (_) => StatisticProvider()),
    ChangeNotifierProvider(create: (_) => DesktopHomeProvider()),
    ChangeNotifierProvider(create: (_) => DetailsAccountProvider()),
    ChangeNotifierProvider(create: (context) => HomeProvider(accountProvider: context.read<AccountProvider>(), categoryProvider: context.read<CategoryProvider>())),
  ];
}
