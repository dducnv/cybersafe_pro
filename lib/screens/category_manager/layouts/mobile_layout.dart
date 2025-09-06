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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CategoryManagerMobileLayout extends StatelessWidget {
  const CategoryManagerMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              showCreateCategoryBottomSheet(context);
            },
            icon: Icon(Icons.add),
            tooltip: 'Thêm danh mục mới',
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return Selector<AccountProvider, Map<int, int>>(
              selector: (context, provider) => provider.mapCategoryIdTotalAccount,
              builder: (context, accountCounts, child) {
                return categoryProvider.categories.isEmpty
                    ? _buildEmptyState()
                    : _buildCategoryList(context, categoryProvider, accountCounts);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    CategoryProvider categoryProvider,
    Map<int, int> accountCounts,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<CategoryProvider>().refresh();
        },
        child: ReorderableListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          cacheExtent: 1000,
          onReorderEnd: (index) {
            HapticFeedback.lightImpact();
          },
          itemBuilder: (BuildContext context, int index) {
            final category = categoryProvider.categories[index];
            final accountCount = accountCounts[category.id] ?? 0;

            return _buildCategoryItem(
              context: context,
              category: category,
              accountCount: accountCount,
              index: index,
            );
          },
          itemCount: categoryProvider.categories.length,
          onReorder: (int oldIndex, int newIndex) {
            _handleReorder(context, oldIndex, newIndex);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required CategoryDriftModelData category,
    required int accountCount,
    required int index,
  }) {
    return Padding(
      key: ValueKey(category.id), // Sử dụng ID thay vì indexPos để tránh conflict
      padding: const EdgeInsets.only(bottom: 6),
      child: CardCustomWidget(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${category.categoryName} ($accountCount)",
                style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            _buildActionButtons(context, category),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CategoryDriftModelData category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            _handleEditCategory(context, category);
          },
          icon: Icon(Icons.edit_note_rounded, size: 21.sp),
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showDeleteCategoryPopup(context: context, category: category);
          },
          icon: Icon(Icons.delete, color: Colors.red[600], size: 21.sp),
        ),
        SizedBox(width: 20.w),
        Icon(Icons.drag_indicator_outlined, size: 21.sp, color: Colors.grey[600]),
      ],
    );
  }

  void _handleEditCategory(BuildContext context, CategoryDriftModelData category) {
    showCreateCategoryBottomSheet(context, isUpdate: true, categoryDriftModelData: category);
  }

  Future<void> _handleReorder(BuildContext context, int oldIndex, int newIndex) async {
    HapticFeedback.mediumImpact();
    await context.read<CategoryProvider>().reorderCategory(oldIndex, newIndex);
  }

  _showDeleteCategoryPopup({
    required BuildContext context,
    required CategoryDriftModelData category,
  }) async {
    final categoryProvider = context.read<CategoryProvider>();
    final hasAccounts = categoryProvider.mapCategoryIdTotalAccount[category.id] != 0;

    return showAppCustomDialog(
      context,
      AppCustomDialog(
        title: context.trSafe(CategoryText.deleteCategory),
        message:
            hasAccounts
                ? context.trSafe(CategoryText.deleteWarningWithAccounts)
                : context.trSafe(CategoryText.deleteWarningEmpty),
        confirmText: context.trSafe(CategoryText.deleteCategory),
        cancelText: context.trSafe(CategoryText.cancel),
        cancelButtonColor: Theme.of(context).colorScheme.primary,
        confirmButtonColor: Theme.of(context).colorScheme.error,
        isCountDownTimer: hasAccounts,
        canConfirmInitially: !hasAccounts,
        onConfirm: () async {
          await context.read<CategoryProvider>().deleteCategory(category);
        },
      ),
    );
  }
}
