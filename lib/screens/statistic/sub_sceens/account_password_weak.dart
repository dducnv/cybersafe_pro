
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/statistic_text.dart';
import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPasswordWeak extends StatelessWidget {
  const AccountPasswordWeak({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.trStatistic(StatisticText.totalAccountPasswordWeak)),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Consumer<StatisticProvider>(
          builder: (context, value, child) {
            return Center(child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h));
                // : ClipRRect(
                //   borderRadius: BorderRadius.circular(25),
                //   child: ListView.builder(
                //     itemCount: value.accountPasswordWeakByCategories.length,
                //     shrinkWrap: true,
                //     itemBuilder: (context, parentIndex) {
                //       return Visibility(
                //         visible: value.accountPasswordWeakByCategories[parentIndex].accounts.isNotEmpty,
                //         child: CardItem(
                //           title: "${value.accountPasswordWeakByCategories[parentIndex].categoryName} (${value.accountPasswordWeakByCategories[parentIndex].accounts.length})",
                //           items: value.accountPasswordWeakByCategories[parentIndex].accounts,
                //           itemBuilder: (item, index) {
                //             return AccountItemWidget(
                //               accountModel: item,
                //               isLastItem: index == value.accountPasswordWeakByCategories[parentIndex].accounts.length - 1,
                //               subIcon: Padding(padding: const EdgeInsets.all(14), child: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp)),
                //               onCallBackPop: () {},
                //             );
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // );
          },
        ),
      ),
    );
  }
}
