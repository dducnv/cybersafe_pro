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
    OnboardingText.terms: 'Điều khoản sử dụng',
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
    OnboardingText.termsAndConditions: 'Agree to the policy and terms',
    OnboardingText.agree: 'Agree',
    OnboardingText.createMasterPassword: 'Create master password',
    OnboardingText.welcomeDescription: 'Welcome to CyberSafe Pro, a secure and safe password management application.',
    OnboardingText.terms: 'Terms of use',
    OnboardingText.policy: 'Privacy policy',
    OnboardingText.continueText: 'Continue',
    OnboardingText.agreeRedirectLink: 'Agree and go to the link',
    OnboardingText.doNotAgreeRedirectLink: 'Do you agree to go to the link?',
    OnboardingText.showLink: 'Show link',
  };

  @override
  Map<String, String> get pt => {
    OnboardingText.welcome: 'Bem-vindo',
    OnboardingText.selectLanguage: 'Escolher idioma',
    OnboardingText.getStarted: 'Começar',
    OnboardingText.termsAndConditions: 'Concordar com a política e os termos',
    OnboardingText.agree: 'Concordar',
    OnboardingText.createMasterPassword: 'Criar senha principal',
    OnboardingText.welcomeDescription: 'Bem-vindo ao CyberSafe Pro, aplicativo seguro para gerenciamento de senhas.',
    OnboardingText.terms: 'Termos de uso',
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
    OnboardingText.termsAndConditions: 'नीति और शर्तों से सहमत',
    OnboardingText.agree: 'सहमत',
    OnboardingText.createMasterPassword: 'मुख्य पासवर्ड बनाएं',
    OnboardingText.welcomeDescription: 'CyberSafe Pro में आपका स्वागत है, एक सुरक्षित पासवर्ड प्रबंधन ऐप।',
    OnboardingText.terms: 'उपयोग की शर्तें',
    OnboardingText.policy: 'गोपनीयता नीति',
    OnboardingText.continueText: 'जारी रखें',
    OnboardingText.agreeRedirectLink: 'सहमत हैं और लिंक पर जाएं',
    OnboardingText.doNotAgreeRedirectLink: 'क्या आप लिंक पर जाना स्वीकार करते हैं?',
    OnboardingText.showLink: 'लिंक दिखाएं',
  };

  @override
  Map<String, String> get ja => {
    OnboardingText.welcome: 'ようこそ',
    OnboardingText.selectLanguage: '言語を選択',
    OnboardingText.getStarted: 'はじめに',
    OnboardingText.termsAndConditions: 'ポリシーと利用規約に同意する',
    OnboardingText.agree: '同意する',
    OnboardingText.createMasterPassword: 'マスターパスワードを作成',
    OnboardingText.welcomeDescription: 'CyberSafe Proへようこそ、安全で安心なパスワード管理アプリです。',
    OnboardingText.terms: '利用規約',
    OnboardingText.policy: 'プライバシーポリシー',
    OnboardingText.continueText: '続ける',
    OnboardingText.agreeRedirectLink: '同意してリンクへ進む',
    OnboardingText.doNotAgreeRedirectLink: 'リンクへ進みますか？',
    OnboardingText.showLink: 'リンクを表示',
  };

  @override
  Map<String, String> get ru => {
    OnboardingText.welcome: 'Добро пожаловать',
    OnboardingText.selectLanguage: 'Выберите язык',
    OnboardingText.getStarted: 'Начать',
    OnboardingText.termsAndConditions: 'Согласиться с политикой и условиями',
    OnboardingText.agree: 'Согласен',
    OnboardingText.createMasterPassword: 'Создать основной пароль',
    OnboardingText.welcomeDescription: 'Добро пожаловать в CyberSafe Pro — безопасное приложение для управления паролями.',
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
    OnboardingText.termsAndConditions: 'Setuju dengan kebijakan dan syarat',
    OnboardingText.agree: 'Setuju',
    OnboardingText.createMasterPassword: 'Buat kata sandi utama',
    OnboardingText.welcomeDescription: 'Selamat datang di CyberSafe Pro, aplikasi manajemen kata sandi yang aman dan terpercaya.',
    OnboardingText.terms: 'Syarat penggunaan',
    OnboardingText.policy: 'Kebijakan privasi',
    OnboardingText.continueText: 'Lanjutkan',
    OnboardingText.agreeRedirectLink: 'Setuju dan pergi ke tautan',
    OnboardingText.doNotAgreeRedirectLink: 'Apakah Anda setuju untuk pergi ke tautan?',
    OnboardingText.showLink: 'Tampilkan tautan',
  };

  @override
  Map<String, String> get tr => {
    OnboardingText.welcome: 'Hoşgeldiniz',
    OnboardingText.selectLanguage: 'Dil seçin',
    OnboardingText.getStarted: 'Başla',
    OnboardingText.termsAndConditions: 'Politika ve şartları kabul et',
    OnboardingText.agree: 'Kabul et',
    OnboardingText.createMasterPassword: 'Ana parola oluştur',
    OnboardingText.welcomeDescription: 'CyberSafe Pro\'ya hoş geldiniz, güvenli ve emniyetli bir parola yönetim uygulaması.',
    OnboardingText.terms: 'Kullanım şartları',
    OnboardingText.policy: 'Gizlilik politikası',
    OnboardingText.continueText: 'Devam et',
    OnboardingText.agreeRedirectLink: 'Kabul et ve bağlantıya git',
    OnboardingText.doNotAgreeRedirectLink: 'Bağlantıya gitmeyi kabul ediyor musunuz?',
    OnboardingText.showLink: 'Bağlantıyı göster',
  };
} 