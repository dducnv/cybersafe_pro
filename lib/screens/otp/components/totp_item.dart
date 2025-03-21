
import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:flutter/material.dart';

class TotpItem extends StatefulWidget {
  final AccountOjbModel account;
  final String secretKey;
  final IconCustomModel iconCustom;
  final String icon;
  final String title;
  final String email;
  final Function() onTap;

  const TotpItem({super.key, required this.secretKey, required this.iconCustom, required this.title, required this.email, required this.icon, required this.onTap, required this.account});

  @override
  State<TotpItem> createState() => _TotpItemState();
}

class _TotpItemState extends State<TotpItem> {
  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(width: 50.h, height: 50.h, child: ColoredBox(color: Colors.grey.withValues(alpha: 0.2), child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconShowComponent(account: widget.account, width: 45.w, height: 45.h, isDecrypted: false),
                      )))),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DecryptText(value: widget.title, decryptTextType: DecryptTextType.info, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                          if (widget.email.isNotEmpty) DecryptText(value: widget.email, decryptTextType: DecryptTextType.info, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    if (widget.secretKey.isEmpty) return;
                    String secretKey = await EncryptAppDataService.instance.decryptTOTPKey(widget.secretKey);
                    clipboardCustom(context: context, text: generateTOTPCode(keySecret: secretKey));
                  },
                  icon: Icon(Icons.copy, size: 20.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
