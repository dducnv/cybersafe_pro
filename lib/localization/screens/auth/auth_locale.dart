import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
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
    LoginText.confirmExit: 'Xác nhận thoát',
    LoginText.confirmExitMessage:
        'Bạn có chắc chắn muốn thoát? Các thao tác đang thực hiện có thể bị gián đoạn.',
    LoginText.cancel: 'Hủy',
    LoginText.exit: 'Thoát',
  };

  @override
  Map<String, String> get en => {
    LoginText.createPinCode: 'Create PIN code',
    LoginText.confirmPinCode: 'Confirm PIN code',
    LoginText.pinCodeNotMatch: 'PIN codes do not match',
    LoginText.pinCodeRequired: 'Please enter all 6 digits',
    LoginText.enterPin: 'Enter PIN code',
    LoginText.enterAnyPin: 'Enter any PIN code',
    LoginText.backupNote: 'Please enter your PIN to confirm backup',
    LoginText.restoreNote: 'Please enter your PIN to confirm restore',
    LoginText.loginLockDescription: 'Account is locked',
    LoginText.pleaseTryAgainLater: 'Please try again in {0}',

    // Thêm các text đã dịch cho dialog xác nhận thoát
    LoginText.confirmExit: 'Confirm exit',
    LoginText.confirmExitMessage:
        'Are you sure you want to exit? Current operations may be interrupted.',
    LoginText.cancel: 'Cancel',
    LoginText.exit: 'Exit',
  };

  @override
  Map<String, String> get hi => {
    LoginText.createPinCode: 'PIN कोड बनाएं',
    LoginText.confirmPinCode: 'PIN कोड की पुष्टि करें',
    LoginText.pinCodeNotMatch: 'PIN कोड मेल नहीं खाते',
    LoginText.pinCodeRequired: 'कृपया सभी 6 अंक दर्ज करें',
    LoginText.enterPin: 'PIN कोड दर्ज करें',
    LoginText.enterAnyPin: 'कोई भी PIN कोड दर्ज करें',
    LoginText.backupNote: 'कृपया बैकअप की पुष्टि के लिए PIN दर्ज करें',
    LoginText.restoreNote: 'कृपया पुनर्स्थापना की पुष्टि के लिए PIN दर्ज करें',
    LoginText.loginLockDescription: 'खाता लॉक है',
    LoginText.pleaseTryAgainLater: 'कृपया {0} बाद पुनः प्रयास करें',
    LoginText.confirmExit: 'बाहर निकलने की पुष्टि करें',
    LoginText.confirmExitMessage:
        'क्या आप वाकई बाहर निकलना चाहते हैं? वर्तमान प्रक्रियाएं बाधित हो सकती हैं।',
    LoginText.cancel: 'रद्द करें',
    LoginText.exit: 'बाहर निकलें',
  };

  @override
  Map<String, String> get ja => {
    LoginText.createPinCode: 'PINコードを作成',
    LoginText.confirmPinCode: 'PINコードを確認',
    LoginText.pinCodeNotMatch: 'PINコードが一致しません',
    LoginText.pinCodeRequired: '6桁すべてを入力してください',
    LoginText.enterPin: 'PINコードを入力',
    LoginText.enterAnyPin: '任意のPINコードを入力',
    LoginText.backupNote: 'バックアップを確認するにはPINコードを入力してください',
    LoginText.restoreNote: '復元を確認するにはPINコードを入力してください',
    LoginText.loginLockDescription: 'アカウントがロックされています',
    LoginText.pleaseTryAgainLater: '{0}後にもう一度お試しください',
    LoginText.confirmExit: '終了の確認',
    LoginText.confirmExitMessage: '本当に終了しますか？現在の操作が中断される可能性があります。',
    LoginText.cancel: 'キャンセル',
    LoginText.exit: '終了',
  };

  @override
  Map<String, String> get ru => {
    LoginText.createPinCode: 'Создать PIN-код',
    LoginText.confirmPinCode: 'Подтвердите PIN-код',
    LoginText.pinCodeNotMatch: 'PIN-коды не совпадают',
    LoginText.pinCodeRequired: 'Пожалуйста, введите все 6 цифр',
    LoginText.enterPin: 'Введите PIN-код',
    LoginText.enterAnyPin: 'Введите любой PIN-код',
    LoginText.backupNote: 'Пожалуйста, введите PIN-код для подтверждения резервного копирования',
    LoginText.restoreNote: 'Пожалуйста, введите PIN-код для подтверждения восстановления',
    LoginText.loginLockDescription: 'Аккаунт заблокирован',
    LoginText.pleaseTryAgainLater: 'Пожалуйста, попробуйте снова через {0}',
    LoginText.confirmExit: 'Подтвердить выход',
    LoginText.confirmExitMessage:
        'Вы уверены, что хотите выйти? Текущие операции могут быть прерваны.',
    LoginText.cancel: 'Отмена',
    LoginText.exit: 'Выйти',
  };

  @override
  Map<String, String> get id => {
    LoginText.createPinCode: 'Buat Kode PIN',
    LoginText.confirmPinCode: 'Konfirmasi Kode PIN',
    LoginText.pinCodeNotMatch: 'Kode PIN tidak cocok',
    LoginText.pinCodeRequired: 'Silakan masukkan semua 6 digit',
    LoginText.enterPin: 'Masukkan Kode PIN',
    LoginText.enterAnyPin: 'Masukkan Kode PIN apa saja',
    LoginText.backupNote: 'Silakan masukkan PIN untuk konfirmasi backup',
    LoginText.restoreNote: 'Silakan masukkan PIN untuk konfirmasi pemulihan',
    LoginText.loginLockDescription: 'Akun terkunci',
    LoginText.pleaseTryAgainLater: 'Silakan coba lagi dalam {0}',
    LoginText.confirmExit: 'Konfirmasi Keluar',
    LoginText.confirmExitMessage:
        'Apakah Anda yakin ingin keluar? Proses yang sedang berjalan mungkin akan terganggu.',
    LoginText.cancel: 'Batal',
    LoginText.exit: 'Keluar',
  };

  @override
  Map<String, String> get pt => {
    LoginText.createPinCode: 'Criar código PIN',
    LoginText.confirmPinCode: 'Confirmar código PIN',
    LoginText.pinCodeNotMatch: 'Os códigos PIN não coincidem',
    LoginText.pinCodeRequired: 'Por favor, insira todos os 6 dígitos',
    LoginText.enterPin: 'Digite o código PIN',
    LoginText.enterAnyPin: 'Digite qualquer código PIN',
    LoginText.backupNote: 'Por favor, insira o PIN para confirmar o backup',
    LoginText.restoreNote: 'Por favor, insira o PIN para confirmar a restauração',
    LoginText.loginLockDescription: 'Conta bloqueada',
    LoginText.pleaseTryAgainLater: 'Por favor, tente novamente em {0}',
    LoginText.confirmExit: 'Confirmar saída',
    LoginText.confirmExitMessage:
        'Tem certeza de que deseja sair? As operações em andamento podem ser interrompidas.',
    LoginText.cancel: 'Cancelar',
    LoginText.exit: 'Sair',
  };

  @override
  Map<String, String> get tr => {
    LoginText.createPinCode: 'PIN Kodu Oluştur',
    LoginText.confirmPinCode: 'PIN Kodunu Onayla',
    LoginText.pinCodeNotMatch: 'PIN kodları eşleşmiyor',
    LoginText.pinCodeRequired: 'Lütfen tüm 6 haneyi girin',
    LoginText.enterPin: 'PIN kodunu girin',
    LoginText.enterAnyPin: 'Herhangi bir PIN kodu girin',
    LoginText.backupNote: 'Yedeklemeyi onaylamak için lütfen PIN kodunu girin',
    LoginText.restoreNote: 'Geri yüklemeyi onaylamak için lütfen PIN kodunu girin',
    LoginText.loginLockDescription: 'Hesap kilitlendi',
    LoginText.pleaseTryAgainLater: 'Lütfen {0} sonra tekrar deneyin',
    LoginText.confirmExit: 'Çıkışı Onayla',
    LoginText.confirmExitMessage:
        'Çıkmak istediğinizden emin misiniz? Mevcut işlemler kesintiye uğrayabilir.',
    LoginText.cancel: 'İptal',
    LoginText.exit: 'Çıkış',
  };

  @override
  Map<String, String> get pt_PT => {
    LoginText.createPinCode: 'Criar código PIN',
    LoginText.confirmPinCode: 'Confirmar código PIN',
    LoginText.pinCodeNotMatch: 'Os códigos PIN não coincidem',
    LoginText.pinCodeRequired: 'Por favor, insira todos os 6 dígitos',
    LoginText.enterPin: 'Digite o código PIN',
    LoginText.enterAnyPin: 'Digite qualquer código PIN',
    LoginText.backupNote: 'Por favor, insira o PIN para confirmar o backup',
    LoginText.restoreNote: 'Por favor, insira o PIN para confirmar a restauração',
    LoginText.loginLockDescription: 'Conta bloqueada',
    LoginText.pleaseTryAgainLater: 'Por favor, tente novamente em {0}',
    LoginText.confirmExit: 'Confirmar saída',
    LoginText.confirmExitMessage:
        'Tem certeza de que deseja sair? As operações em andamento podem ser interrompidas.',
    LoginText.cancel: 'Cancelar',
    LoginText.exit: 'Sair',
  };

  @override
  // TODO: implement es
  Map<String, String> get es => {
    LoginText.createPinCode: 'Crear código PIN',
    LoginText.confirmPinCode: 'Confirmar código PIN',
    LoginText.pinCodeNotMatch: 'Los códigos PIN no coinciden',
    LoginText.pinCodeRequired: 'Por favor, introduce los 6 dígitos',
    LoginText.enterPin: 'Introducir código PIN',
    LoginText.enterAnyPin: 'Introducir cualquier código PIN',
    LoginText.backupNote: 'Por favor, introduce tu PIN para confirmar la copia de seguridad',
    LoginText.restoreNote: 'Por favor, introduce tu PIN para confirmar la restauración',
    LoginText.loginLockDescription: 'La cuenta está bloqueada',
    LoginText.pleaseTryAgainLater: 'Por favor, inténtalo de nuevo en {0}',

    // Textos para el diálogo de confirmación de salida
    LoginText.confirmExit: 'Confirmar salida',
    LoginText.confirmExitMessage:
        '¿Estás seguro de que deseas salir? Las operaciones actuales podrían interrumpirse.',
    LoginText.cancel: 'Cancelar',
    LoginText.exit: 'Salir',
  };
}
