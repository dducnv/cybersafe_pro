import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/otp/components/totp_item.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/otp_text_with_countdown/otp_text_with_countdown.dart';
import 'package:flutter/material.dart';

class OtpMobileLayout extends StatefulWidget {
  const OtpMobileLayout({super.key});

  @override
  State<OtpMobileLayout> createState() => _OtpMobileLayoutState();
}

class _OtpMobileLayoutState extends State<OtpMobileLayout> {
  List<AccountOjbModel> _otpAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadOTPAccounts();
  }

  void _loadOTPAccounts() {
    final accounts = AccountBox.getAllWithOTP();
    setState(() {
      _otpAccounts = accounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Accounts'), elevation: 0, scrolledUnderElevation: 0, backgroundColor: Theme.of(context).colorScheme.surface),

      body:
          _otpAccounts.isEmpty
              ? Center(child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _otpAccounts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final account = _otpAccounts[index];
                  return TotpItem(
                    account: account,
                    secretKey: account.totp.target?.secretKey ?? '',
                    iconCustom: account.getIconCustom ?? IconCustomModel(name: '', imageBase64: ''),
                    title: account.title,
                    email: account.email ?? '',
                    icon: account.icon ?? '',
                    onTap: () {
                      seeDetailTOTPBottomSheet(context, account);
                    },
                  );
                },
              ),
    );
  }

  Future<void> seeDetailTOTPBottomSheet(BuildContext context, AccountOjbModel totp) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        AppRoutes.navigateTo(context, AppRoutes.detailsAccount, arguments: {"accountId": totp.id});
                      },
                      icon: const Icon(Icons.arrow_outward),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: 50.h,
                      height: 50.h,
                      child: ColoredBox(color: Colors.grey.withOpacity(0.2), child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconShowComponent(account: totp, width: 45.w, height: 45.h, isDecrypted: false),
                      ))),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DecryptText(style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), value: totp.title, decryptTextType: DecryptTextType.info),
                DecryptText(style: TextStyle(fontSize: 16.sp), value: totp.email ?? "", decryptTextType: DecryptTextType.info),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DecryptText(
                        style: TextStyle(fontSize: 16.sp),
                        decryptTextType: DecryptTextType.opt,
                        value: totp.totp.target?.secretKey ?? "",
                        builder: (context, value) {
                          return CardCustomWidget(child: OtpTextWithCountdown(keySecret: value));
                        },
                      ),
                    ),

                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (totp.totp.target?.secretKey == null) return;
                        String secretKey = await EncryptAppDataService.instance.decryptTOTPKey(totp.totp.target?.secretKey ?? "");
                        clipboardCustom(context: context, text: generateTOTPCode(keySecret: secretKey));
                      },
                      icon: Icon(Icons.copy, size: 20.sp),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
