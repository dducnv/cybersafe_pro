import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/statistic/widgets/security_check_item.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/request_pro/request_pro.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class StatisticTabletLayout extends StatefulWidget {
  const StatisticTabletLayout({super.key});

  @override
  State<StatisticTabletLayout> createState() => _StatisticTabletLayoutState();
}

class _StatisticTabletLayoutState extends State<StatisticTabletLayout> {
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
      dataMap = {'Mạnh': strongPasswords, 'Yếu': weakPasswords, 'Trùng lặp': duplicatePasswords};

      // Tính điểm bảo mật (thang điểm 100)
      final strengthScore = (strongPasswords - weakPasswords) * (100 / totalAccounts);
      final duplicateScore = duplicatePasswords * (20 / totalAccounts);

      score = (strengthScore - duplicateScore).round().clamp(0, 100);
    });
  }

  @override
  void initState() {
    super.initState();
    dataMap = {'Mạnh': 0, 'Yếu': 0, 'Trùng lặp': 0};
    score = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 500), () {
      if (!mounted) return;
      _updateStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Consumer<StatisticProvider>(
        builder: (context, statisticProvider, child) {
          // Cập nhật thống kê mỗi khi provider thay đổi
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _updateStatistics();
          });
          
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Text(
                        'Tổng quan',
                        style: CustomTextStyle.regular(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Biểu đồ thống kê
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Biểu đồ tròn
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 300.h,
                                child: PieChart(
                                  dataMap: dataMap,
                                  animationDuration: const Duration(milliseconds: 800),
                                  chartLegendSpacing: 32.h,
                                  chartRadius: 170.h,
                                  colorList: const [Colors.blueAccent, Colors.redAccent, Colors.yellowAccent],
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.ring,
                                  ringStrokeWidth: 40,
                                  centerWidget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("$score", style: CustomTextStyle.regular(fontSize: 35.sp, fontWeight: FontWeight.bold)),
                                      Text("Điểm bảo mật", style: CustomTextStyle.regular(fontSize: 11.sp, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  legendOptions: LegendOptions(
                                    showLegendsInRow: true,
                                    legendPosition: LegendPosition.bottom,
                                    showLegends: true,
                                    legendTextStyle: CustomTextStyle.regular(fontWeight: FontWeight.w500, fontSize: 16.sp),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: false,
                                    showChartValues: false,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: false,
                                    decimalPlaces: 1,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Danh sách các chỉ số
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SecurityCheckItem(
                                    title: "Tổng số tài khoản", 
                                    value: statisticProvider.totalAccount, 
                                    icon: Icons.lock
                                  ),
                                  const SizedBox(height: 16),
                                  SecurityCheckItem(
                                    title: "Tổng số mật khẩu mạnh", 
                                    value: statisticProvider.totalAccountPasswordStrong, 
                                    icon: Icons.security_outlined
                                  ),
                                  const SizedBox(height: 16),
                                  SecurityCheckItem(
                                    title: "Tổng số mật khẩu yếu",
                                    value: statisticProvider.totalAccountPasswordWeak,
                                    icon: Icons.warning_rounded,
                                    subIcon: Icons.arrow_forward_ios_rounded,
                                    onTap: () {
                                      Navigator.pushNamed(context, AppRoutes.accountPasswordWeak);
                                    },
                                  ),
                                  const SizedBox(height: 16),
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
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Phân bố theo danh mục
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text(
                        'Phân bố theo danh mục',
                        style: CustomTextStyle.regular(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        final categories = categoryProvider.categories;
                        
                        return categories.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    'Chưa có danh mục nào',
                                    style: CustomTextStyle.regular(
                                      fontSize: 16.sp,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              )
                            : _buildCategoryDistribution(context, categories);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryDistribution(BuildContext context, List<CategoryDriftModelData> categories) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    int totalAccounts = 0;
    for (final category in categories) {
      totalAccounts += categoryProvider.mapCategoryIdTotalAccount[category.id] ?? 0;
    }
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = categories[index];
        final accountCount = categoryProvider.mapCategoryIdTotalAccount[category.id] ?? 0;
        final percentage = totalAccounts > 0
            ? (accountCount / totalAccounts * 100).toInt()
            : 0;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.categoryName,
                  style: CustomTextStyle.regular(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '$accountCount tài khoản',
                  style: CustomTextStyle.regular(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        height: 12,
                        width: percentage > 0 ? (percentage / 100) * double.infinity : 0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$percentage%',
                    style: CustomTextStyle.regular(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
