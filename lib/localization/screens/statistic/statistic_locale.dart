import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/statistic_text.dart';

class StatisticLocale extends BaseLocale {
  final AppLocale appLocale;
  
  StatisticLocale(this.appLocale);
  
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
    StatisticText.title: 'Thống kê',
    StatisticText.securityScore: 'Điểm bảo mật',
    StatisticText.weakPasswords: 'Yếu',
    StatisticText.duplicatePasswords: 'Trùng lặp',
    StatisticText.strongPasswords: 'Mạnh',
    StatisticText.securityCheck: 'Kiểm tra bảo mật',
    StatisticText.passwordAge: 'Tuổi mật khẩu',
    StatisticText.passwordStrength: 'Độ mạnh mật khẩu',
    StatisticText.twoFactorEnabled: 'Xác thực 2 lớp',
    StatisticText.accountsProtected: 'Tài khoản được bảo vệ',
    StatisticText.totalAccount: 'Tổng số tài khoản',
    StatisticText.totalAccountPasswordStrong: 'Tổng số mật khẩu mạnh',
    StatisticText.totalAccountPasswordWeak: 'Tổng số mật khẩu yếu',
    StatisticText.totalAccountSamePassword: 'Tổng số mật khẩu trùng lặp',
  };

  @override
  Map<String, String> get en => {
    StatisticText.title: 'Statistics',
    StatisticText.securityScore: 'Security Score',
    StatisticText.weakPasswords: 'Weaks',
    StatisticText.duplicatePasswords: 'Duplicates',
    StatisticText.strongPasswords: 'Strong',
    StatisticText.securityCheck: 'Security Check',
    StatisticText.passwordAge: 'Password Age',
    StatisticText.passwordStrength: 'Password Strength',
    StatisticText.twoFactorEnabled: 'Two-factor Authentication',
    StatisticText.accountsProtected: 'Protected Accounts',
    StatisticText.totalAccount: 'Total Accounts',
    StatisticText.totalAccountPasswordStrong: 'Total Strong Passwords',
    StatisticText.totalAccountPasswordWeak: 'Total Weak Passwords',
    StatisticText.totalAccountSamePassword: 'Total Duplicate Passwords',
  };

  @override
  Map<String, String> get pt => {
    StatisticText.title: 'Estatísticas',
    StatisticText.securityScore: 'Pontuação de Segurança',
    StatisticText.weakPasswords: 'Fracas',
    StatisticText.duplicatePasswords: 'Duplicadas',
    StatisticText.strongPasswords: 'Fortes',
    StatisticText.securityCheck: 'Verificação de Segurança',
    StatisticText.passwordAge: 'Idade da Senha',
    StatisticText.passwordStrength: 'Força da Senha',
    StatisticText.twoFactorEnabled: 'Autenticação de Dois Fatores',
    StatisticText.accountsProtected: 'Contas Protegidas',
    StatisticText.totalAccount: 'Total de Contas',
    StatisticText.totalAccountPasswordStrong: 'Total de Senhas Fortes',
    StatisticText.totalAccountPasswordWeak: 'Total de Senhas Fracas',
    StatisticText.totalAccountSamePassword: 'Total de Senhas Duplicadas',
  };

  @override
  Map<String, String> get hi => {
    StatisticText.title: 'आंकड़े',
    StatisticText.securityScore: 'सुरक्षा स्कोर',
    StatisticText.weakPasswords: 'कमजोर पासवर्ड',
    StatisticText.duplicatePasswords: 'डुप्लिकेट पासवर्ड',
    StatisticText.strongPasswords: 'मजबूत पासवर्ड',
    StatisticText.securityCheck: 'सुरक्षा जांच',
    StatisticText.passwordAge: 'पासवर्ड आयु',
    StatisticText.passwordStrength: 'पासवर्ड की मजबूती',
    StatisticText.twoFactorEnabled: 'दो-कारक प्रमाणीकरण',
    StatisticText.accountsProtected: 'सुरक्षित खाते',
    StatisticText.totalAccount: 'कुल खाते',
    StatisticText.totalAccountPasswordStrong: 'कुल मजबूत पासवर्ड',
    StatisticText.totalAccountPasswordWeak: 'कुल कमजोर पासवर्ड',
    StatisticText.totalAccountSamePassword: 'कुल डुप्लिकेट पासवर्ड',
  };

  @override
  Map<String, String> get ja => {
    StatisticText.title: '統計',
    StatisticText.securityScore: 'セキュリティスコア',
    StatisticText.weakPasswords: '弱い',
    StatisticText.duplicatePasswords: '重複',
    StatisticText.strongPasswords: '強い',
    StatisticText.securityCheck: 'セキュリティチェック',
    StatisticText.passwordAge: 'パスワードの経過時間',
    StatisticText.passwordStrength: 'パスワード強度',
    StatisticText.twoFactorEnabled: '二要素認証',
    StatisticText.accountsProtected: '保護されたアカウント',
    StatisticText.totalAccount: '総アカウント数',
    StatisticText.totalAccountPasswordStrong: '総強力パスワード数',
    StatisticText.totalAccountPasswordWeak: '総脆弱パスワード数',
    StatisticText.totalAccountSamePassword: '重複パスワード数',
  };

  @override
  Map<String, String> get ru => {
    StatisticText.title: 'Статистика',
    StatisticText.securityScore: 'Оценка безопасности',
    StatisticText.weakPasswords: 'Слабые',
    StatisticText.duplicatePasswords: 'Повторяющиеся',
    StatisticText.strongPasswords: 'Надежные',
    StatisticText.securityCheck: 'Проверка безопасности',
    StatisticText.passwordAge: 'Возраст пароля',
    StatisticText.passwordStrength: 'Надежность пароля',
    StatisticText.twoFactorEnabled: 'Двухфакторная аутентификация',
    StatisticText.accountsProtected: 'Защищенные аккаунты',
    StatisticText.totalAccount: 'Общее количество аккаунтов',
    StatisticText.totalAccountPasswordStrong: 'Общее количество сильных паролей',
    StatisticText.totalAccountPasswordWeak: 'Общее количество слабых паролей',
    StatisticText.totalAccountSamePassword: 'Общее количество повторяющихся паролей',
  };

  @override
  Map<String, String> get id => {
    StatisticText.title: 'Statistik',
    StatisticText.securityScore: 'Skor Keamanan',
    StatisticText.weakPasswords: 'Lemah',
    StatisticText.duplicatePasswords: 'Duplikat',
    StatisticText.strongPasswords: 'Kuat',
    StatisticText.securityCheck: 'Pemeriksaan Keamanan',
    StatisticText.passwordAge: 'Umur Kata Sandi',
    StatisticText.passwordStrength: 'Kekuatan Kata Sandi',
    StatisticText.twoFactorEnabled: 'Autentikasi Dua Faktor',
    StatisticText.accountsProtected: 'Akun yang Dilindungi',
    StatisticText.totalAccount: 'Total Akun',
    StatisticText.totalAccountPasswordStrong: 'Total Kata Sandi Kuat',
    StatisticText.totalAccountPasswordWeak: 'Total Kata Sandi Lemah',
    StatisticText.totalAccountSamePassword: 'Total Kata Sandi Duplikat',
  };
} 