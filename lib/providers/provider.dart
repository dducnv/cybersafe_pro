import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/create_account_form_provider.dart';
import 'package:cybersafe_pro/providers/password_generate_provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ListProvider {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => AppLocale()),
    ChangeNotifierProvider(create: (_)=> ThemeProvider(),),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => AccountProvider()),
    ChangeNotifierProvider(create: (_) => CreateAccountFormProvider()),
    ChangeNotifierProvider(create: (_)=> PasswordGenerateProvider())
  ];
}
