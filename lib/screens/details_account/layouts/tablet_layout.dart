import 'package:cybersafe_pro/database/models/account_ojb_model.dart';

import 'package:flutter/material.dart';

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
              Navigator.pushNamed(context, '/update-account', arguments: {"accountId": accountOjbModel.id});
            },
          ),
          IconButton(icon: const Icon(Icons.delete), tooltip: 'Xóa', onPressed: () {}),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Thông tin đầu trang
              const SizedBox(height: 24),

              // Các hành động nhanh
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
