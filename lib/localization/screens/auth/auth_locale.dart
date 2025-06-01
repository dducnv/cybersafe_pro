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
    LoginText.enterPin: 'Nhập mã PIN',
    LoginText.enterAnyPin: 'Nhập mã PIN bất kỳ',
    LoginText.backupNote: 'Vui lòng nhập mã PIN để xác nhận sao lưu',
    LoginText.restoreNote: 'Vui lòng nhập mã PIN để xác nhận khôi phục',
    LoginText.loginLockDescription: 'Tài khoản đã bị khóa',
    LoginText.pleaseTryAgainLater: 'Vui lòng thử lại sau {0}',
    
    // Thêm các text đã dịch cho dialog xác nhận thoát
    LoginText.confirmExit: 'Xác nhận thoát',
    LoginText.confirmExitMessage: 'Bạn có chắc chắn muốn thoát? Các thao tác đang thực hiện có thể bị gián đoạn.',
    LoginText.cancel: 'Hủy',
    LoginText.exit: 'Thoát',
  };

  @override
  Map<String, String> get en => {
    LoginText.createPinCode: 'Create PIN',
    LoginText.confirmPinCode: 'Confirm PIN',
    LoginText.pinCodeNotMatch: 'PINs do not match',
    LoginText.pinCodeRequired: 'PIN is required',
    LoginText.enterPin: 'Enter PIN',
    LoginText.enterAnyPin: 'Enter any PIN',
    LoginText.backupNote: 'Please enter PIN to confirm backup',
    LoginText.restoreNote: 'Please enter PIN to confirm restore',
    LoginText.loginLockDescription: 'Account is locked',
    LoginText.pleaseTryAgainLater: 'Please try again in {0}',
    
    // Thêm các text đã dịch cho dialog xác nhận thoát
    LoginText.confirmExit: 'Confirm Exit',
    LoginText.confirmExitMessage: 'Are you sure you want to exit? Current operations may be interrupted.',
    LoginText.cancel: 'Cancel',
    LoginText.exit: 'Exit',
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

  @override
  Map<String, String> get tr => {
    LoginText.createPinCode: 'PIN Oluştur',
    LoginText.confirmPinCode: 'PIN Doğrula',
    LoginText.pinCodeNotMatch: 'PINler eşleşmiyor',
    LoginText.pinCodeRequired: 'PIN gereklidir',
  };
}
