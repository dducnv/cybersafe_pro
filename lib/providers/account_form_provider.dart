import 'package:flutter/material.dart';

import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/type_text_field.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';

import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';

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
  IconCustomDriftModelData? selectedIconCustom;

  CategoryDriftModelData? selectedCategory;
  String? appNameError;
  String? categoryError;
  String? otpError;

  bool isAddedTOTP = false;
  List<IconCustomDriftModelData> listIconsCustom = [];

  AccountFormProvider() {
    getListIconCustom();
  }

  Future<void> getListIconCustom() async {
    listIconsCustom = await DriffDbManager.instance.iconCustomAdapter.getAll();
  }

  Future<void> loadAccountToForm(AccountDriftModelData account) async {
    try {
      accountId = account.id;
      appNameController.text = account.title;
      usernameController.text = account.username ?? '';
      passwordController.text = account.password ?? '';
      noteController.text = account.notes ?? '';

      if (account.icon != "default" && account.icon != null && account.icon != "") {
        final branchLogo = allBranchLogos.firstWhere((element) => element.branchLogoSlug == account.icon, orElse: () => BranchLogo([], "default"));
        branchLogoSelected = branchLogo;
      } else if (account.iconCustomId != null) {
        selectedIconCustom = listIconsCustom.firstWhere((element) => element.id == account.iconCustomId);
      } else {
        selectedIconCustom = null;
        branchLogoSelected = null;
      }

      // Set category if exists

      final category = await DriffDbManager.instance.categoryAdapter.getById(account.categoryId);
      if (category != null) {
        setCategory(category);
      }

      final totp = await DriffDbManager.instance.totpAdapter.getByAccountId(account.id);
      if (totp != null) {
        otpController.text = totp.secretKey;
      }

      final customFields = await DriffDbManager.instance.accountCustomFieldAdapter.getByAccountId(account.id);

      // Convert and add custom fields
      if (customFields.isNotEmpty) {
        for (var field in customFields) {
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

  void pickIcon({bool? isCustomIcon, IconCustomDriftModelData? iconCustomModel, BranchLogo? branchLogo}) {
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

  Future<void> handleSaveIcon({required String imageBase64}) async {
    if (imageBase64.isNotEmpty) {
      selectedIconCustom = IconCustomDriftModelData(id: 0, name: iconCustomName.text, imageBase64: imageBase64);
      DriffDbManager.instance.iconCustomAdapter.put(selectedIconCustom!);
      listIconsCustom = await DriffDbManager.instance.iconCustomAdapter.getAll();
      notifyListeners();
    }
  }

  Future<void> deleteIconCustom(IconCustomDriftModelData iconCustomModel) async {
    DriffDbManager.instance.iconCustomAdapter.delete(iconCustomModel.id);
    listIconsCustom = await DriffDbManager.instance.iconCustomAdapter.getAll();
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
  void setCategory(CategoryDriftModelData category) {
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
