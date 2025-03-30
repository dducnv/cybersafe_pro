import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/utils/type_text_field.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddFieldBottomSheet extends StatelessWidget {
  final TextEditingController controller;
  final Function() onAddField;
  final List<TypeTextField> typeTextFields;

  const AddFieldBottomSheet({
    super.key,
    required this.controller,
    required this.onAddField,
    required this.typeTextFields,
  });

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<AccountFormProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      context.trCreateAccount(CreateAccountText.addField),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onAddField,
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
            CustomTextField(
              requiredTextField: true,
              titleTextField: context.trCreateAccount(CreateAccountText.titleField),
              controller: controller,
              autoFocus: true,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              hintText: context.trCreateAccount(CreateAccountText.titleField),
              maxLines: 1,
              isObscure: false,
              onChanged: (value) {
                formProvider.isRequiredFieldTitle = value.isEmpty;
              },
            ),
            const SizedBox(height: 10),
            _buildFieldTypeLabel(context),
            const SizedBox(height: 5),
            Selector<AccountFormProvider, TypeTextField>(
              builder: (context, value, child) {
                return _buildTypeTextFieldSelector(context, typeTextFields, value);
              },
              selector: (context, provider) => provider.typeTextFieldSelected,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldTypeLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: context.trCreateAccount(CreateAccountText.fieldType),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800]),
        children: [TextSpan(text: '*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16))],
      ),
    );
  }

  Widget _buildTypeTextFieldSelector(BuildContext context, List<TypeTextField> typeTextFields, TypeTextField typeTextFieldSelected) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: typeTextFields.length,
      itemBuilder: (context, index) {
        return CustomButtonWidget(
          onPressed: () {
            Provider.of<AccountFormProvider>(context, listen: false).setTypeTextFieldSelected(typeTextFields[index]);
          },
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          margin: const EdgeInsets.all(0),
          text: context.trCreateAccount(CreateAccountText.fieldType),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Radio<TypeTextField>(
                value: typeTextFields[index],
                groupValue: typeTextFieldSelected,
                onChanged: (TypeTextField? value) {
                  typeTextFieldSelected = value!;
                },
              ),
              const SizedBox(width: 10),
              Text(typeTextFields[index].title, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18)),
            ],
          ),
        );
      },
    );
  }
}