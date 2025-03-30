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

class OtpDesktopLayout extends StatefulWidget {
  const OtpDesktopLayout({super.key});

  @override
  State<OtpDesktopLayout> createState() => _OtpDesktopLayoutState();
}

class _OtpDesktopLayoutState extends State<OtpDesktopLayout> {
  List<AccountOjbModel> _otpAccounts = [];
  AccountOjbModel? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _loadOTPAccounts();
  }

  void _loadOTPAccounts() {
    final accounts = AccountBox.getAllWithOTP();
    setState(() {
      _otpAccounts = accounts;
      // Chọn tài khoản đầu tiên nếu có dữ liệu
      if (_otpAccounts.isNotEmpty && _selectedAccount == null) {
        _selectedAccount = _otpAccounts.first;
      }
    });
  }

  void _selectAccount(AccountOjbModel account) {
    setState(() {
      _selectedAccount = account;
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
                  Image.asset("assets/images/exclamation-mark.png", width: 100.w, height: 100.h),
                  SizedBox(height: 30.h),
                  Text(
                    "Không có tài khoản OTP nào",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CustomButtonWidget(
                    text: "Thêm tài khoản OTP",
                    onPressed: () {
                      addTOTPWithKeyboard(context);
                    },
                  ),
                ],
              ),
            )
          : Row(
              children: [
                // Panel bên trái - Danh sách tài khoản
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm tài khoản OTP',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _otpAccounts.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final account = _otpAccounts[index];
                            final isSelected = _selectedAccount?.id == account.id;
                            
                            return InkWell(
                              onTap: () => _selectAccount(account),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? Theme.of(context).colorScheme.secondaryContainer : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TotpItem(
                                  account: account,
                                  secretKey: account.totp.target?.secretKey ?? '',
                                  iconCustom: account.getIconCustom ?? IconCustomModel(name: '', imageBase64: ''),
                                  title: account.title,
                                  email: account.email ?? '',
                                  icon: account.icon ?? '',
                                  onTap: () {
                                    _selectAccount(account);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Panel bên phải - Chi tiết tài khoản
                Expanded(
                  child: _selectedAccount == null
                      ? const Center(
                          child: Text("Chọn một tài khoản để xem chi tiết"),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Center(
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 700),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            AppRoutes.navigateTo(context, AppRoutes.detailsAccount, arguments: {"accountId": _selectedAccount!.id});
                                          },
                                          icon: const Icon(Icons.arrow_outward, size: 24),
                                          tooltip: "Xem chi tiết tài khoản",
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          width: 120.h,
                                          height: 120.h,
                                          child: ColoredBox(
                                            color: Theme.of(context).colorScheme.secondaryContainer,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0), 
                                                child: IconShowComponent(
                                                  account: _selectedAccount!, 
                                                  width: 80.w, 
                                                  height: 80.h, 
                                                  isDecrypted: false
                                                )
                                              )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    DecryptText(
                                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold), 
                                      value: _selectedAccount!.title, 
                                      decryptTextType: DecryptTextType.info
                                    ),
                                    if (_selectedAccount!.email != null && _selectedAccount!.email!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: DecryptText(
                                          style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurfaceVariant), 
                                          value: _selectedAccount!.email ?? "", 
                                          decryptTextType: DecryptTextType.info
                                        ),
                                      ),
                                    const SizedBox(height: 50),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(maxWidth: 400),
                                          width: double.infinity,
                                          child: DecryptText(
                                            style: TextStyle(fontSize: 20.sp),
                                            decryptTextType: DecryptTextType.opt,
                                            value: _selectedAccount!.totp.target?.secretKey ?? "",
                                            builder: (context, value) {
                                              return CardCustomWidget(
                                                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30), 
                                                child: OtpTextWithCountdown(keySecret: value)
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        IconButton(
                                          onPressed: () async {
                                            if (_selectedAccount!.totp.target?.secretKey == null) return;
                                            String secretKey = await EncryptAppDataService.instance.decryptTOTPKey(_selectedAccount!.totp.target?.secretKey ?? "");
                                            clipboardCustom(context: context, text: generateTOTPCode(keySecret: secretKey));
                                          },
                                          icon: Icon(Icons.copy, size: 24.sp),
                                          tooltip: "Sao chép mã OTP",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
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
          left: 30, 
          right: 30,
          top: 30,
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
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              CustomTextField(
                controller: _accountController,
                hintText: 'Ví dụ: example@gmail.com',
                labelText: 'Account Name (Tên tài khoản)',
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 40),
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