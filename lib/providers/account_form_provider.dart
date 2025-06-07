import 'package:cybersafe_pro/database/boxes/icon_custom_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/type_text_field.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

final List<TypeTextField> typeTextFields = [TypeTextField(title: "Text", type: 'text'), TypeTextField(title: "Password", type: 'password')];

class AccountFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  int accountId = 0;

  final TextEditingController appNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  final TextEditingController txtFieldTitle = TextEditingController();
  final TextEditingController iconCustomName = TextEditingController();
  bool isRequiredFieldTitle = false;

  TypeTextField typeTextFieldSelected = typeTextFields[0];
  List<DynamicTextField> dynamicTextFieldNotifier = [];

  BranchLogo? branchLogoSelected;
  IconCustomModel? selectedIconCustom;

  CategoryOjbModel? selectedCategory;
  String? appNameError;
  String? categoryError;
  String? otpError;

  bool isAddedTOTP = false;
  List<IconCustomModel> listIconsCustom = [];

  AccountFormProvider() {
    listIconsCustom = IconCustomBox.getAll();
  }

  Future<void> loadAccountToForm(AccountOjbModel account) async {
    try {
      accountId = account.id;
      appNameController.text = account.title;
      usernameController.text = account.email ?? '';
      passwordController.text = account.password ?? '';
      noteController.text = account.notes ?? '';

      if (account.icon != "default" && account.icon != null && account.icon != "") {
        final branchLogo = allBranchLogos.firstWhere((element) => element.branchLogoSlug == account.icon, orElse: () => BranchLogo([], "default"));
        branchLogoSelected = branchLogo;
      } else if (account.iconCustom.target != null) {
        selectedIconCustom = account.iconCustom.target;
      } else {
        selectedIconCustom = null;
        branchLogoSelected = null;
      }

      // Set category if exists
      if (account.category.target != null) {
        setCategory(account.category.target!);
      }

      // Set TOTP if exists
      if (account.getTotp != null) {
        otpController.text = account.getTotp!.secretKey;
      }

      // Convert and add custom fields
      if (account.getCustomFields.isNotEmpty) {
        for (var field in account.getCustomFields) {
          final controller = TextEditingController(text: field.value);
          final key = field.name;

          // Find matching type for the field
          final fieldType = typeTextFields.firstWhere(
            (type) => type.type == field.typeField,
            orElse: () => typeTextFields[0], // Default to text type
          );

          // Create custom field widget
          final customField = Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    requiredTextField: false,
                    titleTextField: field.hintText,
                    controller: controller,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    hintText: field.hintText,
                    isObscure: field.typeField == "password",
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    dynamicTextFieldNotifier.removeWhere((element) => element.key == key);
                    notifyListeners();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );

          // Add to dynamic fields
          dynamicTextFieldNotifier.add(
            DynamicTextField(key: key, controller: controller, customField: CustomField(key: field.name, hintText: field.hintText, typeField: fieldType), field: customField),
          );
          notifyListeners();
        }
      }

      // Notify listeners of changes
      notifyListeners();
    } catch (e) {
      logError('Error loading account to form: $e');
      rethrow;
    }
  }

  void resetIcon() {
    selectedIconCustom = null;
    branchLogoSelected = null;
    notifyListeners();
  }

  void handleAddTOTP() {
    isAddedTOTP = true;
    notifyListeners();
  }

  void handleDeleteTOTP() {
    isAddedTOTP = false;
    otpController.clear();
    otpError = null;
    notifyListeners();
  }

  void pickIcon({bool? isCustomIcon, IconCustomModel? iconCustomModel, BranchLogo? branchLogo}) {
    if (isCustomIcon != null && isCustomIcon) {
      selectedIconCustom = null;
      selectedIconCustom = iconCustomModel;
      if (appNameController.text.isEmpty) {
        appNameController.text = iconCustomModel!.name;
      }
    } else {
      branchLogoSelected = branchLogo!;
      appNameController.text = branchLogo.branchName!;
      selectedIconCustom = null;
    }
    notifyListeners();
  }

  void handleSaveIcon({required String imageBase64}) {
    if (imageBase64.isNotEmpty) {
      selectedIconCustom = IconCustomModel(name: iconCustomName.text, imageBase64: imageBase64);
      IconCustomBox.put(selectedIconCustom!);
      listIconsCustom = IconCustomBox.getAll();
      notifyListeners();
    }
  }

  void deleteIconCustom(IconCustomModel iconCustomModel) {
    IconCustomBox.delete(iconCustomModel.id);
    listIconsCustom = IconCustomBox.getAll();
    notifyListeners();
  }

  // Validate từng trường
  bool validateAppName() {
    final context = GlobalKeys.appRootNavigatorKey.currentContext!;
    if (appNameController.text.trim().isEmpty) {
      appNameError = context.trSafe(CreateAccountText.appNameValidation);
      notifyListeners();
      return false;
    }
    appNameError = null;
    notifyListeners();
    return true;
  }

  bool validateCategory() {
    final context = GlobalKeys.appRootNavigatorKey.currentContext!;
    if (selectedCategory == null) {
      categoryError = context.trSafe(CreateAccountText.categoryValidation);
      notifyListeners();
      return false;
    }
    categoryError = null;
    notifyListeners();
    return true;
  }

  // Validate toàn bộ form
  bool validateForm() {
    bool isValid = true;

    if (!validateAppName()) isValid = false;
    if (!validateCategory()) isValid = false;

    return isValid;
  }

  void setTypeTextFieldSelected(TypeTextField typeField) {
    typeTextFieldSelected = typeField;
    notifyListeners();
  }

  // Xử lý khi chọn category
  void setCategory(CategoryOjbModel category) {
    selectedCategory = category;
    categoryController.text = category.categoryName;
    validateCategory();
  }

  void setCategoryNull() {
    selectedCategory = null;
    categoryController.clear();
    notifyListeners();
  }

  void handleAddField() {
    if (txtFieldTitle.text.isEmpty) {
      isRequiredFieldTitle = true;
      return;
    }
    final controller = TextEditingController();
    final key = txtFieldTitle.text.toLowerCase().trim().replaceAll(" ", "_") + DateTime.now().microsecondsSinceEpoch.toString();
    final field = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTextField(
              autoFocus: true,
              requiredTextField: false,
              titleTextField: txtFieldTitle.text,
              controller: controller,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              hintText: txtFieldTitle.text,
              isObscure: typeTextFieldSelected.type == "password" ? true : false,
              maxLines: 1,
            ),
          ),
          IconButton(
            onPressed: () {
              dynamicTextFieldNotifier.removeWhere((element) => element.key == key);
              notifyListeners();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );

    dynamicTextFieldNotifier.add(
      DynamicTextField(
        key: key,
        controller: controller,
        customField: CustomField(key: txtFieldTitle.text.toLowerCase().trim().replaceAll(" ", "_"), hintText: txtFieldTitle.text, typeField: typeTextFieldSelected),
        field: field,
      ),
    );
    txtFieldTitle.clear();
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    accountId = 0;
    isAddedTOTP = false;
    otpError = null;
    selectedIconCustom = null;
    branchLogoSelected = null;
    dynamicTextFieldNotifier = [];
    txtFieldTitle.clear();
    appNameController.clear();
    usernameController.clear();
    passwordController.clear();
    // categoryController.clear();
    otpController.clear();
    noteController.clear();
    // selectedCategory = null;
    appNameError = null;
    categoryError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    print("hello");
    txtFieldTitle.dispose();
    appNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    categoryController.dispose();
    otpController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
