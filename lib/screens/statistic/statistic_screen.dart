import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticProvider>().init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return const DesktopLayout();
      case DeviceType.tablet:
        return const TabletLayout();
      case DeviceType.mobile:
        return const MobileLayout();
    }
  }
}
