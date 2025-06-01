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
    copySuccess: 'कॉपी सफलतापूर्वक हो गई',
    selectAccount: 'खाता चुनें',
    unSelectAccount: 'खाता बंद करें',
    accountDetails: 'खाता विवरण',
    updateAccount: 'खाता अपडेट करें',
    copyUsername: 'खाता नाम कॉपी करें',
    copyPassword: 'खाता पासवर्ड कॉपी करें',
    deleteAccount: 'खाता हटाएं',
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
    copySuccess: 'コピーに成功しました',
    selectAccount: 'アカウントを選択',
    unSelectAccount: 'アカウントを選択解除',
    accountDetails: 'アカウントの詳細',
    updateAccount: 'アカウントを更新',
    copyUsername: 'アカウント名をコピー',
    copyPassword: 'パスワードをコピー',
    deleteAccount: 'アカウントを削除',
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
    copySuccess: 'Копирование прошло успешно',
    selectAccount: 'Выбрать аккаунт',
    unSelectAccount: 'Снять выбор с аккаунта',
    accountDetails: 'Детали аккаунта',
    updateAccount: 'Обновить аккаунт',
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
    copySuccess: 'Salinan berhasil',
    selectAccount: 'Pilih akun',
    unSelectAccount: 'Hapus pilihan akun',
    accountDetails: 'Detail akun',
    updateAccount: 'Update account',
    copyUsername: 'Salin nama akun',
    copyPassword: 'Salin password',
    deleteAccount: 'Hapus akun',
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
    seeMore10: 'Daha fazla 10 göster',
    items: 'öğe',
    searchNoResult: 'Sonuç bulunamadı',
    searchTitle: 'Hesapları ara',
    searchHint: 'Kullanıcı adı, e-posta, uygulama adı girin.',
    passwordGenerator: 'Parola Oluşturucu',
    deleteAllAccount: 'Seçilen tüm hesapları sil',
    cancel: 'İptal',
    delete: 'Sil',
    changeCategory: 'Kategori Değiştir',
    copySuccess: 'Kopyalandı',
    selectAccount: 'Hesap Seç',
    unSelectAccount: 'Hesap Seçimi',
    accountDetails: 'Hesap Detayı',
    updateAccount: 'Hesap Güncelle',
    copyUsername: 'Kullanıcı Adını Kopyala',
    copyPassword: 'Parolayı Kopyala',
    deleteAccount: 'Hesap Sil',
  };

}

//key
