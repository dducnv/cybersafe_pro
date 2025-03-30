import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/password_generator_text.dart';

class PasswordGeneratorLocale extends BaseLocale {
  final AppLocale appLocale;
  
  PasswordGeneratorLocale(this.appLocale);
  
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
    PasswordGeneratorText.title: 'Tạo Mật Khẩu',
    PasswordGeneratorText.passwordCopied: 'Đã sao chép mật khẩu vào bộ nhớ tạm',
    PasswordGeneratorText.specialChars: 'Ký tự đặc biệt (!@#,...)',
    PasswordGeneratorText.numbers: 'Số (0-9)',
    PasswordGeneratorText.uppercase: 'Chữ HOA (A-Z)',
    PasswordGeneratorText.lowercase: 'Chữ thường (a-z)',
    PasswordGeneratorText.passwordLength: 'Độ dài mật khẩu',
    PasswordGeneratorText.generatePassword: 'Tạo mật khẩu',
    PasswordGeneratorText.copyPassword: 'Sao chép mật khẩu',
  };

  @override
  Map<String, String> get en => {
    PasswordGeneratorText.title: 'Password Generator',
    PasswordGeneratorText.passwordCopied: 'Password copied to clipboard',
    PasswordGeneratorText.specialChars: 'Special characters (!@#,...)',
    PasswordGeneratorText.numbers: 'Numbers (0-9)',
    PasswordGeneratorText.uppercase: 'Uppercase letters (A-Z)',
    PasswordGeneratorText.lowercase: 'Lowercase letters (a-z)',
    PasswordGeneratorText.passwordLength: 'Password length',
    PasswordGeneratorText.generatePassword: 'Generate password',
    PasswordGeneratorText.copyPassword: 'Copy password',
  };

  @override
  Map<String, String> get pt => {
    PasswordGeneratorText.title: 'Gerador de Senha',
    PasswordGeneratorText.passwordCopied: 'Senha copiada para a área de transferência',
    PasswordGeneratorText.specialChars: 'Caracteres especiais (!@#,...)',
    PasswordGeneratorText.numbers: 'Números (0-9)',
    PasswordGeneratorText.uppercase: 'Letras maiúsculas (A-Z)',
    PasswordGeneratorText.lowercase: 'Letras minúsculas (a-z)',
    PasswordGeneratorText.passwordLength: 'Comprimento da senha',
    PasswordGeneratorText.generatePassword: 'Gerar senha',
    PasswordGeneratorText.copyPassword: 'Copiar senha',
  };

  @override
  Map<String, String> get hi => {
    PasswordGeneratorText.title: 'पासवर्ड जनरेटर',
    PasswordGeneratorText.passwordCopied: 'पासवर्ड क्लिपबोर्ड पर कॉपी किया गया',
    PasswordGeneratorText.specialChars: 'विशेष वर्ण (!@#,...)',
    PasswordGeneratorText.numbers: 'अंक (0-9)',
    PasswordGeneratorText.uppercase: 'बड़े अक्षर (A-Z)',
    PasswordGeneratorText.lowercase: 'छोटे अक्षर (a-z)',
    PasswordGeneratorText.passwordLength: 'पासवर्ड की लंबाई',
    PasswordGeneratorText.generatePassword: 'पासवर्ड बनाएं',
    PasswordGeneratorText.copyPassword: 'पासवर्ड कॉपी करें',
  };

  @override
  Map<String, String> get ja => {
    PasswordGeneratorText.title: 'パスワード生成',
    PasswordGeneratorText.passwordCopied: 'パスワードがクリップボードにコピーされました',
    PasswordGeneratorText.specialChars: '特殊文字 (!@#,...)',
    PasswordGeneratorText.numbers: '数字 (0-9)',
    PasswordGeneratorText.uppercase: '大文字 (A-Z)',
    PasswordGeneratorText.lowercase: '小文字 (a-z)',
    PasswordGeneratorText.passwordLength: 'パスワードの長さ',
    PasswordGeneratorText.generatePassword: 'パスワードを生成',
    PasswordGeneratorText.copyPassword: 'パスワードをコピー',
  };

  @override
  Map<String, String> get ru => {
    PasswordGeneratorText.title: 'Генератор паролей',
    PasswordGeneratorText.passwordCopied: 'Пароль скопирован в буфер обмена',
    PasswordGeneratorText.specialChars: 'Специальные символы (!@#,...)',
    PasswordGeneratorText.numbers: 'Цифры (0-9)',
    PasswordGeneratorText.uppercase: 'Прописные буквы (A-Z)',
    PasswordGeneratorText.lowercase: 'Строчные буквы (a-z)',
    PasswordGeneratorText.passwordLength: 'Длина пароля',
    PasswordGeneratorText.generatePassword: 'Сгенерировать пароль',
    PasswordGeneratorText.copyPassword: 'Скопировать пароль',
  };

  @override
  Map<String, String> get id => {
    PasswordGeneratorText.title: 'Penghasil Kata Sandi',
    PasswordGeneratorText.passwordCopied: 'Kata sandi disalin ke clipboard',
    PasswordGeneratorText.specialChars: 'Karakter khusus (!@#,...)',
    PasswordGeneratorText.numbers: 'Angka (0-9)',
    PasswordGeneratorText.uppercase: 'Huruf besar (A-Z)',
    PasswordGeneratorText.lowercase: 'Huruf kecil (a-z)',
    PasswordGeneratorText.passwordLength: 'Panjang kata sandi',
    PasswordGeneratorText.generatePassword: 'Hasilkan kata sandi',
    PasswordGeneratorText.copyPassword: 'Salin kata sandi',
  };
}