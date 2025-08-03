import 'dart:convert';

import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/providers/account_form_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class IconPicker extends StatelessWidget {
  final Function() onTap;

  const IconPicker({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formProvider = context.read<AccountFormProvider>();
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: onTap,
            child:
                formProvider.selectedIconCustom != null
                    ? Image(
                      image: MemoryImage(
                        base64Decode(formProvider.selectedIconCustom!.imageBase64),
                      ),
                      width: 60.h,
                      height: 60.h,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    )
                    : formProvider.branchLogoSelected != null
                    ? SvgPicture.asset(
                      context.darkMode
                          ? formProvider.branchLogoSelected!.branchLogoPathDarkMode!
                          : formProvider.branchLogoSelected!.branchLogoPathLightMode!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    )
                    : const Center(child: Icon(Icons.add)),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              context.appLocale.createAccountLocale.getText(CreateAccountText.chooseIcon),
              style: CustomTextStyle.regular(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
