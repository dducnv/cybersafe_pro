import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';

class LoginLocale extends BaseLocale {
  final AppLocale appLocale;
  
  LoginLocale(this.appLocale);
  
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
    LoginText.enterPin: 'Nhập mã PIN',
    LoginText.forgotPin: 'Quên mã PIN',
    LoginText.useBiometric: 'Sử dụng sinh trắc học',
    LoginText.incorrectPin: 'Mã PIN không đúng',
    LoginText.pinCodeRequired: 'Vui lòng nhập đủ 6 số',
    LoginText.resetApp: 'Đặt lại ứng dụng',
    LoginText.confirmReset: 'Xác nhận đặt lại',
    LoginText.resetWarning: 'Cảnh báo: Đặt lại ứng dụng sẽ xóa tất cả dữ liệu của bạn. Bạn có chắc chắn muốn tiếp tục?',
    LoginText.enterAnyPin: 'Nhập mã PIN bất kỳ',
    LoginText.backupNote: 'Mã PIN này sẽ dùng để mã hoá file, vui lòng ghi nhớ cho lần khôi phục dữ liệu.',
    LoginText.changePinCode: 'Đổi mã PIN',
    LoginText.loginLockDescription: 'Tài khoản đã bị khóa do nhập sai mật khẩu nhiều lần',
    LoginText.pleaseTryAgainLater: 'Vui lòng thử lại sau {0} phút',
    LoginText.restoreNote: 'Nhập mã PIN sao lưu để khôi phục.',
  };

  @override
  Map<String, String> get en => {
    LoginText.enterPin: 'Enter PIN',
    LoginText.forgotPin: 'Forgot PIN',
    LoginText.useBiometric: 'Use biometric',
    LoginText.incorrectPin: 'Incorrect PIN',
    LoginText.pinCodeRequired: 'Please enter a valid PIN',
    LoginText.resetApp: 'Reset app',
    LoginText.confirmReset: 'Confirm reset',
    LoginText.resetWarning: 'Warning: Resetting the app will delete all your data. Are you sure you want to continue?',
    LoginText.enterAnyPin: 'Enter any PIN',
    LoginText.backupNote: 'This PIN will be used to encrypt files, please remember for data recovery.',
    LoginText.changePinCode: 'Change PIN',
    LoginText.loginLockDescription: 'Account is locked due to multiple incorrect password attempts',
    LoginText.pleaseTryAgainLater: 'Please try again later in {0} minutes',
    LoginText.restoreNote: 'Enter the backup PIN to restore data.',
  };

  @override
  Map<String, String> get pt => {
    LoginText.enterPin: 'Digite o PIN',
    LoginText.forgotPin: 'Esqueceu o PIN',
    LoginText.useBiometric: 'Usar biometria',
    LoginText.incorrectPin: 'PIN incorreto',
    LoginText.pinCodeRequired: 'Por favor, insira um PIN válido',
    LoginText.resetApp: 'Redefinir aplicativo',
    LoginText.confirmReset: 'Confirmar redefinição',
    LoginText.resetWarning: 'Aviso: Redefinir o aplicativo excluirá todos os seus dados. Tem certeza de que deseja continuar?',
    LoginText.enterAnyPin: 'Digite qualquer PIN',
    LoginText.backupNote: 'Este PIN será usado para criptografar arquivos, por favor, lembre-se para recuperação de dados.',
    LoginText.changePinCode: 'Alterar PIN',
    LoginText.loginLockDescription: 'A conta está bloqueada devido a várias tentativas de senha incorretas',
    LoginText.pleaseTryAgainLater: 'Por favor, tente novamente mais tarde em {0} minutos',
    LoginText.restoreNote: 'Digite o PIN de backup para restaurar dados.',
  };

  @override
  Map<String, String> get hi => {
    LoginText.enterPin: 'पिन दर्ज करें',
    LoginText.forgotPin: 'पिन भूल गए',
    LoginText.useBiometric: 'बायोमेट्रिक का उपयोग करें',
    LoginText.incorrectPin: 'गलत पिन',
    LoginText.pinCodeRequired: 'कृपया एक मान्य पिन दर्ज करें',
    LoginText.resetApp: 'ऐप रीसेट करें',
    LoginText.confirmReset: 'रीसेट की पुष्टि करें',
    LoginText.resetWarning: 'चेतावनी: ऐप को रीसेट करने से आपका सभी डेटा हट जाएगा। क्या आप वाकई जारी रखना चाहते हैं?',
    LoginText.enterAnyPin: 'किसी भी पिन दर्ज करें',
    LoginText.backupNote: 'यह पिन फ़ाइलों को एन्क्रिप्ट करने के लिए उपयोग किया जाएगा, कृपया इसे याद रखें डेटा पुनर्स्थापना के लिए।',
    LoginText.changePinCode: 'पिन बदलें',
    LoginText.loginLockDescription: 'खाता बंद है क्योंकि बहुत सारे गलत पासवर्ड प्रयास हैं',
    LoginText.pleaseTryAgainLater: 'कृपया पुनः प्रयास करें बाद में {0} मिनट में',
    LoginText.restoreNote: 'बैकअप पिन दर्ज करें डेटा पुनर्स्थापना के लिए।',
  };

  @override
  Map<String, String> get ja => {
    LoginText.enterPin: 'PINを入力',
    LoginText.forgotPin: 'PINを忘れた',
    LoginText.useBiometric: '生体認証を使用',
    LoginText.incorrectPin: '不正なPIN',
    LoginText.pinCodeRequired: '有効なPINを入力してください',
    LoginText.resetApp: 'アプリをリセット',
    LoginText.confirmReset: 'リセットを確認',
    LoginText.resetWarning: '警告：アプリをリセットするとすべてのデータが削除されます。続行しますか？',
    LoginText.enterAnyPin: '任意のPINを入力',
    LoginText.backupNote: 'このPINはファイルを暗号化するために使用されます。データの復元に備えて覚えておいてください。',
    LoginText.changePinCode: 'PINを変更',
    LoginText.loginLockDescription: 'アカウントは複数の間違ったパスワード試行によりロックされています',
    LoginText.pleaseTryAgainLater: 'もう一度試してください {0} 分後',
    LoginText.restoreNote: 'バックアップPINを入力してデータを復元します。',
  };

  @override
  Map<String, String> get ru => {
    LoginText.enterPin: 'Введите PIN',
    LoginText.forgotPin: 'Забыли PIN',
    LoginText.useBiometric: 'Использовать биометрию',
    LoginText.incorrectPin: 'Неверный PIN',
    LoginText.pinCodeRequired: 'Пожалуйста, введите действительный PIN',
    LoginText.resetApp: 'Сбросить приложение',
    LoginText.confirmReset: 'Подтвердите сброс',
    LoginText.resetWarning: 'Предупреждение: Сброс приложения удалит все ваши данные. Вы уверены, что хотите продолжить?',
    LoginText.enterAnyPin: 'Введите любой PIN',
    LoginText.backupNote: 'Этот PIN будет использоваться для шифрования файлов, пожалуйста, запомните его для восстановления данных.',
    LoginText.changePinCode: 'Изменить PIN',
    LoginText.loginLockDescription: 'Аккаунт заблокирован из-за нескольких неправильных попыток входа',
    LoginText.pleaseTryAgainLater: 'Пожалуйста, попробуйте снова через {0} минут',
    LoginText.restoreNote: 'Введите PIN резервной копии для восстановления данных.',
  };

  @override
  Map<String, String> get id => {
    LoginText.enterPin: 'Masukkan PIN',
    LoginText.forgotPin: 'Lupa PIN',
    LoginText.useBiometric: 'Gunakan biometrik',
    LoginText.incorrectPin: 'PIN salah',
    LoginText.pinCodeRequired: 'Masukkan PIN yang valid',
    LoginText.resetApp: 'Reset aplikasi',
    LoginText.confirmReset: 'Konfirmasi reset',
    LoginText.resetWarning: 'Peringatan: Mereset aplikasi akan menghapus semua data Anda. Apakah Anda yakin ingin melanjutkan?',
    LoginText.enterAnyPin: 'Masukkan PIN apa pun',
    LoginText.backupNote: 'PIN ini akan digunakan untuk mengenkripsi file, silakan ingat untuk pemulihan data.',
    LoginText.changePinCode: 'Ubah PIN',
    LoginText.loginLockDescription: 'Akun terkunci karena beberapa kali percobaan masuk yang salah',
    LoginText.pleaseTryAgainLater: 'Silakan coba lagi nanti dalam {0} menit',
    LoginText.restoreNote: 'Masukkan PIN sao lưu untuk khôi phục dữ liệu.',
  };

  @override
  Map<String, String> get tr => {
    LoginText.enterPin: 'PIN Gir',
    LoginText.forgotPin: 'PIN Unut',
    LoginText.useBiometric: 'Biometrik Kullan',
    LoginText.incorrectPin: 'Yanlış PIN',
    LoginText.pinCodeRequired: 'Lütfen geçerli bir PIN girin',
    LoginText.resetApp: 'Uygulamayı Sıfırla',
    LoginText.confirmReset: 'Sıfırlama Onayla',
    LoginText.resetWarning: 'Uyarı: Uygulamayı sıfırlamak tüm verilerinizi siler. Devam etmek istediğinize emin misiniz?',
    LoginText.enterAnyPin: 'Herhangi bir PIN girin',
    LoginText.backupNote: 'Bu PIN dosyaları şifrelemek için kullanılacak, verileri geri yüklemek için lütfen hatırlayın.',
    LoginText.changePinCode: 'PIN Değiştir',
    LoginText.loginLockDescription: 'Birden fazla yanlış giriş denemesi nedeniyle hesap kilitlendi',
    LoginText.pleaseTryAgainLater: 'Lütfen {0} dakika sonra tekrar deneyin',
    LoginText.restoreNote: 'Verileri geri yüklemek için geri yedekleme PIN girin.',

    LoginText.createPinCode: 'PIN Oluştur',
    LoginText.confirmPinCode: 'PIN Doğrula',
    LoginText.pinCodeNotMatch: 'PINler eşleşmiyor',
    
  };
} 