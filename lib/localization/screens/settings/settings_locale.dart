import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';

class SettingsLocale extends BaseLocale {
  final AppLocale appLocale;

  SettingsLocale(this.appLocale);

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

  static const String settings = 'settings';
  static const String general = 'general';
  static const String security = 'security';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String darkMode = 'dark_mode';
  static const String biometric = 'biometric';
  static const String autoLock = 'auto_lock';
  static const String changePin = 'change_pin';
  static const String backup = 'backup';
  static const String restore = 'restore';
  static const String about = 'about';
  static const String chooseLanguage = 'choose_language';
  static const String importDataFromBrowser = 'import_data_from_browser';
  static const String backupData = 'backup_data';
  static const String deleteData = 'delete_data';
  static const String deleteDataConfirmation = 'delete_data_confirmation';
  static const String confirm = 'confirm';
  static const String lockOnBackground = 'lock_on_background';
  static const String dataIsEmpty = 'data_is_empty';

  static const String deleteDataQuestion = 'delete_data_question';
  static const String cancel = 'cancel';

  @override
  Map<String, String> get vi => {
    settings: 'Cài đặt',
    general: 'Cài đặt chung',
    security: 'Bảo mật',
    language: 'Ngôn ngữ',
    theme: 'Giao diện',
    darkMode: 'Chế độ tối',
    biometric: 'Sinh trắc học',
    autoLock: 'Tự động khóa',
    changePin: 'Đổi mã PIN',
    backup: 'Sao lưu',
    restore: 'Khôi phục',
    about: 'Thông tin',
    chooseLanguage: 'Chọn ngôn ngữ',
    importDataFromBrowser: 'Nhập dữ liệu từ trình duyệt',
    backupData: 'Sao lưu dữ liệu',
    deleteData: 'Xóa dữ liệu',
    deleteDataConfirmation: 'Xác nhận xóa dữ liệu',
    confirm: 'Xác nhận',
    lockOnBackground: 'Khóa khi ứng dụng ở nền',
    dataIsEmpty: 'Dữ liệu trống',
    deleteDataQuestion: 'Bạn có chắc chắn muốn xóa tất cả dữ liệu?',
  };

  @override
  Map<String, String> get en_GB => {
    settings: 'Settings',
    general: 'General',
    security: 'Security',
    language: 'Language',
    theme: 'Theme',
    darkMode: 'Dark Mode',
    biometric: 'Biometric',
    autoLock: 'Auto Lock',
    changePin: 'Change PIN',
    backup: 'Backup',
    restore: 'Restore',
    about: 'About',
    chooseLanguage: 'Choose Language',
    importDataFromBrowser: 'Import Data From Browser',
    backupData: 'Backup Data',
    deleteData: 'Delete Data',
    deleteDataConfirmation: 'Delete Data Confirmation',
    confirm: 'Confirm',
    lockOnBackground: 'Lock on Background',
    dataIsEmpty: 'Data is empty',
    deleteDataQuestion: 'Are you sure you want to delete all data?',
  };

  @override
  Map<String, String> get en_US => {
    settings: 'Settings',
    general: 'General',
    security: 'Security',
    language: 'Language',
    theme: 'Theme',
    darkMode: 'Dark Mode',
    biometric: 'Biometric',
    autoLock: 'Auto Lock',
    changePin: 'Change PIN',
    backup: 'Backup',
    restore: 'Restore',
    about: 'About',
    chooseLanguage: 'Choose Language',
    importDataFromBrowser: 'Import Data From Browser',
    backupData: 'Backup Data',
    deleteData: 'Delete Data',
    deleteDataConfirmation: 'Delete Data Confirmation',
    confirm: 'Confirm',
    lockOnBackground: 'Lock on Background',
    dataIsEmpty: 'Data is empty',
  };

  // Thêm các bản dịch cho các ngôn ngữ khác tương tự
  @override
  Map<String, String> get pt_PT => {
    settings: 'Configurações',
    general: 'Geral',
    security: 'Segurança',
    language: 'Idioma',
    theme: 'Tema',
    darkMode: 'Modo Escuro',
    biometric: 'Biométrico',
    autoLock: 'Bloquear automaticamente',
    changePin: 'Alterar PIN',
    backup: 'Cópia de segurança',
    restore: 'Restaurar',
    about: 'Sobre',
    chooseLanguage: 'Escolher Idioma',
    importDataFromBrowser: 'Importar Dados do Navegador',
    backupData: 'Cópia de segurança de dados',
    deleteData: 'Apagar dados',
    deleteDataConfirmation: 'Confirmação de apagar dados',
    confirm: 'Confirmar',
    lockOnBackground: 'Bloquear quando o aplicativo está em segundo plano',
    dataIsEmpty: 'Dados vazios',
    deleteDataQuestion: 'Tem certeza que deseja apagar todos os dados?',
  };
  @override
  Map<String, String> get pt_BR => {
    settings: 'Configurações',
    general: 'Geral',
    security: 'Segurança',
    language: 'Idioma',
    theme: 'Tema',
    darkMode: 'Modo Escuro',
    biometric: 'Biométrico',
    autoLock: 'Bloquear automaticamente',
    changePin: 'Alterar PIN',
    backup: 'Cópia de segurança',
    restore: 'Restaurar',
    about: 'Sobre',
    chooseLanguage: 'Escolher Idioma',
    importDataFromBrowser: 'Importar Dados do Navegador',
    backupData: 'Cópia de segurança de dados',
    deleteData: 'Apagar dados',
    deleteDataConfirmation: 'Confirmação de apagar dados',
    confirm: 'Confirmar',
    lockOnBackground: 'Bloquear quando o aplicativo está em segundo plano',
    dataIsEmpty: 'Dados vazios',
    deleteDataQuestion: 'Tem certeza que deseja apagar todos os dados?',
  };
  @override
  Map<String, String> get hi => {
    settings: 'सेटिंग्स',
    general: 'सामान्य',
    security: 'सुरक्षा',
    language: 'भाषा',
    theme: 'थीम',
    darkMode: 'डार्क मोड',
    biometric: 'बाइयोमेट्रिक',
    autoLock: 'स्वतः लॉक',
    changePin: 'पिन बदलें',
    backup: 'बैकअप',
    restore: 'पुनर्स्थापित करें',
    about: 'बारे में',
    chooseLanguage: 'भाषा चुनें',
    importDataFromBrowser: 'ब्राउज़र से डेटा आयात करें',
    backupData: 'डेटा बैकअप करें',
    deleteData: 'डेटा हटाएं',
    deleteDataConfirmation: 'डेटा हटाने की पुष्टि',
    confirm: 'सुनिश्चित करें',
    lockOnBackground: 'पृष्ठभूमि पर अनलॉक करें',
    dataIsEmpty: 'डेटा खाली है',
    deleteDataQuestion: 'क्या आप सुनिश्चित हैं कि आप सभी डेटा हटाना चाहते हैं?',
  };
  @override
  Map<String, String> get ja => {
    settings: '設定',
    general: '一般',
    security: 'セキュリティ',
    language: '言語',
    theme: 'テーマ',
    darkMode: 'ダークモード',
    biometric: 'バイオメトリック',
    autoLock: '自動ロック',
    changePin: 'ピン変更',
    backup: 'バックアップ',
    restore: '復元',
    about: 'について',
    chooseLanguage: '言語を選択',
    importDataFromBrowser: 'ブラウザからデータをインポート',
    backupData: 'データのバックアップ',
    deleteData: 'データを削除',
    deleteDataConfirmation: 'データを削除することを確認',
    confirm: '確認',
    lockOnBackground: 'バックグラウンドでアプリケーションをロック',
    dataIsEmpty: 'データが空です',
    deleteDataQuestion: '本当にすべてのデータを削除しますか？',
  };
  @override
  Map<String, String> get ru => {
    settings: 'Настройки',
    general: 'Общие',
    security: 'Безопасность',
    language: 'Язык',
    theme: 'Тема',
    darkMode: 'Темная тема',
    biometric: 'Биометрический',
    autoLock: 'Автоматический замок',
    changePin: 'Изменить PIN',
    backup: 'Резервная копия',
    restore: 'Восстановить',
    about: 'О',
    chooseLanguage: 'Выбрать язык',
    importDataFromBrowser: 'Импортировать данные из браузера',
    backupData: 'Резервная копия данных',
    deleteData: 'Удалить данные',
    deleteDataConfirmation: 'Подтверждение удаления данных',
    confirm: 'Подтвердить',
    lockOnBackground: 'Блокировать при фоновом режиме',
    dataIsEmpty: 'Данные пусты',
  };
  @override
  Map<String, String> get id => {
    settings: 'Pengaturan',
    general: 'Umum',
    security: 'Keamanan',
    language: 'Bahasa',
    theme: 'Tema',
    darkMode: 'Mode Gelap',
    biometric: 'Biometrik',
    autoLock: 'Auto Lock',
    changePin: 'Ubah PIN',
    backup: 'Backup',
    restore: 'Pulihkan',
    about: 'Tentang',
    chooseLanguage: 'Pilih Bahasa',
    importDataFromBrowser: 'Impor Data dari Browser',
    backupData: 'Backup Data',
    deleteData: 'Hapus Data',
    deleteDataConfirmation: 'Konfirmasi Hapus Data',
    confirm: 'Konfirmasi',
    lockOnBackground: 'Memblokir saat aplikasi berada di latar belakang',
    deleteDataQuestion: 'Apakah Anda yakin ingin menghapus semua data?',
  };

  @override
  Map<String, String> get en => {
    settings: 'Settings',
    general: 'General',
    security: 'Security',
    language: 'Language',
    theme: 'Theme',
    darkMode: 'Dark Mode',
    biometric: 'Biometric',
    autoLock: 'Auto Lock',
    changePin: 'Change PIN',
    backup: 'Backup',
    restore: 'Restore',
    about: 'About',
    chooseLanguage: 'Choose Language',
    importDataFromBrowser: 'Import Data From Browser',
    backupData: 'Backup Data',
    deleteData: 'Delete Data',
    deleteDataConfirmation: 'Delete Data Confirmation',
    confirm: 'Confirm',
    lockOnBackground: 'Lock on Background',
    dataIsEmpty: 'Data is empty',
    deleteDataQuestion: 'Are you sure you want to delete all data?',
  };

  @override
  Map<String, String> get pt => {
    settings: 'Configurações',
    general: 'Geral',
    security: 'Segurança',
    language: 'Idioma',
    theme: 'Tema',
    darkMode: 'Modo Escuro',
    biometric: 'Biométrico',
    autoLock: 'Bloquear automaticamente',
    changePin: 'Alterar PIN',
    backup: 'Cópia de segurança',
    restore: 'Restaurar',
    about: 'Sobre',
    chooseLanguage: 'Escolher Idioma',
    importDataFromBrowser: 'Importar Dados do Navegador',
    backupData: 'Cópia de segurança de dados',
    deleteData: 'Apagar dados',
    deleteDataConfirmation: 'Confirmação de apagar dados',
    confirm: 'Confirmar',
    lockOnBackground: 'Bloquear quando o aplicativo está em segundo plano',
    dataIsEmpty: 'Dados vazios',
    deleteDataQuestion: 'Tem certeza que deseja apagar todos os dados?',
  };
}
