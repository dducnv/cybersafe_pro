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
    SidebarText.rateApp: 'Đánh giá ứng dụng',
    SidebarText.support: 'Hỗ trợ',
    SidebarText.requestLanguage: 'Yêu cầu ngôn ngữ',
    SidebarText.contact: 'Liên hệ',
  };

  @override
  Map<String, String> get en => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Category Management',
    SidebarText.about: 'About',
    SidebarText.faqs: 'FAQs',
    SidebarText.featureRequest: 'Feature Request',
    SidebarText.privacyPolicy: 'Privacy Policy',
    SidebarText.termsOfService: 'Terms of Service',
    SidebarText.rateApp: 'Rate the App',
    SidebarText.support: 'Support',
    SidebarText.requestLanguage: 'Request Language',
    SidebarText.contact: 'Contact',
  };

  @override
  Map<String, String> get pt => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Gerenciamento de Categorias',
    SidebarText.about: 'Sobre',
    SidebarText.faqs: 'Perguntas Frequentes',
    SidebarText.featureRequest: 'Solicitar Funcionalidade',
    SidebarText.privacyPolicy: 'Política de Privacidade',
    SidebarText.termsOfService: 'Termos de Serviço',
    SidebarText.rateApp: 'Avaliar o Aplicativo',
    SidebarText.support: 'Suporte',
    SidebarText.requestLanguage: 'Solicitar Idioma',
    SidebarText.contact: 'Contato',
  };

  @override
  Map<String, String> get hi => {
    SidebarText.appName: 'साइबरसेफ',
    SidebarText.categoryManager: 'श्रेणी प्रबंधन',
    SidebarText.about: 'परिचय',
    SidebarText.faqs: 'अक्सर पूछे जाने वाले प्रश्न',
    SidebarText.featureRequest: 'फीचर अनुरोध',
    SidebarText.privacyPolicy: 'गोपनीयता नीति',
    SidebarText.termsOfService: 'सेवा की शर्तें',
    SidebarText.rateApp: 'ऐप को रेट करें',
    SidebarText.support: 'सहायता',
    SidebarText.requestLanguage: 'भाषा अनुरोध',
    SidebarText.contact: 'संपर्क',
  };

  @override
  Map<String, String> get ja => {
    SidebarText.appName: 'サイバーセーフ',
    SidebarText.categoryManager: 'カテゴリ管理',
    SidebarText.about: 'アプリについて',
    SidebarText.faqs: 'よくある質問',
    SidebarText.featureRequest: '機能リクエスト',
    SidebarText.privacyPolicy: 'プライバシーポリシー',
    SidebarText.termsOfService: '利用規約',
    SidebarText.rateApp: 'アプリを評価する',
    SidebarText.support: 'サポート',
    SidebarText.requestLanguage: '言語リクエスト',
    SidebarText.contact: 'お問い合わせ',
  };

  @override
  Map<String, String> get ru => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Управление категориями',
    SidebarText.about: 'О приложении',
    SidebarText.faqs: 'Часто задаваемые вопросы',
    SidebarText.featureRequest: 'Запрос функции',
    SidebarText.privacyPolicy: 'Политика конфиденциальности',
    SidebarText.termsOfService: 'Условия использования',
    SidebarText.rateApp: 'Оценить приложение',
    SidebarText.support: 'Поддержка',
    SidebarText.requestLanguage: 'Запрос языка',
    SidebarText.contact: 'Контакты',
  };

  @override
  Map<String, String> get id => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Manajemen Kategori',
    SidebarText.about: 'Tentang aplikasi',
    SidebarText.faqs: 'Pertanyaan Umum',
    SidebarText.featureRequest: 'Permintaan Fitur',
    SidebarText.privacyPolicy: 'Kebijakan Privasi',
    SidebarText.termsOfService: 'Ketentuan Layanan',
    SidebarText.rateApp: 'Beri Nilai Aplikasi',
    SidebarText.support: 'Dukungan',
    SidebarText.requestLanguage: 'Permintaan Bahasa',
    SidebarText.contact: 'Kontak',
  };

  @override
  Map<String, String> get tr => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Kategori Yönetimi',
    SidebarText.about: 'Hakkında',
    SidebarText.faqs: 'Sıkça Sorulan Sorular',
    SidebarText.featureRequest: 'Özellik Talebi',
    SidebarText.privacyPolicy: 'Gizlilik Politikası',
    SidebarText.termsOfService: 'Kullanım Koşulları',
    SidebarText.rateApp: 'Uygulamayı Değerlendir',
    SidebarText.support: 'Destek',
    SidebarText.requestLanguage: 'Dil Talebi',
    SidebarText.contact: 'İletişim',
  };

  @override
  // TODO: implement es
  Map<String, String> get es => {
    SidebarText.appName: 'CyberSafe',
    SidebarText.categoryManager: 'Gestión de categorías',
    SidebarText.about: 'Acerca de',
    SidebarText.faqs: 'Preguntas frecuentes',
    SidebarText.featureRequest: 'Solicitar función',
    SidebarText.privacyPolicy: 'Política de privacidad',
    SidebarText.termsOfService: 'Términos de servicio',
    SidebarText.rateApp: 'Calificar la aplicación',
    SidebarText.support: 'Soporte',
    SidebarText.requestLanguage: 'Solicitar idioma',
    SidebarText.contact: 'Contacto',
  };
}
