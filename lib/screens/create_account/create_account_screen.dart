// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/device_type.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class CreateAccountScreen extends StatefulWidget {
  final bool isUpdate;
  final int? accountId;
  const CreateAccountScreen({super.key, this.isUpdate = false, this.accountId});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadAccount();
  }

  Future<void> loadAccount() async {
    if (!widget.isUpdate && widget.accountId == null) {
      _resetForm();
      return;
    }

    try {
      _resetForm();
      await _setLoadingState(true);

      final accountOjbModel = await _loadAndDecryptAccount();
      if (accountOjbModel != null && mounted) {
        context.read<AccountFormProvider>().loadAccountToForm(accountOjbModel);
      }
    } finally {
      if (mounted) {
        await _setLoadingState(false);
      }
    }
  }

  void _resetForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountFormProvider>().resetForm();
    });
  }

  Future<void> _setLoadingState(bool loading) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = loading);
    });
  }

  Future<AccountOjbModel?> _loadAndDecryptAccount() async {
    if (widget.accountId == null) return null;

    final accountProvider = context.read<AccountProvider>();
    final account = await AccountBox.getById(widget.accountId!);
    
    if (account == null || !mounted) return null;
    return accountProvider.decryptAccount(account);
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const CreateAccountDesktopLayout();
      case DeviceType.tablet:
        return const CreateAccountMobileLayout();
      case DeviceType.mobile:
        return const CreateAccountMobileLayout();
    }
  }
}
