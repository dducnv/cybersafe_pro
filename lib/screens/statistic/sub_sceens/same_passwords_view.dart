import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/statistic_text.dart';
import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/account_list_tile_widgets.dart';
import 'package:cybersafe_pro/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SamePasswordsView extends StatelessWidget {
  const SamePasswordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.trStatistic(StatisticText.totalAccountSamePassword)), elevation: 0, scrolledUnderElevation: 0, backgroundColor: Theme.of(context).colorScheme.surface),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Consumer<StatisticProvider>(
          builder: (context, value, child) {
            return value.totalAccountSamePassword == 0
                ? Center(child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h))
                : ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: ListView.builder(
                    itemCount: value.accountSamePassword.length,
                    shrinkWrap: true,
                    itemBuilder: (context, parentIndex) {
                      return CardItem(
                        title: "${context.trStatistic(StatisticText.totalAccountSamePassword)}: ${value.accountSamePassword[parentIndex].length}",
                        items: value.accountSamePassword[parentIndex],
                        itemBuilder: (item, index) {
                          return AccountItemWidget(
                            accountModel: item,
                            isLastItem: index == value.accountSamePassword[parentIndex].length - 1,
                            subIcon: Padding(padding: const EdgeInsets.all(14), child: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp)),
                            onCallBackPop: () {},
                          );
                        },
                      );
                    },
                  ),
                );
          },
        ),
      ),
    );
  }
}
