import 'package:cybersafe_pro/components/bottom_sheets/select_category_bottom_sheets.dart';
import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersafe_pro/providers/create_account_form_provider.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';

class CreateAccountMobileLayout extends StatelessWidget {
  const CreateAccountMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final formProvider = Provider.of<CreateAccountFormProvider>(context,listen: true);
      final accountProvider = Provider.of<AccountProvider>(context,listen: true);
    
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final success = await accountProvider.createAccountFromForm(formProvider);
            if (success && context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Icon(Icons.check),
        ),
        appBar: AppBar(
          title: const Text('Tạo tài khoản'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formProvider.formKey,
            child: Column(
              children: [
                // Icon picker
                Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(15),
                    child: const Center(
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Chọn icon text
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Chọn Icon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
    
                // Tên ứng dụng
                CustomTextField(
                  requiredTextField: true,
                  titleTextField: 'Tên ứng dụng',
                  controller: formProvider.appNameController,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  hintText: 'Tên ứng dụng',
                  maxLines: 1,
                  isObscure: false,
                  textError: formProvider.appNameError,
                  onChanged: (_) => formProvider.validateAppName(),
                ),
                const SizedBox(height: 10),
    
                // Tên đăng nhập
                CustomTextField(
                  requiredTextField: false,
                  titleTextField: 'Tên đăng nhập',
                  controller: formProvider.usernameController,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  hintText: 'Tên đăng nhập',
                  maxLines: 1,
                  isObscure: false,
                  autofillHints: const [AutofillHints.username],
                ),
                const SizedBox(height: 10),
    
                // Mật khẩu
                CustomTextField(
                  requiredTextField: false,
                  titleTextField: 'Mật khẩu',
                  controller: formProvider.passwordController,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  hintText: 'Mật khẩu',
                  maxLines: 1,
                  isObscure: true,
                  autofillHints: const [AutofillHints.password],
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.loop),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
    
                // Chọn danh mục
                CustomTextField(
                  requiredTextField: true,
                  titleTextField: 'Chọn danh mục',
                  controller: formProvider.categoryController,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  hintText: 'Chọn danh mục',
                  maxLines: 1,
                  isObscure: false,
                  readOnly: true,
                  textError: formProvider.categoryError,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  onTap: () {
                    showSelectCategoryBottomSheet(
                      context,
                      selectedCategory: formProvider.selectedCategory,
                      onSelected: formProvider.setCategory,
                    );
                  },
                ),
                const SizedBox(height: 10),
    
                // Xác thực 2 lớp
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Xác thực 2 lớp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            requiredTextField: false,
                            controller: formProvider.otpController,
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.start,
                            hintText: 'Nhập mã xác thực TOTP',
                            maxLines: 1,
                            isObscure: false,
                            readOnly: true,
                            prefixIcon: const Icon(Icons.qr_code_scanner),
                            onTap: () {},
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.keyboard_alt_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
    
                // Ghi chú
                CustomTextField(
                  requiredTextField: false,
                  titleTextField: 'Ghi chú',
                  controller: formProvider.noteController,
                  textInputAction: TextInputAction.newline,
                  textAlign: TextAlign.start,
                  textInputType: TextInputType.multiline,
                  hintText: 'Ghi chú',
                  minLines: 1,
                  maxLines: 15,
                  isObscure: false,
                ),
                const SizedBox(height: 16),
    
                // Thêm trường
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm trường'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
