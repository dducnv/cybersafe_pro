import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showCreateCategoryBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 16.h,
      ),
      child: const CreateCategoryBottomSheet(),
    ),
  );
}

class CreateCategoryBottomSheet extends StatelessWidget {
  const CreateCategoryBottomSheet({super.key});

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
              titleTextField: "Tên danh mục",
              controller: provider.txtCategoryName,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              hintText: "Nhập tên danh mục",
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
                  text: "Tạo danh mục",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        "Tạo danh mục",
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
