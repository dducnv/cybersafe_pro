import 'dart:convert';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/services/account/account_services.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: unnecessary_import
import 'package:characters/characters.dart';

class IconShowComponent extends StatelessWidget {
  final AccountDriftModelData account;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  const IconShowComponent({super.key, required this.account, this.width, this.height, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final branchLogo = allBranchLogos.firstWhere((element) => element.branchLogoSlug == account.icon, orElse: () => BranchLogo([], "default"));
    final iconCustom = AccountServices.instance.mapCustomIcon[account.iconCustomId];
    final canShowAppIcon =
        account.icon != "default" &&
        account.icon != null &&
        account.icon!.isNotEmpty &&
        branchLogo.branchLogoSlug != "default" &&
        branchLogo.branchLogoPathDarkMode != null &&
        branchLogo.branchLogoPathLightMode != null;
    if (account.iconCustomId != null && iconCustom?.imageBase64 != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: MemoryImage(base64Decode(iconCustom?.imageBase64 ?? "")),
          width: width ?? 50.h,
          height: height ?? 50.h,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
      );
    } else if (canShowAppIcon) {
      return SvgPicture.asset(context.darkMode ? branchLogo.branchLogoPathDarkMode! : branchLogo.branchLogoPathLightMode!, width: width ?? 30.h, height: height ?? 30.h);
    } else {
      return Center(
        child:
            !DataSecureService.isValueEncrypted(account.title)
                ? Text(account.title.isNotEmpty ? _getSafeFirstCharacter(account.title) : "?", style: textStyle ?? CustomTextStyle.regular(fontSize: 24.sp, fontWeight: FontWeight.bold))
                : DecryptText(
                  showLoading: false,
                  style: textStyle ?? CustomTextStyle.regular(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  value: account.title,
                  decryptTextType: DecryptTextType.info,
                  builder: (context, value) {
                    return Text(value.isNotEmpty ? _getSafeFirstCharacter(value) : "?", style: textStyle ?? CustomTextStyle.regular(fontSize: 24.sp, fontWeight: FontWeight.bold));
                  },
                ),
      );
    }
  }

  String _getSafeFirstCharacter(String text) {
    if (text.isEmpty) return "?";

    try {
      // Sử dụng package characters để xử lý đúng các ký tự Unicode
      final firstChar = text.characters.first;
      // Emoji không cần chuyển đổi chữ hoa/thường
      if (_isEmoji(firstChar)) return firstChar;
      return firstChar.toUpperCase();
    } catch (e) {
      return "?";
    }
  }

  bool _isEmoji(String text) {
    // Kiểm tra đơn giản nếu là emoji (có thể mở rộng)
    return text.codeUnits.length > 1;
  }
}
