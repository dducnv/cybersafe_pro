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

  static const String transferData = 'transfer_data';
  static const String transferDataMessage = 'transfer_data_message';


  static const String appIsNotInstalled = 'app_is_not_installed';
  static const String appIsNotInstalledMessage = 'app_is_not_installed_message';
  static const String installNow = 'install_now';

  static const String receiveData = 'receive_data';
  static const String receiveDataMessage = 'receive_data_message';

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
    cancel: 'Hủy',
    appIsNotInstalled: 'Ứng dụng chưa được cài đặt',
    appIsNotInstalledMessage: 'Hãy cài đặt ứng dụng trước khi chuyển dữ liệu?',
    installNow: 'Cài đặt ngay',
    transferData: 'Chuyển dữ liệu sang bản Pro',
    transferDataMessage: 'Bạn có chắc chắn muốn chuyển dữ liệu từ Lite sang Pro?',

    receiveData: 'Nhận dữ liệu',
    receiveDataMessage: 'Để tiếp tục nhận dữ liệu từ bản Lite, vui lòng chọn file để thêm dữ liệu vào bản Pro!',
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
    cancel: 'Cancel',
    appIsNotInstalled: 'App is not installed',
    appIsNotInstalledMessage: 'Please install the app before transferring data?',
    installNow: 'Install Now',
    transferData: 'Transfer data to Pro version',
    transferDataMessage: 'Do you want to transfer data from Lite to Pro?',

    receiveData: 'Receive data',
    receiveDataMessage: 'To continue receiving data from the Lite version, please select a file to add data to the Pro version!',
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
    deleteDataQuestion: 'Are you sure you want to delete all data?',
    cancel: 'Cancel',
    appIsNotInstalled: 'App is not installed',
    appIsNotInstalledMessage: 'Please install the app before transferring data?',
    installNow: 'Install Now',
    transferData: 'Transfer data to Pro version',
    transferDataMessage: 'Do you want to transfer data from Lite to Pro?',

    receiveData: 'Receive data',
    receiveDataMessage: 'To continue receiving data from the Lite version, please select a file to add data to the Pro version!',
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
    cancel: 'Cancelar',
    appIsNotInstalled: 'Aplicativo não instalado',
    appIsNotInstalledMessage: 'Por favor, instale o aplicativo antes de transferir os dados?',
    installNow: 'Instalar agora',
    transferData: 'Transferir dados para a versão Pro',
    transferDataMessage: 'Você deseja transferir dados do Lite para o Pro?',

    receiveData: 'Receber dados',
    receiveDataMessage: 'Para continuar recebendo dados da versão Lite, por favor selecione um arquivo para adicionar dados à versão Pro!',
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
    cancel: 'Cancelar',
    appIsNotInstalled: 'Aplicativo não instalado',
    appIsNotInstalledMessage: 'Por favor, instale o aplicativo antes de transferir os dados?',
    installNow: 'Instalar agora',
    transferData: 'Transferir dados para a versão Pro',
    transferDataMessage: 'Você deseja transferir dados do Lite para o Pro?',

    receiveData: 'Receber dados',
    receiveDataMessage: 'Para continuar recebendo dados da versão Lite, por favor selecione um arquivo para adicionar dados à versão Pro!',
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
    cancel: 'रद्द करें',
    appIsNotInstalled: 'ऐप इंस्टॉल नहीं है',
    appIsNotInstalledMessage: 'कृपया डेटा स्थानांतरित करने से पहले ऐप इंस्टॉल करें?',
    installNow: 'अब इंस्टॉल करें',
    transferData: 'डेटा स्थानांतरित करें बाइट से प्रो में',
    transferDataMessage: 'क्या आप डेटा को Lite से Pro में स्थानांतरित करना चाहते हैं?',

    receiveData: 'डेटा प्राप्त करें',
    receiveDataMessage: 'बाइट से प्रो में डेटा प्राप्त करने के लिए, कृपया एक फ़ाइल चुनें जो डेटा जोड़ें!',
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
    cancel: 'キャンセル',
    appIsNotInstalled: 'アプリがインストールされていません',
    appIsNotInstalledMessage: 'データを転送する前にアプリをインストールしてください？',
    installNow: '今すぐインストール',
    transferData: 'データを転送',
    transferDataMessage: 'LiteからProにデータを転送',

    receiveData: 'データを受け取る',
    receiveDataMessage: 'Liteのバージョンから継続してデータを受け取るには、データをProバージョンに追加するためにファイルを選択してください！',
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
    deleteDataQuestion: 'Вы уверены, что хотите удалить все данные?',
    cancel: 'Отмена',
    appIsNotInstalled: 'Приложение не установлено',
    appIsNotInstalledMessage: 'Пожалуйста, установите приложение перед передачей данных?',
    installNow: 'Установить сейчас',
    transferData: 'Передать данные в Pro-версию',
    transferDataMessage: 'Передача данных из Lite в Pro',

    receiveData: 'Получить данные',
    receiveDataMessage: 'Для продолжения получения данных из Lite-версии, пожалуйста, выберите файл для добавления данных в Pro-версию!',
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
    cancel: 'Batalkan',
    appIsNotInstalled: 'Aplikasi tidak terpasang',
    appIsNotInstalledMessage: 'Silakan instal aplikasi sebelum mentransfer data?',
    installNow: 'Instal Sekarang',
    transferData: "Transfer data ke versi Pro",
    transferDataMessage: 'Do you want to transfer data from Lite to Pro?',

    receiveData: 'Menerima data',
    receiveDataMessage: 'Untuk melanjutkan menerima data dari Lite, silakan pilih file untuk menambahkan data ke versi Pro!',
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
    cancel: 'Cancel',
    appIsNotInstalled: 'App is not installed',
    appIsNotInstalledMessage: 'Please install the app before transferring data?',
    installNow: 'Install Now',
    transferData: 'Transfer data to Pro version',
    transferDataMessage: 'Do you want to transfer data from Lite to Pro?',

    receiveData: 'Receive data',
    receiveDataMessage: 'To continue receiving data from the Lite version, please select a file to add data to the Pro version!',
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
    cancel: 'Cancelar',
    appIsNotInstalled: 'Aplicativo não instalado',
    appIsNotInstalledMessage: 'Por favor, instale o aplicativo antes de transferir os dados?',
    installNow: 'Instalar agora',
    transferData: 'Transferir dados para a versão Pro',
    transferDataMessage: 'Você deseja transferir dados do Lite para o Pro?',

    receiveData: 'Receber dados',
    receiveDataMessage: 'Para continuar recebendo dados da versão Lite, por favor selecione um arquivo para adicionar dados à versão Pro!',
  };
}
