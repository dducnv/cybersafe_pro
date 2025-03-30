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
    LoginText.resetApp: 'Đặt lại ứng dụng',
    LoginText.confirmReset: 'Xác nhận đặt lại',
    LoginText.resetWarning: 'Cảnh báo: Đặt lại ứng dụng sẽ xóa tất cả dữ liệu của bạn. Bạn có chắc chắn muốn tiếp tục?',
  };

  @override
  Map<String, String> get en => {
    LoginText.enterPin: 'Enter PIN',
    LoginText.forgotPin: 'Forgot PIN',
    LoginText.useBiometric: 'Use biometric',
    LoginText.incorrectPin: 'Incorrect PIN',
    LoginText.resetApp: 'Reset app',
    LoginText.confirmReset: 'Confirm reset',
    LoginText.resetWarning: 'Warning: Resetting the app will delete all your data. Are you sure you want to continue?',
  };

  @override
  Map<String, String> get pt => {
    LoginText.enterPin: 'Digite o PIN',
    LoginText.forgotPin: 'Esqueceu o PIN',
    LoginText.useBiometric: 'Usar biometria',
    LoginText.incorrectPin: 'PIN incorreto',
    LoginText.resetApp: 'Redefinir aplicativo',
    LoginText.confirmReset: 'Confirmar redefinição',
    LoginText.resetWarning: 'Aviso: Redefinir o aplicativo excluirá todos os seus dados. Tem certeza de que deseja continuar?',
  };

  @override
  Map<String, String> get hi => {
    LoginText.enterPin: 'पिन दर्ज करें',
    LoginText.forgotPin: 'पिन भूल गए',
    LoginText.useBiometric: 'बायोमेट्रिक का उपयोग करें',
    LoginText.incorrectPin: 'गलत पिन',
    LoginText.resetApp: 'ऐप रीसेट करें',
    LoginText.confirmReset: 'रीसेट की पुष्टि करें',
    LoginText.resetWarning: 'चेतावनी: ऐप को रीसेट करने से आपका सभी डेटा हट जाएगा। क्या आप वाकई जारी रखना चाहते हैं?',
  };

  @override
  Map<String, String> get ja => {
    LoginText.enterPin: 'PINを入力',
    LoginText.forgotPin: 'PINを忘れた',
    LoginText.useBiometric: '生体認証を使用',
    LoginText.incorrectPin: '不正なPIN',
    LoginText.resetApp: 'アプリをリセット',
    LoginText.confirmReset: 'リセットを確認',
    LoginText.resetWarning: '警告：アプリをリセットするとすべてのデータが削除されます。続行しますか？',
  };

  @override
  Map<String, String> get ru => {
    LoginText.enterPin: 'Введите PIN',
    LoginText.forgotPin: 'Забыли PIN',
    LoginText.useBiometric: 'Использовать биометрию',
    LoginText.incorrectPin: 'Неверный PIN',
    LoginText.resetApp: 'Сбросить приложение',
    LoginText.confirmReset: 'Подтвердите сброс',
    LoginText.resetWarning: 'Предупреждение: Сброс приложения удалит все ваши данные. Вы уверены, что хотите продолжить?',
  };

  @override
  Map<String, String> get id => {
    LoginText.enterPin: 'Masukkan PIN',
    LoginText.forgotPin: 'Lupa PIN',
    LoginText.useBiometric: 'Gunakan biometrik',
    LoginText.incorrectPin: 'PIN salah',
    LoginText.resetApp: 'Reset aplikasi',
    LoginText.confirmReset: 'Konfirmasi reset',
    LoginText.resetWarning: 'Peringatan: Mereset aplikasi akan menghapus semua data Anda. Apakah Anda yakin ingin melanjutkan?',
  };
} 