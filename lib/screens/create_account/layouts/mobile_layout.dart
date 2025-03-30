import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/request_pro/request_pro.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/screens/create_account/components/icon_picker.dart';
import 'package:cybersafe_pro/screens/create_account/components/account_form_fields.dart';
import 'package:cybersafe_pro/screens/create_account/components/add_field_bottom_sheet.dart';
import 'package:image/image.dart' as img;

class CreateAccountMobileLayout extends StatefulWidget {
  const CreateAccountMobileLayout({super.key});

  @override
  State<CreateAccountMobileLayout> createState() => _CreateAccountMobileLayoutState();
}

class _CreateAccountMobileLayoutState extends State<CreateAccountMobileLayout> with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountFormProvider, AccountProvider>(
      builder: (context, formProvider, accountProvider, _) {
        return Scaffold(floatingActionButton: _buildSubmitButton(context, formProvider, accountProvider), appBar: _buildAppBar(context), body: _buildBody(context, formProvider));
      },
    );
  }

  Widget _buildBody(BuildContext context, AccountFormProvider formProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formProvider.formKey,
        child: Column(
          children: [
            IconPicker(onTap: () => _showIconPicker(context, formProvider)),
            const SizedBox(height: 10),
            AccountFormFields(formProvider: formProvider, onAddField: () => _showAddFieldBottomSheet(context)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar( elevation: 0, scrolledUnderElevation: 0, shadowColor: Colors.transparent, backgroundColor: Theme.of(context).colorScheme.surface);
  }

  Widget _buildSubmitButton(BuildContext context, AccountFormProvider formProvider, AccountProvider accountProvider) {
    return FloatingActionButton(onPressed: () => _handleSubmit(context, formProvider, accountProvider), child: const Icon(Icons.check));
  }

  Future<void> _handleSubmit(BuildContext context, AccountFormProvider formProvider, AccountProvider accountProvider) async {
    final success = await accountProvider.createAccountFromForm(formProvider);
    if (success && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showIconPicker(BuildContext context, AccountFormProvider formProvider) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => DefaultTabController(
            length: 2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(context.appLocale.createAccountLocale.getText(CreateAccountText.chooseIcon), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                        IconButton(
                          onPressed: () {
                            _pickImageFromGallery(context, formProvider, tabController);
                          },
                          icon: Icon(Icons.add, size: 24.sp),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    selected: formProvider.branchLogoSelected == null,
                    onTap: () {
                      formProvider.resetIcon();
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.cancel_outlined, color: Colors.blueAccent, size: 30.sp),
                    title: Text(context.appLocale.createAccountLocale.getText(CreateAccountText.noSelect), style: TextStyle(fontSize: 16.sp)),
                  ),
                  const SizedBox(height: 10),

                  TabBar(dividerColor: Colors.grey[500], controller: tabController, tabs: [Tab(text: context.appLocale.createAccountLocale.getText(CreateAccountText.iconApp)), Tab(text: context.appLocale.createAccountLocale.getText(CreateAccountText.iconCustom))]),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [_buildListIconsDefaultApp(context: context, formProvider: formProvider), _buildListIconsCustom(context: context, formProvider: formProvider)],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _showAddFieldBottomSheet(BuildContext context) async {
    final formProvider = context.read<AccountFormProvider>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => AddFieldBottomSheet(
            controller: formProvider.txtFieldTitle,
            onAddField: () {
              Navigator.pop(context);
              formProvider.handleAddField();
            },
            typeTextFields: typeTextFields,
          ),
    );
  }

  Widget _buildListIconsDefaultApp({required BuildContext context, required AccountFormProvider formProvider}) {
    return ListView.builder(
      itemCount: branchLogoCategories.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var column = Column(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(branchLogoCategories[index].categoryName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600))),
            const SizedBox(height: 10),
            Column(
              children:
                  branchLogoCategories[index].branchLogos
                      .map(
                        (e) => ListTile(
                          selected: formProvider.branchLogoSelected == e,
                          onTap: () {
                            formProvider.pickIcon(isCustomIcon: false, iconCustomModel: null, branchLogo: e);
                            Navigator.pop(context);
                          },
                          leading: SizedBox(width: 40.h, height: 40.h, child: SvgPicture.asset(context.darkMode ? e.branchLogoPathDarkMode! : e.branchLogoPathLightMode!)),
                          title: Text(e.branchName ?? "", style: TextStyle(fontSize: 16.sp)),
                        ),
                      )
                      .toList(),
            ),
          ],
        );
        return column;
      },
    );
  }

  Widget _buildListIconsCustom({required BuildContext context, required AccountFormProvider formProvider}) {
    return Selector<AccountFormProvider, List<IconCustomModel>>(
      selector: (context, formProvider) => formProvider.listIconsCustom,
      builder: (context, listIconsCustom, child) {
        return listIconsCustom.isEmpty
            ? Center(child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h))
            : ListView.builder(
              itemCount: listIconsCustom.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RequestPro(
                  child: ListTile(
                    onTap: () {
                      formProvider.pickIcon(isCustomIcon: true, iconCustomModel: formProvider.listIconsCustom[index]);
                      Navigator.pop(context);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(base64Decode(formProvider.listIconsCustom[index].imageBase64), width: 40.h, height: 40.h, fit: BoxFit.contain),
                    ),
                    title: Text(formProvider.listIconsCustom[index].name, style: TextStyle(fontSize: 16.sp)),
                    trailing: IconButton(
                      onPressed: () {
                        formProvider.deleteIconCustom(formProvider.listIconsCustom[index]);
                      },
                      icon: IgnorePointer(ignoring: false, child: Icon(Icons.close, color: Colors.redAccent, size: 24.sp)),
                    ),
                  ),
                );
              },
            );
      },
    );
  }

  //pick image from gallery
  Future<void> _pickImageFromGallery(BuildContext context, AccountFormProvider formProvider, TabController tabController) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).colorScheme.primary,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: true, aspectRatioPickerButtonHidden: true, minimumAspectRatio: 1.0),
        WebUiSettings(
          // ignore: use_build_context_synchronously
          context: context,
        ),
      ],
    );

    if (croppedFile == null) {
      return;
    }

    //resize image 70x70
    final File file = File(croppedFile.path);
    final List<int> imageBytes = await file.readAsBytes();
    Uint8List imageUint8List = Uint8List.fromList(imageBytes);
    final img.Image? originalImage = img.decodeImage(imageUint8List);

    if (originalImage == null) {
      return;
    }

    // Resize the image to 70x70
    final img.Image resizedImage = img.copyResize(originalImage, width: 100, height: 100);
    final List<int> resizedImageBytes = img.encodePng(resizedImage);
    final String base64Image = base64Encode(resizedImageBytes);

    _showDialogCreateCustomIcon(
      // ignore: use_build_context_synchronously
      context: context,
      base64Image: base64Image,
      formProvider: formProvider,
      tabController: tabController,
    );
  }

  Future<void> _showDialogCreateCustomIcon({required BuildContext context, required String base64Image, required AccountFormProvider formProvider, required TabController tabController}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
              contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
              content: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 300.0, // Set your desired minimum width
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(base64Image),
                        width: 50.h, // Fixed width, remove the .w if using a fixed size
                        height: 50.h, // Fixed height, remove the .w if using a fixed size
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      autoFocus: true,
                      requiredTextField: true,
                      titleTextField: "Tên icon",
                      controller: formProvider.iconCustomName,
                      textInputAction: TextInputAction.go,
                      textAlign: TextAlign.start,
                      hintText: "Tên icon",
                      maxLines: 1,
                      isObscure: false,
                      onFieldSubmitted: (value) async {
                        if (formProvider.iconCustomName.text.isEmpty) {
                          return;
                        }
                        formProvider.handleSaveIcon(imageBase64: base64Image);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (formProvider.iconCustomName.text.isEmpty) {
                      return;
                    }
                    formProvider.handleSaveIcon(imageBase64: base64Image);
                    tabController.animateTo(1);
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
