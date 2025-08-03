import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';

class HomeLocale extends BaseLocale {
  @override
  String get languageCode => appLocale.locale.languageCode;
  @override
  String get countryCode => appLocale.locale.countryCode ?? 'VN';
  @override
  String get languageName => appLocale.locale.languageCode;
  @override
  String get languageNativeName => appLocale.locale.languageCode;
  @override
  String get flagEmoji => appLocale.locale.countryCode ?? 'VN';
  final AppLocale appLocale;

  HomeLocale(this.appLocale);

  static const String home = 'home';
  static const String accounts = 'accounts';
  static const String categories = 'categories';
  static const String settings = 'settings';
  static const String search = 'search';
  static const String addAccount = 'add_account';
  static const String noAccounts = 'no_accounts';
  static const String click = 'click';
  static const String toAddAccount = 'to_add_account';
  static const String seeMore = 'see_more_remaining';
  static const String seeMore10 = 'see_more_10';
  static const String items = 'items';
  static const String searchNoResult = 'search_no_result';
  static const String searchTitle = 'search_title';
  static const String searchHint = 'search_hint';
  static const String passwordGenerator = 'password_generator';
  static const String deleteAllAccount = 'delete_all_account_selected';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String changeCategory = 'change_category';
  static const String copySuccess = 'copy_success';

  static const String selectAccount = 'select_account';
  static const String unSelectAccount = 'un_select_account';
  static const String updateAccount = 'update_account';
  static const String accountDetails = 'account_details';
  static const String copyUsername = 'copy_username';
  static const String copyPassword = 'copy_password';
  static const String deleteAccount = 'delete_account';

  static const String migrationData = 'migration_data';

  @override
  Map<String, String> get vi => {
    home: 'Trang chủ',
    accounts: 'Tài khoản',
    categories: 'Danh mục',
    settings: 'Cài đặt',
    search: 'Tìm kiếm',
    addAccount: 'Thêm tài khoản',
    noAccounts: 'Chưa có tài khoản nào',
    click: 'Nhấn',
    toAddAccount: 'để thêm tài khoản',
    seeMore: 'Xem thêm {count} mục còn lại',
    seeMore10: 'Xem thêm 10 mục tiếp theo',
    items: 'mục',
    searchNoResult: 'Không tìm thấy kết quả',
    searchTitle: 'Tìm kiếm tài khoản',
    searchHint: 'Nhập tên tài khoản, email, tên ứng dụng.',
    passwordGenerator: 'Tạo mật khẩu',
    deleteAllAccount: 'Xoá tài khoản đã chọn',
    cancel: 'Huỷ',
    delete: 'Xoá',
    changeCategory: 'Thay đổi danh mục',
    copySuccess: 'Sao chép thành công',
    selectAccount: 'Chọn tài khoản',
    unSelectAccount: 'Bỏ chọn tài khoản',
    accountDetails: 'Chi tiết tài khoản',
    updateAccount: 'Cập nhật tài khoản',
    copyUsername: 'Sao chép tên tài khoản',
    copyPassword: 'Sao chép mật khẩu',
    deleteAccount: 'Xoá tài khoản',

    migrationData: "Đang nâng cấp mã hoá. Vui lòng chờ vài phút và không tắt ứng dụng.",
  };

  @override
  Map<String, String> get en_GB => {
    home: 'Home',
    accounts: 'Accounts',
    categories: 'Categories',
    settings: 'Settings',
    search: 'Search',
    addAccount: 'Add Account',
    noAccounts: 'No accounts yet',
    click: 'Click',
    toAddAccount: 'to add account',
    seeMore: 'See more {count} remaining',
    seeMore10: 'See more 10 items',
    items: 'items',
    searchNoResult: 'No results found',
    searchTitle: 'Search accounts',
    searchHint: 'Enter username, email, app name.',
    passwordGenerator: 'Password Generator',
    deleteAllAccount: 'Delete all selected accounts',
    delete: 'Delete',
    changeCategory: 'Change Category',
    copySuccess: 'Copy success',
    selectAccount: 'Select account',
    unSelectAccount: 'Unselect account',
    accountDetails: 'Account details',
    updateAccount: 'Update account',
    copyUsername: 'Copy username',
    copyPassword: 'Copy password',
    deleteAccount: 'Delete account',

    migrationData: "Migrating data. Please wait a few minutes and do not close the app.",
  };

  @override
  Map<String, String> get en_US => {
    home: 'Home',
    accounts: 'Accounts',
    categories: 'Categories',
    settings: 'Settings',
    search: 'Search',
    addAccount: 'Add Account',
    noAccounts: 'No accounts yet',
    click: 'Click',
    toAddAccount: 'to add account',
    seeMore: 'See more {count} remaining',
    seeMore10: 'See more 10 items',
    items: 'items',
    searchNoResult: 'No results found',
    searchTitle: 'Search accounts',
    searchHint: 'Enter username, email, app name.',
    passwordGenerator: 'Password Generator',
    deleteAllAccount: 'Delete all selected accounts',
    cancel: 'Cancel',
    delete: 'Delete',
    changeCategory: 'Change Category',
    copySuccess: 'Copy success',
    selectAccount: 'Select account',
    unSelectAccount: 'Unselect account',
    accountDetails: 'Account details',
    updateAccount: 'Update account',
    copyUsername: 'Copy username',
    copyPassword: 'Copy password',
    deleteAccount: 'Delete account',

    migrationData: "Migrating data. Please wait a few minutes and do not close the app.",
  };
  @override
  Map<String, String> get hi => {
    home: 'घर',
    accounts: 'खाते',
    categories: 'श्रेणियाँ',
    settings: 'सेटिंग्स',
    search: 'खोज',
    addAccount: 'खाता जोड़ें',
    noAccounts: 'कोई खाते नहीं',
    click: 'क्लिक',
    toAddAccount: 'खाता जोड़ने के लिए',
    seeMore: 'अधिक देखें {count} शेष',
    seeMore10: 'अगले 10 आइटम देखें',
    items: 'आइटम',
    searchNoResult: 'कोई परिणाम नहीं मिला',
    searchTitle: 'खाता खोजें',
    searchHint: 'खाता नाम, ईमेल, ऐप का नाम दर्ज करें।',
    passwordGenerator: 'पासवर्ड जनरेट करें',
    deleteAllAccount: 'चयनित खातों को हटाएं',
    cancel: 'रद्द करें',
    delete: 'हटाएं',
    changeCategory: 'श्रेणी बदलें',
    copySuccess: 'सफलतापूर्वक कॉपी किया गया',
    selectAccount: 'खाता चुनें',
    unSelectAccount: 'चयन हटाएं',
    accountDetails: 'खाते का विवरण',
    updateAccount: 'खाता अपडेट करें',
    copyUsername: 'खाता नाम कॉपी करें',
    copyPassword: 'पासवर्ड कॉपी करें',
    deleteAccount: 'खाता हटाएं',

    migrationData:
        "डेटा अपग्रेड हो रहा है। कृपया कुछ मिनट प्रतीक्षा करें और एप्लिकेशन को बंद न करें।",
  };
  @override
  Map<String, String> get ja => {
    home: 'ホーム',
    accounts: 'アカウント',
    categories: 'カテゴリ',
    settings: '設定',
    search: '検索',
    addAccount: 'アカウント追加',
    noAccounts: 'アカウントがありません',
    click: 'クリック',
    toAddAccount: 'アカウントを追加',
    seeMore: '{count}件をさらに表示',
    seeMore10: 'さらに10件表示',
    items: '件',
    searchNoResult: '結果が見つかりません',
    searchTitle: 'アカウント検索',
    searchHint: 'アカウント名、メール、アプリ名を入力してください。',
    passwordGenerator: 'パスワード生成',
    deleteAllAccount: '選択したアカウントをすべて削除',
    cancel: 'キャンセル',
    delete: '削除',
    changeCategory: 'カテゴリ変更',
    copySuccess: 'コピーしました',
    selectAccount: 'アカウント選択',
    unSelectAccount: '選択解除',
    accountDetails: 'アカウント詳細',
    updateAccount: 'アカウント更新',
    copyUsername: 'アカウント名をコピー',
    copyPassword: 'パスワードをコピー',
    deleteAccount: 'アカウント削除',

    migrationData: "データのアップグレード中です。数分間お待ちください。",
  };
  @override
  Map<String, String> get ru => {
    home: 'Главная',
    accounts: 'Аккаунты',
    categories: 'Категории',
    settings: 'Настройки',
    search: 'Поиск',
    addAccount: 'Добавить аккаунт',
    noAccounts: 'Нет аккаунтов',
    click: 'Нажмите',
    toAddAccount: 'чтобы добавить аккаунт',
    seeMore: 'Показать еще {count}',
    seeMore10: 'Показать еще 10',
    items: 'элементов',
    searchNoResult: 'Результатов не найдено',
    searchTitle: 'Поиск аккаунта',
    searchHint: 'Введите имя аккаунта, email, название приложения.',
    passwordGenerator: 'Генератор паролей',
    deleteAllAccount: 'Удалить выбранные аккаунты',
    cancel: 'Отмена',
    delete: 'Удалить',
    changeCategory: 'Изменить категорию',
    copySuccess: 'Успешно скопировано',
    selectAccount: 'Выбрать аккаунт',
    unSelectAccount: 'Снять выбор',
    accountDetails: 'Детали аккаунта',
    updateAccount: 'Обновить аккаунт',
    copyUsername: 'Копировать имя аккаунта',
    copyPassword: 'Копировать пароль',
    deleteAccount: 'Удалить аккаунт',

    migrationData:
        "Данные обновляются. Пожалуйста, подождите несколько минут и не закрывайте приложение.",
  };
  @override
  Map<String, String> get id => {
    home: 'Beranda',
    accounts: 'Akun',
    categories: 'Kategori',
    settings: 'Pengaturan',
    search: 'Cari',
    addAccount: 'Tambah Akun',
    noAccounts: 'Belum ada akun',
    click: 'Klik',
    toAddAccount: 'untuk menambah akun',
    seeMore: 'Lihat lebih {count} item',
    seeMore10: 'Lihat 10 item berikutnya',
    items: 'item',
    searchNoResult: 'Tidak ada hasil',
    searchTitle: 'Cari akun',
    searchHint: 'Masukkan nama akun, email, nama aplikasi.',
    passwordGenerator: 'Generator Kata Sandi',
    deleteAllAccount: 'Hapus semua akun yang dipilih',
    cancel: 'Batal',
    delete: 'Hapus',
    changeCategory: 'Ubah Kategori',
    copySuccess: 'Berhasil disalin',
    selectAccount: 'Pilih akun',
    unSelectAccount: 'Batalkan pilihan akun',
    accountDetails: 'Detail akun',
    updateAccount: 'Perbarui akun',
    copyUsername: 'Salin nama akun',
    copyPassword: 'Salin kata sandi',
    deleteAccount: 'Hapus akun',

    migrationData: "Sedang memigrasi data. Mohon tunggu beberapa menit dan jangan tutup aplikasi.",
  };
  @override
  Map<String, String> get pt_PT => {
    home: 'Página inicial',
    accounts: 'Contas',
    categories: 'Categorias',
    settings: 'Configurações',
    search: 'Pesquisar',
    addAccount: 'Adicionar Conta',
    noAccounts: 'Nenhuma conta ainda',
    click: 'Clique',
    toAddAccount: 'para adicionar uma conta',
    seeMore: 'Ver mais {count} itens',
    seeMore10: 'Ver mais 10 itens',
    items: 'itens',
    searchNoResult: 'Nenhum resultado encontrado',
    searchTitle: 'Pesquisar contas',
    searchHint: 'Digite o nome do usuário, email, nome do aplicativo.',
    passwordGenerator: 'Gerador de senha',
    deleteAllAccount: 'Deletar todas as contas selecionadas',
    cancel: 'Cancelar',
    delete: 'Deletar',
    changeCategory: 'Mudar Categoria',
    copySuccess: 'Cópia realizada com sucesso',
    selectAccount: 'Selecionar conta',
    unSelectAccount: 'Desmarcar conta',
    accountDetails: 'Detalhes da conta',
    updateAccount: 'Atualizar conta',
    copyUsername: 'Copiar nome de usuário',
    copyPassword: 'Copiar senha',
    deleteAccount: 'Deletar conta',

    migrationData: "A migrar dados. Por favor, aguarde alguns minutos e não feche a aplicação.",
  };
  @override
  Map<String, String> get pt_BR => {
    home: 'Página inicial',
    accounts: 'Contas',
    categories: 'Categorias',
    settings: 'Configurações',
    search: 'Pesquisar',
    addAccount: 'Adicionar Conta',
    noAccounts: 'Nenhuma conta ainda',
    click: 'Clique',
    toAddAccount: 'para adicionar uma conta',
    seeMore: 'Ver mais {count} itens',
    seeMore10: 'Ver mais 10 itens',
    items: 'itens',
    searchNoResult: 'Nenhum resultado encontrado',
    searchTitle: 'Pesquisar contas',
    searchHint: 'Digite o nome do usuário, email, nome do aplicativo.',
    passwordGenerator: 'Gerador de senha',
    deleteAllAccount: 'Deletar todas as contas selecionadas',
    cancel: 'Cancelar',
    delete: 'Deletar',
    changeCategory: 'Mudar Categoria',
    copySuccess: 'Cópia realizada com sucesso',
    selectAccount: 'Selecionar conta',
    unSelectAccount: 'Desmarcar conta',
    accountDetails: 'Detalhes da conta',
    updateAccount: 'Atualizar conta',
    copyUsername: 'Copiar nome de usuário',
    copyPassword: 'Copiar senha',
    deleteAccount: 'Deletar conta',

    migrationData: "Migrando dados. Por favor, aguarde alguns minutos e não feche o aplicativo.",
  };

  @override
  Map<String, String> get en => {
    home: 'Home',
    accounts: 'Accounts',
    categories: 'Categories',
    settings: 'Settings',
    search: 'Search',
    addAccount: 'Add Account',
    noAccounts: 'No accounts yet',
    click: 'Click',
    toAddAccount: 'to add account',
    seeMore: 'See more {count} remaining',
    seeMore10: 'See more 10 items',
    items: 'items',
    searchNoResult: 'No results found',
    searchTitle: 'Search accounts',
    searchHint: 'Enter username, email, app name.',
    passwordGenerator: 'Password Generator',
    deleteAllAccount: 'Delete all selected accounts',
    cancel: 'Cancel',
    delete: 'Delete',
    changeCategory: 'Change Category',
    copySuccess: 'Copy success',
    selectAccount: 'Select account',
    unSelectAccount: 'Unselect account',
    accountDetails: 'Account details',
    updateAccount: 'Update account',
    copyUsername: 'Copy username',
    copyPassword: 'Copy password',
    deleteAccount: 'Delete account',

    migrationData: "Migrating data. Please wait a few minutes and do not close the app.",
  };

  @override
  Map<String, String> get pt => {
    home: 'Página inicial',
    accounts: 'Contas',
    categories: 'Categorias',
    settings: 'Configurações',
    search: 'Pesquisar',
    addAccount: 'Adicionar Conta',
    noAccounts: 'Nenhuma conta ainda',
    click: 'Clique',
    toAddAccount: 'para adicionar uma conta',
    seeMore: 'Ver mais {count} itens',
    seeMore10: 'Ver mais 10 itens',
    items: 'itens',
    searchNoResult: 'Nenhum resultado encontrado',
    searchTitle: 'Pesquisar contas',
    searchHint: 'Digite o nome do usuário, email, nome do aplicativo.',
    passwordGenerator: 'Gerador de senha',
    deleteAllAccount: 'Deletar todas as contas selecionadas',
    cancel: 'Cancelar',
    delete: 'Deletar',
    changeCategory: 'Mudar Categoria',
    copySuccess: 'Cópia realizada com sucesso',
    selectAccount: 'Selecionar conta',
    unSelectAccount: 'Desmarcar conta',
    accountDetails: 'Detalhes da conta',
    updateAccount: 'Atualizar conta',
    copyUsername: 'Copiar nome de usuário',
    copyPassword: 'Copiar senha',
    deleteAccount: 'Deletar conta',

    migrationData: "A migrar dados. Por favor, aguarde alguns minutos e não feche a aplicação.",
  };

  @override
  Map<String, String> get tr => {
    home: 'Ana Sayfa',
    accounts: 'Hesaplar',
    categories: 'Kategoriler',
    settings: 'Ayarlar',
    search: 'Ara',
    addAccount: 'Hesap Ekle',
    noAccounts: 'Henüz hesap yok',
    click: 'Tıkla',
    toAddAccount: 'hesap eklemek için',
    seeMore: 'Daha fazla {count} göster',
    seeMore10: 'Sonraki 10 öğeyi göster',
    items: 'öğe',
    searchNoResult: 'Sonuç bulunamadı',
    searchTitle: 'Hesap ara',
    searchHint: 'Hesap adı, e-posta, uygulama adı girin.',
    passwordGenerator: 'Parola Oluşturucu',
    deleteAllAccount: 'Seçili hesapları sil',
    cancel: 'İptal',
    delete: 'Sil',
    changeCategory: 'Kategoriyi Değiştir',
    copySuccess: 'Başarıyla kopyalandı',
    selectAccount: 'Hesap Seç',
    unSelectAccount: 'Hesap Seçimini Kaldır',
    accountDetails: 'Hesap Detayları',
    updateAccount: 'Hesabı Güncelle',
    copyUsername: 'Hesap Adını Kopyala',
    copyPassword: 'Parolayı Kopyala',
    deleteAccount: 'Hesabı Sil',

    migrationData: "Veriler taşınıyor. Lütfen birkaç dakika bekleyin ve uygulamayı kapatmayın.",
  };

  @override
  // TODO: implement es
  Map<String, String> get es => {
    home: 'Inicio',
    accounts: 'Cuentas',
    categories: 'Categorías',
    settings: 'Configuración',
    search: 'Buscar',
    addAccount: 'Agregar cuenta',
    noAccounts: 'Aún no hay cuentas',
    click: 'Haz clic',
    toAddAccount: 'para agregar una cuenta',
    seeMore: 'Ver más ({count} restantes)',
    seeMore10: 'Ver 10 elementos más',
    items: 'elementos',
    searchNoResult: 'No se encontraron resultados',
    searchTitle: 'Buscar cuentas',
    searchHint: 'Introduce nombre de usuario, correo electrónico o nombre de la aplicación.',
    passwordGenerator: 'Generador de contraseñas',
    deleteAllAccount: 'Eliminar todas las cuentas seleccionadas',
    delete: 'Eliminar',
    changeCategory: 'Cambiar categoría',
    copySuccess: 'Copiado con éxito',
    selectAccount: 'Seleccionar cuenta',
    unSelectAccount: 'Deseleccionar cuenta',
    accountDetails: 'Detalles de la cuenta',
    updateAccount: 'Actualizar cuenta',
    copyUsername: 'Copiar nombre de usuario',
    copyPassword: 'Copiar contraseña',
    deleteAccount: 'Eliminar cuenta',

    migrationData: "Migrando datos. Por favor, espera unos minutos y no cierres la aplicación.",
  };
}

//key
