import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountDetailActions extends StatelessWidget {
  final AccountOjbModel account;
  final _encryptService = EncryptAppDataService.instance;

  AccountDetailActions({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (account.email != null && account.email!.isNotEmpty)
              _buildActionButton(
                context: context,
                icon: Icons.copy,
                label: 'Sao chép Email',
                onPressed: () => _copyToClipboard(context, account.email!, 'Email đã được sao chép', isPassword: false),
              ),
            if (account.password != null && account.password!.isNotEmpty)
              _buildActionButton(
                context: context,
                icon: Icons.copy,
                label: 'Sao chép Mật khẩu',
                onPressed: () => _copyToClipboard(context, account.password!, 'Mật khẩu đã được sao chép', isPassword: true),
              ),
            if (account.totp.target != null)
              _buildActionButton(
                context: context,
                icon: Icons.security,
                label: 'Mã OTP',
                onPressed: () => _showOTPDialog(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String message, {bool isPassword = false}) async {
    String? decryptedText;
    
    if (isPassword) {
      decryptedText = await _encryptService.decryptPassword(text);
    } else {
      decryptedText = await _encryptService.decryptInfo(text);
    }
    
    await Clipboard.setData(ClipboardData(text: decryptedText));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    }

  void _showOTPDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mã xác thực'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Hiển thị mã OTP với đồng hồ đếm ngược
            Text(
              'Chức năng hiển thị mã OTP đang được phát triển',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
} 