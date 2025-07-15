import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showSelectCategoryBottomSheet(BuildContext context, {CategoryOjbModel? selectedCategory, bool isFromChangeCategory = false, required Function(CategoryOjbModel) onSelected}) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(child: SelectCategoryBottomSheet(selectedCategory: selectedCategory, onSelected: onSelected, isFromChangeCategory: isFromChangeCategory)),
  );
}

class SelectCategoryBottomSheet extends StatelessWidget {
  final CategoryOjbModel? selectedCategory;
  final Function(CategoryOjbModel) onSelected;
  final bool isFromChangeCategory;

  const SelectCategoryBottomSheet({super.key, this.selectedCategory, required this.onSelected, required this.isFromChangeCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector cho số lượng categories
          Selector<CategoryProvider, int>(
            selector: (_, provider) => provider.categories.length,
            builder: (context, count, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: Text("${isFromChangeCategory? context.trHome(HomeLocale.changeCategory): context.trCreateAccount(CreateAccountText.chooseCategory)} ($count)", style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w600))),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        showCreateCategoryBottomSheet(context);
                      },
                      icon: Icon(Icons.add, size: 24.sp),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 10.h),

          // Selector cho danh sách categories
          Expanded(
            child: Selector<CategoryProvider, List<CategoryOjbModel>>(
              selector: (_, provider) => provider.categoryList,
              shouldRebuild: (previous, next) {
                return previous.length != next.length || previous.any((prev) => next.any((next) => prev.categoryName != next.categoryName || prev.accounts.length != next.accounts.length));
              },
              builder: (context, categories, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      selected: selectedCategory == category,
                      onTap: () {
                        onSelected(category);
                        Navigator.pop(context);
                      },
                      leading: Icon(Icons.folder, color: Theme.of(context).colorScheme.primary, size: 24.sp),
                      title: Consumer<AccountProvider>(
                        builder: (context, accountProvider, _) {
                          final accountCount = accountProvider.getTotalAccountsInCategory(category.id);
                          return Text(
                            "${category.categoryName} ($accountCount)", 
                            style: CustomTextStyle.regular(fontSize: 16.sp)
                          );
                        }
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
