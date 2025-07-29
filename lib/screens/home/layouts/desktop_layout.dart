import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/details_account_text.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/desktop_home_provider.dart';
import 'package:cybersafe_pro/providers/details_account_provider.dart';
import 'package:cybersafe_pro/providers/home_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/category_manager/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/create_account/create_account_screen.dart' show CreateAccountScreen;
import 'package:cybersafe_pro/screens/create_account/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/home/components/desktop_appbar.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/screens/settings/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/statistic/statistic_screen.dart';
import 'package:cybersafe_pro/screens/otp/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/account_list_tile_widgets.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/card_item.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/item_custom/item_copy_value.dart';
import 'package:cybersafe_pro/widgets/modal_side_sheet/modal_side_sheet.dart';
import 'package:cybersafe_pro/widgets/otp_text_with_countdown/otp_text_with_countdown.dart';
import 'package:cybersafe_pro/widgets/request_pro/request_pro.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeDesktopLayout extends StatefulWidget {
  const HomeDesktopLayout({super.key});

  @override
  State<HomeDesktopLayout> createState() => _HomeDesktopLayoutState();
}

class _HomeDesktopLayoutState extends State<HomeDesktopLayout> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Kiểm tra nếu có màn hình hiện tại cần hiển thị
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndOpenCurrentScreen();
    });

    // Lắng nghe sự thay đổi của currentScreen
    DeviceInfo.currentScreen.addListener(_checkAndOpenCurrentScreen);
  }

  @override
  void dispose() {
    DeviceInfo.currentScreen.removeListener(_checkAndOpenCurrentScreen);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkAndOpenCurrentScreen() {
    final currentScreen = DeviceInfo.currentScreen.value;
    if (currentScreen == null || currentScreen == AppRoutes.home) return;

    // Reset giá trị để tránh mở lại khi quay lại màn hình này
    final screenToOpen = currentScreen;
    DeviceInfo.currentScreen.value = AppRoutes.home;

    // Mở modal side sheet tương ứng với màn hình hiện tại
    switch (screenToOpen) {
      case AppRoutes.createAccount:
      case AppRoutes.updateAccount:
        _openCreateAccountSheet();
        break;
      case AppRoutes.settingsRoute:
        _openSettingsSheet();
        break;
      case AppRoutes.passwordGenerator:
        _openPasswordGeneratorSheet();
        break;
      case AppRoutes.statistic:
        _openStatisticSheet();
        break;
      case AppRoutes.categoryManager:
        _openCategoryManagerSheet();
        break;
      case AppRoutes.otpList:
        _openOtpListSheet();
        break;
    }
  }

  void _openCreateAccountSheet() {
    showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: const CreateAccountMobileLayout());
  }

  void _openSettingsSheet() {
    showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: const SettingMobileLayout());
  }

  void _openPasswordGeneratorSheet() {
    showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: const PasswordGenerateScreen());
  }

  void _openStatisticSheet() {
    showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: const StatisticScreen());
  }

  void _openCategoryManagerSheet() {
    showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: const CategoryManagerMobileLayout());
  }

  void _openOtpListSheet() {
    showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: const OtpMobileLayout());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: DesktopAppbar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Sidebar bên trái
                  Container(
                    width: 80,
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildNavItem(icon: Icons.category, onTap: _openCategoryManagerSheet),
                        _buildNavItem(icon: Icons.password_rounded, onTap: _openPasswordGeneratorSheet),
                        _buildNavItem(icon: Icons.bar_chart_rounded, onTap: _openStatisticSheet),
                        _buildNavItem(icon: Icons.key, onTap: _openOtpListSheet),
                      ],
                    ),
                  ),

                  // Danh sách tài khoản
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border(right: BorderSide(color: context.darkMode ? Colors.grey.shade800 : Colors.grey.shade300, width: 1)),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () {
                                return Future.wait([]);
                              },
                              child: Consumer<HomeProvider>(
                                builder: (context, homeProvider, child) {
                                  final groupedAccounts = homeProvider.groupedAccounts;

                                  if (groupedAccounts.isEmpty) {
                                    return _buildEmptyData();
                                  }

                                  return ListView.builder(
                                    controller: _scrollController,
                                    itemCount: groupedAccounts.length,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final categoryProvider = homeProvider.categoryProvider;

                                      final categoryKeys = groupedAccounts.keys.toList();
                                      final categoryId = categoryKeys[index];
                                      final category = categoryProvider.mapCategoryIdCategory[categoryId];
                                      final accounts = groupedAccounts[categoryId] ?? [];

                                      return CardItem<AccountDriftModelData>(
                                        items: accounts,
                                        title: category?.categoryName ?? "",
                                        totalItems: categoryProvider.mapCategoryIdTotalAccount[categoryId] ?? 0,
                                        showSeeMore: homeProvider.canExpandCategory(categoryId),
                                        onSeeMoreItems: () {
                                          homeProvider.loadMoreAccountsForCategory(categoryId);
                                        },
                                        itemBuilder: (account, itemIndex) {
                                          return MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              curve: Curves.easeInOut,
                                              child: Selector<DesktopHomeProvider, AccountDriftModelData?>(
                                                selector: (context, provider) => provider.selectedAccount,
                                                builder: (context, selectedAccount, child) {
                                                  return AccountItemWidget(
                                                    accountModel: account,
                                                    isSelected: selectedAccount?.id == account.id,
                                                    isLastItem: itemIndex == accounts.length - 1,
                                                    onLongPress: () {},
                                                    onCallBackPop: () {},
                                                    onTapSubButton: () {
                                                      bottomSheetOptionAccountItem(viewModel: homeProvider, accountModel: account);
                                                    },
                                                    onSelect: () {
                                                      homeProvider.handleSelectAccount(account);
                                                    },
                                                    onTap: () {
                                                      // Chọn tài khoản để hiển thị chi tiết
                                                      context.read<DesktopHomeProvider>().selectAccount(account);
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Chi tiết tài khoản
                  Expanded(
                    flex: 3,
                    child: Consumer<DesktopHomeProvider>(
                      builder: (context, desktopProvider, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                                child: child,
                              ),
                            );
                          },
                          child:
                              !desktopProvider.hasSelectedAccount
                                  ? Container(
                                    key: const ValueKey('empty'),
                                    color: Theme.of(context).colorScheme.surface,
                                    child: Center(
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 500),
                                        opacity: 1.0,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.account_circle_outlined, size: 64, color: Colors.grey[400]),
                                            const SizedBox(height: 16),
                                            Text("Select an account to view details.", style: CustomTextStyle.regular(fontSize: 16, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(key: ValueKey('account_${desktopProvider.selectedAccount!.id}'), child: _buildAccountDetails(context, desktopProvider.selectedAccount!)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Phần danh mục ở dưới
            Padding(padding: EdgeInsets.only(top: 16, bottom: 24.h), child: _buildCategoryDetail(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context, AccountDriftModelData account) {
    final accountDetailsProvider = context.watch<DetailsAccountProvider>();

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nội dung chi tiết
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 400),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(offset: Offset(0, 20 * (1 - value)), child: Opacity(opacity: value, child: _buildAccountIcon(context, account)));
                      },
                    ),
                    SizedBox(height: 16),
                    if (accountDetailsProvider.totpDriftModelData != null)
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(offset: Offset(0, 20 * (1 - value)), child: Opacity(opacity: value, child: _buildTOTPWidget(accountDetailsProvider.totpDriftModelData!)));
                        },
                      ),
                    SizedBox(height: 16),
                    if ((accountDetailsProvider.accountDriftModelData?.username != null && accountDetailsProvider.accountDriftModelData!.username!.isNotEmpty) ||
                        (accountDetailsProvider.accountDriftModelData?.password != null && accountDetailsProvider.accountDriftModelData!.password!.isNotEmpty))
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(offset: Offset(0, 20 * (1 - value)), child: Opacity(opacity: value, child: _buildBaseInfo(context, account)));
                        },
                      ),
                    SizedBox(height: 16),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 700),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(offset: Offset(0, 20 * (1 - value)), child: Opacity(opacity: value, child: _buildCategory(context, accountDetailsProvider.categoryDriftModelData!)));
                      },
                    ),
                    SizedBox(height: 16),
                    if (account.notes != null && account.notes!.isNotEmpty)
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(offset: Offset(0, 20 * (1 - value)), child: Opacity(opacity: value, child: _buildNoteWidget(context, account)));
                        },
                      ),
                    SizedBox(height: 16),
                    if (accountDetailsProvider.accountCustomFieldDriftModelData?.isNotEmpty ?? false)
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 900),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(opacity: value, child: _buildCustomFieldsWidget(accountDetailsProvider.accountCustomFieldDriftModelData!)),
                          );
                        },
                      ),
                    if (accountDetailsProvider.passwordHistoryDriftModelData?.isNotEmpty ?? false)
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(opacity: value, child: _buildPasswordHistoryWidget(accountDetailsProvider.passwordHistoryDriftModelData!, accountDetailsProvider.accountDriftModelData!)),
                          );
                        },
                      ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1100),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(offset: Offset(0, 20 * (1 - value)), child: Opacity(opacity: value, child: _buildUpdatedAtWidget(account)));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountIcon(BuildContext context, AccountDriftModelData account) {
    return Center(
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.5, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
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
              );
            },
          ),
          SizedBox(height: 5.h),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: DecryptText(showLoading: true, style: CustomTextStyle.regular(fontWeight: FontWeight.bold, fontSize: 20.sp), value: account.title, decryptTextType: DecryptTextType.info),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBaseInfo(BuildContext context, AccountDriftModelData account) {
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
              if (account.username != null && account.username!.isNotEmpty)
                ItemCopyValue(title: context.trDetails(DetailsAccountText.username), value: account.username!, isLastItem: account.password?.isEmpty ?? true),
              if (account.password != null && account.password!.isNotEmpty)
                Padding(padding: EdgeInsets.symmetric(vertical: 5.h), child: Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest)),
              if (account.password != null && account.password!.isNotEmpty)
                ItemCopyValue(title: context.trDetails(DetailsAccountText.password), value: account.password!, isLastItem: true, isPrivateValue: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(BuildContext context, CategoryDriftModelData category) {
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
              Text(category.categoryName, style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteWidget(BuildContext context, AccountDriftModelData account) {
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

  Widget _buildCustomFieldsWidget(List<AccountCustomFieldDriftModelData> customFields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(context.trDetails(DetailsAccountText.customFields), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        CardCustomWidget(
          child: Column(
            children: [
              ...customFields.map(
                (element) => Column(
                  children: [
                    ItemCopyValue(title: element.hintText, value: element.value, isPrivateValue: element.typeField.toLowerCase().contains("password"), isLastItem: customFields.last == element),
                    if (customFields.last != element) Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTOTPWidget(TOTPDriftModelData totp) {
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
                  final decryptPassword = await DataSecureService.decryptTOTPKey(totp.secretKey);
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
                        future: DataSecureService.decryptTOTPKey(totp.secretKey),
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

  Widget _buildUpdatedAtWidget(AccountDriftModelData account) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "${context.trDetails(DetailsAccountText.updatedAt)}: ", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          TextSpan(text: formatDateTime(account.updatedAt), style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildPasswordHistoryWidget(List<PasswordHistoryDriftModelData> passwordHistories, AccountDriftModelData account) {
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
                  TextSpan(text: "${passwordHistories.length}", style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
            RequestPro(
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  bottomSheetPasswordHistory(context: context, account: account, passwordHistories: passwordHistories);
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

  Future<void> bottomSheetPasswordHistory({required BuildContext context, required AccountDriftModelData account, required List<PasswordHistoryDriftModelData> passwordHistories}) async {
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
                    itemCount: passwordHistories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final passwordHistory = passwordHistories[index];
                      return ListTile(
                        title: DecryptText(decryptTextType: DecryptTextType.password, style: Theme.of(context).textTheme.bodyLarge!, value: passwordHistory.password),
                        subtitle: Text(formatDateTime(passwordHistory.createdAt), style: Theme.of(context).textTheme.bodyMedium),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () async {
                            final decryptPassword = await DataSecureService.decryptPassword(passwordHistory.password);
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

  Widget _buildNavItem({required IconData icon, required VoidCallback? onTap}) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(100), child: Padding(padding: const EdgeInsets.all(24), child: Icon(icon, size: 24.sp)));
  }

  Widget _buildCategoryDetail(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          SizedBox(
            height: 40.h,
            child: Row(
              children: [
                SizedBox(width: 10),
                IconButton(
                  style: ButtonStyle(minimumSize: WidgetStateProperty.all(Size(40.h, 40.h))),
                  onPressed: () {
                    showCreateCategoryBottomSheet(context);
                  },
                  icon: Center(child: Icon(Icons.add, size: 20.sp)),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    height: 35.h,
                    child: Consumer2<CategoryProvider, HomeProvider>(
                      builder: (context, categoryProvider, accountProvider, child) {
                        final categories = categoryProvider.categories;
                        return ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(width: 10.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          padding: EdgeInsets.only(right: 16),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = category.id == accountProvider.selectedCategoryId;

                            return Material(
                              child: Ink(
                                decoration: BoxDecoration(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.withAlpha(50), borderRadius: BorderRadius.circular(25)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () {
                                    accountProvider.selectCategory(category.id, context: context);
                                  },
                                  child: AnimatedSize(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.w),
                                          child: Center(
                                            child: Text(category.categoryName, style: CustomTextStyle.regular(fontSize: 14.sp, color: isSelected ? Theme.of(context).colorScheme.onPrimary : null)),
                                          ),
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            right: 0,
                                            child: Padding(padding: EdgeInsets.all(8.h).copyWith(right: 20), child: Icon(Icons.close, size: 18.sp, color: Theme.of(context).colorScheme.onPrimary)),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyData() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.appLocale.homeLocale.getText(HomeLocale.click), style: CustomTextStyle.regular(fontSize: 16.sp)),
              const SizedBox(width: 5),
              CircleAvatar(child: Icon(Icons.add, size: 21.sp)),
              const SizedBox(width: 5),
              Text(context.appLocale.homeLocale.getText(HomeLocale.toAddAccount), style: CustomTextStyle.regular(fontSize: 16.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> bottomSheetOptionAccountItem({required HomeProvider viewModel, required AccountDriftModelData accountModel}) async {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10))),

                Selector<HomeProvider, bool>(
                  selector: (context, viewModel) => viewModel.accountSelected.contains(accountModel),
                  builder: (context, isSelected, child) {
                    return ListTile(
                      leading: isSelected ? Icon(Icons.cancel_outlined, size: 24.sp) : Icon(Icons.check_circle_outline_rounded, size: 24.sp),
                      title: Text(isSelected ? context.trHome(HomeLocale.unSelectAccount) : context.trHome(HomeLocale.selectAccount), style: titleHomeOptiomItemStyle),
                      onTap: () {
                        viewModel.handleSelectAccount(accountModel);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.info, size: 24.sp),
                  title: Text(context.trHome(HomeLocale.accountDetails), style: titleHomeOptiomItemStyle),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<DesktopHomeProvider>().selectAccount(accountModel);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit, size: 24.sp),
                  title: Text(context.trHome(HomeLocale.updateAccount), style: titleHomeOptiomItemStyle),
                  onTap: () async {
                    Navigator.pop(context);
                    await showModalSideSheet(
                      context: context,
                      ignoreAppBar: true,
                      barrierDismissible: true,
                      withCloseControll: false,
                      body: CreateAccountScreen(isUpdate: true, accountId: accountModel.id),
                    );
                    if (!mounted) return;
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (!mounted) return;
                      DriffDbManager.instance.accountAdapter.getById(accountModel.id).then((value) {
                        if (value != null && mounted) {
                          context.read<DesktopHomeProvider>().selectAccount(value);
                        }
                      });
                    });
                  },
                ),
                if (accountModel.username != null && accountModel.username != "")
                  ListTile(
                    leading: Icon(Icons.account_circle_rounded, size: 24.sp),
                    title: Text(context.trHome(HomeLocale.copyUsername), style: titleHomeOptiomItemStyle),
                    onTap: () async {
                      Navigator.pop(context);
                      clipboardCustom(context: context, text: accountModel.username ?? "");
                    },
                  ),
                if (accountModel.password != null && accountModel.password != "")
                  ListTile(
                    leading: Icon(Icons.password, size: 24.sp),
                    title: Text(context.trHome(HomeLocale.copyPassword), style: titleHomeOptiomItemStyle),
                    onTap: () async {
                      Navigator.pop(context);
                      String password = await DataSecureService.decryptPassword(accountModel.password ?? "");
                      if (!context.mounted) return;
                      clipboardCustom(context: context, text: password);
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red, size: 24.sp),
                  title: Text(context.trHome(HomeLocale.deleteAccount), style: CustomTextStyle.regular(color: Colors.red, fontSize: 16.sp)),
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
                          await context.read<AccountProvider>().deleteAccount(accountModel);
                          if (!context.mounted) return;
                          context.read<CategoryProvider>().refresh();
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
  }
}

// Placeholder components for the screens
