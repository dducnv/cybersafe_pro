import '../../base_locale.dart';
import '../../app_locale.dart';

class AuthLocale extends BaseLocale {
  AuthLocale(super.appLocale);

  // Keys cho màn hình auth
  static const String login = 'login';
  static const String register = 'register';
  static const String email = 'email';
  static const String password = 'password';
  static const String forgotPassword = 'forgotPassword';

  @override
  Map<String, dynamic> get vi => {
    login: 'Đăng nhập',
    register: 'Đăng ký',
    email: 'Email',
    password: 'Mật khẩu',
    forgotPassword: 'Quên mật khẩu?',
  };

  @override
  Map<String, dynamic> get en => {
    login: 'Login',
    register: 'Register',
    email: 'Email',
    password: 'Password',
    forgotPassword: 'Forgot Password?',
  };
} 