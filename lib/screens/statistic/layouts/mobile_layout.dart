import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/statistic_text.dart';
import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/statistic/widgets/security_check_item.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/request_pro/request_pro.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class StatisticMobileLayout extends StatefulWidget {
  const StatisticMobileLayout({super.key});

  @override
  State<StatisticMobileLayout> createState() => _StatisticMobileLayoutState();
}

class _StatisticMobileLayoutState extends State<StatisticMobileLayout> {
  Map<String, double> dataMap = {};
  int score = 0;

  void _updateStatistics() {
    if (!mounted) return;

    final statisticProvider = Provider.of<StatisticProvider>(context, listen: false);
    final totalAccounts = statisticProvider.totalAccount.toDouble();

    final strongPasswords = statisticProvider.totalAccountPasswordStrong.toDouble();
    final weakPasswords = statisticProvider.totalAccountPasswordWeak.toDouble();
    final duplicatePasswords = statisticProvider.totalAccountSamePassword.toDouble();

    setState(() {
      dataMap = {
        context.trSafe(StatisticText.strongPasswords): strongPasswords,
        context.trSafe(StatisticText.weakPasswords): weakPasswords,
        context.trSafe(StatisticText.duplicatePasswords): duplicatePasswords,
      };

      // Tính điểm bảo mật (thang điểm 100)
      if (totalAccounts == 0) {
        score = 0; // Không có tài khoản = 0 điểm
      } else {
        // Điểm cơ bản dựa trên tỷ lệ mật khẩu mạnh
        final strongPasswordRatio = strongPasswords / totalAccounts;
        final baseScore = strongPasswordRatio * 70; // Tối đa 70 điểm cho mật khẩu mạnh

        // Trừ điểm cho mật khẩu yếu
        final weakPasswordRatio = weakPasswords / totalAccounts;
        final weakPenalty = weakPasswordRatio * 30; // Trừ tối đa 30 điểm cho mật khẩu yếu

        // Trừ điểm cho mật khẩu trùng lặp
        final duplicateRatio = duplicatePasswords / totalAccounts;
        final duplicatePenalty = duplicateRatio * 20; // Trừ tối đa 20 điểm cho mật khẩu trùng
        final finalScore = baseScore - weakPenalty - duplicatePenalty;
        score = finalScore.round().clamp(0, 100);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    dataMap = {
      context.trSafe(StatisticText.strongPasswords): 0,
      context.trSafe(StatisticText.weakPasswords): 0,
      context.trSafe(StatisticText.duplicatePasswords): 0,
    };
    score = 0;
    _updateStatistics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final statisticProvider = Provider.of<StatisticProvider>(context, listen: false);
      if (!statisticProvider.isLoading && statisticProvider.statistics != null) {
        _updateStatistics();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    GlobalKeys.appRootNavigatorKey.currentContext?.read<StatisticProvider>().reset(notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.trStatistic(StatisticText.title),
          style: CustomTextStyle.regular(fontSize: 18.sp),
        ),
      ),
      body: Consumer<StatisticProvider>(
        builder: (context, statisticProvider, child) {
          // Cập nhật thống kê mỗi khi provider thay đổi
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !statisticProvider.isLoading) {
              _updateStatistics();
            }
          });

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ColoredBox(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          child: PieChart(
                            dataMap: dataMap,
                            animationDuration: const Duration(milliseconds: 800),
                            chartLegendSpacing: 32.h,
                            chartRadius: 170.h,
                            colorList: const [
                              Colors.blueAccent,
                              Colors.redAccent,
                              Colors.yellowAccent,
                            ],
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 40,
                            centerWidget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$score",
                                  style: CustomTextStyle.regular(
                                    fontSize: 35.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  context.trStatistic(StatisticText.securityScore),
                                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            legendOptions: LegendOptions(
                              showLegendsInRow: true,
                              legendPosition: LegendPosition.bottom,
                              showLegends: true,
                              legendTextStyle: CustomTextStyle.regular(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: false,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                            // gradientList: ---To add gradient colors---
                            // emptyColorGradient: ---Empty Color gradient---
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SecurityCheckItem(
                              title: context.trStatistic(StatisticText.totalAccount),
                              value: statisticProvider.totalAccount,
                              icon: Icons.lock,
                            ),
                            const SizedBox(height: 10),
                            SecurityCheckItem(
                              title: context.trStatistic(StatisticText.totalAccountPasswordStrong),
                              value: statisticProvider.totalAccountPasswordStrong,
                              icon: Icons.security_outlined,
                            ),
                            const SizedBox(height: 10),
                            SecurityCheckItem(
                              title: context.trStatistic(StatisticText.totalAccountPasswordWeak),
                              value: statisticProvider.totalAccountPasswordWeak,
                              icon: Icons.warning_rounded,
                              subIcon: Icons.arrow_forward_ios_rounded,
                              onTap: () {
                                AppRoutes.navigateTo(context, AppRoutes.accountPasswordWeak);
                              },
                            ),
                            const SizedBox(height: 10),
                            RequestPro(
                              child: SecurityCheckItem(
                                title: context.trStatistic(StatisticText.totalAccountSamePassword),
                                value: statisticProvider.accountSamePassword.length,
                                icon: Icons.copy_rounded,
                                subIcon: Icons.arrow_forward_ios_rounded,
                                onTap: () {
                                  AppRoutes.navigateTo(context, AppRoutes.accountSamePassword);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
