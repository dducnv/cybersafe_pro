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
    OtpText.secretKey: 'Khóa bí mật',
    OtpText.invalidSecretKey: 'Khóa bí mật không hợp lệ',
    OtpText.enterManually: 'Tự nhập',
    OtpText.secretKeyValidation: 'Không được để trống',
    OtpText.enterOldPin: 'Nhập PIN cũ',
  };

  @override
  Map<String, String> get en => {
    OtpText.title: 'Two-Factor Authentication',
    OtpText.scanQrCode: 'Scan QR Code',
    OtpText.manualEntry: 'Enter Manually',
    OtpText.addAccount: 'Add Account',
    OtpText.accountName: 'Account Name',
    OtpText.secretKey: 'Secret Key',
    OtpText.invalidSecretKey: 'Invalid secret key',
    OtpText.enterManually: 'Enter manually',
    OtpText.secretKeyValidation: 'Cannot be empty',
    OtpText.enterOldPin: 'Enter Old PIN',
  };

  @override
  Map<String, String> get pt => {
    OtpText.title: 'Autenticação em Duas Etapas',
    OtpText.scanQrCode: 'Escanear QR Code',
    OtpText.manualEntry: 'Inserir Manualmente',
    OtpText.addAccount: 'Adicionar Conta',
    OtpText.accountName: 'Nome da Conta',
    OtpText.secretKey: 'Chave secreta',
    OtpText.invalidSecretKey: 'Chave secreta inválida',
    OtpText.enterManually: 'Inserir manualmente',
    OtpText.secretKeyValidation: 'Não pode estar vazio',
    OtpText.enterOldPin: 'Digite o PIN antigo',
  };

  @override
  Map<String, String> get hi => {
    OtpText.title: 'दो-चरणीय प्रमाणीकरण',
    OtpText.scanQrCode: 'QR कोड स्कैन करें',
    OtpText.manualEntry: 'मैन्युअल प्रवेश करें',
    OtpText.addAccount: 'खाता जोड़ें',
    OtpText.accountName: 'खाता नाम',
    OtpText.secretKey: 'गुप्त कुंजी',
    OtpText.invalidSecretKey: 'अमान्य गुप्त कुंजी',
    OtpText.enterManually: 'मैन्युअल रूप से प्रवेश करें',
    OtpText.secretKeyValidation: 'खाली नहीं हो सकता',
    OtpText.enterOldPin: 'पुराना PIN दर्ज करें',
  };

  @override
  Map<String, String> get ja => {
    OtpText.title: '二要素認証',
    OtpText.scanQrCode: 'QRコードをスキャン',
    OtpText.manualEntry: '手動入力',
    OtpText.addAccount: 'アカウントを追加',
    OtpText.accountName: 'アカウント名',
    OtpText.secretKey: 'シークレットキー',
    OtpText.invalidSecretKey: '無効なシークレットキー',
    OtpText.enterManually: '手動で入力',
    OtpText.secretKeyValidation: '空にできません',
    OtpText.enterOldPin: '古いPINを入力',
  };

  @override
  Map<String, String> get ru => {
    OtpText.title: 'Двухфакторная аутентификация',
    OtpText.scanQrCode: 'Сканировать QR-код',
    OtpText.manualEntry: 'Ввести вручную',
    OtpText.addAccount: 'Добавить аккаунт',
    OtpText.accountName: 'Имя аккаунта',
    OtpText.secretKey: 'Секретный ключ',
    OtpText.invalidSecretKey: 'Неверный секретный ключ',
    OtpText.enterManually: 'Ввести вручную',
    OtpText.secretKeyValidation: 'Не может быть пустым',
    OtpText.enterOldPin: 'Введите старый PIN',
  };

  @override
  Map<String, String> get id => {
    OtpText.title: 'Otentikasi Dua Faktor',
    OtpText.scanQrCode: 'Pindai Kode QR',
    OtpText.manualEntry: 'Masukkan Secara Manual',
    OtpText.addAccount: 'Tambah Akun',
    OtpText.accountName: 'Nama Akun',
    OtpText.secretKey: 'Kunci Rahasia',
    OtpText.invalidSecretKey: 'Kunci rahasia tidak valid',
    OtpText.enterManually: 'Masukkan secara manual',
    OtpText.secretKeyValidation: 'Tidak boleh kosong',
    OtpText.enterOldPin: 'Masukkan PIN lama',
  };

  @override
  Map<String, String> get tr => {
    OtpText.title: 'İki Adımlı Doğrulama',
    OtpText.scanQrCode: 'QR Kodunu Tara',
    OtpText.manualEntry: 'Manuel Giriş',
    OtpText.addAccount: 'Hesap Ekle',
    OtpText.accountName: 'Hesap Adı',
    OtpText.secretKey: 'Gizli Anahtar',
    OtpText.invalidSecretKey: 'Geçersiz gizli anahtar',
    OtpText.enterManually: 'Manuel olarak gir',
    OtpText.secretKeyValidation: 'Boş bırakılamaz',
    OtpText.enterOldPin: 'Eski PIN gir',
  };

  @override
  Map<String, String> get es => {
    OtpText.title: 'Autenticación en dos pasos',
    OtpText.scanQrCode: 'Escanear código QR',
    OtpText.manualEntry: 'Ingresar manualmente',
    OtpText.addAccount: 'Agregar cuenta',
    OtpText.accountName: 'Nombre de la cuenta',
    OtpText.secretKey: 'Clave secreta',
    OtpText.invalidSecretKey: 'Clave secreta inválida',
    OtpText.enterManually: 'Ingresar manualmente',
    OtpText.secretKeyValidation: 'No puede estar vacío',
    OtpText.enterOldPin: 'Introducir PIN antiguo',
  };
}
