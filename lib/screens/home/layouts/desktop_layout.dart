import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/details_account_text.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/providers/desktop_home_provider.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/category_manager/category_manager_screen.dart';
import 'package:cybersafe_pro/screens/category_manager/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/create_account/create_account_screen.dart';
import 'package:cybersafe_pro/screens/create_account/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/details_account/details_account_screen.dart';
import 'package:cybersafe_pro/screens/home/components/desktop_appbar.dart';
import 'package:cybersafe_pro/screens/otp/otp_list_screen.dart';
import 'package:cybersafe_pro/screens/password_generator/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/password_generator/password_generate_screen.dart';
import 'package:cybersafe_pro/screens/settings/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/settings/setting_screen.dart';
import 'package:cybersafe_pro/screens/statistic/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/statistic/statistic_screen.dart';
import 'package:cybersafe_pro/screens/otp/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeDesktopLayout extends StatefulWidget {
  const HomeDesktopLayout({super.key});

  @override
  State<HomeDesktopLayout> createState() => _HomeDesktopLayoutState();
}

class _HomeDesktopLayoutState extends State<HomeDesktopLayout> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollController _scrollController = ScrollController();
  final decryptService = EncryptAppDataService.instance;

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
        padding: const EdgeInsets.only(top:16),
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
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () {
                                return Future.wait([context.read<CategoryProvider>().refresh(), context.read<AccountProvider>().refreshAccounts(resetExpansion: true)]);
                              },
                              child: Consumer<AccountProvider>(
                                builder: (context, accountProvider, child) {
                                  final groupedAccounts = accountProvider.groupedAccounts;
        
                                  if (groupedAccounts.isEmpty) {
                                    return _buildEmptyData();
                                  }
        
                                  return ListView.builder(
                                    controller: _scrollController,
                                    itemCount: groupedAccounts.length,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final categoryKeys = groupedAccounts.keys.toList();
                                      final categoryId = categoryKeys[index];
                                      final category = context.read<CategoryProvider>().categories[categoryId];
                                      final accounts = groupedAccounts[categoryId] ?? [];
        
                                      return CardItem<AccountOjbModel>(
                                        items: accounts,
                                        title: category?.categoryName ?? "",
                                        totalItems: accountProvider.getTotalAccountsInCategory(categoryId),
                                        showSeeMore: accountProvider.canExpandCategory(categoryId),
                                        onSeeMoreItems: () {
                                          accountProvider.loadMoreAccountsForCategory(categoryId);
                                        },
                                        itemBuilder: (account, itemIndex) {
                                          return AccountItemWidget(
                                            accountModel: account,
                                            isLastItem: itemIndex == accounts.length - 1,
                                            onLongPress: () {},
                                            onCallBackPop: () {},
                                            onTapSubButton: () {
                                              bottomSheetOptionAccountItem(context: context, viewModel: accountProvider, accountModel: account);
                                            },
                                            onSelect: () {
                                              context.read<AccountProvider>().handleSelectOrRemoveAccount(account);
                                            },
                                            onTap: () {
                                              // Chọn tài khoản để hiển thị chi tiết
                                              context.read<DesktopHomeProvider>().selectAccount(account);
                                            },
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
                        if (!desktopProvider.hasSelectedAccount) {
                          return Container(
                            color: Theme.of(context).colorScheme.surface,
                            child: Center(child: Text("Chọn một tài khoản để xem chi tiết", style: TextStyle(fontSize: 16, color: Colors.grey))),
                          );
                        }
                        final account = desktopProvider.selectedAccount!;
                        return _buildAccountDetails(context, account);
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

  Widget _buildAccountDetails(BuildContext context, AccountOjbModel account) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nội dung chi tiết
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAccountIcon(context, account),
                  SizedBox(height: 16),
                  if (account.totp.target != null) _buildTOTPWidget(account),
                  SizedBox(height: 16),
                  _buildBaseInfo(context, account),
                  SizedBox(height: 16),
                  _buildCategory(context, account),
                  SizedBox(height: 16),
                  if (account.notes != null && account.notes!.isNotEmpty) _buildNoteWidget(context, account),
                  SizedBox(height: 16),
                  if (account.customFields.isNotEmpty) _buildCustomFieldsWidget(account),
                  if (account.passwordHistories.isNotEmpty) _buildPasswordHistoryWidget(account),
                  _buildUpdatedAtWidget(account),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountIcon(BuildContext context, AccountOjbModel account) {
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
                isDecrypted: false,
                textStyle: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          DecryptText(showLoading: true, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp), value: account.title, decryptTextType: DecryptTextType.info),
        ],
      ),
    );
  }

  Widget _buildBaseInfo(BuildContext context, AccountOjbModel account) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(context.trDetails(DetailsAccountText.baseInfo), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        SizedBox(height: 5.h),
        CardCustomWidget(
          child: Column(
            children: [
              if (account.email != null && account.email!.isNotEmpty)
                ItemCopyValue(title: context.trDetails(DetailsAccountText.username), value: account.email!, isLastItem: account.password?.isEmpty ?? true),
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

  Widget _buildCategory(BuildContext context, AccountOjbModel account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(context.trDetails(DetailsAccountText.category), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        CardCustomWidget(
          child: Row(
            children: [
              Icon(Icons.folder, color: Theme.of(context).colorScheme.primary, size: 24.sp),
              const SizedBox(width: 10),
              Text(account.category.target?.categoryName ?? "", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteWidget(BuildContext context, AccountOjbModel account) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(context.trDetails(DetailsAccountText.note), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]))],
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future: decryptService.decryptInfo(account.notes ?? ""),
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
                    textStyle: TextStyle(),
                    maxLines: null,
                    isObscure: false,
                    controller: TextEditingController(text: snapshot.data),
                  );
                }
                return SizedBox.shrink();
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
        Text(context.trDetails(DetailsAccountText.customFields), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
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
        Text(context.trDetails(DetailsAccountText.otpCode), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
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
          TextSpan(text: "${context.trDetails(DetailsAccountText.updatedAt)}: ", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          TextSpan(text: account.updatedAtFormat, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey[600])),
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
                  TextSpan(text: "${context.trDetails(DetailsAccountText.passwordHistoryTitle)}: ", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                  TextSpan(text: "${account.passwordHistories.length}", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
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
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
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
                      Text(context.trDetails(DetailsAccountText.passwordHistoryTitle), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
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
                    child: Consumer2<CategoryProvider, AccountProvider>(
                      builder: (context, categoryProvider, accountProvider, child) {
                        final categories = categoryProvider.categoryList;
                        return ScrollablePositionedList.separated(
                          separatorBuilder: (context, index) => SizedBox(width: 10.w),
                          scrollDirection: Axis.horizontal,
                          itemScrollController: itemScrollController,
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
                                          child: Center(child: Text(category.categoryName, style: TextStyle(fontSize: 14.sp, color: isSelected ? Theme.of(context).colorScheme.onPrimary : null))),
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
              Text(context.appLocale.homeLocale.getText(HomeLocale.click), style: TextStyle(fontSize: 16.sp)),
              const SizedBox(width: 5),
              CircleAvatar(child: Icon(Icons.add, size: 21.sp)),
              const SizedBox(width: 5),
              Text(context.appLocale.homeLocale.getText(HomeLocale.toAddAccount), style: TextStyle(fontSize: 16.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> bottomSheetOptionAccountItem({required BuildContext context, required AccountProvider viewModel, required AccountOjbModel accountModel}) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10))),

                Selector<AccountProvider, bool>(
                  selector: (context, viewModel) => viewModel.accountSelected.contains(accountModel),
                  builder: (context, isSelected, child) {
                    return ListTile(
                      leading: isSelected ? Icon(Icons.cancel_outlined, size: 24.sp) : Icon(Icons.check_circle_outline_rounded, size: 24.sp),
                      title: Text(isSelected ? context.trHome(HomeLocale.unSelectAccount) : context.trHome(HomeLocale.selectAccount), style: titleHomeOptiomItemStyle),
                      onTap: () {
                        viewModel.handleSelectOrRemoveAccount(accountModel);
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
                    AppRoutes.navigateTo(context, AppRoutes.detailsAccount, arguments: {"accountId": accountModel.id});
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit, size: 24.sp),
                  title: Text(context.trHome(HomeLocale.updateAccount), style: titleHomeOptiomItemStyle),
                  onTap: () async {
                    AppRoutes.navigateTo(context, AppRoutes.updateAccount, arguments: {"accountId": accountModel.id});
                  },
                ),
                if (accountModel.email != null && accountModel.email != "")
                  ListTile(
                    leading: Icon(Icons.account_circle_rounded, size: 24.sp),
                    title: Text(context.trHome(HomeLocale.copyUsername), style: titleHomeOptiomItemStyle),
                    onTap: () async {
                      Navigator.pop(context);
                      clipboardCustom(context: context, text: accountModel.email ?? "");
                    },
                  ),
                if (accountModel.password != null && accountModel.password != "")
                  ListTile(
                    leading: Icon(Icons.password, size: 24.sp),
                    title: Text(context.trHome(HomeLocale.copyPassword), style: titleHomeOptiomItemStyle),
                    onTap: () async {
                      Navigator.pop(context);
                      String password = await EncryptAppDataService.instance.decryptPassword(accountModel.password ?? "");
                      if (!context.mounted) return;
                      clipboardCustom(context: context, text: password);
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red, size: 24.sp),
                  title: Text(context.trHome(HomeLocale.deleteAccount), style: TextStyle(color: Colors.red, fontSize: 16.sp)),
                  onTap: () {
                    Navigator.pop(context);
                    showAppCustomDialog(
                      context,
                      AppCustomDialog(
                        title: context.trSafe(DetailsAccountText.deleteAccount),
                        message: context.trSafe(DetailsAccountText.deleteAccountQuestion),
                        confirmText: context.trSafe(DetailsAccountText.deleteAccount),
                        cancelText: context.trSafe(DetailsAccountText.cancel),
                        isCountDownTimer: true,
                        onConfirm: () {
                          context.read<CategoryProvider>().refresh();
                          context.read<AccountProvider>().deleteAccount(accountModel);
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
  }
}

// Placeholder components for the screens
