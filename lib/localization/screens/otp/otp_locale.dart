import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/otp_text.dart';

class OtpLocale extends BaseLocale {
  final AppLocale appLocale;
  
  OtpLocale(this.appLocale);
  
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
    OtpText.title: 'Tài khoản OTP',
    OtpText.scanQrCode: 'Quét mã QR',
    OtpText.manualEntry: 'Nhập thủ công',
    OtpText.addAccount: 'Thêm tài khoản',
    OtpText.accountName: 'Tên tài khoản',
    OtpText.secretKey: 'Khóa bí mật',
    OtpText.invalidSecretKey: 'Khóa bí mật không hợp lệ',
    OtpText.enterManually: 'Nhập thủ công',
    OtpText.secretKeyValidation: 'Không được để trống',
  };

  @override
  Map<String, String> get en => {
    OtpText.title: 'OTP Accounts',
    OtpText.scanQrCode: 'Scan QR Code',
    OtpText.manualEntry: 'Manual Entry',
    OtpText.addAccount: 'Add Account',
    OtpText.accountName: 'Account Name',
    OtpText.secretKey: 'Secret Key',
    OtpText.invalidSecretKey: 'Invalid Secret Key',
    OtpText.enterManually: 'Enter Manually',
    OtpText.secretKeyValidation: 'Cannot be empty',
  };

  @override
  Map<String, String> get pt => {
    OtpText.title: 'Contas OTP',
    OtpText.scanQrCode: 'Escanear Código QR',
    OtpText.manualEntry: 'Entrada Manual',
    OtpText.addAccount: 'Adicionar Conta',
    OtpText.accountName: 'Nome da Conta',
    OtpText.secretKey: 'Chave Secreta',
    OtpText.invalidSecretKey: 'Chave Secreta Inválida',
    OtpText.enterManually: 'Inserir Manualmente',
    OtpText.secretKeyValidation: 'Não pode ser vazio',
  };

  @override
  Map<String, String> get hi => {
    OtpText.title: 'OTP खाते',
    OtpText.scanQrCode: 'QR कोड स्कैन करें',
    OtpText.manualEntry: 'मैनुअल प्रविष्टि',
    OtpText.addAccount: 'खाता जोड़ें',
    OtpText.accountName: 'खाता नाम',
    OtpText.secretKey: 'गुप्त कुंजी',
    OtpText.invalidSecretKey: 'अमान्य गुप्त कुंजी',
    OtpText.enterManually: 'मैनुअल रूप से दर्ज करें',
    OtpText.secretKeyValidation: 'खाली नहीं हो सकता है',
  };

  @override
  Map<String, String> get ja => {
    OtpText.title: 'OTPアカウント',
    OtpText.scanQrCode: 'QRコードをスキャン',
    OtpText.manualEntry: '手動入力',
    OtpText.addAccount: 'アカウントを追加',
    OtpText.accountName: 'アカウント名',
    OtpText.secretKey: 'シークレットキー',
    OtpText.invalidSecretKey: '無効なシークレットキー',
    OtpText.enterManually: '手動で入力',
    OtpText.secretKeyValidation: '空にできません',
  };

  @override
  Map<String, String> get ru => {
    OtpText.title: 'OTP аккаунты',
    OtpText.scanQrCode: 'Сканировать QR-код',
    OtpText.manualEntry: 'Ручной ввод',
    OtpText.addAccount: 'Добавить аккаунт',
    OtpText.accountName: 'Имя аккаунта',
    OtpText.secretKey: 'Секретный ключ',
    OtpText.invalidSecretKey: 'Недействительный секретный ключ',
    OtpText.enterManually: 'Ввести вручную',
    OtpText.secretKeyValidation: 'Не может быть пустым',
  };

  @override
  Map<String, String> get id => {
    OtpText.title: 'Akun OTP',
    OtpText.scanQrCode: 'Pindai Kode QR',
    OtpText.manualEntry: 'Entri Manual',
    OtpText.addAccount: 'Tambah Akun',
    OtpText.accountName: 'Nama Akun',
    OtpText.secretKey: 'Kunci Rahasia',
    OtpText.invalidSecretKey: 'Kunci Rahasia Tidak Valid',
    OtpText.enterManually: 'Masukkan Secara Manual',
    OtpText.secretKeyValidation: 'Tidak dapat kosong',
  };
}