import '../../base_locale.dart';
import '../../app_locale.dart';

class HomeLocale extends BaseLocale {
  HomeLocale(super.appLocale);

  // Keys cho màn hình home
  static const String dashboard = 'dashboard';
  static const String securityStatus = 'securityStatus';
  static const String passwordHealth = 'passwordHealth';
  static const String dataProtection = 'dataProtection';

  @override
  Map<String, dynamic> get vi => {
    dashboard: 'Bảng điều khiển',
    securityStatus: 'Trạng thái bảo mật',
    passwordHealth: 'Sức khỏe mật khẩu',
    dataProtection: 'Bảo vệ dữ liệu',
  };

  @override
  Map<String, dynamic> get en => {
    dashboard: 'Dashboard',
    securityStatus: 'Security Status',
    passwordHealth: 'Password Health',
    dataProtection: 'Data Protection',
  };
} 