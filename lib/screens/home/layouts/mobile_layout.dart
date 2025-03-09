import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/screens/create_account/create_account_screen.dart';
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

  @override
  void initState() {
    super.initState();
    // Load accounts khi màn hình được khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode; // Cố định chiều cao FAB

    return Scaffold(
      key: _scaffoldKey,
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
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAccountScreen()));
            },
            child: Icon(Icons.add, size: 18.sp),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(25),
                child: RefreshIndicator(
                  onRefresh: () => context.read<AccountProvider>().getAccounts(),
                  child: Selector<AccountProvider, Map<int, List<AccountOjbModel>>>(
                    selector: (_, provider) => provider.groupedAccounts,
                    builder: (context, groupedAccounts, child) {
                      if (groupedAccounts.isEmpty) {
                        return const Center(child: Text('Chưa có tài khoản nào'));
                      }

                      return ListView.builder(
                        itemCount: groupedAccounts.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final category = context.read<CategoryProvider>().categories[groupedAccounts.keys.toList()[index]];
                          final accounts = groupedAccounts[category?.id]??[];
                          return CardItem<AccountOjbModel>(
                            items: accounts,
                            title:category?.categoryName ?? "",
                            itemBuilder: (account, itemIndex) {
                              return AccountItemWidget(
                                accountModel: account,
                                isLastItem: itemIndex == accounts.length - 1,
                                onSelect: () {
                                  // Xử lý khi tap vào account
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
          Padding(padding: EdgeInsets.only(top: 16.h, bottom: 65 + 16 + 40 + 16), child: _buildCategory()),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return SizedBox(
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
              child: Selector<CategoryProvider, List<CategoryOjbModel>>(
                selector: (context, provider) => provider.categoryList,
                builder: (context, value, child) {
                  return ScrollablePositionedList.separated(
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    itemScrollController: itemScrollController,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Material(
                        child: Ink(
                          decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(25)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {},
                            child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h), child: Center(child: Text(value[index].categoryName, style: TextStyle(fontSize: 14.sp)))),
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
    );
  }
}
