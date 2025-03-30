import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';

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
    LoginText.createPinCode: 'Tạo mã PIN',
    LoginText.confirmPinCode: 'Xác nhận mã PIN',
    LoginText.pinCodeNotMatch: 'Mã PIN không khớp',
    LoginText.pinCodeRequired: 'Vui lòng nhập đủ 6 số',
  };

  @override
  Map<String, String> get en => {
    LoginText.createPinCode: 'Create PIN',
    LoginText.confirmPinCode: 'Confirm PIN',
    LoginText.pinCodeNotMatch: 'PINs do not match',
    LoginText.pinCodeRequired: 'PIN is required',
  };

  @override
  Map<String, String> get en_GB => {
    LoginText.createPinCode: 'Create PIN',
    LoginText.confirmPinCode: 'Confirm PIN',
    LoginText.pinCodeNotMatch: 'PINs do not match',
    LoginText.pinCodeRequired: 'PIN is required',
  };

  @override
  Map<String, String> get en_US => {
    LoginText.createPinCode: 'Create PIN',
    LoginText.confirmPinCode: 'Confirm PIN',
    LoginText.pinCodeNotMatch: 'PINs do not match',
    LoginText.pinCodeRequired: 'PIN is required',
  };
  @override
  Map<String, String> get pt_PT => {
    LoginText.createPinCode: 'Criar PIN',
    LoginText.confirmPinCode: 'Confirmar PIN',
    LoginText.pinCodeNotMatch: 'PINs não correspondem',
    LoginText.pinCodeRequired: 'PIN é obrigatório',
  };

  @override
  Map<String, String> get pt_BR => {
    LoginText.createPinCode: 'Criar PIN',
    LoginText.confirmPinCode: 'Confirmar PIN',
    LoginText.pinCodeNotMatch: 'PINs não correspondem',
    LoginText.pinCodeRequired: 'PIN é obrigatório',
  };

  @override
  Map<String, String> get hi => {
    LoginText.createPinCode: 'PIN बनाना',
    LoginText.confirmPinCode: 'PIN सुनिश्चित करना',
    LoginText.pinCodeNotMatch: 'PIN मेल नहीं खाते',
    LoginText.pinCodeRequired: 'PIN आवश्यक है',
  };

  @override
  Map<String, String> get ja => {
    LoginText.createPinCode: 'PIN ログイン',
    LoginText.confirmPinCode: 'PIN 確認',
    LoginText.pinCodeNotMatch: 'PIN が一致しません',
    LoginText.pinCodeRequired: 'PIN が必要です',
  };

  @override
  Map<String, String> get ru => {
    LoginText.createPinCode: 'PIN ログイン',
    LoginText.confirmPinCode: 'PIN 確認',
    LoginText.pinCodeNotMatch: 'PIN が一致しません',
    LoginText.pinCodeRequired: 'PIN が必要です',
  };

  @override
  Map<String, String> get id => {
    LoginText.createPinCode: 'PIN Masuk',
    LoginText.confirmPinCode: 'PIN Konfirmasi',
    LoginText.pinCodeNotMatch: 'PIN tidak cocok',
    LoginText.pinCodeRequired: 'PIN diperlukan',
  };

  @override
  Map<String, String> get pt => {
    LoginText.createPinCode: 'Criar PIN',
    LoginText.confirmPinCode: 'Confirmar PIN',
    LoginText.pinCodeNotMatch: 'PINs não correspondem',
    LoginText.pinCodeRequired: 'PIN é obrigatório',
  };
}
