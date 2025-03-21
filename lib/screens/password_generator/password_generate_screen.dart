import 'package:cybersafe_pro/providers/password_generate_provider.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';
import 'layouts/desktop_layout.dart';

class PasswordGenerateScreen extends StatefulWidget {
  final bool isFromForm;
  final Function(String)? onPasswordChanged;
  const PasswordGenerateScreen({super.key, this.isFromForm = false, this.onPasswordChanged});

  @override
  State<PasswordGenerateScreen> createState() => _PasswordGenerateScreenState();
}

class _PasswordGenerateScreenState extends State<PasswordGenerateScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PasswordGenerateProvider>().init(widget.isFromForm, widget.onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const PasswordGenerateDesktopLayout();
      case DeviceType.tablet:
        return const PasswordGenarateTabletLayout();
      case DeviceType.mobile:
        return const PasswordGenerateMobileLayout();
    }
  }
}
