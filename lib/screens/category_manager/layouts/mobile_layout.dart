import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CategoryManagerMobileLayout extends StatelessWidget {
  const CategoryManagerMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showCreateCategoryBottomSheet(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: Selector<CategoryProvider, Tuple2<List<CategoryDriftModelData>, Map<int, int>>>(
          selector: (context, provider) => Tuple2(provider.categoryList, provider.mapCategoryIdTotalAccount),
          builder: (context, categoryProvider, child) {
            return categoryProvider.item1.isEmpty
                ? Center(child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h))
                : ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    onReorderEnd: (index) {},
                    padding: EdgeInsets.all(16),
                    itemBuilder: (BuildContext context, int index) {
                      var category = categoryProvider.item1[index];
                      return Padding(
                        key: ValueKey(category.indexPos),
                        padding: const EdgeInsets.only(bottom: 6),
                        child: CardCustomWidget(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(child: Text("${category.categoryName} (${categoryProvider.item2[category.id]})", style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w500))),
                              IconButton(
                                onPressed: () {
                                  showCreateCategoryBottomSheet(context, isUpdate: true, categoryDriftModelData: category);
                                },
                                icon: Icon(Icons.edit_note_rounded, size: 21.sp),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showDeleteCategoryPopup(context: context, category: category);
                                },
                                icon: Icon(Icons.delete, color: Colors.red[600], size: 21.sp),
                              ),
                              SizedBox(width: 20.w),
                              Icon(Icons.drag_indicator_outlined, size: 21.sp),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: categoryProvider.item1.length,
                    onReorder: (int oldIndex, int newIndex) {
                      context.read<CategoryProvider>().reorderCategory(oldIndex, newIndex);
                    },
                  ),
                );
          },
        ),
      ),
    );
  }

  _showDeleteCategoryPopup({required BuildContext context, required CategoryDriftModelData category}) async {
    final categoryProvider = context.read<CategoryProvider>();
    return showAppCustomDialog(
      context,
      AppCustomDialog(
        title: context.trSafe(CategoryText.deleteCategory),
        message: categoryProvider.mapCategoryIdTotalAccount[category.id] != 0 ? context.trSafe(CategoryText.deleteWarningWithAccounts) : context.trSafe(CategoryText.deleteWarningEmpty),
        confirmText: context.trSafe(CategoryText.deleteCategory),
        cancelText: context.trSafe(CategoryText.cancel),
        cancelButtonColor: Theme.of(context).colorScheme.primary,
        confirmButtonColor: Theme.of(context).colorScheme.error,
        isCountDownTimer: categoryProvider.mapCategoryIdTotalAccount[category.id] != 0,
        canConfirmInitially: categoryProvider.mapCategoryIdTotalAccount[category.id] == 0,
        onConfirm: () async {
          bool result = await context.read<CategoryProvider>().deleteCategory(category);
          if (result && context.mounted) {
            context.read<CategoryProvider>().refresh();
            context.read<AccountProvider>().refreshAccounts();
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
