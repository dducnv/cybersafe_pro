import 'package:cybersafe_pro/components/bottom_sheets/select_category_bottom_sheets.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/otp_qrcode_scan/otp_qrcode_scan.dart';
import 'package:cybersafe_pro/widgets/otp_text_with_countdown/otp_text_with_countdown.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:provider/provider.dart';

class AccountFormFields extends StatelessWidget {
  final AccountFormProvider formProvider;
  final Function() onAddField;

  const AccountFormFields({super.key, required this.formProvider, required this.onAddField});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          requiredTextField: true,
          autoFocus: true,
          titleTextField: 'Tên ứng dụng',
          controller: formProvider.appNameController,
          textError: formProvider.appNameError,
          onChanged: (_) => formProvider.validateAppName(),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        _buildUsernameField(),
        const SizedBox(height: 10),
        _buildPasswordField(context),
        const SizedBox(height: 10),
        _buildCategoryField(context),
        const SizedBox(height: 10),
        Selector<AccountFormProvider, bool>(
          builder: (context, value, child) => !value ? _buildTOTPField(context) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(left: 5, bottom: 5), child: Text("Xác thực 2 lớp", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]))),
              Row(
                children: [
                  Expanded(child: CardCustomWidget(child: OtpTextWithCountdown(keySecret: formProvider.otpController.text))),
                  IconButton(
                    onPressed: () {
                      formProvider.handleDeleteTOTP();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  ],
                ),
            ],
          ),
          selector: (context, provider) => provider.isAddedTOTP,
        ),
        const SizedBox(height: 10),
        _buildNotesField(),
        const SizedBox(height: 10),
        _buildCustomFields(),
        const SizedBox(height: 10),
        _buildAddFieldButton(),
      ],
    );
  }

  Widget _buildUsernameField() {
    return CustomTextField(
      titleTextField: 'Tên đăng nhập',
      controller: formProvider.usernameController,
      autofillHints: const [AutofillHints.username],
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 5), child: Text("Mật khẩu", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]))),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                requiredTextField: false,
                controller: formProvider.passwordController,
                isObscure: true,
                autofillHints: const [AutofillHints.password],
                suffixIcon: IconButton(icon: const Icon(Icons.loop), onPressed: () {}),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                maxLines: 1,
                onChanged: (value) {
                  formProvider.passNotifier.value = PasswordStrength.calculate(text: value);
                },
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.loop_rounded),
              onPressed: () {
                if (formProvider.passwordController.text.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actionsPadding: const EdgeInsets.only(bottom: 2, right: 10),
                        contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
                        content: Text("Bạn có muốn ghi đè lên mật khẩu cũ không?", style: TextStyle(fontSize: 16.sp)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Hủy bỏ", style: TextStyle(fontSize: 14.sp)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _toGenPass(context);
                            },
                            child: Text("Đồng ý", style: TextStyle(fontSize: 14.sp)),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  _toGenPass(context);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        PasswordStrengthChecker(
          strength: formProvider.passNotifier,
          configuration: PasswordStrengthCheckerConfiguration(borderWidth: 1, height: 12.h, inactiveBorderColor: Theme.of(context).colorScheme.surfaceContainerHighest, showStatusWidget: false),
        ),
      ],
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return CustomTextField(
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
      suffixIcon: Padding(padding: const EdgeInsets.only(right: 12), child: const Icon(Icons.keyboard_arrow_down)),
      onTap: () {
        showSelectCategoryBottomSheet(context, selectedCategory: formProvider.selectedCategory, onSelected: formProvider.setCategory);
      },
    );
  }

  Widget _buildTOTPField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 5, left: 5), child: Text('Xác thực 2 lớp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]))),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: formProvider.otpController,
                hintText: 'Nhập mã xác thực TOTP',
                prefixIcon: const Icon(Icons.key),
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.start,
                textInputType: TextInputType.text,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    if (OTP.isKeyValid(value)) {
                      formProvider.handleAddTOTP();
                    } else {
                      formProvider.otpError = 'Mã xác thực không hợp lệ';
                    }
                  }
                },
                textError: formProvider.otpError,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () async {
                final uri = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QrcodeScaner()));
                if (uri != null) {
                  var otpCustom = OTP.fromUri(uri.toString()).toJson();
                  debugPrint("otpCustom.toString(): ${otpCustom.toString()}");
                  formProvider.otpError = null;
                  formProvider.handleAddTOTP();
                  formProvider.otpController.text = otpCustom['secret'].toUpperCase();
                  formProvider.appNameController.text = otpCustom['issuer'];
                  formProvider.usernameController.text = otpCustom['accountName'];
                  for (var icon in allBranchLogos) {
                    final pattern = icon.keyWords!.map((k) => RegExp.escape(k)).join('|');
                    final regex = RegExp(pattern, caseSensitive: false);
                    if (regex.hasMatch(otpCustom['issuer'])) {
                      formProvider.branchLogoSelected = icon;
                      break;
                    }
                  }
                }
              },
              icon: const Icon(Icons.qr_code),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return CustomTextField(
      titleTextField: 'Ghi chú',
      controller: formProvider.noteController,
      textInputType: TextInputType.multiline,
      minLines: 1,
      isObscure: false,
      maxLines: 15,
      textInputAction: TextInputAction.newline,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildCustomFields() {
    return Column(
      children: List.generate(formProvider.dynamicTextFieldNotifier.length, (index) {
        return formProvider.dynamicTextFieldNotifier[index].field;
      }),
    );
  }

  Widget _buildAddFieldButton() {
    return OutlinedButton.icon(onPressed: onAddField, icon: const Icon(Icons.add), label: const Text('Thêm trường'));
  }

  Future _toGenPass(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PasswordGenerateScreen(
            isFromForm: true,
            onPasswordChanged: (password) {
              formProvider.passwordController.text = password;
              formProvider.passNotifier.value = PasswordStrength.calculate(text: password);
            },
          );
        },
      ),
    );
  }
}
