import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/details_account_text.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/item_custom/item_copy_value.dart';
import 'package:cybersafe_pro/widgets/otp_text_with_countdown/otp_text_with_countdown.dart';
import 'package:cybersafe_pro/widgets/request_pro/request_pro.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DetailsAccountMobileLayout extends StatefulWidget {
  final AccountOjbModel accountOjbModel;
  const DetailsAccountMobileLayout({super.key, required this.accountOjbModel});

  @override
  State<DetailsAccountMobileLayout> createState() => _DetailsAccountMobileLayoutState();
}

class _DetailsAccountMobileLayoutState extends State<DetailsAccountMobileLayout> {
  final decryptService = EncryptAppDataService.instance;
  late AccountOjbModel _accountOjbModel;

  @override
  void initState() {
    super.initState();
    _accountOjbModel = widget.accountOjbModel;
  }

  // Getter để truy cập accountOjbModel
  AccountOjbModel get accountOjbModel => _accountOjbModel;

  Future<void> reloadAccount() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      AccountOjbModel? accountOjbModelLoaded = await AccountBox.getById(widget.accountOjbModel.id);
      if (accountOjbModelLoaded != null) {
        setState(() {
          _accountOjbModel = accountOjbModelLoaded;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> detailBlocks = [
      _buildAccountIcon(),
      if (accountOjbModel.totp.target != null && accountOjbModel.totp.target?.secretKey != null) _buildTOTPWidget(accountOjbModel),
      if ((accountOjbModel.email != null && accountOjbModel.email!.isNotEmpty) || (accountOjbModel.password != null && accountOjbModel.password!.isNotEmpty)) _buildBaseInfo(),
      _buildCategory(),
      if (accountOjbModel.notes != null && accountOjbModel.notes!.isNotEmpty) _buildNoteWidget(),
      if (accountOjbModel.customFields.isNotEmpty) _buildCustomFieldsWidget(accountOjbModel),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (accountOjbModel.passwordHistories.isNotEmpty) _buildPasswordHistoryWidget(accountOjbModel),
          const SizedBox(height: 10),
          _buildUpdatedAtWidget(accountOjbModel),
        ],
      ),
      const SizedBox(height: 16),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10))),
                          SizedBox(height: 10.h),
                          ListTile(
                            title: Text(context.trDetails(DetailsAccountText.editAccount)),
                            onTap: () async {
                              AppRoutes.pop(context);
                              await AppRoutes.navigateTo(context, AppRoutes.updateAccount, arguments: {"accountId": accountOjbModel.id});
                              reloadAccount();
                            },
                          ),
                          ListTile(
                            title: Text(context.trDetails(DetailsAccountText.deleteAccount), style: CustomTextStyle.regular(color: Theme.of(context).colorScheme.error)),
                            onTap: () {
                              showAppCustomDialog(
                                context,
                                AppCustomDialog(
                                  title: context.trSafe(DetailsAccountText.deleteAccount),
                                  message: context.trSafe(DetailsAccountText.deleteAccountQuestion),
                                  confirmText: context.trSafe(DetailsAccountText.deleteAccount),
                                  cancelText: context.trSafe(DetailsAccountText.cancel),
                                  isCountDownTimer: true,
                                  onConfirm: () async {
                                    await context.read<AccountProvider>().deleteAccount(widget.accountOjbModel);
                                    if (!context.mounted) return;
                                    context.read<CategoryProvider>().refresh();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: AnimationLimiter(
            child: Column(
              children: List.generate(
                detailBlocks.length,
                (index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: detailBlocks[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountIcon() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 70.h,
            height: 70.h,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: IconShowComponent(
                account: accountOjbModel,
                width: 50.h,
                height: 50.h,
                isDecrypted: false,
                textStyle: CustomTextStyle.regular(fontSize: 30.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          DecryptText(showLoading: true, style: CustomTextStyle.regular(fontWeight: FontWeight.bold, fontSize: 20.sp), value: accountOjbModel.title, decryptTextType: DecryptTextType.info),
        ],
      ),
    );
  }

  Widget _buildBaseInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(context.trDetails(DetailsAccountText.baseInfo), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        SizedBox(height: 5.h),
        CardCustomWidget(
          child: Column(
            children: [
              if (accountOjbModel.email != null && accountOjbModel.email!.isNotEmpty)
                ItemCopyValue(title: context.trDetails(DetailsAccountText.username), value: accountOjbModel.email!, isLastItem: accountOjbModel.password?.isEmpty ?? true),
              if (accountOjbModel.password != null && accountOjbModel.password!.isNotEmpty && accountOjbModel.email != null && accountOjbModel.email!.isNotEmpty)
                Padding(padding: EdgeInsets.symmetric(vertical: 5.h), child: Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest)),
              if (accountOjbModel.password != null && accountOjbModel.password!.isNotEmpty)
                ItemCopyValue(title: context.trDetails(DetailsAccountText.password), value: accountOjbModel.password!, isLastItem: true, isPrivateValue: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(context.trDetails(DetailsAccountText.category), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        CardCustomWidget(
          child: Row(
            children: [
              Icon(Icons.folder, color: Theme.of(context).colorScheme.primary, size: 24.sp),
              const SizedBox(width: 10),
              Text(accountOjbModel.category.target?.categoryName ?? "", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteWidget() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(context.trDetails(DetailsAccountText.note), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]))],
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future: decryptService.decryptInfo(accountOjbModel.notes ?? ""),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return CustomTextField(
                    borderRadius: BorderRadius.circular(25),
                    contentPadding: const EdgeInsets.all(15),
                    readOnly: true,
                    autoFocus: true,
                    borderColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    requiredTextField: false,
                    textInputType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    textAlign: TextAlign.start,
                    minLines: 1,
                    textStyle: CustomTextStyle.regular(),
                    maxLines: null,
                    isObscure: false,
                    controller: TextEditingController(text: snapshot.data),
                  );
                }
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.primary.withValues(alpha: .4),
                  highlightColor: Theme.of(context).colorScheme.primary,
                  child: Text('Decrypting...', textAlign: TextAlign.start, style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomFieldsWidget(AccountOjbModel account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(context.trDetails(DetailsAccountText.customFields), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        CardCustomWidget(
          child: Column(
            children: [
              ...account.customFields.map(
                (element) => Column(
                  children: [
                    ItemCopyValue(
                      title: element.hintText,
                      value: element.value,
                      isPrivateValue: element.typeField.toLowerCase().contains("password"),
                      isLastItem: account.customFields.last == element,
                    ),
                    if (account.customFields.last != element) Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTOTPWidget(AccountOjbModel account) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.trDetails(DetailsAccountText.otpCode), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        RequestPro(
          child: CardCustomWidget(
            padding: const EdgeInsets.all(0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  HapticFeedback.selectionClick();
                  final decryptService = EncryptAppDataService.instance;
                  final decryptPassword = await decryptService.decryptTOTPKey(account.totp.target!.secretKey);
                  final otpCode = generateTOTPCode(keySecret: decryptPassword);
                  if (otpCode.isNotEmpty && mounted) {
                    clipboardCustom(context: context, text: otpCode);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: decryptService.decryptTOTPKey(account.totp.target!.secretKey),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return OtpTextWithCountdown(keySecret: snapshot.data!);
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      Icon(Icons.copy, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatedAtWidget(AccountOjbModel account) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "${context.trDetails(DetailsAccountText.updatedAt)}: ", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          TextSpan(text: account.updatedAtFormat, style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildPasswordHistoryWidget(AccountOjbModel account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "${context.trDetails(DetailsAccountText.passwordHistoryTitle)}: ", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                  TextSpan(text: "${account.passwordHistories.length}", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
            RequestPro(
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  bottomSheetPasswordHistory(context: context, accountOjbModel: account);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  child: Text(
                    context.trDetails(DetailsAccountText.passwordHistoryDetail),
                    style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> bottomSheetPasswordHistory({required BuildContext context, required AccountOjbModel accountOjbModel}) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.trDetails(DetailsAccountText.passwordHistoryTitle), style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, size: 22),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: accountOjbModel.passwordHistories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final passwordHistory = accountOjbModel.passwordHistories[index];
                      return ListTile(
                        title: DecryptText(decryptTextType: DecryptTextType.password, style: Theme.of(context).textTheme.bodyLarge!, value: passwordHistory.password),
                        subtitle: Text(passwordHistory.createdAtFormat, style: Theme.of(context).textTheme.bodyMedium),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () async {
                            final decryptService = EncryptAppDataService.instance;
                            final decryptPassword = await decryptService.decryptPassword(passwordHistory.password);
                            if (decryptPassword.isNotEmpty && context.mounted) {
                              clipboardCustom(context: context, text: decryptPassword);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
