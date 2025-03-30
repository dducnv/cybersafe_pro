import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/screens/create_account/components/account_form_fields.dart';
import 'package:cybersafe_pro/screens/create_account/components/add_field_bottom_sheet.dart';
import 'package:cybersafe_pro/screens/create_account/components/icon_picker.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/request_pro/request_pro.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

class CreateAccountTabletLayout extends StatefulWidget {
  const CreateAccountTabletLayout({super.key});

  @override
  State<CreateAccountTabletLayout> createState() => _CreateAccountTabletLayoutState();
}

class _CreateAccountTabletLayoutState extends State<CreateAccountTabletLayout> with SingleTickerProviderStateMixin {
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
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Center(child: Container(constraints: const BoxConstraints(maxWidth: 800), child: _buildBody(context, formProvider))),
          floatingActionButton: _buildSubmitButton(context, formProvider, accountProvider),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AccountFormProvider formProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formProvider.formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột bên trái - Phần chọn icon
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(context.appLocale.createAccountLocale.getText(CreateAccountText.chooseIcon), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
                    child: IconPicker(onTap: () => _showIconPicker(context, formProvider)),
                  ),
                  SizedBox(height: 20.h),
                  OutlinedButton.icon(
                    onPressed: () => _showIconPicker(context, formProvider),
                    icon: const Icon(Icons.edit),
                    label: Text(context.appLocale.createAccountLocale.getText(CreateAccountText.changeIcon)),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                  ),
                ],
              ),
            ),

            // Dấu phân cách
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              width: 1,
              height: 500, // Chiều cao cố định để tạo đường phân cách
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            ),

            // Cột bên phải - Form nhập liệu
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text("Chi tiết", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  ),
                  AccountFormFields(
                    formProvider: formProvider,
                    onAddField: () => _showAddFieldBottomSheet(context),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _showAddFieldBottomSheet(context),
                      icon: const Icon(Icons.add),
                      label: Text(context.appLocale.createAccountLocale.getText(CreateAccountText.addField)),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(context.appLocale.createAccountLocale.getText(CreateAccountText.title)),
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.surface,
      centerTitle: true,
    );
  }

  Widget _buildSubmitButton(BuildContext context, AccountFormProvider formProvider, AccountProvider accountProvider) {
    return FloatingActionButton.extended(
      onPressed: () => _handleSubmit(context, formProvider, accountProvider),
      label: Text(context.appLocale.createAccountLocale.getText(CreateAccountText.save)),
      icon: const Icon(Icons.check),
    );
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
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(context.appLocale.createAccountLocale.getText(CreateAccountText.chooseIcon), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                            IconButton(
                              onPressed: () {
                                _pickImageFromGallery(context, formProvider, tabController);
                              },
                              icon: Icon(Icons.add_photo_alternate, size: 24.sp),
                              tooltip: "Thêm ảnh tùy chỉnh",
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
                      TabBar(
                        dividerColor: Colors.grey[500],
                        controller: tabController,
                        tabs: [
                          Tab(text: context.appLocale.createAccountLocale.getText(CreateAccountText.iconApp)),
                          Tab(text: context.appLocale.createAccountLocale.getText(CreateAccountText.iconCustom)),
                        ],
                      ),
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
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 3),
      itemCount: branchLogoCategories.expand((category) => category.branchLogos).length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Tính toán category và logo dựa trên index tổng
        int categoryIndex = 0;
        int logoIndex = index;

        while (logoIndex >= branchLogoCategories[categoryIndex].branchLogos.length) {
          logoIndex -= branchLogoCategories[categoryIndex].branchLogos.length;
          categoryIndex++;
          if (categoryIndex >= branchLogoCategories.length) {
            return const SizedBox(); // Trường hợp ngoại lệ, không nên xảy ra
          }
        }

        final category = branchLogoCategories[categoryIndex];
        final logo = category.branchLogos.toList()[logoIndex];

        return Card(
          elevation: formProvider.branchLogoSelected == logo ? 3 : 1,
          color: formProvider.branchLogoSelected == logo ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface,
          child: InkWell(
            onTap: () {
              formProvider.pickIcon(isCustomIcon: false, iconCustomModel: null, branchLogo: logo);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 40.h, height: 40.h, child: SvgPicture.asset(context.darkMode ? logo.branchLogoPathDarkMode! : logo.branchLogoPathLightMode!)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      logo.branchName ?? "",
                      style: TextStyle(fontSize: 16.sp, fontWeight: formProvider.branchLogoSelected == logo ? FontWeight.bold : FontWeight.normal),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListIconsCustom({required BuildContext context, required AccountFormProvider formProvider}) {
    return Selector<AccountFormProvider, List<IconCustomModel>>(
      selector: (context, formProvider) => formProvider.listIconsCustom,
      builder: (context, listIconsCustom, child) {
        return listIconsCustom.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/exclamation-mark.png", width: 80.w, height: 80.h),
                  SizedBox(height: 16.h),
                  Text("Không có biểu tượng tùy chỉnh", style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () => _pickImageFromGallery(context, formProvider, tabController),
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text("Thêm biểu tượng tùy chỉnh"),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                  ),
                ],
              ),
            )
            : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1),
              itemCount: listIconsCustom.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final icon = listIconsCustom[index];
                return RequestPro(
                  child: InkWell(
                    onTap: () {
                      formProvider.pickIcon(isCustomIcon: true, iconCustomModel: icon);
                      Navigator.pop(context);
                    },
                    child: Card(
                      elevation: formProvider.branchLogoSelected != null && formProvider.iconCustomName.text == icon.name ? 3 : 1,
                      color: formProvider.branchLogoSelected != null && formProvider.iconCustomName.text == icon.name ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(width: 60.h, height: 60.h, child: Image.memory(base64Decode(icon.imageBase64), fit: BoxFit.cover))),
                            SizedBox(height: 8.h),
                            Text(
                              icon.name,
                              style: TextStyle(fontSize: 14.sp, fontWeight: formProvider.branchLogoSelected != null && formProvider.iconCustomName.text == icon.name ? FontWeight.bold : FontWeight.normal),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
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

    // Show dialog to create custom icon
    if (!context.mounted) return;
    await _showIconNameDialog(context).then((iconName) {
      if (iconName != null && iconName.isNotEmpty) {
        formProvider.iconCustomName.text = iconName;
        formProvider.handleSaveIcon(imageBase64: base64Image);
        tabController.animateTo(1);
      }
    });
  }

  Future<String?> _showIconNameDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tên biểu tượng'),
          content: CustomTextField(
            controller: controller,
            autoFocus: true,
            hintText: 'Nhập tên biểu tượng',
            labelText: 'Tên biểu tượng',
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.start,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
