import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showCreateCategoryBottomSheet(BuildContext context, {
  bool isUpdate = false,
  CategoryOjbModel? categoryOjbModel
}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
  
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.w,
          right: 16.w,
          top: 16.h,
        ),
        child:  CreateCategoryBottomSheet(
          isUpdate: isUpdate,
          categoryOjbModel: categoryOjbModel,
        ),
      ),
    ),
  );
}

class CreateCategoryBottomSheet extends StatefulWidget {
  final bool isUpdate;
  final CategoryOjbModel? categoryOjbModel;
  const CreateCategoryBottomSheet({super.key,  this.categoryOjbModel, this.isUpdate = false});

  @override
  State<CreateCategoryBottomSheet> createState() => _CreateCategoryBottomSheetState();
}

class _CreateCategoryBottomSheetState extends State<CreateCategoryBottomSheet> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.categoryOjbModel?.categoryName ?? "";
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateCategory(BuildContext context, String name) async {
    if (name.trim().isEmpty) return;

    final navigator = Navigator.of(context);
    final categoryProvider = context.read<CategoryProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final success = await categoryProvider.createCategory(
      CategoryOjbModel(categoryName: name.trim())
    );
    if (success) {
      navigator.pop();
    } else if (categoryProvider.error != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(categoryProvider.error!)),
      );
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
            CustomTextField(
              autoFocus: true,
              requiredTextField: true,
              titleTextField: context.trCategory(CategoryText.categoryName),
              controller: textController,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              maxLines: 1,
              onFieldSubmitted: (value) => _handleCreateCategory(context, value),
            ),
            SizedBox(height: 16.h),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: provider.txtCategoryName,
              builder: (context, value, child) {
                return CustomButtonWidget(
                  margin: EdgeInsets.zero,
                  isDisabled: value.text.trim().isEmpty,
                  onPressed: () => _handleCreateCategory(
                    context, 
                    value.text,
                  ),
                  text: context.trCategory(CategoryText.createCategory),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        context.trCategory(CategoryText.createCategory),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
