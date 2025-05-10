import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';
import 'layouts/desktop_layout.dart';

class DetailsAccountScreen extends StatefulWidget {
  final int accountId;

  const DetailsAccountScreen({super.key, required this.accountId});

  @override
  State<DetailsAccountScreen> createState() => _DetailsAccountScreenState();
}

class _DetailsAccountScreenState extends State<DetailsAccountScreen> {
  late AccountOjbModel accountOjbModel;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    AccountOjbModel? accountOjbModelLoaded = await AccountBox.getById(widget.accountId);
    if (accountOjbModelLoaded != null) {
      setState(() {
        accountOjbModel = accountOjbModelLoaded;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return DetailsAccountMobileLayout(accountOjbModel: accountOjbModel);
  }
}
