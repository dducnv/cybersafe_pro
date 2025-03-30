import 'dart:convert';

import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/resources/brand_logo.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:characters/characters.dart';

class IconShowComponent extends StatelessWidget {
  final AccountOjbModel account;
  final bool isDecrypted;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  const IconShowComponent({super.key, required this.account, this.isDecrypted = false, this.width, this.height, this.textStyle});

  @override
  Widget build(BuildContext context) {
    if (account.iconCustom.target != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: MemoryImage(base64Decode(account.iconCustom.target!.imageBase64)),
          width: width ?? 50.h,
          height: height ?? 50.h,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
      );
    } else if (account.icon != "default" && account.icon != null && account.icon!.isNotEmpty) {
      final branchLogo = allBranchLogos.firstWhere((element) => element.branchLogoSlug == account.icon, orElse: () => BranchLogo([], "default"));
      return SvgPicture.asset(context.darkMode ? branchLogo.branchLogoPathDarkMode! : branchLogo.branchLogoPathLightMode!, width: width ?? 30.h, height: height ?? 30.h);
    } else {
      return Center(
        child:
            isDecrypted
                ? Text(account.title.isNotEmpty ? _getSafeFirstCharacter(account.title) : "?", style: textStyle ?? TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold))
                : DecryptText(
                  showLoading: false,
                  style: textStyle ?? TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  value: account.title,
                  decryptTextType: DecryptTextType.info,
                  builder: (context, value) {
                    return Text(value.isNotEmpty ? _getSafeFirstCharacter(value) : "?", style: textStyle ?? TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold));
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
