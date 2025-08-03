import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/details_account_text.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/details_account_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
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
  final int accountId;

  const DetailsAccountMobileLayout({super.key, required this.accountId});

  @override
  State<DetailsAccountMobileLayout> createState() => _DetailsAccountMobileLayoutState();
}

class _DetailsAccountMobileLayoutState extends State<DetailsAccountMobileLayout> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsAccountProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingScreen();
        }

        if (provider.accountDriftModelData == null) {
          return _buildErrorScreen();
        }

        return _buildMainContent(provider);
      },
    );
  }

  /// Main content with all account details
  Widget _buildMainContent(DetailsAccountProvider provider) {
    final account = provider.accountDriftModelData!;
    final detailBlocks = _buildDetailBlocks(provider, account);

    return Scaffold(
      appBar: _buildAppBar(provider),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimationLimiter(
            child: Column(
              children: List.generate(
                detailBlocks.length,
                (index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(verticalOffset: 30.0, child: FadeInAnimation(child: detailBlocks[index])),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build all detail blocks for the account
  List<Widget> _buildDetailBlocks(DetailsAccountProvider provider, AccountDriftModelData account) {
    final blocks = <Widget>[];

    // Account icon and title
    blocks.add(_AccountIconSection(account: account));

    // TOTP section (if available)
    if (_hasTOTP(provider)) {
      blocks.add(_TOTPSection(totpData: provider.totpDriftModelData!, account: account));
    }

    // Base info section (username/password)
    if (_hasBaseInfo(account)) {
      blocks.add(_BaseInfoSection(account: account));
    }

    // Category section
    blocks.add(_CategorySection(category: provider.categoryDriftModelData));

    // Notes section (if available)
    if (_hasNotes(account)) {
      blocks.add(_NotesSection(account: account));
    }

    // Custom fields section (if available)
    if (_hasCustomFields(provider)) {
      blocks.add(_CustomFieldsSection(customFields: provider.accountCustomFieldDriftModelData!));
    }

    // Password history and updated at
    blocks.add(_PasswordHistoryAndUpdatedSection(passwordHistories: provider.passwordHistoryDriftModelData, account: account));

    blocks.add(const SizedBox(height: 16));

    return blocks;
  }

  /// Check if account has TOTP data
  bool _hasTOTP(DetailsAccountProvider provider) {
    return provider.totpDriftModelData != null && provider.totpDriftModelData?.secretKey != null;
  }

  /// Check if account has base info (username/password)
  bool _hasBaseInfo(AccountDriftModelData account) {
    return (account.username != null && account.username!.isNotEmpty) || (account.password != null && account.password!.isNotEmpty);
  }

  /// Check if account has notes
  bool _hasNotes(AccountDriftModelData account) {
    return account.notes != null && account.notes!.isNotEmpty;
  }

  /// Check if account has custom fields
  bool _hasCustomFields(DetailsAccountProvider provider) {
    return provider.accountCustomFieldDriftModelData != null && provider.accountCustomFieldDriftModelData!.isNotEmpty;
  }

  /// App bar with actions
  PreferredSizeWidget _buildAppBar(DetailsAccountProvider provider) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: [IconButton(onPressed: () => _showActionBottomSheet(provider), icon: const Icon(Icons.more_vert))],
    );
  }

  /// Loading screen
  Widget _buildLoadingScreen() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  /// Error screen
  Widget _buildErrorScreen() {
    return Scaffold(appBar: AppBar(title: const Text('Account Details')), body: const Center(child: Text('Account not found')));
  }

  /// Show action bottom sheet (edit/delete)
  void _showActionBottomSheet(DetailsAccountProvider provider) {
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
                _buildBottomSheetHandle(),
                SizedBox(height: 10.h),
                _buildActionListTile(title: context.trDetails(DetailsAccountText.editAccount), onTap: () => _handleEditAccount()),
                _buildActionListTile(
                  title: context.trDetails(DetailsAccountText.deleteAccount),
                  style: CustomTextStyle.regular(color: Theme.of(context).colorScheme.error),
                  onTap: () => _handleDeleteAccount(provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Bottom sheet handle
  Widget _buildBottomSheetHandle() {
    return Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)));
  }

  /// Action list tile
  Widget _buildActionListTile({required String title, TextStyle? style, required VoidCallback onTap}) {
    return ListTile(title: Text(title, style: style), onTap: onTap);
  }

  /// Handle edit account action
  Future<void> _handleEditAccount() async {
    AppRoutes.pop(context);
    await AppRoutes.navigateTo(context, AppRoutes.updateAccount, arguments: {"accountId": widget.accountId});

    if (!mounted) return;
    context.read<DetailsAccountProvider>().loadAccountDetails(widget.accountId);
  }

  /// Handle delete account action
  void _handleDeleteAccount(DetailsAccountProvider provider) {
    showAppCustomDialog(
      context,
      AppCustomDialog(
        title: context.trSafe(DetailsAccountText.deleteAccount),
        message: context.trSafe(DetailsAccountText.deleteAccountQuestion),
        confirmText: context.trSafe(DetailsAccountText.deleteAccount),
        cancelText: context.trSafe(DetailsAccountText.cancel),
        isCountDownTimer: true,
        onConfirm: () => _performDeleteAccount(provider),
      ),
    );
  }

  /// Perform account deletion
  Future<void> _performDeleteAccount(DetailsAccountProvider provider) async {
    await context.read<AccountProvider>().deleteAccount(provider.accountDriftModelData!);

    if (!mounted) return;

    context.read<CategoryProvider>().refresh();
    Navigator.of(context).pop(); // Close dialog
    Navigator.of(context).pop(); // Close details screen
  }
}

/// Account icon and title section
class _AccountIconSection extends StatelessWidget {
  final AccountDriftModelData account;

  const _AccountIconSection({required this.account});

  @override
  Widget build(BuildContext context) {
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
                account: account,
                width: 50.h,
                height: 50.h,
                textStyle: CustomTextStyle.regular(fontSize: 30.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          DecryptText(showLoading: true, style: CustomTextStyle.regular(fontWeight: FontWeight.bold, fontSize: 20.sp), value: account.title, decryptTextType: DecryptTextType.info),
        ],
      ),
    );
  }
}

/// TOTP section
class _TOTPSection extends StatelessWidget {
  final TOTPDriftModelData totpData;
  final AccountDriftModelData account;

  const _TOTPSection({required this.totpData, required this.account});

  @override
  Widget build(BuildContext context) {
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
                onTap: () => _handleTOTPCopy(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: DataSecureService.decryptTOTPKey(totpData.secretKey),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return OtpTextWithCountdown(keySecret: snapshot.data!);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const Icon(Icons.copy, size: 18),
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

  Future<void> _handleTOTPCopy(BuildContext context) async {
    HapticFeedback.selectionClick();
    final decryptPassword = await DataSecureService.decryptTOTPKey(totpData.secretKey);
    final otpCode = generateTOTPCode(keySecret: decryptPassword);

    if (otpCode.isNotEmpty && context.mounted) {
      clipboardCustom(context: context, text: otpCode);
    }
  }
}

/// Base info section (username/password)
class _BaseInfoSection extends StatelessWidget {
  final AccountDriftModelData account;

  const _BaseInfoSection({required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(context.trDetails(DetailsAccountText.baseInfo), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        SizedBox(height: 5.h),
        CardCustomWidget(child: Column(children: [if (_hasUsername) _buildUsernameField(), if (_hasBothUsernameAndPassword) _buildDivider(context), if (_hasPassword) _buildPasswordField()])),
      ],
    );
  }

  bool get _hasUsername => account.username != null && account.username!.isNotEmpty;

  bool get _hasPassword => account.password != null && account.password!.isNotEmpty;

  bool get _hasBothUsernameAndPassword => _hasUsername && _hasPassword;

  Widget _buildUsernameField() {
    return Builder(builder: (context) => ItemCopyValue(title: context.trDetails(DetailsAccountText.username), value: account.username!, isLastItem: !_hasPassword));
  }

  Widget _buildPasswordField() {
    return Builder(builder: (context) => ItemCopyValue(title: context.trDetails(DetailsAccountText.password), value: account.password!, isLastItem: true, isPrivateValue: true));
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 5.h), child: Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest));
  }
}

/// Category section
class _CategorySection extends StatelessWidget {
  final CategoryDriftModelData? category;

  const _CategorySection({this.category});

  @override
  Widget build(BuildContext context) {
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
              Text(category?.categoryName ?? "", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Notes section
class _NotesSection extends StatelessWidget {
  final AccountDriftModelData account;

  const _NotesSection({required this.account});

  @override
  Widget build(BuildContext context) {
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
              future: DataSecureService.decryptInfo(account.notes ?? ""),
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
}

/// Custom fields section
class _CustomFieldsSection extends StatelessWidget {
  final List<AccountCustomFieldDriftModelData> customFields;

  const _CustomFieldsSection({required this.customFields});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(context.trDetails(DetailsAccountText.customFields), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        CardCustomWidget(child: Column(children: customFields.map((field) => _buildCustomField(context, field)).toList())),
      ],
    );
  }

  Widget _buildCustomField(BuildContext context, AccountCustomFieldDriftModelData field) {
    final isLast = customFields.last == field;

    return Column(
      children: [
        ItemCopyValue(title: field.hintText, value: field.value, isPrivateValue: field.typeField.toLowerCase().contains("password"), isLastItem: isLast),
        if (!isLast) Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ],
    );
  }
}

/// Password history and updated at section
class _PasswordHistoryAndUpdatedSection extends StatelessWidget {
  final List<PasswordHistoryDriftModelData>? passwordHistories;
  final AccountDriftModelData account;

  const _PasswordHistoryAndUpdatedSection({this.passwordHistories, required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (_hasPasswordHistory) _buildPasswordHistoryWidget(context), const SizedBox(height: 10), _buildUpdatedAtWidget(context)]);
  }

  bool get _hasPasswordHistory => passwordHistories != null && passwordHistories!.isNotEmpty;

  Widget _buildPasswordHistoryWidget(BuildContext context) {
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
                  TextSpan(
                    text: "${context.trDetails(DetailsAccountText.passwordHistoryTitle)}: ",
                    style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                  ),
                  TextSpan(text: "${passwordHistories!.length}", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
            RequestPro(
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => _showPasswordHistoryBottomSheet(context),
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

  Widget _buildUpdatedAtWidget(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "${context.trDetails(DetailsAccountText.updatedAt)}: ", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          TextSpan(text: formatDateTime(account.updatedAt), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showPasswordHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_buildBottomSheetHeader(context), Expanded(child: _buildPasswordHistoryList(context))],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.trDetails(DetailsAccountText.passwordHistoryTitle), style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 22)),
        ],
      ),
    );
  }

  Widget _buildPasswordHistoryList(BuildContext context) {
    return ListView.builder(
      itemCount: passwordHistories!.length,
      itemBuilder: (BuildContext context, int index) {
        final passwordHistory = passwordHistories![index];
        return ListTile(
          title: DecryptText(decryptTextType: DecryptTextType.password, style: Theme.of(context).textTheme.bodyLarge!, value: passwordHistory.password),
          subtitle: Text(formatDateTime(passwordHistory.createdAt), style: Theme.of(context).textTheme.bodyMedium),
          trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () => _copyPasswordHistory(context, passwordHistory)),
        );
      },
    );
  }

  Future<void> _copyPasswordHistory(BuildContext context, PasswordHistoryDriftModelData passwordHistory) async {
    final decryptPassword = await DataSecureService.decryptPassword(passwordHistory.password);

    if (decryptPassword.isNotEmpty && context.mounted) {
      clipboardCustom(context: context, text: decryptPassword);
    }
  }
}
