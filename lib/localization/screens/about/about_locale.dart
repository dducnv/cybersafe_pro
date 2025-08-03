import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/general.dart';

class AboutLocale extends BaseLocale {
  final AppLocale appLocale;

  AboutLocale(this.appLocale);

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
    GeneralText.aboutAppTitle: 'Giới thiệu về ứng dụng',
    GeneralText.appVersion: 'Phiên bản hiện tại',
    GeneralText.securityOfflineTitle: 'Bảo mật tuyệt đối, hoàn toàn offline',
    GeneralText.securityOfflineDesc:
        'Mật khẩu được lưu trữ an toàn trên thiết bị, không kết nối mạng, mã hóa chuẩn AES-256.',
    GeneralText.categoryOrganizeTitle: 'Quản lý thông minh theo danh mục',
    GeneralText.categoryOrganizeDesc:
        'Dễ dàng phân loại tài khoản, tìm kiếm nhanh chóng và quản lý hiệu quả.',
    GeneralText.backupRestoreTitle: 'Sao lưu & Khôi phục an toàn',
    GeneralText.backupRestoreDesc:
        'Tạo bản sao lưu dữ liệu đã mã hóa và khôi phục bất cứ khi nào bạn cần.',
    GeneralText.privacyMaxTitle: 'Bảo vệ quyền riêng tư tối đa',
    GeneralText.privacyMaxDesc:
        'Không thu thập dữ liệu, không cần đăng ký tài khoản, sử dụng hoàn toàn ngoại tuyến.',

    GeneralText.proIntroTitle: 'Nâng cấp Pro để trải nghiệm trọn vẹn mọi tính năng',
    GeneralText.twoFactorAuthDesc: 'Mở khoá màn hình truy cập nhanh mã OTP (2FA)',
    GeneralText.statisticsDuplicatePasswordDesc: 'Phân tích và cảnh báo mật khẩu trùng lặp',
    GeneralText.customThemeColorDesc: 'Tùy chỉnh màu sắc giao diện theo ý thích',
    GeneralText.customIconDesc: 'Tạo và sử dụng icon cá nhân không giới hạn',
    GeneralText.passwordHistoryDetailDesc: 'Xem lại lịch sử thay đổi mật khẩu',

    GeneralText.updateNowText: 'Cập nhật ngay',
    GeneralText.notNowText: 'Để sau',
  };

  @override
  Map<String, String> get en => {
    GeneralText.aboutAppTitle: 'About the App',
    GeneralText.appVersion: 'Current Version',
    GeneralText.securityOfflineTitle: 'Absolute Security, Fully Offline',
    GeneralText.securityOfflineDesc:
        'Passwords are securely stored on your device, no network connection, AES-256 standard encryption.',
    GeneralText.categoryOrganizeTitle: 'Smart Category Management',
    GeneralText.categoryOrganizeDesc:
        'Easily categorize accounts, search quickly, and manage efficiently.',
    GeneralText.backupRestoreTitle: 'Safe Backup & Restore',
    GeneralText.backupRestoreDesc: 'Create encrypted data backups and restore whenever you need.',
    GeneralText.privacyMaxTitle: 'Maximum Privacy Protection',
    GeneralText.privacyMaxDesc:
        'No data collection, no account registration required, fully offline usage.',

    GeneralText.proIntroTitle: 'Upgrade to Pro for the full experience',
    GeneralText.twoFactorAuthDesc: 'Unlock the screen to quickly access OTP codes (2FA)',
    GeneralText.statisticsDuplicatePasswordDesc: 'Analyze and alert duplicate passwords',
    GeneralText.customThemeColorDesc: 'Customize interface colors as you like',
    GeneralText.customIconDesc: 'Create and use unlimited personal icons',
    GeneralText.passwordHistoryDetailDesc: 'Review password change history',

    GeneralText.updateNowText: 'Update now',
    GeneralText.notNowText: 'Later',
  };

  @override
  Map<String, String> get hi => {
    GeneralText.aboutAppTitle: 'एप्लिकेशन के बारे में',
    GeneralText.appVersion: 'वर्तमान संस्करण',
    GeneralText.securityOfflineTitle: 'पूर्ण ऑफलाइन सुरक्षा',
    GeneralText.securityOfflineDesc:
        'आपके डिवाइस पर पासवर्ड पूरी तरह से संग्रहीत हैं, नेटवर्क कनेक्शन नहीं है, AES-256 एन्क्रिप्शन',
    GeneralText.categoryOrganizeTitle: 'श्रेणियों के अनुसार समूहीकरण',
    GeneralText.categoryOrganizeDesc:
        'खाते श्रेणियों में समूहीकृत करें, तेजी से खोजें और प्रबंधित करें',
    GeneralText.backupRestoreTitle: 'बैकअप और पुनर्स्थापना',
    GeneralText.backupRestoreDesc:
        'डेटा का एन्क्रिप्टेड बैकअप बनाएं और जब चाहिए तो पुनर्स्थापित करें',
    GeneralText.privacyMaxTitle: 'अधिकतम गोपनीयता',
    GeneralText.privacyMaxDesc:
        'उपयोगकर्ता डेटा संग्रहण नहीं करता है, खाता पंजीकरण आवश्यक नहीं है, पूरी तरह से ऑफलाइन',

    GeneralText.proIntroTitle: 'प्रो संस्करण में बढ़ाएं और सभी सुविधाओं को खोलें',
    GeneralText.twoFactorAuthDesc: 'स्क्रीन अनलॉक करें और OTP (2FA) कोड तक तुरंत पहुँचें',
    GeneralText.statisticsDuplicatePasswordDesc: 'डुप्लिकेट पासवर्ड सुविधा',
    GeneralText.customThemeColorDesc: 'संपादित विषय रंग सुविधा',
    GeneralText.customIconDesc: 'संपादित आइकन सुविधा',
    GeneralText.passwordHistoryDetailDesc: 'पासवर्ड इतिहास विवरण सुविधा',

    GeneralText.updateNowText: 'अभी अपडेट करें',
    GeneralText.notNowText: 'बाद में',
  };

  @override
  Map<String, String> get id => {
    GeneralText.aboutAppTitle: 'Tentang Aplikasi',
    GeneralText.appVersion: 'Versi Saat Ini',
    GeneralText.securityOfflineTitle: 'Keamanan Mutlak, Sepenuhnya Offline',
    GeneralText.securityOfflineDesc:
        'Kata sandi disimpan dengan aman di perangkat Anda, tanpa koneksi jaringan, enkripsi standar AES-256.',
    GeneralText.categoryOrganizeTitle: 'Manajemen Kategori Cerdas',
    GeneralText.categoryOrganizeDesc:
        'Kategorikan akun dengan mudah, cari dengan cepat, dan kelola secara efisien.',
    GeneralText.backupRestoreTitle: 'Backup & Restore Aman',
    GeneralText.backupRestoreDesc:
        'Buat cadangan data terenkripsi dan pulihkan kapan saja Anda butuhkan.',
    GeneralText.privacyMaxTitle: 'Perlindungan Privasi Maksimal',
    GeneralText.privacyMaxDesc:
        'Tanpa pengumpulan data, tanpa pendaftaran akun, penggunaan sepenuhnya offline.',

    GeneralText.proIntroTitle: 'Upgrade ke Pro untuk pengalaman fitur lengkap',
    GeneralText.twoFactorAuthDesc: 'Lindungi akun dengan autentikasi dua faktor (2FA)',
    GeneralText.statisticsDuplicatePasswordDesc: 'Analisis dan peringatan kata sandi duplikat',
    GeneralText.customThemeColorDesc: 'Sesuaikan warna antarmuka sesuai keinginan',
    GeneralText.customIconDesc: 'Buat dan gunakan ikon pribadi tanpa batas',
    GeneralText.passwordHistoryDetailDesc: 'Lihat riwayat perubahan kata sandi',

    GeneralText.updateNowText: 'Perbarui sekarang',
    GeneralText.notNowText: 'Nanti',
  };

  @override
  Map<String, String> get ja => {
    GeneralText.aboutAppTitle: 'アプリについて',
    GeneralText.appVersion: '現在のバージョン',
    GeneralText.securityOfflineTitle: '完全オフラインの絶対的なセキュリティ',
    GeneralText.securityOfflineDesc: 'パスワードはデバイスに安全に保存され、ネットワーク接続なし、AES-256標準暗号化。',
    GeneralText.categoryOrganizeTitle: 'カテゴリでスマート管理',
    GeneralText.categoryOrganizeDesc: 'アカウントを簡単に分類し、素早く検索して効率的に管理。',
    GeneralText.backupRestoreTitle: '安全なバックアップと復元',
    GeneralText.backupRestoreDesc: '暗号化されたバックアップを作成し、必要なときに復元できます。',
    GeneralText.privacyMaxTitle: '最大限のプライバシー保護',
    GeneralText.privacyMaxDesc: 'データ収集なし、アカウント登録不要、完全オフライン利用。',

    GeneralText.proIntroTitle: 'Proにアップグレードしてすべての機能を体験',
    GeneralText.twoFactorAuthDesc: '画面ロックを解除してOTP（2FA）コードにすぐアクセス',
    GeneralText.statisticsDuplicatePasswordDesc: '重複パスワードを分析・警告',
    GeneralText.customThemeColorDesc: 'インターフェースの色を自由にカスタマイズ',
    GeneralText.customIconDesc: '無制限に個人アイコンを作成・使用',
    GeneralText.passwordHistoryDetailDesc: 'パスワード変更履歴を確認',

    GeneralText.updateNowText: '今すぐ更新',
    GeneralText.notNowText: '後で',
  };

  @override
  Map<String, String> get pt => {
    GeneralText.aboutAppTitle: 'Sobre o Aplicativo',
    GeneralText.appVersion: 'Versão Atual',
    GeneralText.securityOfflineTitle: 'Segurança absoluta, totalmente offline',
    GeneralText.securityOfflineDesc:
        'Senhas armazenadas com segurança no seu dispositivo, sem conexão de rede, criptografia padrão AES-256.',
    GeneralText.categoryOrganizeTitle: 'Gerenciamento inteligente por categorias',
    GeneralText.categoryOrganizeDesc:
        'Classifique contas facilmente, pesquise rapidamente e gerencie com eficiência.',
    GeneralText.backupRestoreTitle: 'Backup & Restauração Seguros',
    GeneralText.backupRestoreDesc: 'Crie backups criptografados e restaure sempre que precisar.',
    GeneralText.privacyMaxTitle: 'Proteção máxima de privacidade',
    GeneralText.privacyMaxDesc:
        'Sem coleta de dados, sem necessidade de cadastro, uso totalmente offline.',

    GeneralText.proIntroTitle: 'Atualize para o Pro para aproveitar todos os recursos',
    GeneralText.twoFactorAuthDesc:
        'Desbloqueie a tela para acessar rapidamente os códigos OTP (2FA)',
    GeneralText.statisticsDuplicatePasswordDesc: 'Analise e alerte sobre senhas duplicadas',
    GeneralText.customThemeColorDesc: 'Personalize as cores da interface como preferir',
    GeneralText.customIconDesc: 'Crie e use ícones pessoais ilimitados',
    GeneralText.passwordHistoryDetailDesc: 'Veja o histórico de alterações de senha',

    GeneralText.updateNowText: 'Atualizar agora',
    GeneralText.notNowText: 'Depois',
  };

  @override
  Map<String, String> get ru => {
    GeneralText.aboutAppTitle: 'О приложении',
    GeneralText.appVersion: 'Текущая версия',
    GeneralText.securityOfflineTitle: 'Абсолютная безопасность, полностью офлайн',
    GeneralText.securityOfflineDesc:
        'Пароли надежно хранятся на вашем устройстве, без подключения к сети, шифрование по стандарту AES-256.',
    GeneralText.categoryOrganizeTitle: 'Умное управление категориями',
    GeneralText.categoryOrganizeDesc:
        'Легко сортируйте аккаунты, быстро ищите и эффективно управляйте.',
    GeneralText.backupRestoreTitle: 'Безопасное резервное копирование и восстановление',
    GeneralText.backupRestoreDesc:
        'Создавайте зашифрованные резервные копии данных и восстанавливайте их в любое время.',
    GeneralText.privacyMaxTitle: 'Максимальная защита конфиденциальности',
    GeneralText.privacyMaxDesc: 'Без сбора данных, без регистрации аккаунта, полностью офлайн.',

    GeneralText.proIntroTitle: 'Обновите до Pro для полного доступа ко всем функциям',
    GeneralText.twoFactorAuthDesc: 'Защитите аккаунт двухфакторной аутентификацией (2FA)',
    GeneralText.statisticsDuplicatePasswordDesc: 'Анализ и предупреждение о повторяющихся паролях',
    GeneralText.customThemeColorDesc: 'Настройте цвета интерфейса по своему вкусу',
    GeneralText.customIconDesc:
        'Создавайте и используйте неограниченное количество собственных иконок',
    GeneralText.passwordHistoryDetailDesc: 'Просматривайте историю изменений паролей',

    GeneralText.updateNowText: 'Обновить сейчас',
    GeneralText.notNowText: 'Позже',
  };

  @override
  Map<String, String> get tr => {
    GeneralText.aboutAppTitle: 'Uygulama Hakkında',
    GeneralText.appVersion: 'Güncel Sürüm',
    GeneralText.securityOfflineTitle: 'Mutlak Güvenlik, Tamamen Çevrimdışı',
    GeneralText.securityOfflineDesc:
        'Parolalarınız cihazınızda güvenle saklanır, ağ bağlantısı yok, AES-256 standart şifreleme.',
    GeneralText.categoryOrganizeTitle: 'Akıllı Kategori Yönetimi',
    GeneralText.categoryOrganizeDesc:
        'Hesapları kolayca kategorilere ayırın, hızlıca arayın ve verimli yönetin.',
    GeneralText.backupRestoreTitle: 'Güvenli Yedekleme & Geri Yükleme',
    GeneralText.backupRestoreDesc:
        'Şifrelenmiş veri yedekleri oluşturun ve istediğiniz zaman geri yükleyin.',
    GeneralText.privacyMaxTitle: 'Maksimum Gizlilik Koruması',
    GeneralText.privacyMaxDesc:
        'Veri toplanmaz, hesap kaydı gerekmez, tamamen çevrimdışı kullanım.',

    GeneralText.proIntroTitle: 'Tüm özellikleri deneyimlemek için Pro\'ya yükseltin',
    GeneralText.twoFactorAuthDesc: 'Ekranı açarak OTP (2FA) koduna hızlıca erişin',
    GeneralText.statisticsDuplicatePasswordDesc: 'Yinelenen şifreleri analiz edin ve uyarı alın',
    GeneralText.customThemeColorDesc: 'Arayüz renklerini istediğiniz gibi özelleştirin',
    GeneralText.customIconDesc: 'Sınırsız kişisel simge oluşturun ve kullanın',
    GeneralText.passwordHistoryDetailDesc: 'Şifre değişiklik geçmişini görüntüleyin',

    GeneralText.updateNowText: 'Şimdi güncelle',
    GeneralText.notNowText: 'Daha sonra',
  };

  @override
  // TODO: implement es
  Map<String, String> get es => {
    GeneralText.aboutAppTitle: 'Acerca de la aplicación',
    GeneralText.appVersion: 'Versión actual',
    GeneralText.securityOfflineTitle: 'Seguridad absoluta, completamente sin conexión',
    GeneralText.securityOfflineDesc:
        'Las contraseñas se almacenan de forma segura en tu dispositivo, sin conexión a la red, con cifrado estándar AES-256.',
    GeneralText.categoryOrganizeTitle: 'Gestión inteligente de categorías',
    GeneralText.categoryOrganizeDesc:
        'Organiza fácilmente tus cuentas, busca rápidamente y gestiona con eficiencia.',
    GeneralText.backupRestoreTitle: 'Respaldo y restauración seguros',
    GeneralText.backupRestoreDesc:
        'Crea respaldos cifrados de tus datos y restáuralos cuando lo necesites.',
    GeneralText.privacyMaxTitle: 'Máxima protección de privacidad',
    GeneralText.privacyMaxDesc:
        'Sin recopilación de datos, sin necesidad de registrar una cuenta, uso completamente sin conexión.',

    GeneralText.proIntroTitle: 'Actualiza a Pro para disfrutar al máximo',
    GeneralText.twoFactorAuthDesc:
        'Desbloquea la pantalla para acceder rápidamente a los códigos OTP (2FA)',
    GeneralText.statisticsDuplicatePasswordDesc: 'Analiza y alerta sobre contraseñas duplicadas',
    GeneralText.customThemeColorDesc: 'Personaliza los colores de la interfaz como desees',
    GeneralText.customIconDesc: 'Crea y utiliza iconos personales ilimitados',
    GeneralText.passwordHistoryDetailDesc: 'Revisa el historial de cambios de contraseñas',

    GeneralText.updateNowText: 'Actualizar ahora',
    GeneralText.notNowText: 'Más tarde',
  };
}
