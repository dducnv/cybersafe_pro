import 'dart:io';

import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/components/bottom_sheets/search_bottom_sheet.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/details_account_text.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/account_list_tile_widgets.dart';
import 'package:cybersafe_pro/widgets/card_item.dart';
import 'package:cybersafe_pro/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../components/home_app_bar.dart';

class HomeMobileLayout extends StatefulWidget {
  const HomeMobileLayout({super.key});

  @override
  State<HomeMobileLayout> createState() => _HomeMobileLayoutState();
}

class _HomeMobileLayoutState extends State<HomeMobileLayout> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTopNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Thêm listener để theo dõi vị trí cuộn
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _showScrollToTopNotifier.dispose();
    super.dispose();
  }

  // Hàm theo dõi vị trí cuộn để hiển thị/ẩn nút đẩy lên đầu trang
  void _scrollListener() {
    // Hiển thị nút khi cuộn xuống quá 300 pixel
    if (_scrollController.offset >= 300 && !_showScrollToTopNotifier.value) {
      _showScrollToTopNotifier.value = true;
    } else if (_scrollController.offset < 300 && _showScrollToTopNotifier.value) {
      _showScrollToTopNotifier.value = false;
    }
  }

  // Hàm cuộn lên đầu trang
  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: HomeAppBarCustom(scaffoldKey: _scaffoldKey),
      drawer: Drawer(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))), child: Sidebar()),
      floatingActionButton: SizedBox(
        width: 61.h,
        height: 61.h,
        child: FittedBox(
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              await AppRoutes.navigateTo(context, AppRoutes.createAccount);
            },
            child: Icon(Icons.add, size: 18),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60.h,
        padding: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.surface,
        notchMargin: 8,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 16),
            // Nút Home
            Expanded(
              child: _buildNavItem(
                icon: Icons.key_rounded,
                onTap: () {
                  AppRoutes.navigateTo(context, AppRoutes.otpList);
                },
              ),
            ),
            // Nút Danh mục
            Expanded(
              child: _buildNavItem(
                icon: Icons.password_rounded,
                onTap: () {
                  AppRoutes.navigateTo(context, AppRoutes.passwordGenerator);
                },
              ),
            ),
            // Khoảng trống cho FAB
            const SizedBox(width: 80),
            // Nút Tìm kiếm
            Expanded(
              child: _buildNavItem(
                icon: Icons.search_outlined,
                onTap: () {
                  showSearchBottomSheet(context);
                },
              ),
            ),
            // Nút cuộn lên đầu trang
            Expanded(
              child: _buildNavItem(
                icon: Icons.bar_chart_rounded,
                onTap: () {
                  AppRoutes.navigateTo(context, AppRoutes.statistic);
                },
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),

      body: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(25),
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
                          controller: _scrollController, // Sử dụng ScrollController
                          itemCount: groupedAccounts.length,
                          shrinkWrap: true,
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
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 16, bottom: 60.h), child: _buildCategory()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory() {
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
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.w).copyWith(right: isSelected ? 0 : 20.w),
                                          child: Center(child: Text(category.categoryName, style: TextStyle(fontSize: 14.sp, color: isSelected ? Theme.of(context).colorScheme.onPrimary : null))),
                                        ),
                                        if (isSelected) Padding(padding: EdgeInsets.all(8.h), child: Icon(Icons.close, size: 18.sp, color: Theme.of(context).colorScheme.onPrimary)),
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

  // Helper method để tạo các mục trong thanh điều hướng
  Widget _buildNavItem({required IconData icon, required VoidCallback? onTap}) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Icon(icon, size: 24.sp)));
  }
}
