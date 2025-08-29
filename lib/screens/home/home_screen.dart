import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/main.dart';
import 'package:cybersafe_pro/providers/home_provider.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/device_type.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int numberLogins;
  @override
  void initState() {
    super.initState();
    reviewApp();
    loadData();
    // DeepLinkHandler().initialize();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoadingDialog(animationReverse: false);
      await context.read<HomeProvider>().initData();
      SecureApplicationUtil.instance.unpause();
      hideLoadingDialog();
    });
  }

  reviewApp() async {
    numberLogins = await SecureStorage.instance.readInt(SecureStorageKey.numberLogin) ?? 0;
    await SecureStorage.instance.saveInt(SecureStorageKey.numberLogin, numberLogins + 1);
    if (numberLogins != 0 && numberLogins % 2 == 0) {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const HomeDesktopLayout();
      case DeviceType.tablet:
        return const HomeMobileLayout();
      case DeviceType.mobile:
        return const HomeMobileLayout();
    }
  }
}
