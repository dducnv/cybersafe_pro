import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/account_detail_actions.dart';
import '../components/account_detail_header.dart';
import '../components/account_detail_item.dart';

class DetailsAccountTabletLayout extends StatelessWidget {
  final AccountOjbModel accountOjbModel;
  const DetailsAccountTabletLayout({super.key, required this.accountOjbModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tài khoản'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Chỉnh sửa',
            onPressed: () {
              Navigator.pushNamed(
                context, 
                '/update-account',
                arguments: {"accountId": accountOjbModel.id},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Xóa',
            onPressed: () {
              _showDeleteConfirmationDialog(context, accountOjbModel.id.toString());
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Thông tin đầu trang
              AccountDetailHeader(account: accountOjbModel, category: accountOjbModel.category.target),
              
              const SizedBox(height: 24),
              
              // Các hành động nhanh
              AccountDetailActions(account: accountOjbModel),
              
              const SizedBox(height: 24),
              
              // Danh sách thông tin chi tiết
              Expanded(
                child: _buildAccountDetails(accountOjbModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDetails(AccountOjbModel account) {
    // Danh sách các trường thông tin
    final List<Map<String, dynamic>> detailItems = [
      if (account.email?.isNotEmpty == true)
        {'title': 'Tên đăng nhập', 'value': account.email!, 'icon': Icons.person, 'isPassword': false},
      if (account.password?.isNotEmpty == true)
        {'title': 'Mật khẩu', 'value': account.password!, 'icon': Icons.lock, 'isPassword': true},
      if (account.notes?.isNotEmpty == true)
        {'title': 'Ghi chú', 'value': account.notes!, 'icon': Icons.note, 'isPassword': false},
    ];

    // Thêm các trường tùy chỉnh
    if (account.customFields.isNotEmpty) {
      for (var field in account.customFields) {
        detailItems.add({
          'title': field.name,
          'value': field.value,
          'icon': Icons.article,
          'isPassword': field.typeField == 'password',
        });
      }
    }

    if (detailItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48.sp,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Không có thông tin chi tiết',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: detailItems.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = detailItems[index];
          return AccountDetailItem(
            title: item['title'],
            value: item['value'],
            icon: item['icon'],
            isPassword: item['isPassword'],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String accountId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tài khoản'),
        content: const Text('Bạn có chắc chắn muốn xóa tài khoản này? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              // Xóa tài khoản
              final AccountOjbModel account = context.read<AccountProvider>().accountList.firstWhere(
                (acc) => acc.id.toString() == accountId,
                orElse: () => null as AccountOjbModel,
              );
              
              await context.read<AccountProvider>().deleteAccount(account);
              
              // Cập nhật danh sách danh mục
              if (context.mounted) {
                context.read<CategoryProvider>().refresh();
              
                // Quay về màn hình trước
                Navigator.pop(context); // Đóng dialog
                Navigator.pop(context); // Quay về màn hình trước
              }
                        },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}