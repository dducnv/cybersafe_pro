import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/create_account_text.dart';
import 'package:cybersafe_pro/localization/keys/otp_text.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/home_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/otp/components/totp_item.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/otp_qrcode_scan/otp_qrcode_scan.dart';
import 'package:cybersafe_pro/widgets/otp_text_with_countdown/otp_text_with_countdown.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class OtpMobileLayout extends StatefulWidget {
  const OtpMobileLayout({super.key});

  @override
  State<OtpMobileLayout> createState() => _OtpMobileLayoutState();
}

class _OtpMobileLayoutState extends State<OtpMobileLayout> {
  List<MapEntry<AccountDriftModelData, TOTPDriftModelData>> _otpAccounts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOTPAccounts();
    });
  }

  Future<void> _loadOTPAccounts() async {
    setState(() {
      _isLoading = true;
    });
    // Đợi 1 frame để tránh block UI
    await Future.delayed(Duration(milliseconds: 10));
    final accounts = await Future(() => DriffDbManager.instance.totpAdapter.getAllWithOTP());
    if (mounted) {
      setState(() {
        _otpAccounts = accounts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.trOtp(OtpText.title), style: CustomTextStyle.regular(fontSize: 18.sp)),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _otpAccounts.isEmpty
              ? Center(
                child: Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h),
              )
              : AnimationLimiter(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _otpAccounts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final account = _otpAccounts[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: TotpItem(
                            account: account.key,
                            secretKey: account.value.secretKey,
                            iconCustom: IconCustomModel(name: '', imageBase64: ''),
                            title: account.key.title,
                            email: account.key.username ?? '',
                            icon: account.key.icon ?? '',
                            onTap: () async {
                              // Giải mã trước khi mở bottom sheet
                              final secretKeyEncrypted = account.value.secretKey;
                              if (secretKeyEncrypted.isEmpty) {
                                seeDetailTOTPBottomSheet(context, account.key, account.value, '');
                                return;
                              }
                              showLoadingDialog(
                                context: context,
                              ); // Sửa lại truyền context đúng dạng
                              String decryptedSecretKey = '';
                              try {
                                decryptedSecretKey = await DataSecureService.decryptTOTPKey(
                                  secretKeyEncrypted,
                                );
                              } catch (e) {
                                decryptedSecretKey = '';
                              }
                              hideLoadingDialog();
                              if (context.mounted) {
                                seeDetailTOTPBottomSheet(
                                  context,
                                  account.key,
                                  account.value,
                                  decryptedSecretKey,
                                ); // Truyền trực tiếp
                              }
                            },
                          ),
                        ),
                      ),
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
              addTOTPWithKeyboard(
                context,
                callBackSuccess: () {
                  context.read<HomeProvider>().refreshData();
                  _loadOTPAccounts();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> addTOTPWithKeyboard(BuildContext context, {Function? callBackSuccess}) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddTOTPWithKeyboardBottomSheet(callBackSuccess: callBackSuccess);
      },
    );
  }

  Future<void> addTOTPWithQrcode(BuildContext context) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const QrcodeScaner()));
    if (result != null) {
      var otpCustom = OTP.fromUri(result.toString()).toJson();
      final secretKey = otpCustom['secret'];
      final issuer = otpCustom['issuer'];
      final accountName = otpCustom['accountName'];
      if (context.mounted) {
        await context.read<AccountProvider>().createAccountOnlyOtp(
          secretKey: secretKey,
          appName: issuer,
          accountName: accountName,
        );
        _loadOTPAccounts();
      }
    }
  }

  Future<void> seeDetailTOTPBottomSheet(
    BuildContext context,
    AccountDriftModelData account,
    TOTPDriftModelData totp,
    String decryptedSecretKey,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
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
                          AppRoutes.navigateTo(
                            context,
                            AppRoutes.detailsAccount,
                            arguments: {"accountId": account.id},
                          );
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
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconShowComponent(account: account, width: 45.w, height: 45.h),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DecryptText(
                    style: CustomTextStyle.regular(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    value: account.title,
                    decryptTextType: DecryptTextType.info,
                  ),
                  DecryptText(
                    style: CustomTextStyle.regular(fontSize: 16.sp),
                    value: account.username ?? "",
                    decryptTextType: DecryptTextType.info,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CardCustomWidget(
                          padding: EdgeInsets.all(10),
                          child:
                              (decryptedSecretKey.isEmpty)
                                  ? Text('Error', style: CustomTextStyle.regular(color: Colors.red))
                                  : OtpTextWithCountdown(keySecret: decryptedSecretKey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          if (decryptedSecretKey.isEmpty) return;
                          clipboardCustom(
                            context: context,
                            text: generateTOTPCode(keySecret: decryptedSecretKey),
                          );
                        },
                        icon: Icon(Icons.copy, size: 20.sp),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddTOTPWithKeyboardBottomSheet extends StatefulWidget {
  final Function? callBackSuccess;
  const AddTOTPWithKeyboardBottomSheet({super.key, this.callBackSuccess});

  @override
  State<AddTOTPWithKeyboardBottomSheet> createState() => _AddTOTPWithKeyboardBottomSheetState();
}

class _AddTOTPWithKeyboardBottomSheetState extends State<AddTOTPWithKeyboardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final controllerSecretKey = TextEditingController();
  final controllerIssuer = TextEditingController();
  final controllerAccountName = TextEditingController();
  bool isCreating = false;

  void _handleSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (controllerAccountName.text.isNotEmpty &&
          controllerIssuer.text.isNotEmpty &&
          controllerSecretKey.text.isNotEmpty &&
          !isCreating) {
        setState(() {
          isCreating = true;
        });
        await context.read<AccountProvider>().createAccountOnlyOtp(
          secretKey: controllerSecretKey.text,
          appName: controllerIssuer.text,
          accountName: controllerAccountName.text,
        );
        widget.callBackSuccess?.call();
        if (!context.mounted) return;
        Navigator.pop(context);
        if (!mounted) return;
        setState(() {
          isCreating = false;
        });
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        context.trOtp(OtpText.enterManually),
                        style: CustomTextStyle.regular(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _handleSubmit(context),
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                titleTextField: context.trOtp(OtpText.accountName),
                controller: controllerIssuer,
                autoFocus: true,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                hintText: context.trCreateAccount(CreateAccountText.appName),
                maxLines: 1,
                isObscure: false,
                requiredTextField: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return context.trSafe(CreateAccountText.appNameValidation);
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              CustomTextField(
                titleTextField: context.trCreateAccount(CreateAccountText.username),
                controller: controllerAccountName,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                hintText: context.trCreateAccount(CreateAccountText.username),
                maxLines: 1,
                isObscure: false,
                requiredTextField: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return context.trSafe(CreateAccountText.usernameValidation);
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              CustomTextField(
                titleTextField: context.trOtp(OtpText.secretKey),
                controller: controllerSecretKey,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.start,
                hintText: context.trOtp(OtpText.secretKey),
                requiredTextField: true,
                maxLines: 1,
                isObscure: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return context.trSafe(OtpText.secretKeyValidation);
                  }
                  if (!OTP.isKeyValid(value ?? '')) {
                    return context.trSafe(OtpText.invalidSecretKey);
                  }
                  return null;
                },
                onFieldSubmitted: (value) => _handleSubmit(context),
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
