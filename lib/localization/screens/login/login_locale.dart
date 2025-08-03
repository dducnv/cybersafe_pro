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
    LoginText.useBiometric: 'Kích hoạt sinh trắc học',
    LoginText.incorrectPin: 'Mã PIN không đúng',
    LoginText.pinCodeRequired: 'Vui lòng nhập đủ 6 số',
    LoginText.resetApp: 'Đặt lại ứng dụng',
    LoginText.confirmReset: 'Xác nhận đặt lại',
    LoginText.resetWarning:
        'Cảnh báo: Đặt lại ứng dụng sẽ xóa tất cả dữ liệu của bạn. Bạn có chắc chắn muốn tiếp tục?',
    LoginText.enterAnyPin: 'Nhập mã PIN bất kỳ',
    LoginText.backupNote:
        'Mã PIN này sẽ dùng để mã hoá file, vui lòng ghi nhớ cho lần khôi phục dữ liệu.',
    LoginText.changePinCode: 'Đổi mã PIN',
    LoginText.loginLockDescription: 'Tài khoản đã bị khóa do nhập sai mật khẩu nhiều lần',
    LoginText.pleaseTryAgainLater: 'Vui lòng thử lại sau {0} phút',
    LoginText.restoreNote: 'Nhập mã PIN sao lưu để khôi phục.',
  };

  @override
  Map<String, String> get en => {
    LoginText.enterPin: 'Enter PIN',
    LoginText.forgotPin: 'Forgot PIN',
    LoginText.useBiometric: 'Enable biometric',
    LoginText.incorrectPin: 'Incorrect PIN',
    LoginText.pinCodeRequired: 'Please enter all 6 digits',
    LoginText.resetApp: 'Reset app',
    LoginText.confirmReset: 'Confirm reset',
    LoginText.resetWarning:
        'Warning: Resetting the app will delete all your data. Are you sure you want to continue?',
    LoginText.enterAnyPin: 'Enter any PIN',
    LoginText.backupNote:
        'This PIN will be used to encrypt files, please remember it for data recovery.',
    LoginText.changePinCode: 'Change PIN',
    LoginText.loginLockDescription:
        'Account has been locked due to too many incorrect password attempts',
    LoginText.pleaseTryAgainLater: 'Please try again after {0} minutes',
    LoginText.restoreNote: 'Enter the backup PIN to restore data.',
  };

  @override
  Map<String, String> get pt => {
    LoginText.enterPin: 'Digite o PIN',
    LoginText.forgotPin: 'Esqueceu o PIN',
    LoginText.useBiometric: 'Ativar biometria',
    LoginText.incorrectPin: 'PIN incorreto',
    LoginText.pinCodeRequired: 'Por favor, insira todos os 6 dígitos',
    LoginText.resetApp: 'Redefinir aplicativo',
    LoginText.confirmReset: 'Confirmar redefinição',
    LoginText.resetWarning:
        'Aviso: Redefinir o aplicativo excluirá todos os seus dados. Tem certeza de que deseja continuar?',
    LoginText.enterAnyPin: 'Digite qualquer PIN',
    LoginText.backupNote:
        'Este PIN será usado para criptografar arquivos, lembre-se dele para recuperação de dados.',
    LoginText.changePinCode: 'Alterar PIN',
    LoginText.loginLockDescription:
        'A conta foi bloqueada devido a muitas tentativas de senha incorretas',
    LoginText.pleaseTryAgainLater: 'Por favor, tente novamente após {0} minutos',
    LoginText.restoreNote: 'Digite o PIN de backup para restaurar os dados.',
  };

  @override
  Map<String, String> get hi => {
    LoginText.enterPin: 'पिन दर्ज करें',
    LoginText.forgotPin: 'पिन भूल गए',
    LoginText.useBiometric: 'बायोमेट्रिक सक्षम करें',
    LoginText.incorrectPin: 'गलत पिन',
    LoginText.pinCodeRequired: 'कृपया सभी 6 अंक दर्ज करें',
    LoginText.resetApp: 'ऐप रीसेट करें',
    LoginText.confirmReset: 'रीसेट की पुष्टि करें',
    LoginText.resetWarning:
        'चेतावनी: ऐप को रीसेट करने से आपका सारा डेटा हट जाएगा। क्या आप वाकई जारी रखना चाहते हैं?',
    LoginText.enterAnyPin: 'कोई भी पिन दर्ज करें',
    LoginText.backupNote:
        'यह पिन फाइलों को एन्क्रिप्ट करने के लिए उपयोग किया जाएगा, कृपया डेटा पुनर्स्थापना के लिए इसे याद रखें।',
    LoginText.changePinCode: 'पिन बदलें',
    LoginText.loginLockDescription: 'बहुत बार गलत पासवर्ड डालने के कारण खाता लॉक हो गया है',
    LoginText.pleaseTryAgainLater: '{0} मिनट बाद पुनः प्रयास करें',
    LoginText.restoreNote: 'डेटा पुनर्स्थापना के लिए बैकअप पिन दर्ज करें।',
  };

  @override
  Map<String, String> get ja => {
    LoginText.enterPin: 'PINを入力',
    LoginText.forgotPin: 'PINを忘れた',
    LoginText.useBiometric: '生体認証を有効にする',
    LoginText.incorrectPin: 'PINが正しくありません',
    LoginText.pinCodeRequired: '6桁すべてを入力してください',
    LoginText.resetApp: 'アプリをリセット',
    LoginText.confirmReset: 'リセットを確認',
    LoginText.resetWarning: '警告：アプリをリセットするとすべてのデータが削除されます。本当に続行しますか？',
    LoginText.enterAnyPin: '任意のPINを入力',
    LoginText.backupNote: 'このPINはファイルの暗号化に使われます。データ復元のために必ず覚えておいてください。',
    LoginText.changePinCode: 'PINを変更',
    LoginText.loginLockDescription: 'パスワードを何度も間違えたためアカウントがロックされました',
    LoginText.pleaseTryAgainLater: '{0}分後にもう一度お試しください',
    LoginText.restoreNote: 'データを復元するにはバックアップPINを入力してください。',
  };

  @override
  Map<String, String> get ru => {
    LoginText.enterPin: 'Введите PIN',
    LoginText.forgotPin: 'Забыли PIN',
    LoginText.useBiometric: 'Включить биометрию',
    LoginText.incorrectPin: 'Неверный PIN',
    LoginText.pinCodeRequired: 'Пожалуйста, введите все 6 цифр',
    LoginText.resetApp: 'Сбросить приложение',
    LoginText.confirmReset: 'Подтвердить сброс',
    LoginText.resetWarning:
        'Внимание: сброс приложения удалит все ваши данные. Вы уверены, что хотите продолжить?',
    LoginText.enterAnyPin: 'Введите любой PIN',
    LoginText.backupNote:
        'Этот PIN будет использоваться для шифрования файлов, пожалуйста, запомните его для восстановления данных.',
    LoginText.changePinCode: 'Изменить PIN',
    LoginText.loginLockDescription:
        'Аккаунт заблокирован из-за слишком большого количества неверных попыток ввода пароля',
    LoginText.pleaseTryAgainLater: 'Пожалуйста, попробуйте снова через {0} минут',
    LoginText.restoreNote: 'Введите PIN для восстановления данных.',
  };

  @override
  Map<String, String> get id => {
    LoginText.enterPin: 'Masukkan PIN',
    LoginText.forgotPin: 'Lupa PIN',
    LoginText.useBiometric: 'Aktifkan biometrik',
    LoginText.incorrectPin: 'PIN salah',
    LoginText.pinCodeRequired: 'Masukkan 6 digit PIN',
    LoginText.resetApp: 'Reset aplikasi',
    LoginText.confirmReset: 'Konfirmasi reset',
    LoginText.resetWarning:
        'Peringatan: Mereset aplikasi akan menghapus semua data Anda. Apakah Anda yakin ingin melanjutkan?',
    LoginText.enterAnyPin: 'Masukkan PIN apa saja',
    LoginText.backupNote:
        'PIN ini akan digunakan untuk mengenkripsi file, harap diingat untuk pemulihan data.',
    LoginText.changePinCode: 'Ubah PIN',
    LoginText.loginLockDescription:
        'Akun telah dikunci karena terlalu banyak percobaan kata sandi yang salah',
    LoginText.pleaseTryAgainLater: 'Silakan coba lagi setelah {0} menit',
    LoginText.restoreNote: 'Masukkan PIN cadangan untuk memulihkan data.',
  };

  @override
  Map<String, String> get tr => {
    LoginText.enterPin: 'PIN Gir',
    LoginText.forgotPin: 'PIN Unut',
    LoginText.useBiometric: 'Biyometriği Etkinleştir',
    LoginText.incorrectPin: 'Yanlış PIN',
    LoginText.pinCodeRequired: 'Lütfen 6 haneli PIN girin',
    LoginText.resetApp: 'Uygulamayı Sıfırla',
    LoginText.confirmReset: 'Sıfırlamayı Onayla',
    LoginText.resetWarning:
        'Uyarı: Uygulamayı sıfırlamak tüm verilerinizi silecektir. Devam etmek istediğinizden emin misiniz?',
    LoginText.enterAnyPin: 'Herhangi bir PIN girin',
    LoginText.backupNote:
        'Bu PIN dosyaları şifrelemek için kullanılacak, lütfen veri kurtarma için hatırlayın.',
    LoginText.changePinCode: 'PIN Değiştir',
    LoginText.loginLockDescription: 'Çok fazla yanlış şifre denemesi nedeniyle hesap kilitlendi',
    LoginText.pleaseTryAgainLater: '{0} dakika sonra tekrar deneyin',
    LoginText.restoreNote: 'Verileri geri yüklemek için yedek PIN girin.',

    LoginText.createPinCode: 'PIN Oluştur',
    LoginText.confirmPinCode: 'PIN Doğrula',
    LoginText.pinCodeNotMatch: 'PINler eşleşmiyor',
  };

  @override
  // TODO: implement es
  Map<String, String> get es => {
    LoginText.enterPin: 'Introducir PIN',
    LoginText.forgotPin: '¿Olvidaste el PIN?',
    LoginText.useBiometric: 'Activar biometría',
    LoginText.incorrectPin: 'PIN incorrecto',
    LoginText.pinCodeRequired: 'Por favor, introduce los 6 dígitos',
    LoginText.resetApp: 'Restablecer aplicación',
    LoginText.confirmReset: 'Confirmar restablecimiento',
    LoginText.resetWarning:
        'Advertencia: Restablecer la aplicación eliminará todos tus datos. ¿Estás seguro de que deseas continuar?',
    LoginText.enterAnyPin: 'Introduce cualquier PIN',
    LoginText.backupNote:
        'Este PIN se usará para cifrar los archivos, por favor recuérdalo para recuperar los datos.',
    LoginText.changePinCode: 'Cambiar PIN',
    LoginText.loginLockDescription:
        'La cuenta ha sido bloqueada por demasiados intentos fallidos de contraseña',
    LoginText.pleaseTryAgainLater: 'Por favor, inténtalo de nuevo después de {0} minutos',
    LoginText.restoreNote: 'Introduce el PIN de respaldo para restaurar los datos.',
  };
}
