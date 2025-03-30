import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';

class AuthLocale extends BaseLocale {
  final AppLocale appLocale;

  AuthLocale(this.appLocale);

  @override
  String get languageCode => appLocale.currentLocaleModel.languageCode;
  @override
  String get countryCode => appLocale.currentLocaleModel.countryCode;
  @override
  String get languageName => appLocale.currentLocaleModel.languageName;
  @override
  String get languageNativeName => appLocale.currentLocaleModel.languageNativeName;
  @override
  String get flagEmoji => appLocale.currentLocaleModel.flagEmoji;

  @override
  Map<String, String> get vi => {
    'login': 'Đăng nhập',
    'register': 'Đăng ký',
    'enter_pin': 'Nhập mã PIN',
    'confirm_pin': 'Xác nhận mã PIN',
    'pin_not_match': 'Mã PIN không khớp',
    'pin_required': 'Vui lòng nhập mã PIN',
    'biometric_login': 'Đăng nhập bằng sinh trắc học',
  };

  @override
  Map<String, String> get en_GB => {
    'login': 'Login',
    'register': 'Register',
    'enter_pin': 'Enter PIN',
    'confirm_pin': 'Confirm PIN',
    'pin_not_match': 'PINs do not match',
    'pin_required': 'PIN is required',
    'biometric_login': 'Biometric Login',
  };

  @override
  Map<String, String> get en_US => {'login': 'Login', 'register': 'Register', 'enter_pin': 'Enter PIN', 'confirm_pin': 'Confirm PIN'};
  @override
  Map<String, String> get pt_PT => {
    'login': 'Entrar',
    'register': 'Registrar',
    'enter_pin': 'Digite o PIN',
    'confirm_pin': 'Confirme o PIN',
    'pin_not_match': 'PINs não correspondem',
    'pin_required': 'PIN é obrigatório',
    'biometric_login': 'Login Biométrico',
  };

  @override
  Map<String, String> get pt_BR => {'login': 'Entrar', 'register': 'Registrar'};

  @override
  Map<String, String> get hi => {
    'login': 'लॉग इन करें',
    'register': 'पंजीकरण करें',
    'enter_pin': 'पिन दर्ज करें',
    'confirm_pin': 'पिन की पुष्टि करें',
    'pin_not_match': 'पिन मेल नहीं खाते',
    'pin_required': 'पिन आवश्यक है',
    'biometric_login': 'बायोमेट्रिक लॉगिन',
  };

  @override
  Map<String, String> get ja => {
    'login': 'ログイン',
    'register': '登録',
    'enter_pin': 'PINを入力',
    'confirm_pin': 'PINを確認',
    'pin_not_match': 'PINが一致しません',
    'pin_required': 'PINが必要です',
    'biometric_login': '生体認証ログイン',
  };

  @override
  Map<String, String> get ru => {
    'login': 'Вход',
    'register': 'Регистрация',
    'enter_pin': 'Введите PIN',
    'confirm_pin': 'Подтвердите PIN',
    'pin_not_match': 'PIN-коды не совпадают',
    'pin_required': 'Требуется PIN',
    'biometric_login': 'Биометрический вход',
  };

  @override
  Map<String, String> get id => {
    'login': 'Masuk',
    'register': 'Daftar',
    'enter_pin': 'Masukkan PIN',
    'confirm_pin': 'Konfirmasi PIN',
    'pin_not_match': 'PIN tidak cocok',
    'pin_required': 'PIN diperlukan',
    'biometric_login': 'Login Biometrik',
  };
  
  @override
  // TODO: implement en
  Map<String, String> get en => throw UnimplementedError();
  
  @override
  // TODO: implement pt
  Map<String, String> get pt => throw UnimplementedError();
}
