import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/statistic/widgets/security_check_item.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/request_pro/request_pro.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  Map<String, double> dataMap = {};
  int score = 0;

  void _updateStatistics() {
    if (!mounted) return;
    
    final statisticProvider = Provider.of<StatisticProvider>(context, listen: false);
    final totalAccounts = statisticProvider.totalAccount.toDouble();
    if (totalAccounts == 0) return;

    final strongPasswords = statisticProvider.totalAccountPasswordStrong.toDouble();
    final weakPasswords = statisticProvider.totalAccountPasswordWeak.toDouble();
    final duplicatePasswords = statisticProvider.totalAccountSamePassword.toDouble();

    setState(() {
      dataMap = {
        'Mạnh': strongPasswords,
        'Yếu': weakPasswords,
        'Trùng lặp': duplicatePasswords,
      };

      // Tính điểm bảo mật (thang điểm 100)
      final strengthScore = (strongPasswords - weakPasswords) * (100 / totalAccounts);
      final duplicateScore = duplicatePasswords * (20 / totalAccounts);
      
      score = (strengthScore - duplicateScore).round().clamp(0, 100);
    });
  }

  @override
  void initState() {
    super.initState();
    dataMap = {
      'Mạnh': 0,
      'Yếu': 0,
      'Trùng lặp': 0,
    };
    score = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
      ),
      body: Consumer<StatisticProvider>(
        builder: (context, statisticProvider, child) {
          // Cập nhật thống kê mỗi khi provider thay đổi
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _updateStatistics();
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
                                style: TextStyle(
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Điểm bảo mật",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          legendOptions: LegendOptions(
                            showLegendsInRow: true,
                            legendPosition: LegendPosition.bottom,
                            showLegends: true,
                            legendTextStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.sp),
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
                  )),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SecurityCheckItem(
                              title: "Tổng số tài khoản",
                              value:statisticProvider.totalAccount,
                              icon: Icons.lock,
                            ),
                            const SizedBox(height: 10),
                            SecurityCheckItem(
                              title: "Tổng số mật khẩu mạnh",
                              value: statisticProvider.totalAccountPasswordStrong,
                              icon: Icons.security_outlined,
                            ),
                            const SizedBox(height: 10),
                            SecurityCheckItem(
                              title: "Tổng số mật khẩu yếu",
                              value: statisticProvider.totalAccountPasswordWeak,
                              icon: Icons.warning_rounded,
                              subIcon: Icons.arrow_forward_ios_rounded,
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.accountPasswordWeak);
                              },
                            ),
                            const SizedBox(height: 10),
                            RequestPro(
                              child: SecurityCheckItem(
                                title: "Tổng số mật khẩu trùng lặp",
                                value: statisticProvider.accountSamePassword.length,
                                icon: Icons.copy_rounded,
                                subIcon: Icons.arrow_forward_ios_rounded,
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.accountSamePassword);
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
