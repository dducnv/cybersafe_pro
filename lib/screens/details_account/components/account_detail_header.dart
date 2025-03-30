import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:flutter/material.dart';

class AccountDetailHeader extends StatelessWidget {
  final AccountOjbModel account;
  final CategoryOjbModel? category;

  const AccountDetailHeader({
    super.key,
    required this.account,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Icon và tên tài khoản
            Row(
              children: [
                Container(
                  width: 60.h,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: IconShowComponent(
                      account: account,
                      width: 40.h,
                      height: 40.h,
                      isDecrypted: false,
                      textStyle: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecryptText(
                        showLoading: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                        value: account.title,
                        decryptTextType: DecryptTextType.info,
                      ),
                      if (category != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            category!.categoryName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      if (account.email != null && account.email!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: DecryptText(
                            showLoading: true,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            value: account.email!,
                            decryptTextType: DecryptTextType.info,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Thông tin thêm có thể hiển thị ở đây
            if (account.updatedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.update,
                      size: 14.sp,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cập nhật: ${_formatDate(account.updatedAt!)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 