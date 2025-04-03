import 'package:cybersafe_pro/components/bottom_sheets/select_category_bottom_sheets.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/logger.dart';
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
          titleTextField: context.trCreateAccount(CreateAccountText.appName),
          hintText: "Social App Name, Bank Name,...",
          controller: formProvider.appNameController,
          textError: formProvider.appNameError,
          onChanged: (_) => formProvider.validateAppName(),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        _buildUsernameField(context),
        const SizedBox(height: 10),
        _buildPasswordField(context),
        const SizedBox(height: 10),
        _buildCategoryField(context),
        const SizedBox(height: 10),
        Selector<AccountFormProvider, bool>(
          builder:
              (context, value, child) =>
                  !value
                      ? _buildTOTPField(context)
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              context.appLocale.createAccountLocale.getText(CreateAccountText.twoFactorAuth),
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                            ),
                          ),
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
        _buildNotesField(context),
        const SizedBox(height: 10),
        _buildCustomFields(),
        const SizedBox(height: 10),
        _buildAddFieldButton(context),
      ],
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return CustomTextField(
      titleTextField: context.trCreateAccount(CreateAccountText.username),
      hintText: "Email, Phone, Username,...",
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
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(context.appLocale.createAccountLocale.getText(CreateAccountText.password), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                requiredTextField: false,
                controller: formProvider.passwordController,
                isObscure: true,
                hintText: context.trCreateAccount(CreateAccountText.password),
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
                  showAppCustomDialog(
                    context,
                    AppCustomDialog(
                      canConfirmInitially: true,
                      title: context.trSafe(CreateAccountText.overwritePassword),
                      message: context.trSafe(CreateAccountText.overwritePasswordMessage),
                      confirmText: context.trSafe(CreateAccountText.confirm),
                      cancelText: context.trSafe(CreateAccountText.cancel),
                      onConfirm: () {
                        Navigator.of(context).pop();
                        _toGenPass(context);
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    ),
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
      titleTextField: context.trCreateAccount(CreateAccountText.category),
      controller: formProvider.categoryController,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.start,
      hintText: context.trCreateAccount(CreateAccountText.chooseCategory),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 5),
          child: Text(context.trCreateAccount(CreateAccountText.twoFactorAuth), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: formProvider.otpController,
                hintText: context.trCreateAccount(CreateAccountText.enterKey),
                prefixIcon: const Icon(Icons.key),
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.start,
                textInputType: TextInputType.text,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    if (OTP.isKeyValid(value)) {
                      formProvider.handleAddTOTP();
                    } else {
                      formProvider.otpError = context.trSafe(CreateAccountText.otpError);
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
                  logInfo("otpCustom.toString(): ${otpCustom.toString()}");
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

  Widget _buildNotesField(BuildContext context) {
    return CustomTextField(
      titleTextField: context.trCreateAccount(CreateAccountText.note),
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

  Widget _buildAddFieldButton(BuildContext context) {
    return OutlinedButton.icon(onPressed: onAddField, icon: const Icon(Icons.add), label: Text(context.trCreateAccount(CreateAccountText.addField)));
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
