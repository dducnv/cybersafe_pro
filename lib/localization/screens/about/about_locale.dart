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
    GeneralText.aboutAppTitle: 'Giới thiệu ứng dụng',
    GeneralText.appVersion: 'Phiên bản ứng dụng',
    GeneralText.securityOfflineTitle: 'Bảo mật offline hoàn toàn',
    GeneralText.securityOfflineDesc: 'Lưu trữ mật khẩu hoàn toàn trên thiết bị, không có kết nối mạng, mã hóa AES-256',
    GeneralText.categoryOrganizeTitle: 'Tổ chức theo danh mục',
    GeneralText.categoryOrganizeDesc: 'Phân loại tài khoản vào các danh mục, tìm kiếm nhanh và quản lý dễ dàng',
    GeneralText.backupRestoreTitle: 'Sao lưu và khôi phục',
    GeneralText.backupRestoreDesc: 'Tạo bản sao lưu mã hóa của dữ liệu và khôi phục khi cần thiết',
    GeneralText.privacyMaxTitle: 'Riêng tư tối đa',
    GeneralText.privacyMaxDesc: 'Không thu thập dữ liệu người dùng, không yêu cầu đăng ký tài khoản, hoàn toàn offline',

    GeneralText.proIntroTitle: 'Nâng cấp lên phiên bản Pro để mở khóa tất cả tính năng',
    GeneralText.twoFactorAuthDesc: 'Tính năng lưu mã xác thực 2 lớp',
    GeneralText.statisticsDuplicatePasswordDesc: 'Tính năng thống kê tài khoản trùng lặp',
    GeneralText.customThemeColorDesc: 'Tuỳ chỉnh màu ứng dụng',
    GeneralText.customIconDesc: 'Tuỳ chỉnh icon không giới hạn',
    GeneralText.passwordHistoryDetailDesc: 'Xem lịch sử mật khẩu',

    GeneralText.updateNowText: 'Cập nhật ngay',
    GeneralText.notNowText: 'Để sau',
  };

  @override
  Map<String, String> get en => {
    GeneralText.aboutAppTitle: 'About App',
    GeneralText.appVersion: 'App Version',
    GeneralText.securityOfflineTitle: 'Complete offline security',
    GeneralText.securityOfflineDesc: 'Store passwords completely on your device, no network connection, AES-256 encryption',
    GeneralText.categoryOrganizeTitle: 'Organize by categories',
    GeneralText.categoryOrganizeDesc: 'Organize accounts into categories, search quickly and manage easily',
    GeneralText.backupRestoreTitle: 'Backup and restore',
    GeneralText.backupRestoreDesc: 'Create encrypted backup of data and restore when needed',
    GeneralText.privacyMaxTitle: 'Maximum privacy',
    GeneralText.privacyMaxDesc: 'No user data collection, no account registration required, completely offline',

    GeneralText.proIntroTitle: 'Upgrade to the Pro version to unlock all features',
    GeneralText.twoFactorAuthDesc: 'Two-factor authentication feature',
    GeneralText.statisticsDuplicatePasswordDesc: 'Statistics duplicate password feature',
    GeneralText.customThemeColorDesc: 'Custom theme color feature',
    GeneralText.customIconDesc: 'Custom icon feature',
    GeneralText.passwordHistoryDetailDesc: 'Password history detail feature',

    GeneralText.updateNowText: 'Update now',
    GeneralText.notNowText: 'Not now',
  };

  @override
  Map<String, String> get hi => {
    GeneralText.aboutAppTitle: 'आवश्यकताएं',
    GeneralText.appVersion: 'वर्तमान संस्करण',
    GeneralText.securityOfflineTitle: 'पूर्ण ऑफलाइन सुरक्षा',
    GeneralText.securityOfflineDesc: 'आपके डिवाइस पर पासवर्ड पूरी तरह से संग्रहीत हैं, नेटवर्क कनेक्शन नहीं है, AES-256 एन्क्रिप्शन',
    GeneralText.categoryOrganizeTitle: 'श्रेणियों के अनुसार समूहीकरण',
    GeneralText.categoryOrganizeDesc: 'खाते श्रेणियों में समूहीकृत करें, तेजी से खोजें और प्रबंधित करें',
    GeneralText.backupRestoreTitle: 'बैकअप और पुनर्स्थापना',
    GeneralText.backupRestoreDesc: 'डेटा का एन्क्रिप्टेड बैकअप बनाएं और जब चाहिए तो पुनर्स्थापित करें',
    GeneralText.privacyMaxTitle: 'अधिकतम गोपनीयता',
    GeneralText.privacyMaxDesc: 'उपयोगकर्ता डेटा संग्रहण नहीं करता है, खाता पंजीकरण आवश्यक नहीं है, पूरी तरह से ऑफलाइन',

    GeneralText.proIntroTitle: 'प्रो संस्करण में बढ़ाएं और सभी सुविधाओं को खोलें',
    GeneralText.twoFactorAuthDesc: 'दो-कारक प्रमाणीकरण सुविधा',
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
    GeneralText.appVersion: 'Versi Aplikasi',
    GeneralText.securityOfflineTitle: 'Keamanan Offline Penuh',
    GeneralText.securityOfflineDesc: 'Simpan kata sandi penuh di perangkat Anda, tidak ada koneksi jaringan, enkripsi AES-256',
    GeneralText.categoryOrganizeTitle: 'Mengorganisasi Berdasarkan Kategori',
    GeneralText.categoryOrganizeDesc: 'Mengorganisasi akun ke dalam kategori, cari dengan cepat dan kelola dengan mudah',
    GeneralText.backupRestoreTitle: 'Backup dan Restore',
    GeneralText.backupRestoreDesc: 'Buat salinan cadangan terenkripsi dari data dan kembalikan kapan saja diperlukan',
    GeneralText.privacyMaxTitle: 'Privasi Maksimal',
    GeneralText.privacyMaxDesc: 'Tidak mengumpulkan data pengguna, tidak memerlukan pendaftaran akun, seluruhnya offline',

    GeneralText.proIntroTitle: 'Upgrade ke versi Pro untuk membuka semua fitur',
    GeneralText.twoFactorAuthDesc: 'Fitur otentikasi dua faktor',
    GeneralText.statisticsDuplicatePasswordDesc: 'Fitur statistik duplikat password',
    GeneralText.customThemeColorDesc: 'Fitur pengaturan tema',
    GeneralText.customIconDesc: 'Fitur pengaturan ikon',
    GeneralText.passwordHistoryDetailDesc: 'Fitur detail riwayat password',

    GeneralText.updateNowText: 'Update sekarang',
    GeneralText.notNowText: 'Nanti',
  };

  @override
  Map<String, String> get ja => {
    GeneralText.aboutAppTitle: 'アプリの概要',
    GeneralText.appVersion: 'アプリのバージョン',
    GeneralText.securityOfflineTitle: '完全オフラインセキュリティ',
    GeneralText.securityOfflineDesc: 'パスワードを完全にデバイスに保存し、ネットワーク接続がなく、AES-256暗号化',
    GeneralText.categoryOrganizeTitle: 'カテゴリ別に整理',
    GeneralText.categoryOrganizeDesc: 'アカウントをカテゴリに分類し、迅速に検索して管理しやすい',
    GeneralText.backupRestoreTitle: 'バックアップと復元',
    GeneralText.backupRestoreDesc: 'データの暗号化バックアップを作成し、必要なときに復元できる',
    GeneralText.privacyMaxTitle: '最大のプライバシー',
    GeneralText.privacyMaxDesc: 'ユーザーのデータ収集を行わない、アカウント登録を要求しない、完全にオフライン',

    GeneralText.proIntroTitle: 'プロバージョンにアップグレードしてすべての機能を開ける',
    GeneralText.twoFactorAuthDesc: '二要素認証機能',
    GeneralText.statisticsDuplicatePasswordDesc: '重複パスワード統計機能',
    GeneralText.customThemeColorDesc: 'カスタムテーマカラー機能',
    GeneralText.customIconDesc: 'カスタムアイコン機能',
    GeneralText.passwordHistoryDetailDesc: 'パスワード履歴詳細機能',

    GeneralText.updateNowText: '今すぐ更新',
    GeneralText.notNowText: '後で',
  };

  @override
  Map<String, String> get pt => {
    GeneralText.aboutAppTitle: 'Sobre o Aplicativo',
    GeneralText.appVersion: 'Versão do Aplicativo',
    GeneralText.securityOfflineTitle: 'Segurança Offline Completa',
    GeneralText.securityOfflineDesc: 'Armazene senhas completamente no seu dispositivo, sem conexão de rede, criptografia AES-256',
    GeneralText.categoryOrganizeTitle: 'Organizar por Categorias',
    GeneralText.categoryOrganizeDesc: 'Organize accounts into categories, search quickly and manage easily',
    GeneralText.backupRestoreTitle: 'Backup and restore',
    GeneralText.backupRestoreDesc: 'Create encrypted backup of data and restore when needed',
    GeneralText.privacyMaxTitle: 'Máxima privacidade',
    GeneralText.privacyMaxDesc: 'Não coleta dados do usuário, não requer registro de conta, totalmente offline',

    GeneralText.proIntroTitle: 'Upgrade to the Pro version to unlock all features',
    GeneralText.twoFactorAuthDesc: 'Two-factor authentication feature',
    GeneralText.statisticsDuplicatePasswordDesc: 'Statistics duplicate password feature',
    GeneralText.customThemeColorDesc: 'Custom theme color feature',
    GeneralText.customIconDesc: 'Custom icon feature',
    GeneralText.passwordHistoryDetailDesc: 'Password history detail feature',

    GeneralText.updateNowText: 'Atualizar agora',
    GeneralText.notNowText: 'Mais tarde',
  };

  @override
  Map<String, String> get ru => {
    GeneralText.aboutAppTitle: 'О приложении',
    GeneralText.appVersion: 'Версия приложения',
    GeneralText.securityOfflineTitle: 'Полная автономная безопасность',
    GeneralText.securityOfflineDesc: 'Храните пароли полностью на своем устройстве, без сетевого подключения, шифрование AES-256',
    GeneralText.categoryOrganizeTitle: 'Организация по категориям',
    GeneralText.categoryOrganizeDesc: 'Организуйте учетные записи в категории, быстро найдите и управляйте ими',
    GeneralText.backupRestoreTitle: 'Резервное копирование и восстановление',
    GeneralText.backupRestoreDesc: 'Создайте зашифрованную резервную копию данных и восстановите при необходимости',
    GeneralText.privacyMaxTitle: 'Максимальная конфиденциальность',
    GeneralText.privacyMaxDesc: 'Не собирает данные пользователей, не требует регистрации учетной записи, полностью автономна',

    GeneralText.proIntroTitle: 'Upgrade to the Pro version to unlock all features',
    GeneralText.twoFactorAuthDesc: 'Two-factor authentication feature',
    GeneralText.statisticsDuplicatePasswordDesc: 'Statistics duplicate password feature',
    GeneralText.customThemeColorDesc: 'Custom theme color feature',
    GeneralText.customIconDesc: 'Custom icon feature',
    GeneralText.passwordHistoryDetailDesc: 'Password history detail feature',

    GeneralText.updateNowText: 'Обновить сейчас',
    GeneralText.notNowText: 'Позже',
  };
}
