import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/settings/widgets/change_lang_widget.dart';
import 'package:cybersafe_pro/screens/settings/widgets/set_theme_color.dart';
import 'package:cybersafe_pro/screens/settings/widgets/set_theme_mode_widget.dart';
import 'package:cybersafe_pro/screens/settings/widgets/use_biometric_login.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTabletLayout extends StatelessWidget {
  const SettingsTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt'), centerTitle: true, elevation: 0, scrolledUnderElevation: 0, backgroundColor: Theme.of(context).colorScheme.surface),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security Section
                _buildSectionTitle(context, 'Bảo mật', Icons.security),
                Card(
                  margin: const EdgeInsets.only(bottom: 24, top: 8),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.password, color: Theme.of(context).colorScheme.primary, size: 24.sp),
                        title: Text('Thay đổi mật khẩu chính', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                        subtitle: Text('Cập nhật mật khẩu chính của bạn', style: TextStyle(fontSize: 13.sp)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          AppRoutes.navigateTo(context, AppRoutes.registerMasterPin, arguments: {"isChangePin": true});
                        },
                      ),
                      const Divider(height: 1),
                      const UseBiometricLogin(),
                    ],
                  ),
                ),

                // Interface Section
                _buildSectionTitle(context, 'Giao diện', Icons.palette),
                Card(
                  margin: const EdgeInsets.only(bottom: 24, top: 8),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [SetThemeModeWidget(), Divider(height: 1), const SetThemeColor()]),
                ),

                // Language Section
                _buildSectionTitle(context, 'Ngôn ngữ', Icons.translate),
                Card(
                  margin: const EdgeInsets.only(bottom: 24, top: 8),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const Column(children: [ChangeLangWidget()]),
                ),

                // About Section
                _buildSectionTitle(context, 'Thông tin ứng dụng', Icons.info_outline),
                Card(
                  margin: const EdgeInsets.only(bottom: 24, top: 8),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.privacy_tip_outlined, color: Theme.of(context).colorScheme.primary, size: 24.sp),
                        title: Text('Chính sách bảo mật', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Mở trang chính sách bảo mật
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.description_outlined, color: Theme.of(context).colorScheme.primary, size: 24.sp),
                        title: Text('Điều khoản sử dụng', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Mở trang điều khoản sử dụng
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.star_outline, color: Theme.of(context).colorScheme.primary, size: 24.sp),
                        title: Text('Đánh giá ứng dụng', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Mở trang đánh giá ứng dụng
                        },
                      ),
                      const Divider(height: 1),
                      AboutListTile(
                        icon: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary, size: 24.sp),
                        applicationName: 'CyberSafe Pro',
                        applicationVersion: '1.0.0',
                        applicationIcon: const FlutterLogo(size: 24),
                        applicationLegalese: '© 2023 CyberSafe Pro',
                        aboutBoxChildren: [
                          const SizedBox(height: 12),
                          Text('CyberSafe Pro là ứng dụng quản lý mật khẩu an toàn, giúp bạn lưu trữ và bảo vệ thông tin đăng nhập quan trọng.', style: TextStyle(fontSize: 14.sp)),
                        ],
                        dense: false,
                        child: Text('Phiên bản', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),

                // Danger Zone
                _buildSectionTitle(context, 'Khu vực nguy hiểm', Icons.warning_amber, color: Colors.red),
                Card(
                  margin: const EdgeInsets.only(bottom: 32, top: 8),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.delete_forever, color: Colors.red, size: 24.sp),
                        title: Text('Xóa tất cả dữ liệu', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.red)),
                        subtitle: Text('Xóa toàn bộ dữ liệu trong ứng dụng (không thể khôi phục)', style: TextStyle(fontSize: 13.sp)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showDeleteConfirmationDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 16, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: color ?? Theme.of(context).colorScheme.primary),
          SizedBox(width: 8.w),
          Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: color ?? Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xóa tất cả dữ liệu?'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bạn có chắc chắn muốn xóa tất cả dữ liệu? Hành động này không thể hoàn tác.', style: TextStyle(fontSize: 14.sp)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacity(0.3))),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Tất cả tài khoản, mật khẩu và dữ liệu khác sẽ bị xóa vĩnh viễn.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 13.sp))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp))),
              TextButton(
                onPressed: () async {
                  // Đóng dialog
                  Navigator.pop(context);

                  // Yêu cầu xác thực mật khẩu chính
                  final localAuthProvider = Provider.of<LocalAuthProvider>(context, listen: false);


                  // Hiển thị snackbar thông báo
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng xác thực để xóa tất cả dữ liệu')));
                },
                child: Text('Xóa tất cả', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 14.sp)),
              ),
            ],
          ),
    );
  }
}
