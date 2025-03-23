import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/otp/components/totp_item.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/otp_qrcode_scan/otp_qrcode_scan.dart';
import 'package:cybersafe_pro/widgets/otp_text_with_countdown/otp_text_with_countdown.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

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

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        overlayOpacity: 0.1,
        renderOverlay: false,
        spacing: 12,
        spaceBetweenChildren: 6,
        children: [
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(Icons.qr_code_scanner_rounded),
            onTap: () {
              addTOTPWithQrcode(context);
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(Icons.keyboard_alt_rounded),
            onTap: () {
              addTOTPWithKeyboard(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> addTOTPWithKeyboard(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const AddTOTPWithKeyboardBottomSheet();
      },
    );
  }

  Future<void> addTOTPWithQrcode(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QrcodeScaner()));
    if (result != null) {
      var otpCustom = OTP.fromUri(result.toString()).toJson();
      final secretKey = otpCustom['secret'];
      final issuer = otpCustom['issuer'];
      final accountName = otpCustom['accountName'];
      if (context.mounted) {
        await context.read<AccountProvider>().createAccountOnlyOtp(secretKey: secretKey, issuer: issuer, accountName: accountName);
        _loadOTPAccounts();
      }
    }
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
                      child: ColoredBox(
                        color: Colors.grey.withOpacity(0.2),
                        child: Center(child: Padding(padding: const EdgeInsets.all(8.0), child: IconShowComponent(account: totp, width: 45.w, height: 45.h, isDecrypted: false))),
                      ),
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

class AddTOTPWithKeyboardBottomSheet extends StatefulWidget {
  const AddTOTPWithKeyboardBottomSheet({super.key});

  @override
  State<AddTOTPWithKeyboardBottomSheet> createState() => _AddTOTPWithKeyboardBottomSheetState();
}

class _AddTOTPWithKeyboardBottomSheetState extends State<AddTOTPWithKeyboardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final controllerSecretKey = TextEditingController();
  final controllerIssuer = TextEditingController();
  final controllerAccountName = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (controllerAccountName.text.isNotEmpty && controllerIssuer.text.isNotEmpty && controllerSecretKey.text.isNotEmpty) {
        context.read<AccountProvider>().createAccountOnlyOtp(secretKey: controllerSecretKey.text, issuer: controllerIssuer.text, accountName: controllerAccountName.text);
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    controllerSecretKey.dispose();
    controllerIssuer.dispose();
    controllerAccountName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  Expanded(child: Center(child: Text("Thêm thủ công", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800])))),
                  IconButton(onPressed: _handleSubmit, icon: const Icon(Icons.check)),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                titleTextField: "Tên tài khoản",
                controller: controllerAccountName,
                autoFocus: true,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                hintText: "Tên tài khoản",
                maxLines: 1,
                isObscure: false,
                requiredTextField: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập tên tài khoản';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              CustomTextField(
                titleTextField: "Tên đăng nhập",
                controller: controllerIssuer,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                hintText: "Tên đăng nhập",
                maxLines: 1,
                isObscure: false,
                requiredTextField: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              CustomTextField(
                titleTextField: "Khoá bảo mật",
                controller: controllerSecretKey,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.start,
                hintText: "Nhập khoá bảo mật",
                requiredTextField: true,
                maxLines: 1,
                isObscure: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập khoá bảo mật';
                  }
                  if (!OTP.isKeyValid(value ?? '')) {
                    return 'Khoá bảo mật không hợp lệ';
                  }
                  return null;
                },
                onFieldSubmitted: (value) => _handleSubmit(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
