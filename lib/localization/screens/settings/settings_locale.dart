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

  static const String waitingNotification = 'waiting_notification';
  static const String decryptingData = 'decrypting_data';

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
    backup: 'Quản lý dữ liệu',
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
    appIsNotInstalledMessage: 'Hãy cài đặt ứng dụng trước khi chuyển dữ liệu!',
    installNow: 'Cài đặt ngay',
    transferData: 'Chuyển dữ liệu sang bản Pro',
    transferDataMessage: 'Bạn có chắc chắn muốn chuyển dữ liệu từ Lite sang Pro?',

    receiveData: 'Nhận dữ liệu',
    receiveDataMessage:
        'Để tiếp tục nhận dữ liệu từ bản Lite, vui lòng chọn file để thêm dữ liệu vào bản Pro!',

    waitingNotification: "Vui lòng đợi, quá trình có thể mất vài phút",
    decryptingData: "Đang giải mã dữ liệu...",
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
    receiveDataMessage:
        'To continue receiving data from the Lite version, please select a file to add data to the Pro version!',
    waitingNotification: "Please wait, the process may take a few minutes",
    decryptingData: "Decrypting data...",
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
    receiveDataMessage:
        'To continue receiving data from the Lite version, please select a file to add data to the Pro version!',
    waitingNotification: "Please wait, the process may take a few minutes",
    decryptingData: "Decrypting data...",
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
    receiveDataMessage:
        'Para continuar recebendo dados da versão Lite, por favor selecione um arquivo para adicionar dados à versão Pro!',
    waitingNotification: "Por favor, aguarde, o processo pode levar alguns minutos",
    decryptingData: "Descriptografando dados...",
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
    receiveDataMessage:
        'Para continuar recebendo dados da versão Lite, por favor selecione um arquivo para adicionar dados à versão Pro!',
    waitingNotification: "Por favor, aguarde, o processo pode levar alguns minutos",
    decryptingData: "Descriptografando dados...",
  };
  @override
  Map<String, String> get hi => {
    settings: 'सेटिंग्स',
    general: 'सामान्य सेटिंग्स',
    security: 'सुरक्षा',
    language: 'भाषा',
    theme: 'थीम',
    darkMode: 'डार्क मोड',
    biometric: 'बायोमेट्रिक',
    autoLock: 'स्वतः लॉक',
    changePin: 'पिन बदलें',
    backup: 'डेटा प्रबंधन',
    restore: 'पुनर्स्थापित करें',
    about: 'बारे में',
    chooseLanguage: 'भाषा चुनें',
    importDataFromBrowser: 'ब्राउज़र से डेटा आयात करें',
    backupData: 'डेटा का बैकअप लें',
    deleteData: 'डेटा हटाएं',
    deleteDataConfirmation: 'डेटा हटाने की पुष्टि',
    confirm: 'पुष्टि करें',
    lockOnBackground: 'ऐप बैकग्राउंड में हो तो लॉक करें',
    dataIsEmpty: 'डेटा खाली है',
    deleteDataQuestion: 'क्या आप वाकई सभी डेटा हटाना चाहते हैं?',
    cancel: 'रद्द करें',
    appIsNotInstalled: 'ऐप इंस्टॉल नहीं है',
    appIsNotInstalledMessage: 'कृपया डेटा ट्रांसफर से पहले ऐप इंस्टॉल करें!',
    installNow: 'अब इंस्टॉल करें',
    transferData: 'डेटा Pro में ट्रांसफर करें',
    transferDataMessage: 'क्या आप वाकई Lite से Pro में डेटा ट्रांसफर करना चाहते हैं?',
    receiveData: 'डेटा प्राप्त करें',
    receiveDataMessage:
        'Lite से डेटा प्राप्त करने के लिए, कृपया Pro में जोड़ने के लिए एक फ़ाइल चुनें!',
    waitingNotification: "कृपया प्रतीक्षा करें, प्रक्रिया कुछ मिनट ले सकती है",
    decryptingData: "डेटा डिक्रिप्ट कर रहा है...",
  };
  @override
  Map<String, String> get ja => {
    settings: '設定',
    general: '一般設定',
    security: 'セキュリティ',
    language: '言語',
    theme: 'テーマ',
    darkMode: 'ダークモード',
    biometric: 'バイオメトリクス',
    autoLock: '自動ロック',
    changePin: 'PINを変更',
    backup: 'データ管理',
    restore: '復元',
    about: '情報',
    chooseLanguage: '言語を選択',
    importDataFromBrowser: 'ブラウザからデータをインポート',
    backupData: 'データのバックアップ',
    deleteData: 'データを削除',
    deleteDataConfirmation: 'データ削除の確認',
    confirm: '確認',
    lockOnBackground: 'アプリがバックグラウンドの時ロック',
    dataIsEmpty: 'データが空です',
    deleteDataQuestion: '本当にすべてのデータを削除しますか？',
    cancel: 'キャンセル',
    appIsNotInstalled: 'アプリがインストールされていません',
    appIsNotInstalledMessage: 'データ転送の前にアプリをインストールしてください！',
    installNow: '今すぐインストール',
    transferData: 'データをProに転送',
    transferDataMessage: 'LiteからProにデータを転送しますか？',
    receiveData: 'データを受信',
    receiveDataMessage: 'Liteからデータを受信し続けるには、Proに追加するファイルを選択してください！',

    waitingNotification: "Please wait, the process may take a few minutes",
    decryptingData: "Decrypting data...",
  };
  @override
  Map<String, String> get ru => {
    settings: 'Настройки',
    general: 'Общие настройки',
    security: 'Безопасность',
    language: 'Язык',
    theme: 'Тема',
    darkMode: 'Темная тема',
    biometric: 'Биометрия',
    autoLock: 'Автоблокировка',
    changePin: 'Изменить PIN',
    backup: 'Управление данными',
    restore: 'Восстановить',
    about: 'О программе',
    chooseLanguage: 'Выбрать язык',
    importDataFromBrowser: 'Импортировать данные из браузера',
    backupData: 'Резервное копирование данных',
    deleteData: 'Удалить данные',
    deleteDataConfirmation: 'Подтверждение удаления данных',
    confirm: 'Подтвердить',
    lockOnBackground: 'Блокировать, когда приложение в фоне',
    dataIsEmpty: 'Данные отсутствуют',
    deleteDataQuestion: 'Вы уверены, что хотите удалить все данные?',
    cancel: 'Отмена',
    appIsNotInstalled: 'Приложение не установлено',
    appIsNotInstalledMessage: 'Пожалуйста, установите приложение перед передачей данных!',
    installNow: 'Установить сейчас',
    transferData: 'Передать данные в Pro',
    transferDataMessage: 'Вы уверены, что хотите передать данные из Lite в Pro?',
    receiveData: 'Получить данные',
    receiveDataMessage:
        'Чтобы продолжить получение данных из Lite, выберите файл для добавления данных в Pro!',
    waitingNotification: "Пожалуйста, подождите, процесс может занять несколько минут",
    decryptingData: "Расшифровка данных...",
  };
  @override
  Map<String, String> get id => {
    settings: 'Pengaturan',
    general: 'Pengaturan umum',
    security: 'Keamanan',
    language: 'Bahasa',
    theme: 'Tema',
    darkMode: 'Mode gelap',
    biometric: 'Biometrik',
    autoLock: 'Kunci otomatis',
    changePin: 'Ubah PIN',
    backup: 'Manajemen data',
    restore: 'Pulihkan',
    about: 'Tentang',
    chooseLanguage: 'Pilih bahasa',
    importDataFromBrowser: 'Impor data dari browser',
    backupData: 'Cadangkan data',
    deleteData: 'Hapus data',
    deleteDataConfirmation: 'Konfirmasi hapus data',
    confirm: 'Konfirmasi',
    lockOnBackground: 'Kunci saat aplikasi di latar belakang',
    dataIsEmpty: 'Data kosong',
    deleteDataQuestion: 'Apakah Anda yakin ingin menghapus semua data?',
    cancel: 'Batalkan',
    appIsNotInstalled: 'Aplikasi belum terpasang',
    appIsNotInstalledMessage: 'Silakan instal aplikasi sebelum mentransfer data!',
    installNow: 'Instal sekarang',
    transferData: 'Transfer data ke Pro',
    transferDataMessage: 'Apakah Anda yakin ingin mentransfer data dari Lite ke Pro?',
    receiveData: 'Terima data',
    receiveDataMessage:
        'Untuk terus menerima data dari Lite, silakan pilih file untuk menambahkan data ke Pro!',

    waitingNotification: "Silakan tunggu, proses mungkin memakan beberapa menit",
    decryptingData: "Menguraikan data...",
  };

  @override
  Map<String, String> get en => {
    settings: 'Settings',
    general: 'General settings',
    security: 'Security',
    language: 'Language',
    theme: 'Theme',
    darkMode: 'Dark mode',
    biometric: 'Biometric',
    autoLock: 'Auto lock',
    changePin: 'Change PIN',
    backup: 'Data management',
    restore: 'Restore',
    about: 'About',
    chooseLanguage: 'Choose language',
    importDataFromBrowser: 'Import data from browser',
    backupData: 'Backup data',
    deleteData: 'Delete data',
    deleteDataConfirmation: 'Delete data confirmation',
    confirm: 'Confirm',
    lockOnBackground: 'Lock when app is in background',
    dataIsEmpty: 'Data is empty',
    deleteDataQuestion: 'Are you sure you want to delete all data?',
    cancel: 'Cancel',
    appIsNotInstalled: 'App is not installed',
    appIsNotInstalledMessage: 'Please install the app before transferring data!',
    installNow: 'Install now',
    transferData: 'Transfer data to Pro version',
    transferDataMessage: 'Are you sure you want to transfer data from Lite to Pro?',
    receiveData: 'Receive data',
    receiveDataMessage:
        'To continue receiving data from Lite, please select a file to add data to Pro!',

    waitingNotification: "Please wait, the process may take a few minutes",
    decryptingData: "Decrypting data...",
  };

  @override
  Map<String, String> get pt => {
    settings: 'Configurações',
    general: 'Configurações gerais',
    security: 'Segurança',
    language: 'Idioma',
    theme: 'Tema',
    darkMode: 'Modo escuro',
    biometric: 'Biometria',
    autoLock: 'Bloqueio automático',
    changePin: 'Alterar PIN',
    backup: 'Gerenciamento de dados',
    restore: 'Restaurar',
    about: 'Sobre',
    chooseLanguage: 'Escolher idioma',
    importDataFromBrowser: 'Importar dados do navegador',
    backupData: 'Fazer backup dos dados',
    deleteData: 'Excluir dados',
    deleteDataConfirmation: 'Confirmação de exclusão de dados',
    confirm: 'Confirmar',
    lockOnBackground: 'Bloquear quando o app estiver em segundo plano',
    dataIsEmpty: 'Dados vazios',
    deleteDataQuestion: 'Tem certeza de que deseja excluir todos os dados?',
    cancel: 'Cancelar',
    appIsNotInstalled: 'Aplicativo não instalado',
    appIsNotInstalledMessage: 'Por favor, instale o aplicativo antes de transferir os dados!',
    installNow: 'Instalar agora',
    transferData: 'Transferir dados para o Pro',
    transferDataMessage: 'Você tem certeza que deseja transferir os dados do Lite para o Pro?',
    receiveData: 'Receber dados',
    receiveDataMessage:
        'Para continuar recebendo dados do Lite, selecione um arquivo para adicionar dados ao Pro!',

    waitingNotification: "Please wait, the process may take a few minutes",
    decryptingData: "Decrypting data...",
  };

  @override
  Map<String, String> get tr => {
    settings: 'Ayarlar',
    general: 'Genel ayarlar',
    security: 'Güvenlik',
    language: 'Dil',
    theme: 'Tema',
    darkMode: 'Koyu mod',
    biometric: 'Biyometrik',
    autoLock: 'Otomatik kilit',
    changePin: 'PIN değiştir',
    backup: 'Veri yönetimi',
    restore: 'Geri yükle',
    about: 'Hakkında',
    chooseLanguage: 'Dil seç',
    importDataFromBrowser: 'Tarayıcıdan veri içe aktar',
    backupData: 'Veri yedekle',
    deleteData: 'Veri sil',
    deleteDataConfirmation: 'Veri silme onayı',
    confirm: 'Onayla',
    lockOnBackground: 'Uygulama arka planda iken kilitle',
    dataIsEmpty: 'Veri yok',
    deleteDataQuestion: 'Tüm verileri silmek istediğinizden emin misiniz?',
    cancel: 'İptal',
    appIsNotInstalled: 'Uygulama yüklü değil',
    appIsNotInstalledMessage: 'Veri aktarmadan önce lütfen uygulamayı yükleyin!',
    installNow: 'Şimdi yükle',
    transferData: 'Verileri Pro sürüme aktar',
    transferDataMessage: "Lite'dan Pro'ya veri aktarmak istediğinizden emin misiniz?",
    receiveData: 'Veri al',
    receiveDataMessage:
        "Lite'dan veri almaya devam etmek için lütfen Pro'ya eklemek üzere bir dosya seçin!",

    waitingNotification: "Please wait, the process may take a few minutes",
    decryptingData: "Decrypting data...",
  };

  @override
  // TODO: implement es
  Map<String, String> get es => {
    settings: 'Configuración',
    general: 'General',
    security: 'Seguridad',
    language: 'Idioma',
    theme: 'Tema',
    darkMode: 'Modo oscuro',
    biometric: 'Biometría',
    autoLock: 'Bloqueo automático',
    changePin: 'Cambiar PIN',
    backup: 'Copia de seguridad',
    restore: 'Restaurar',
    about: 'Acerca de',
    chooseLanguage: 'Elegir idioma',
    importDataFromBrowser: 'Importar datos desde el navegador',
    backupData: 'Hacer copia de seguridad',
    deleteData: 'Eliminar datos',
    deleteDataConfirmation: 'Confirmación de eliminación de datos',
    confirm: 'Confirmar',
    lockOnBackground: 'Bloquear en segundo plano',
    dataIsEmpty: 'Los datos están vacíos',
    deleteDataQuestion: '¿Estás seguro de que deseas eliminar todos los datos?',
    cancel: 'Cancelar',
    appIsNotInstalled: 'La aplicación no está instalada',
    appIsNotInstalledMessage: '¿Por favor, instala la aplicación antes de transferir los datos?',
    installNow: 'Instalar ahora',
    transferData: 'Transferir datos a la versión Pro',
    transferDataMessage: '¿Deseas transferir los datos de la versión Lite a la versión Pro?',

    receiveData: 'Recibir datos',
    receiveDataMessage:
        'Para continuar recibiendo datos desde la versión Lite, ¡por favor selecciona un archivo para agregar los datos a la versión Pro!',

    waitingNotification: "Por favor, espere, el proceso puede tomar unos minutos",
    decryptingData: "Descifrando datos...",
  };

  @override
  Map<String, String> get it => {
    settings: 'Impostazioni',
    general: 'Generali',
    security: 'Sicurezza',
    language: 'Lingua',
    theme: 'Tema',
    darkMode: 'Modalità scura',
    biometric: 'Biometria',
    autoLock: 'Blocco automatico',
    changePin: 'Cambia PIN',
    backup: 'Backup',
    restore: 'Ripristino',
    about: 'Informazioni',
    chooseLanguage: 'Scegli Lingua',
    importDataFromBrowser: 'Importa Dati dal Browser',
    backupData: 'Esegui Backup', // Dịch là "Thực hiện Backup" (như một nút hành động)
    deleteData: 'Elimina Dati',
    deleteDataConfirmation: 'Conferma Eliminazione Dati',
    confirm: 'Conferma',
    lockOnBackground: 'Blocca in background',
    dataIsEmpty: 'Nessun dato', // "Data is empty"
    deleteDataQuestion: 'Sei sicuro di voler eliminare tutti i dati?',
    cancel: 'Annulla',
    appIsNotInstalled: 'App non installata',
    appIsNotInstalledMessage:
        'È necessario installare l\'app prima di trasferire i dati.', // "Please install the app before transferring data?" (dịch lại thành câu khẳng định)
    installNow: 'Installa Ora',
    transferData: 'Trasferisci dati alla versione Pro',
    transferDataMessage: 'Vuoi trasferire i dati dalla versione Lite alla Pro?',

    receiveData: 'Ricevi dati',
    receiveDataMessage:
        'Per continuare a ricevere dati dalla versione Lite, seleziona un file per aggiungere dati alla versione Pro!',
    waitingNotification: "Attendere prego, il processo potrebbe richiedere alcuni minuti",
    decryptingData: "Decrittazione dati in corso...",
  };
}
