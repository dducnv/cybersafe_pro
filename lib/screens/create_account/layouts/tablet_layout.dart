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
          body: Center(child: Container(constraints: const BoxConstraints(maxWidth: 800), child: SizedBox.shrink())),
          floatingActionButton: _buildSubmitButton(context, formProvider, accountProvider),
        );
      },
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

  //pick image from gallery
}
