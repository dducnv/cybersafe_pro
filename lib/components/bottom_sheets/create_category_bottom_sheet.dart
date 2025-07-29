import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showCreateCategoryBottomSheet(BuildContext context, {bool isUpdate = false, CategoryDriftModelData? categoryDriftModelData}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder:
        (context) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: CreateCategoryBottomSheet(isUpdate: isUpdate, categoryDriftModelData: categoryDriftModelData),
          ),
        ),
  );
}

class CreateCategoryBottomSheet extends StatefulWidget {
  final bool isUpdate;
  final CategoryDriftModelData? categoryDriftModelData;
  const CreateCategoryBottomSheet({super.key, this.categoryDriftModelData, this.isUpdate = false});

  @override
  State<CreateCategoryBottomSheet> createState() => _CreateCategoryBottomSheetState();
}

class _CreateCategoryBottomSheetState extends State<CreateCategoryBottomSheet> {
  @override
  void initState() {
    super.initState();
    final categoryProvider = context.read<CategoryProvider>();
    categoryProvider.txtCategoryName = TextEditingController();
    categoryProvider.txtCategoryName.text = widget.categoryDriftModelData?.categoryName ?? "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleCreateCategory(BuildContext context, String name) async {
    if (name.trim().isEmpty) return;

    final navigator = Navigator.of(context);
    final categoryProvider = context.read<CategoryProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    bool success = false;

    if (widget.isUpdate) {
      success = await categoryProvider.updateCategory(id: widget.categoryDriftModelData!.id, categoryName: name.trim());
    } else {
      success = await categoryProvider.createCategory(name.trim());
    }
    if (success) {
      navigator.pop();
    } else if (categoryProvider.error != null) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(categoryProvider.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.trCategory(widget.isUpdate ? CategoryText.updateCategory : CategoryText.createCategory), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: provider.txtCategoryName,
                  builder: (context, value, child) {
                    return IconButton(
                      onPressed:
                          value.text.trim().isEmpty
                              ? null
                              : () {
                                _handleCreateCategory(context, value.text);
                              },
                      icon: Icon(Icons.check),
                    );
                  },
                ),
              ],
            ),
            CustomTextField(
              autoFocus: true,
              requiredTextField: true,
              titleTextField: context.trCategory(CategoryText.categoryName),
              controller: provider.txtCategoryName,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              maxLines: 1,
              onFieldSubmitted: (value) => _handleCreateCategory(context, value),
            ),
            SizedBox(height: 16.h),

            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
