import 'dart:io';

import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/components/bottom_sheets/search_bottom_sheet.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/account_list_tile_widgets.dart';
import 'package:cybersafe_pro/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../components/home_app_bar.dart';
import '../../../providers/theme_provider.dart';
import '../../settings/components/theme_color_picker.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode; // Cố định chiều cao FAB

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      appBar: HomeAppBarCustom(scaffoldKey: _scaffoldKey),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)), SizedBox(height: 10), Text('CyberSafe Pro', style: TextStyle(color: Colors.white, fontSize: 20))],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    selected: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.password),
                    title: const Text('Passwords'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  // Theme mode toggle
                  ListTile(
                    leading: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  // Theme color section
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Theme Colors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ThemeColorPicker()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65.w,
        height: 65.h,
        child: FittedBox(
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              await AppRoutes.navigateTo(context, AppRoutes.createAccount);
            },
            child: Icon(Icons.add, size: 18.sp),
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
            Expanded(child: _buildNavItem(icon: Icons.key_rounded, onTap: () {
              AppRoutes.navigateTo(context, AppRoutes.otpList);
            })),
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
            Expanded(child: _buildNavItem(icon: Icons.search_outlined, onTap: () {
              showSearchBottomSheet(context);
            })),
            // Nút cuộn lên đầu trang
            Expanded(child: _buildNavItem(icon: Icons.analytics_sharp, onTap: () {})),
            SizedBox(width: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(25),
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.wait([context.read<CategoryProvider>().getCategories(), context.read<AccountProvider>().refreshAccounts(resetExpansion: true)]);
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
                                   AppRoutes.navigateTo(context, AppRoutes.updateAccount, arguments: {"accountId": accounts[itemIndex].id});
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
          Padding(padding: EdgeInsets.only(top: 16, bottom: Platform.isIOS ? 148 : 113), child: _buildCategory()),
        ],
      ),
    );
  }

 Widget _buildCategory() {
    return Column(
      children: [
        SizedBox(
          height: 40.h,
          child: Row(
            children: [
              IconButton(
                style: ButtonStyle(minimumSize: WidgetStateProperty.all(Size(40.w, 40.h))),
                onPressed: () {
                  showCreateCategoryBottomSheet(context);
                },
                icon: Center(child: Icon(Icons.add, size: 20.sp)),
              ),
              Flexible(
                child: SizedBox(
                  height: 35.h,
                  child: Consumer2<CategoryProvider, AccountProvider>(
                    builder: (context, categoryProvider, accountProvider, child) {
                      final categories = categoryProvider.categoryList;
                      return ScrollablePositionedList.separated(
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        itemScrollController: itemScrollController,
                        itemCount: categories.length,
                        padding: EdgeInsets.only(right: 16),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category.id == accountProvider.selectedCategoryId;
                          
                          return Material(
                            child: Ink(
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.withAlpha(50),
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  accountProvider.selectCategory(category.id, context: context);

                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h).copyWith(right: isSelected ? 0 : 20.w),
                                      child: Center(
                                        child: Text(
                                          category.categoryName,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: isSelected 
                                              ? Theme.of(context).colorScheme.onPrimary
                                              : null
                                          )
                                        )
                                      ),
                                    ),
                                    if (isSelected)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.close, size: 18.sp, color: Theme.of(context).colorScheme.onPrimary),
                                      )
                                  ],
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
              Text("Nhấn", style: TextStyle(fontSize: 16.sp)),
              const SizedBox(width: 5),
              CircleAvatar(child: Icon(Icons.add, size: 21.sp)),
              const SizedBox(width: 5),
              Text("để thêm tài khoản", style: TextStyle(fontSize: 16.sp)),
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
