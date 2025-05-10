import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layouts/mobile_layout.dart';

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
    return const StatisticMobileLayout();
  }
}
