import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/sidebar_text.dart';

class SidebarLocale extends BaseLocale {
  final AppLocale appLocale;
  
  SidebarLocale(this.appLocale);
  
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
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Quản lý danh mục',
    SidebarText.about: 'Giới thiệu',
    SidebarText.faqs: 'FAQs',
    SidebarText.featureRequest: 'Yêu cầu tính năng',
    SidebarText.privacyPolicy: 'Chính sách bảo mật',
    SidebarText.termsOfService: 'Điều khoản dịch vụ',
  };

  @override
  Map<String, String> get en => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Category Manager',
    SidebarText.about: 'About',
    SidebarText.faqs: 'FAQs',
    SidebarText.featureRequest: 'Feature Request',
    SidebarText.privacyPolicy: 'Privacy Policy',
    SidebarText.termsOfService: 'Terms of Service',
  };

  @override
  Map<String, String> get pt => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Gerenciador de Categorias',
    SidebarText.about: 'Sobre',
    SidebarText.faqs: 'FAQs',
    SidebarText.featureRequest: 'Solicitar Recurso',
    SidebarText.privacyPolicy: 'Política de Privacidade',
    SidebarText.termsOfService: 'Termos de Serviço',
  };

  @override
  Map<String, String> get hi => {
    SidebarText.appName: 'साइबरसेफ',
    SidebarText.categoryManager: 'श्रेणी प्रबंधक',
    SidebarText.about: 'परिचय',
    SidebarText.faqs: 'सामान्य प्रश्न',
    SidebarText.featureRequest: 'सुविधा अनुरोध',
    SidebarText.privacyPolicy: 'गोपनीयता नीति',
    SidebarText.termsOfService: 'सेवा की शर्तें',
  };

  @override
  Map<String, String> get ja => {
    SidebarText.appName: 'サイバーセーフ',
    SidebarText.categoryManager: 'カテゴリマネージャー',
    SidebarText.about: '私たちについて',
    SidebarText.faqs: 'よくある質問',
    SidebarText.featureRequest: '機能リクエスト',
    SidebarText.privacyPolicy: 'プライバシーポリシー',
    SidebarText.termsOfService: '利用規約',
  };

  @override
  Map<String, String> get ru => {
    SidebarText.appName: 'КиберБезопасность',
    SidebarText.categoryManager: 'Управление категориями',
    SidebarText.about: 'О нас',
    SidebarText.faqs: 'ЧЗВ',
    SidebarText.featureRequest: 'Запрос функции',
    SidebarText.privacyPolicy: 'Политика конфиденциальности',
    SidebarText.termsOfService: 'Условия использования',
  };

  @override
  Map<String, String> get id => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Pengelola Kategori',
    SidebarText.about: 'Tentang',
    SidebarText.faqs: 'FAQs',
    SidebarText.featureRequest: 'Permintaan Fitur',
    SidebarText.privacyPolicy: 'Kebijakan Privasi',
    SidebarText.termsOfService: 'Ketentuan Layanan',
  };
} 