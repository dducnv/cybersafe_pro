import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/statistic_text.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/statistic_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/account_list_tile_widgets.dart';
import 'package:cybersafe_pro/widgets/card_item.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPasswordWeak extends StatelessWidget {
  const AccountPasswordWeak({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.trStatistic(StatisticText.totalAccountPasswordWeak),
          style: CustomTextStyle.regular(fontSize: 18.sp),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Consumer<StatisticProvider>(
          builder: (context, value, child) {
            return value.accountPasswordWeakByCategories.isEmpty
                ? Center(
                  child: Image.asset(
                    "assets/images/exclamation-mark.png",
                    width: 60.w,
                    height: 60.h,
                  ),
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: ListView.builder(
                    itemCount: value.accountPasswordWeakByCategories.length,
                    shrinkWrap: true,
                    itemBuilder: (context, parentIndex) {
                      final accounts =
                          value.accountPasswordWeakByCategories[value
                              .accountPasswordWeakByCategories
                              .keys
                              .toList()[parentIndex]]!;
                      final categoryProvider = context.read<CategoryProvider>();
                      final category = categoryProvider.categories.firstWhere(
                        (element) =>
                            element.id ==
                            value.accountPasswordWeakByCategories.keys.toList()[parentIndex],
                      );
                      return Visibility(
                        visible: accounts.isNotEmpty,
                        child: CardItem<AccountDriftModelData>(
                          title: "${category.categoryName} (${accounts.length})",
                          items: accounts,
                          itemBuilder: (item, index) {
                            return AccountItemWidget(
                              accountModel: item,
                              isLastItem: index == accounts.length - 1,
                              subIcon: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Icon(Icons.arrow_forward_ios_rounded, size: 18.sp),
                              ),
                              onCallBackPop: () {},
                            );
                          },
                        ),
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
