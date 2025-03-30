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
    toAddAccount: 'एक खाता जोड़ें',
    seeMore: 'अधिक देखें {count} शेष',
    seeMore10: 'अधिक 10 आइटम देखें',
    items: 'आइटम',
    searchNoResult: 'कोई परिणाम नहीं मिला',
    searchTitle: 'खाते खोजें',
    searchHint: 'खाता नाम, ईमेल, एप्लिकेशन नाम दर्ज करें।',
    passwordGenerator: 'पासवर्ड जनरेटर',
    deleteAllAccount: 'सभी चुने गए खाते हटाएं',
    cancel: 'बंद करें',
    delete: 'हटाएं',
    changeCategory: 'श्रेणी बदलें',
  };
  @override
  Map<String, String> get ja => {
    home: 'ホーム',
    accounts: 'アカウント',
    categories: 'カテゴリ',
    settings: '設定',
    search: '検索',
    addAccount: 'アカウントを追加',
    noAccounts: 'まだアカウントがありません',
    click: 'クリック',
    toAddAccount: 'アカウントを追加',
    seeMore: 'さらに{count}件表示',
    seeMore10: 'さらに10件表示',
    items: 'アイテム',
    searchNoResult: '検索結果が見つかりません',
    searchTitle: 'アカウントを検索',
    searchHint: 'ユーザー名、メール、アプリケーション名を入力してください。',
    passwordGenerator: 'パスワードジェネレーター',
    deleteAllAccount: 'すべての選択されたアカウントを削除',
    cancel: 'キャンセル',
    delete: '削除',
    changeCategory: 'カテゴリを変更',
  };
  @override
  Map<String, String> get ru => {
    home: 'Главная',
    accounts: 'Аккаунты',
    categories: 'Категории',
    settings: 'Настройки',
    search: 'Поиск',
    addAccount: 'Добавить аккаунт',
    noAccounts: 'Еще нет аккаунтов',
    click: 'Нажмите',
    toAddAccount: 'чтобы добавить аккаунт',
    seeMore: 'Показать еще {count} элементов',
    seeMore10: 'Показать еще 10 элементов',
    items: 'элементов',
    searchNoResult: 'Ничего не найдено',
    searchTitle: 'Поиск аккаунтов',
    searchHint: 'Введите имя пользователя, электронную почту, имя приложения.',
    passwordGenerator: 'Генератор паролей',
    deleteAllAccount: 'Удалить все выбранные аккаунты',
    cancel: 'Отмена',
    delete: 'Удалить',
    changeCategory: 'Изменить категорию',
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
    toAddAccount: 'untuk menambahkan akun',
    seeMore: 'Lihat lebih {count} item',
    seeMore10: 'Lihat lebih 10 item',
    items: 'item',
    searchNoResult: 'Tidak ada hasil pencarian',
    searchTitle: 'Cari akun',
    searchHint: 'Masukkan nama pengguna, email, nama aplikasi.',
    passwordGenerator: 'Generator Password',
    deleteAllAccount: 'Hapus semua akun yang dipilih',
    cancel: 'Batal',
    delete: 'Hapus',
    changeCategory: 'Ubah Kategori',
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
  };
}

//key
