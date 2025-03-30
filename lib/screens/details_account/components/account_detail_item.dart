import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountDetailItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isPassword;
  final _encryptService = EncryptAppDataService.instance;

  AccountDetailItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                DecryptText(
                  value: value,
                  decryptTextType: isPassword ? DecryptTextType.password : DecryptTextType.info,
                  showLoading: true,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Sao chép',
            onPressed: () => _copyValue(context),
          ),
        ],
      ),
    );
  }

  void _copyValue(BuildContext context) async {
    String? decryptedValue;
    
    if (isPassword) {
      decryptedValue = await _encryptService.decryptPassword(value);
    } else {
      decryptedValue = await _encryptService.decryptInfo(value);
    }
    
    await Clipboard.setData(ClipboardData(text: decryptedValue));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title đã được sao chép'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    }
} 