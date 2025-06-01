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
    OtpText.title: 'Xác thực hai yếu tố',
    OtpText.scanQrCode: 'Quét mã QR',
    OtpText.manualEntry: 'Nhập thủ công',
    OtpText.addAccount: 'Thêm tài khoản',
    OtpText.accountName: 'Tên tài khoản',
    OtpText.secretKey: 'Mã xác thực',
    OtpText.invalidSecretKey: 'Mã xác thực không hợp lệ',
    OtpText.enterManually: 'Nhập thủ công',
    OtpText.secretKeyValidation: 'Không được để trống',
  };

  @override
  Map<String, String> get en => {
    OtpText.title: 'Two-Factor Authentication',
    OtpText.scanQrCode: 'Scan QR Code',
    OtpText.manualEntry: 'Enter Manually',
    OtpText.addAccount: 'Add Account',
    OtpText.accountName: 'Account Name',
    OtpText.secretKey: 'Authentication Code',
    OtpText.invalidSecretKey: 'Invalid authentication code',
    OtpText.enterManually: 'Enter manually',
    OtpText.secretKeyValidation: 'Cannot be empty',
  };

  @override
  Map<String, String> get pt => {
    OtpText.title: 'Autenticação em Duas Etapas',
    OtpText.scanQrCode: 'Escanear QR Code',
    OtpText.manualEntry: 'Inserir Manualmente',
    OtpText.addAccount: 'Adicionar Conta',
    OtpText.accountName: 'Nome da Conta',
    OtpText.secretKey: 'Código de Autenticação',
    OtpText.invalidSecretKey: 'Código de autenticação inválido',
    OtpText.enterManually: 'Inserir manualmente',
    OtpText.secretKeyValidation: 'Não pode estar vazio',
  };

  @override
  Map<String, String> get hi => {
    OtpText.title: 'दो-चरणीय प्रमाणीकरण',
    OtpText.scanQrCode: 'QR कोड स्कैन करें',
    OtpText.manualEntry: 'मैन्युअल दर्ज करें',
    OtpText.addAccount: 'खाता जोड़ें',
    OtpText.accountName: 'खाता नाम',
    OtpText.secretKey: 'प्रमाणीकरण कोड',
    OtpText.invalidSecretKey: 'अमान्य प्रमाणीकरण कोड',
    OtpText.enterManually: 'मैन्युअल रूप से दर्ज करें',
    OtpText.secretKeyValidation: 'खाली नहीं हो सकता',
  };

  @override
  Map<String, String> get ja => {
    OtpText.title: '二要素認証',
    OtpText.scanQrCode: 'QRコードをスキャン',
    OtpText.manualEntry: '手動入力',
    OtpText.addAccount: 'アカウントを追加',
    OtpText.accountName: 'アカウント名',
    OtpText.secretKey: '認証コード',
    OtpText.invalidSecretKey: '無効な認証コード',
    OtpText.enterManually: '手動で入力',
    OtpText.secretKeyValidation: '空にできません',
  };

  @override
  Map<String, String> get ru => {
    OtpText.title: 'Двухфакторная аутентификация',
    OtpText.scanQrCode: 'Сканировать QR-код',
    OtpText.manualEntry: 'Ввести вручную',
    OtpText.addAccount: 'Добавить аккаунт',
    OtpText.accountName: 'Имя аккаунта',
    OtpText.secretKey: 'Код аутентификации',
    OtpText.invalidSecretKey: 'Неверный код аутентификации',
    OtpText.enterManually: 'Ввести вручную',
    OtpText.secretKeyValidation: 'Не может быть пустым',
  };

  @override
  Map<String, String> get id => {
    OtpText.title: 'Otentikasi Dua Faktor',
    OtpText.scanQrCode: 'Pindai Kode QR',
    OtpText.manualEntry: 'Masukkan Secara Manual',
    OtpText.addAccount: 'Tambah Akun',
    OtpText.accountName: 'Nama Akun',
    OtpText.secretKey: 'Kode Autentikasi',
    OtpText.invalidSecretKey: 'Kode autentikasi tidak valid',
    OtpText.enterManually: 'Masukkan secara manual',
    OtpText.secretKeyValidation: 'Tidak boleh kosong',
  };

  @override
  Map<String, String> get tr => {
    OtpText.title: 'İki Adımlı Doğrulama',
    OtpText.scanQrCode: 'QR Kodunu Tara',
    OtpText.manualEntry: 'Manuel Giriş',
    OtpText.addAccount: 'Hesap Ekle',
    OtpText.accountName: 'Hesap Adı',
    OtpText.secretKey: 'Doğrulama Kodu',
    OtpText.invalidSecretKey: 'Geçersiz doğrulama kodu',
    OtpText.enterManually: 'Manuel olarak gir',
    OtpText.secretKeyValidation: 'Boş bırakılamaz',
  };
}