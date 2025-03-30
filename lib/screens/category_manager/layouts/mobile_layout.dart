import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

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
      body: Selector<CategoryProvider, List<CategoryOjbModel>>(
        selector: (context, provider) => provider.categoryList,
        builder: (context, categories, child) {
          return categories.isEmpty
              ? Center(child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h))
              : ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  onReorderEnd: (index) {},
                  padding: EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int index) {
                    var category = categories[index];
                    return Padding(
                      key: ValueKey(category.indexPos),
                      padding: const EdgeInsets.only(bottom: 6),
                      child: CardCustomWidget(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(child: Text("${category.categoryName} (${category.accounts.length})", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500))),
                            IconButton(
                              onPressed: () {
                                showCreateCategoryBottomSheet(context, isUpdate: true, categoryOjbModel: category);
                              },
                              icon: Icon(Icons.edit_note_rounded, size: 21.sp),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteCategoryPopup(context: context, category: category);
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
                  itemCount: categories.length,
                  onReorder: (int oldIndex, int newIndex) {
                    context.read<CategoryProvider>().reorderCategory(oldIndex, newIndex);
                  },
                ),
              );
        },
      ),
    );
  }

  Future<void> deleteCategoryPopup({required BuildContext context, required CategoryOjbModel category}) async {
    bool canDelete = false;
    int countdown = 5;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!canDelete && category.accounts.isNotEmpty) {
              Future.delayed(const Duration(seconds: 1), () {
                if (countdown > 0 && context.mounted) {
                  setState(() {
                    countdown--;
                  });
                  if (countdown == 0) {
                    setState(() {
                      canDelete = true;
                    });
                  }
                }
              });
            } else {
              countdown = 5;
              canDelete = true;
            }

            return AlertDialog(
              title: Text(context.trCategory(CategoryText.deleteCategory), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.accounts.isNotEmpty
                        ? context.trCategory(CategoryText.deleteWarningWithAccounts)
                        : context.trCategory(CategoryText.deleteWarningEmpty),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      canDelete
                          ? () async {
                            bool result = await context.read<CategoryProvider>().deleteCategory(category);
                            if (result && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                          : null,
                  child: Text("${context.trCategory(CategoryText.deleteCategory)} ${!canDelete ? "($countdown)" : ""}", style: TextStyle(color: canDelete ? Colors.redAccent : Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(context.trCategory(CategoryText.cancel), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
