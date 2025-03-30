import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
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

class OtpTabletLayout extends StatefulWidget {
  const OtpTabletLayout({super.key});

  @override
  State<OtpTabletLayout> createState() => _OtpTabletLayoutState();
}

class _OtpTabletLayoutState extends State<OtpTabletLayout> {
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
      appBar: AppBar(
        title: const Text('OTP Accounts'), 
        elevation: 0, 
        scrolledUnderElevation: 0, 
        backgroundColor: Theme.of(context).colorScheme.surface
      ),
      body: _otpAccounts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/exclamation-mark.png", width: 80.w, height: 80.h),
                  SizedBox(height: 20.h),
                  Text(
                    "Không có tài khoản OTP nào",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Tính toán số cột dựa trên độ rộng của màn hình
                  int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
                  
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _otpAccounts.length,
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
                          seeDetailTOTPBottomSheet(
                            context,
                            account,
                            callBackSuccess: () {
                              context.read<CategoryProvider>().refresh();
                              _loadOTPAccounts();
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
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
        await context.read<AccountProvider>().createAccountOnlyOtp(secretKey: secretKey, appName: issuer, accountName: accountName);
        _loadOTPAccounts();
      }
    }
  }

  Future<void> seeDetailTOTPBottomSheet(BuildContext context, AccountOjbModel totp, {Function? callBackSuccess}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
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
                            icon: const Icon(Icons.arrow_outward, size: 24),
                            tooltip: "Xem chi tiết tài khoản",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: 80.h,
                            height: 80.h,
                            child: ColoredBox(
                              color: Colors.grey.withOpacity(0.2),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0), 
                                  child: IconShowComponent(
                                    account: totp, 
                                    width: 60.w, 
                                    height: 60.h, 
                                    isDecrypted: false
                                  )
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DecryptText(
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold), 
                        value: totp.title, 
                        decryptTextType: DecryptTextType.info
                      ),
                      if (totp.email != null && totp.email!.isNotEmpty)
                        DecryptText(
                          style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurfaceVariant), 
                          value: totp.email ?? "", 
                          decryptTextType: DecryptTextType.info
                        ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: DecryptText(
                              style: TextStyle(fontSize: 18.sp),
                              decryptTextType: DecryptTextType.opt,
                              value: totp.totp.target?.secretKey ?? "",
                              builder: (context, value) {
                                return CardCustomWidget(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), 
                                  child: OtpTextWithCountdown(keySecret: value)
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              if (totp.totp.target?.secretKey == null) return;
                              String secretKey = await EncryptAppDataService.instance.decryptTOTPKey(totp.totp.target?.secretKey ?? "");
                              clipboardCustom(context: context, text: generateTOTPCode(keySecret: secretKey));
                            },
                            icon: Icon(Icons.copy, size: 24.sp),
                            tooltip: "Sao chép mã OTP",
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
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
  final TextEditingController _secretController = TextEditingController();
  final TextEditingController _issuerController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  @override
  void dispose() {
    _secretController.dispose();
    _issuerController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 24, 
          right: 24,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thêm tài khoản OTP',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _secretController,
                hintText: 'Nhập Mã bí mật',
                labelText: 'Secret Key *',
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập secret key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _issuerController,
                hintText: 'Ví dụ: Google, Facebook,...',
                labelText: 'Issuer (Tên ứng dụng) *',
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên ứng dụng';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _accountController,
                hintText: 'Ví dụ: example@gmail.com',
                labelText: 'Account Name (Tên tài khoản)',
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  text: 'Thêm tài khoản',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<AccountProvider>().createAccountOnlyOtp(
                            secretKey: _secretController.text,
                            appName: _issuerController.text,
                            accountName: _accountController.text,
                          );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}