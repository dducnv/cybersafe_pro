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
    CreateAccountText.chooseIcon: 'Chọn Icon',
    CreateAccountText.noSelect: 'Không chọn',
    CreateAccountText.twoFactorAuth: 'Xác thực 2 lớp',
    CreateAccountText.password: 'Mật khẩu',
    CreateAccountText.overwritePassword: 'Ghi đè mật khẩu',
    CreateAccountText.overwritePasswordMessage: 'Mật khẩu cũ sẽ bị ghi đè bởi mật khẩu mới!',
    CreateAccountText.cancel: 'Hủy bỏ',
    CreateAccountText.confirm: 'Đồng ý',
    CreateAccountText.addField: 'Thêm mục thông tin',
    CreateAccountText.customFields: 'Thông tin bổ sung',
    CreateAccountText.chooseFieldType: 'Chọn kiểu thông tin',

    CreateAccountText.appName: 'Tên ứng dụng',
    CreateAccountText.username: 'Tên tài khoản',
    CreateAccountText.confirmPassword: 'Xác nhận mật khẩu',
    CreateAccountText.note: 'Ghi chú',
    CreateAccountText.category: 'Danh mục',
    CreateAccountText.chooseCategory: 'Chọn danh mục',
    CreateAccountText.enterKey: 'Nhập mã xác thực hai yếu tố',
    CreateAccountText.otpError: 'Mã xác thực không hợp lệ',
    CreateAccountText.titleField: 'Tên mục thông tin',
    CreateAccountText.fieldType: 'Kiểu thông tin',
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
    CreateAccountText.overwritePassword: 'Overwrite password',
    CreateAccountText.overwritePasswordMessage: 'The old password will be overwritten by the new password!',
    CreateAccountText.cancel: 'Cancel',
    CreateAccountText.confirm: 'Agree',
    CreateAccountText.addField: 'Add information field',
    CreateAccountText.customFields: 'Additional information',
    CreateAccountText.chooseFieldType: 'Choose information type',

    CreateAccountText.appName: 'App name',
    CreateAccountText.username: 'Account name',
    CreateAccountText.confirmPassword: 'Confirm password',
    CreateAccountText.note: 'Note',
    CreateAccountText.category: 'Category',
    CreateAccountText.chooseCategory: 'Choose category',
    CreateAccountText.enterKey: 'Enter two-factor authentication code',
    CreateAccountText.otpError: 'Invalid authentication code',
    CreateAccountText.titleField: 'Information field name',
    CreateAccountText.fieldType: 'Information type',
    CreateAccountText.iconApp: 'Default icon',
    CreateAccountText.iconCustom: 'Custom icon',

    CreateAccountText.appNameValidation: 'App name cannot be empty',
    CreateAccountText.usernameValidation: 'Account name cannot be empty',
    CreateAccountText.passwordValidation: 'Password cannot be empty',
    CreateAccountText.confirmPasswordValidation: 'Confirm password cannot be empty',
    CreateAccountText.noteValidation: 'Note cannot be empty',
    CreateAccountText.categoryValidation: 'Category cannot be empty',
  };

  @override
  Map<String, String> get pt => {
    CreateAccountText.title: 'Criar Conta',
    CreateAccountText.updateAccount: 'Atualizar Conta',
    CreateAccountText.chooseIcon: 'Escolher ícone',
    CreateAccountText.noSelect: 'Não selecionado',
    CreateAccountText.twoFactorAuth: 'Autenticação de dois fatores',
    CreateAccountText.password: 'Senha',
    CreateAccountText.overwritePassword: 'Sobrescrever senha',
    CreateAccountText.overwritePasswordMessage: 'A senha antiga será sobrescrita pela nova senha!',
    CreateAccountText.cancel: 'Cancelar',
    CreateAccountText.confirm: 'Concordar',
    CreateAccountText.addField: 'Adicionar campo de informação',
    CreateAccountText.customFields: 'Informações adicionais',
    CreateAccountText.chooseFieldType: 'Escolher tipo de informação',

    CreateAccountText.appName: 'Nome do aplicativo',
    CreateAccountText.username: 'Nome da conta',
    CreateAccountText.confirmPassword: 'Confirmar senha',
    CreateAccountText.note: 'Nota',
    CreateAccountText.category: 'Categoria',
    CreateAccountText.chooseCategory: 'Escolher categoria',
    CreateAccountText.enterKey: 'Digite o código de autenticação de dois fatores',
    CreateAccountText.otpError: 'Código de autenticação inválido',
    CreateAccountText.titleField: 'Nome do campo de informação',
    CreateAccountText.fieldType: 'Tipo de informação',
    CreateAccountText.iconApp: 'Ícone padrão',
    CreateAccountText.iconCustom: 'Ícone personalizado',

    CreateAccountText.appNameValidation: 'O nome do aplicativo não pode estar vazio',
    CreateAccountText.usernameValidation: 'O nome da conta não pode estar vazio',
    CreateAccountText.passwordValidation: 'A senha não pode estar vazia',
    CreateAccountText.confirmPasswordValidation: 'A confirmação da senha não pode estar vazia',
    CreateAccountText.noteValidation: 'A nota não pode estar vazia',
    CreateAccountText.categoryValidation: 'A categoria não pode estar vazia',
  };

  @override
  Map<String, String> get hi => {
    CreateAccountText.title: 'खाता बनाएं',
    CreateAccountText.updateAccount: 'खाता अपडेट करें',
    CreateAccountText.chooseIcon: 'आइकन चुनें',
    CreateAccountText.noSelect: 'कोई चयन नहीं',
    CreateAccountText.twoFactorAuth: 'दो-कारक प्रमाणीकरण',
    CreateAccountText.password: 'पासवर्ड',
    CreateAccountText.overwritePassword: 'पासवर्ड अधिलेखित करें',
    CreateAccountText.overwritePasswordMessage: 'पुराना पासवर्ड नए पासवर्ड से अधिलेखित कर दिया जाएगा!',
    CreateAccountText.cancel: 'रद्द करें',
    CreateAccountText.confirm: 'सहमत',
    CreateAccountText.addField: 'जानकारी फ़ील्ड जोड़ें',
    CreateAccountText.customFields: 'अतिरिक्त जानकारी',
    CreateAccountText.chooseFieldType: 'जानकारी का प्रकार चुनें',

    CreateAccountText.appName: 'ऐप नाम',
    CreateAccountText.username: 'खाता नाम',
    CreateAccountText.confirmPassword: 'पासवर्ड सुनिश्चित करें',
    CreateAccountText.note: 'नोट',
    CreateAccountText.category: 'श्रेणी',
    CreateAccountText.chooseCategory: 'श्रेणी चुनें',
    CreateAccountText.enterKey: 'दो-कारक प्रमाणीकरण कोड दर्ज करें',
    CreateAccountText.otpError: 'अमान्य प्रमाणीकरण कोड',
    CreateAccountText.titleField: 'जानकारी फ़ील्ड का नाम',
    CreateAccountText.fieldType: 'जानकारी का प्रकार',
    CreateAccountText.iconApp: 'डिफ़ॉल्ट आइकन',
    CreateAccountText.iconCustom: 'व्यक्तिगत आइकन',

    CreateAccountText.appNameValidation: 'ऐप का नाम खाली नहीं हो सकता',
    CreateAccountText.usernameValidation: 'खाता नाम खाली नहीं हो सकता',
    CreateAccountText.passwordValidation: 'पासवर्ड खाली नहीं हो सकता',
    CreateAccountText.confirmPasswordValidation: 'पासवर्ड सुनिश्चित करें खाली नहीं हो सकता',
    CreateAccountText.noteValidation: 'नोट खाली नहीं हो सकता',
    CreateAccountText.categoryValidation: 'श्रेणी खाली नहीं हो सकती',
  };

  @override
  Map<String, String> get ja => {
    CreateAccountText.title: 'アカウント作成',
    CreateAccountText.updateAccount: 'アカウント更新',
    CreateAccountText.chooseIcon: 'アイコンを選択',
    CreateAccountText.noSelect: '未選択',
    CreateAccountText.twoFactorAuth: '二要素認証',
    CreateAccountText.password: 'パスワード',
    CreateAccountText.overwritePassword: 'パスワードを上書き',
    CreateAccountText.overwritePasswordMessage: '古いパスワードは新しいパスワードで上書きされます！',
    CreateAccountText.cancel: 'キャンセル',
    CreateAccountText.confirm: '同意する',
    CreateAccountText.addField: '情報フィールドを追加',
    CreateAccountText.customFields: '追加情報',
    CreateAccountText.chooseFieldType: '情報タイプを選択',

    CreateAccountText.appName: 'アプリ名',
    CreateAccountText.username: 'アカウント名',
    CreateAccountText.confirmPassword: 'パスワードを確認',
    CreateAccountText.note: 'ノート',
    CreateAccountText.category: 'カテゴリ',
    CreateAccountText.chooseCategory: 'カテゴリを選択',
    CreateAccountText.enterKey: '二要素認証コードを入力',
    CreateAccountText.otpError: '認証コードが無効です',
    CreateAccountText.titleField: '情報フィールド名',
    CreateAccountText.fieldType: '情報タイプ',
    CreateAccountText.iconApp: 'デフォルトのアイコン',
    CreateAccountText.iconCustom: 'カスタムのアイコン',

    CreateAccountText.appNameValidation: 'アプリ名は空にできません',
    CreateAccountText.usernameValidation: 'アカウント名は空にできません',
    CreateAccountText.passwordValidation: 'パスワードは空にできません',
    CreateAccountText.confirmPasswordValidation: '確認パスワードは空にできません',
    CreateAccountText.noteValidation: 'ノートは空にできません',
    CreateAccountText.categoryValidation: 'カテゴリは空にできません',
  };

  @override
  Map<String, String> get ru => {
    CreateAccountText.title: 'Создать аккаунт',
    CreateAccountText.updateAccount: 'Обновить аккаунт',
    CreateAccountText.chooseIcon: 'Выбрать иконку',
    CreateAccountText.noSelect: 'Не выбрано',
    CreateAccountText.twoFactorAuth: 'Двухфакторная аутентификация',
    CreateAccountText.password: 'Пароль',
    CreateAccountText.overwritePassword: 'Перезаписать пароль',
    CreateAccountText.overwritePasswordMessage: 'Старый пароль будет перезаписан новым паролем!',
    CreateAccountText.cancel: 'Отмена',
    CreateAccountText.confirm: 'Согласен',
    CreateAccountText.addField: 'Добавить информационное поле',
    CreateAccountText.customFields: 'Дополнительная информация',
    CreateAccountText.chooseFieldType: 'Выбрать тип информации',

    CreateAccountText.appName: 'Название приложения',
    CreateAccountText.username: 'Имя аккаунта',
    CreateAccountText.confirmPassword: 'Подтвердить пароль',
    CreateAccountText.note: 'Заметка',
    CreateAccountText.category: 'Категория',
    CreateAccountText.chooseCategory: 'Выбрать категорию',
    CreateAccountText.enterKey: 'Введите код двухфакторной аутентификации',
    CreateAccountText.otpError: 'Неверный код аутентификации',
    CreateAccountText.titleField: 'Название информационного поля',
    CreateAccountText.fieldType: 'Тип информации',
    CreateAccountText.iconApp: 'Иконка по умолчанию',
    CreateAccountText.iconCustom: 'Пользовательская иконка',

    CreateAccountText.appNameValidation: 'Название приложения не может быть пустым',
    CreateAccountText.usernameValidation: 'Имя аккаунта не может быть пустым',
    CreateAccountText.passwordValidation: 'Пароль не может быть пустым',
    CreateAccountText.confirmPasswordValidation: 'Подтверждение пароля не может быть пустым',
    CreateAccountText.noteValidation: 'Заметка не может быть пустой',
    CreateAccountText.categoryValidation: 'Категория не может быть пустой',
  };

  @override
  Map<String, String> get id => {
    CreateAccountText.title: 'Buat Akun',
    CreateAccountText.updateAccount: 'Perbarui Akun',
    CreateAccountText.chooseIcon: 'Pilih ikon',
    CreateAccountText.noSelect: 'Tidak ada pilihan',
    CreateAccountText.twoFactorAuth: 'Autentikasi dua faktor',
    CreateAccountText.password: 'Kata sandi',
    CreateAccountText.overwritePassword: 'Timpa kata sandi',
    CreateAccountText.overwritePasswordMessage: 'Kata sandi lama akan ditimpa dengan kata sandi baru!',
    CreateAccountText.cancel: 'Batal',
    CreateAccountText.confirm: 'Setuju',
    CreateAccountText.addField: 'Tambah kolom informasi',
    CreateAccountText.customFields: 'Informasi tambahan',
    CreateAccountText.chooseFieldType: 'Pilih jenis informasi',

    CreateAccountText.appName: 'Nama aplikasi',
    CreateAccountText.username: 'Nama akun',
    CreateAccountText.confirmPassword: 'Konfirmasi kata sandi',
    CreateAccountText.note: 'Catatan',
    CreateAccountText.category: 'Kategori',
    CreateAccountText.chooseCategory: 'Pilih kategori',
    CreateAccountText.enterKey: 'Masukkan kode autentikasi dua faktor',
    CreateAccountText.otpError: 'Kode autentikasi tidak valid',
    CreateAccountText.titleField: 'Nama kolom informasi',
    CreateAccountText.fieldType: 'Jenis informasi',
    CreateAccountText.iconApp: 'Ikon default',
    CreateAccountText.iconCustom: 'Ikon pribadi',

    CreateAccountText.appNameValidation: 'Nama aplikasi tidak boleh kosong',
    CreateAccountText.usernameValidation: 'Nama akun tidak boleh kosong',
    CreateAccountText.passwordValidation: 'Kata sandi tidak boleh kosong',
    CreateAccountText.confirmPasswordValidation: 'Konfirmasi kata sandi tidak boleh kosong',
    CreateAccountText.noteValidation: 'Catatan tidak boleh kosong',
    CreateAccountText.categoryValidation: 'Kategori tidak boleh kosong',
  };  

  @override
  Map<String, String> get tr => {
    CreateAccountText.title: 'Hesap Oluştur',
    CreateAccountText.updateAccount: 'Hesap Güncelle',
    CreateAccountText.chooseIcon: 'Simge Seç',
    CreateAccountText.noSelect: 'Seçim yok',
    CreateAccountText.twoFactorAuth: 'İki Faktörlü Kimlik Doğrulama',

    CreateAccountText.password: 'Parola',
    CreateAccountText.overwritePassword: 'Parolayı üzerine yaz',
    CreateAccountText.overwritePasswordMessage: 'Eski parola yeni parola ile değiştirilecek!',
    CreateAccountText.cancel: 'İptal',
    CreateAccountText.confirm: 'Kabul et',
    CreateAccountText.addField: 'Bilgi alanı ekle',
    CreateAccountText.customFields: 'Ek bilgi',
    CreateAccountText.chooseFieldType: 'Bilgi türü seç',

    CreateAccountText.appName: 'Uygulama Adı',
    CreateAccountText.username: 'Hesap adı',
    CreateAccountText.confirmPassword: 'Parolayı Doğrula',
    CreateAccountText.note: 'Not',
    CreateAccountText.category: 'Kategori',
    CreateAccountText.chooseCategory: 'Kategori Seç',
    CreateAccountText.enterKey: 'İki faktörlü kimlik doğrulama kodunu girin',
    CreateAccountText.otpError: 'Geçersiz doğrulama kodu',

    CreateAccountText.titleField: 'Bilgi alanı adı',
    CreateAccountText.fieldType: 'Bilgi türü',
    CreateAccountText.iconApp: 'Varsayılan Simge',
    CreateAccountText.iconCustom: 'Özel Simge',

    CreateAccountText.appNameValidation: 'Uygulama adı boş olamaz',
    CreateAccountText.usernameValidation: 'Hesap adı boş olamaz',
    CreateAccountText.passwordValidation: 'Parola boş olamaz',
    CreateAccountText.confirmPasswordValidation: 'Parola doğrulama boş olamaz',
    CreateAccountText.noteValidation: 'Not boş olamaz',
    CreateAccountText.categoryValidation: 'Kategori boş olamaz',
  };
} 