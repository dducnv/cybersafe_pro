import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/onboarding_text.dart';

class OnboardingLocale extends BaseLocale {
  final AppLocale appLocale;
  
  OnboardingLocale(this.appLocale);
  
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
    OnboardingText.welcome: 'Chào mừng',
    OnboardingText.selectLanguage: 'Chọn ngôn ngữ',
    OnboardingText.getStarted: 'Bắt đầu',
    OnboardingText.termsAndConditions: 'Đồng ý với chính sách và điều khoản',
    OnboardingText.agree: 'Đồng ý',
    OnboardingText.createMasterPassword: 'Tạo mật khẩu chính',
    OnboardingText.welcomeDescription: 'Chào mừng đến với CyberSafe Pro, ứng dụng bảo mật và quản lý mật khẩu an toàn.',
    OnboardingText.terms: 'Điều khoản dịch vụ',
    OnboardingText.policy: 'Chính sách bảo mật',
    OnboardingText.continueText: 'Tiếp tục',
    OnboardingText.agreeRedirectLink: 'Đồng ý và đi đến đường dẫn',
    OnboardingText.doNotAgreeRedirectLink: 'Bạn có đồng ý đi đến đường dẫn không?',
    OnboardingText.showLink: 'Hiển thị đường dẫn',
  };

  @override
  Map<String, String> get en => {
    OnboardingText.welcome: 'Welcome',
    OnboardingText.selectLanguage: 'Select language',
    OnboardingText.getStarted: 'Get started',
    OnboardingText.termsAndConditions: 'Agree to terms and conditions',
    OnboardingText.agree: 'Agree',
    OnboardingText.createMasterPassword: 'Create master password',
    OnboardingText.welcomeDescription: 'Welcome to CyberSafe Pro, the secure password management application.',
    OnboardingText.terms: 'Terms and conditions',
    OnboardingText.policy: 'Privacy policy',
    OnboardingText.continueText: 'Continue',
    OnboardingText.agreeRedirectLink: 'Agree and go to the link',
    OnboardingText.doNotAgreeRedirectLink: 'Do you agree to go to the link?',
    OnboardingText.showLink: 'Show link',
  };

  @override
  Map<String, String> get pt => {
    OnboardingText.welcome: 'Bem-vindo',
    OnboardingText.selectLanguage: 'Selecionar idioma',
    OnboardingText.getStarted: 'Começar',
    OnboardingText.termsAndConditions: 'Concordar com os termos e condições',
    OnboardingText.agree: 'Concordar',
    OnboardingText.createMasterPassword: 'Criar senha mestra',
    OnboardingText.welcomeDescription: 'Bem-vindo ao CyberSafe Pro, o aplicativo seguro de gerenciamento de senhas.',
    OnboardingText.terms: 'Termos e condições',
    OnboardingText.policy: 'Política de privacidade',
    OnboardingText.continueText: 'Continuar',
    OnboardingText.agreeRedirectLink: 'Concordar e ir para o link',
    OnboardingText.doNotAgreeRedirectLink: 'Você concorda em ir para o link?',
    OnboardingText.showLink: 'Mostrar link',
  };

  @override
  Map<String, String> get hi => {
    OnboardingText.welcome: 'स्वागत है',
    OnboardingText.selectLanguage: 'भाषा चुनें',
    OnboardingText.getStarted: 'शुरू करें',
    OnboardingText.termsAndConditions: 'नियम और शर्तों से सहमत',
    OnboardingText.agree: 'सहमत',
    OnboardingText.createMasterPassword: 'मास्टर पासवर्ड बनाएं',
    OnboardingText.welcomeDescription: 'साइबरसेफ प्रो में आपका स्वागत है, सुरक्षित पासवर्ड प्रबंधन एप्लिकेशन।',
    OnboardingText.terms: 'नियम और शर्तों',
    OnboardingText.policy: 'गोपनीयता नीति',
    OnboardingText.continueText: 'जारी रखें',
    OnboardingText.agreeRedirectLink: 'सहमत हो और लिंक पर जाएं',
    OnboardingText.doNotAgreeRedirectLink: 'क्या आप लिंक पर जाना चाहते हैं?',
    OnboardingText.showLink: 'लिंक दिखाएं',
  };

  @override
  Map<String, String> get ja => {
    OnboardingText.welcome: 'ようこそ',
    OnboardingText.selectLanguage: '言語を選択',
    OnboardingText.getStarted: '始める',
    OnboardingText.termsAndConditions: '利用規約に同意',
    OnboardingText.agree: '同意する',
    OnboardingText.createMasterPassword: 'マスターパスワードを作成',
    OnboardingText.welcomeDescription: 'サイバーセーフプロへようこそ、安全なパスワード管理アプリケーションです。',
    OnboardingText.terms: '利用規約',
    OnboardingText.policy: 'プライバシーポリシー',
    OnboardingText.continueText: '続ける',
    OnboardingText.agreeRedirectLink: '同意してリンクに移動',
    OnboardingText.doNotAgreeRedirectLink: 'リンクに移動しますか？',
    OnboardingText.showLink: 'リンクを表示',
  };

  @override
  Map<String, String> get ru => {
    OnboardingText.welcome: 'Добро пожаловать',
    OnboardingText.selectLanguage: 'Выберите язык',
    OnboardingText.getStarted: 'Начать',
    OnboardingText.termsAndConditions: 'Согласие с условиями использования',
    OnboardingText.agree: 'Согласен',
    OnboardingText.createMasterPassword: 'Создать мастер-пароль',
    OnboardingText.welcomeDescription: 'Добро пожаловать в CyberSafe Pro, безопасное приложение для управления паролями.',
    OnboardingText.terms: 'Условия использования',
    OnboardingText.policy: 'Политика конфиденциальности',
    OnboardingText.continueText: 'Продолжить',
    OnboardingText.agreeRedirectLink: 'Согласен и перейти по ссылке',
    OnboardingText.doNotAgreeRedirectLink: 'Вы согласны перейти по ссылке?',
    OnboardingText.showLink: 'Показать ссылку',
  };

  @override
  Map<String, String> get id => {
    OnboardingText.welcome: 'Selamat Datang',
    OnboardingText.selectLanguage: 'Pilih bahasa',
    OnboardingText.getStarted: 'Mulai',
    OnboardingText.termsAndConditions: 'Setuju dengan syarat dan ketentuan',
    OnboardingText.agree: 'Setuju',
    OnboardingText.createMasterPassword: 'Buat kata sandi utama',
    OnboardingText.welcomeDescription: 'Selamat datang di CyberSafe Pro, aplikasi pengelolaan kata sandi yang aman.',
    OnboardingText.terms: 'Syarat dan ketentuan',
    OnboardingText.policy: 'Kebijakan privasi',
    OnboardingText.continueText: 'Lanjutkan',
    OnboardingText.agreeRedirectLink: 'Setuju dan pergi ke link',
    OnboardingText.doNotAgreeRedirectLink: 'Apakah Anda setuju untuk pergi ke link?',
    OnboardingText.showLink: 'Tampilkan tautan',
  };
} 