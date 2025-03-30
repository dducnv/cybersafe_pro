import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';

class CreateAccountLocale extends BaseLocale {
  final AppLocale appLocale;
  
  CreateAccountLocale(this.appLocale);
  
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
    CreateAccountText.title: 'Tạo tài khoản',
    CreateAccountText.updateAccount: 'Cập nhật tài khoản',
    CreateAccountText.chooseIcon: 'Chọn icon',
    CreateAccountText.noSelect: 'Không chọn',
    CreateAccountText.twoFactorAuth: 'Xác thực 2 lớp',
    CreateAccountText.password: 'Mật khẩu',
    CreateAccountText.overwritePassword: 'Bạn có muốn ghi đè lên mật khẩu cũ không?',
    CreateAccountText.cancel: 'Hủy bỏ',
    CreateAccountText.confirm: 'Đồng ý',
    CreateAccountText.addField: 'Thêm trường',
    CreateAccountText.customFields: 'Các trường tùy chỉnh',
    CreateAccountText.chooseFieldType: 'Chọn loại trường',

    CreateAccountText.appName: 'Tên ứng dụng',
    CreateAccountText.username: 'Tên tài khoản',
    CreateAccountText.confirmPassword: 'Xác nhận mật khẩu',
    CreateAccountText.note: 'Ghi chú',
    CreateAccountText.category: 'Danh mục',
    CreateAccountText.chooseCategory: 'Chọn danh mục',
    CreateAccountText.enterKey: 'Nhập mã xác thực TOTP',
    CreateAccountText.otpError: 'Mã xác thực không hợp lệ',
    CreateAccountText.titleField: 'Tên trường',
    CreateAccountText.fieldType: 'Loại trường',
    CreateAccountText.iconApp: 'Icon mặc định',
    CreateAccountText.iconCustom: 'Icon tùy chỉnh',

    CreateAccountText.appNameValidation: 'Tên ứng dụng không được để trống',
    CreateAccountText.usernameValidation: 'Tên tài khoản không được để trống',
    CreateAccountText.passwordValidation: 'Mật khẩu không được để trống',
    CreateAccountText.confirmPasswordValidation: 'Xác nhận mật khẩu không được để trống',
    CreateAccountText.noteValidation: 'Ghi chú không được để trống',
    CreateAccountText.categoryValidation: 'Danh mục không được để trống',
  };

  @override
  Map<String, String> get en => {
    CreateAccountText.title: 'Create Account',
    CreateAccountText.updateAccount: 'Update Account',
    CreateAccountText.chooseIcon: 'Choose icon',
    CreateAccountText.noSelect: 'No selection',
    CreateAccountText.twoFactorAuth: 'Two-factor authentication',
    CreateAccountText.password: 'Password',
    CreateAccountText.overwritePassword: 'Do you want to overwrite the old password?',
    CreateAccountText.cancel: 'Cancel',
    CreateAccountText.confirm: 'Confirm',
    CreateAccountText.addField: 'Add field',
    CreateAccountText.customFields: 'Custom fields',
    CreateAccountText.chooseFieldType: 'Choose field type',

    CreateAccountText.appName: 'App name',
    CreateAccountText.username: 'Username',
    CreateAccountText.confirmPassword: 'Confirm password',
    CreateAccountText.note: 'Note',
    CreateAccountText.category: 'Category',
    CreateAccountText.chooseCategory: 'Choose category',
    CreateAccountText.enterKey: 'Enter TOTP key',
    CreateAccountText.otpError: 'Invalid TOTP key',
    CreateAccountText.titleField: 'Title field',
    CreateAccountText.fieldType: 'Field type',
    CreateAccountText.iconApp: 'Default icon',
    CreateAccountText.iconCustom: 'Custom icon',

    CreateAccountText.appNameValidation: 'App name cannot be empty',
    CreateAccountText.usernameValidation: 'Username cannot be empty',
    CreateAccountText.passwordValidation: 'Password cannot be empty',
    CreateAccountText.confirmPasswordValidation: 'Confirm password cannot be empty',
    CreateAccountText.noteValidation: 'Note cannot be empty',
  };

  @override
  Map<String, String> get pt => {
    CreateAccountText.title: 'Criar Conta',
    CreateAccountText.updateAccount: 'Atualizar Conta',
    CreateAccountText.chooseIcon: 'Escolher ícone',
    CreateAccountText.noSelect: 'Sem seleção',
    CreateAccountText.twoFactorAuth: 'Autenticação de dois fatores',
    CreateAccountText.password: 'Senha',
    CreateAccountText.overwritePassword: 'Deseja substituir a senha antiga?',
    CreateAccountText.cancel: 'Cancelar',
    CreateAccountText.confirm: 'Confirmar',
    CreateAccountText.addField: 'Adicionar campo',
    CreateAccountText.customFields: 'Campos personalizados',
    CreateAccountText.chooseFieldType: 'Escolher tipo de campo',

    CreateAccountText.appName: 'Nome do aplicativo',
    CreateAccountText.username: 'Nome de usuário',
    CreateAccountText.confirmPassword: 'Confirmar senha',
    CreateAccountText.note: 'Nota',
    CreateAccountText.category: 'Categoria',
    CreateAccountText.chooseCategory: 'Escolher categoria',
    CreateAccountText.enterKey: 'Digite a chave TOTP',
    CreateAccountText.otpError: 'Chave TOTP inválida',
    CreateAccountText.titleField: 'Título do campo',
    CreateAccountText.fieldType: 'Tipo de campo',
    CreateAccountText.iconApp: 'Icone padrão',
    CreateAccountText.iconCustom: 'Icone personalizado',

    CreateAccountText.appNameValidation: 'O nome do aplicativo não pode estar vazio',
    CreateAccountText.usernameValidation: 'O nome de usuário não pode estar vazio',
    CreateAccountText.passwordValidation: 'A senha não pode estar vazia',
    CreateAccountText.confirmPasswordValidation: 'A senha de confirmação não pode estar vazia',
    CreateAccountText.noteValidation: 'A nota não pode estar vazia',
  };

  @override
  Map<String, String> get hi => {
    CreateAccountText.title: 'खाता बनाएं',
    CreateAccountText.updateAccount: 'खाता अपडेट करें',
    CreateAccountText.chooseIcon: 'आइकन चुनें',
    CreateAccountText.noSelect: 'कोई चयन नहीं',
    CreateAccountText.twoFactorAuth: 'दो-कारक प्रमाणीकरण',
    CreateAccountText.password: 'पासवर्ड',
    CreateAccountText.overwritePassword: 'क्या आप पुराने पासवर्ड को अधिलेखित करना चाहते हैं?',
    CreateAccountText.cancel: 'रद्द करें',
    CreateAccountText.confirm: 'पुष्टि करें',
    CreateAccountText.addField: 'फ़ील्ड जोड़ें',
    CreateAccountText.customFields: 'कस्टम फ़ील्ड',
    CreateAccountText.chooseFieldType: 'फ़ील्ड प्रकार चुनें',

    CreateAccountText.appName: 'ऐप नाम',
    CreateAccountText.username: 'उपयोगकर्ता नाम',
    CreateAccountText.confirmPassword: 'पासवर्ड सुनिश्चित करें',
    CreateAccountText.note: 'नोट',
    CreateAccountText.category: 'श्रेणी',
    CreateAccountText.chooseCategory: 'श्रेणी चुनें',
    CreateAccountText.enterKey: 'TOTP कुंजी दर्ज करें',
    CreateAccountText.otpError: 'टोटप कुंजी अमान्य है',
    CreateAccountText.titleField: 'फ़ील्ड शीर्षक',
    CreateAccountText.fieldType: 'फ़ील्ड प्रकार',
    CreateAccountText.iconApp: 'डिफ़ॉल्ट आइकन',
    CreateAccountText.iconCustom: 'व्यक्तिगत आइकन',

    CreateAccountText.appNameValidation: 'एप्लिकेशन नाम खाली नहीं हो सकता है',
    CreateAccountText.usernameValidation: 'उपयोगकर्ता नाम खाली नहीं हो सकता है',
    CreateAccountText.passwordValidation: 'पासवर्ड खाली नहीं हो सकता है',
    CreateAccountText.confirmPasswordValidation: 'पासवर्ड सुनिश्चित करें खाली नहीं हो सकता है',
    CreateAccountText.noteValidation: 'नोट खाली नहीं हो सकता है', 
  };

  @override
  Map<String, String> get ja => {
    CreateAccountText.title: 'アカウント作成',
    CreateAccountText.updateAccount: 'アカウント更新',
    CreateAccountText.chooseIcon: 'アイコンを選択',
    CreateAccountText.noSelect: '選択なし',
    CreateAccountText.twoFactorAuth: '二要素認証',
    CreateAccountText.password: 'パスワード',
    CreateAccountText.overwritePassword: '古いパスワードを上書きしますか？',
    CreateAccountText.cancel: 'キャンセル',
    CreateAccountText.confirm: '確認',
    CreateAccountText.addField: 'フィールドを追加',
    CreateAccountText.customFields: 'カスタムフィールド',
    CreateAccountText.chooseFieldType: 'フィールドタイプを選択',

    CreateAccountText.appName: 'アプリ名',
    CreateAccountText.username: 'ユーザー名',
    CreateAccountText.confirmPassword: 'パスワードを確認',
    CreateAccountText.note: 'ノート',
    CreateAccountText.category: 'カテゴリ',
    CreateAccountText.chooseCategory: 'カテゴリを選択',
    CreateAccountText.enterKey: 'TOTP キーを入力',
    CreateAccountText.otpError: 'TOTP キーが無効です',
    CreateAccountText.titleField: 'フィールドタイトル',
    CreateAccountText.fieldType: 'フィールドタイプ',
    CreateAccountText.iconApp: 'デフォルトのアイコン',
    CreateAccountText.iconCustom: 'カスタムのアイコン',

    CreateAccountText.appNameValidation: 'アプリ名は空にできません',
    CreateAccountText.usernameValidation: 'ユーザー名は空にできません',
    CreateAccountText.passwordValidation: 'パスワードは空にできません',
    CreateAccountText.confirmPasswordValidation: '確認パスワードは空にできません',
    CreateAccountText.noteValidation: 'ノートは空にできません',
  };

  @override
  Map<String, String> get ru => {
    CreateAccountText.title: 'Создать аккаунт',
    CreateAccountText.updateAccount: 'Обновить аккаунт',
    CreateAccountText.chooseIcon: 'Выбрать иконку',
    CreateAccountText.noSelect: 'Не выбрано',
    CreateAccountText.twoFactorAuth: 'Двухфакторная аутентификация',
    CreateAccountText.password: 'Пароль',
    CreateAccountText.overwritePassword: 'Вы хотите перезаписать старый пароль?',
    CreateAccountText.cancel: 'Отмена',
    CreateAccountText.confirm: 'Подтвердить',
    CreateAccountText.addField: 'Добавить поле',
    CreateAccountText.customFields: 'Пользовательские поля',
    CreateAccountText.chooseFieldType: 'Выберите тип поля',

    CreateAccountText.appName: 'Название приложения',
    CreateAccountText.username: 'Имя пользователя',
    CreateAccountText.confirmPassword: 'Подтвердить пароль',
    CreateAccountText.note: 'Заметка',
    CreateAccountText.category: 'Категория',
    CreateAccountText.chooseCategory: 'Выбрать категорию',
    CreateAccountText.enterKey: 'Введите ключ TOTP',
    CreateAccountText.otpError: 'TOTP キーが無効です',
    CreateAccountText.titleField: 'フィールドタイトル',
    CreateAccountText.fieldType: 'フィールドタイプ',
    CreateAccountText.iconApp: 'デフォルトのアイコン',
    CreateAccountText.iconCustom: 'カスタムのアイコン',

    CreateAccountText.appNameValidation: 'アプリ名は空にできません',
    CreateAccountText.usernameValidation: 'ユーザー名は空にできません',
    CreateAccountText.passwordValidation: 'パスワードは空にできません',
    CreateAccountText.confirmPasswordValidation: '確認パスワードは空にできません',
    CreateAccountText.noteValidation: 'ノートは空にできません',
  };

  @override
  Map<String, String> get id => {
    CreateAccountText.title: 'Buat Akun',
    CreateAccountText.updateAccount: 'Perbarui Akun',
    CreateAccountText.chooseIcon: 'Pilih ikon',
    CreateAccountText.noSelect: 'Tidak ada pilihan',
    CreateAccountText.twoFactorAuth: 'Autentikasi dua faktor',
    CreateAccountText.password: 'Kata sandi',
    CreateAccountText.overwritePassword: 'Apakah Anda ingin menimpa kata sandi lama?',
    CreateAccountText.cancel: 'Batal',
    CreateAccountText.confirm: 'Konfirmasi',
    CreateAccountText.addField: 'Tambah kolom',
    CreateAccountText.customFields: 'Kolom kustom',
    CreateAccountText.chooseFieldType: 'Pilih jenis kolom',

    CreateAccountText.appName: 'Nama aplikasi',
    CreateAccountText.username: 'Nama pengguna',
    CreateAccountText.confirmPassword: 'Konfirmasi kata sandi',
    CreateAccountText.note: 'Catatan',
    CreateAccountText.category: 'Kategori',
    CreateAccountText.chooseCategory: 'Pilih kategori',
    CreateAccountText.enterKey: 'Masukkan kunci TOTP',
    CreateAccountText.otpError: 'Kunci TOTP tidak valid',
    CreateAccountText.titleField: 'Judul kolom',
    CreateAccountText.fieldType: 'Jenis kolom',
    CreateAccountText.iconApp: 'Ikon default',
    CreateAccountText.iconCustom: 'Ikon pribadi',

    CreateAccountText.appNameValidation: 'Nama aplikasi tidak boleh kosong',
    CreateAccountText.usernameValidation: 'Nama pengguna tidak boleh kosong',
    CreateAccountText.passwordValidation: 'Kata sandi tidak boleh kosong',
    CreateAccountText.confirmPasswordValidation: 'Konfirmasi kata sandi tidak boleh kosong',
    CreateAccountText.noteValidation: 'Catatan tidak boleh kosong',
  };  
} 