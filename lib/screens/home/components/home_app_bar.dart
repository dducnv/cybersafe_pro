import 'package:cybersafe_pro/components/bottom_sheets/select_category_bottom_sheets.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeAppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  final Size preferredSize;

  const HomeAppBarCustom({super.key, this.isDesktop = false, this.scaffoldKey}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeAppBarCustom> createState() => _HomeAppBarCustomState();
}

class _HomeAppBarCustomState extends State<HomeAppBarCustom> {
  @override
  Widget build(BuildContext context) {
    return Selector<AccountProvider, List<AccountOjbModel>>(
      selector: (context, provider) => provider.accountSelected,
      builder: (context, accountSelected, child) {
        bool isHasAccountSelected = accountSelected.isNotEmpty;
        return AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: isHasAccountSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          leading:
              isHasAccountSelected
                  ? IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
                    onPressed: () {
                      context.read<AccountProvider>().handleClearAccountsSelected();
                    },
                  )
                  : widget.scaffoldKey != null
                  ? IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      widget.scaffoldKey?.currentState?.openDrawer();
                    },
                  )
                  : null,
          title: !isHasAccountSelected ? const Text("CyberSafe PRO", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)) : null,
          scrolledUnderElevation: 0,
          actions:
              isHasAccountSelected
                  ? [
                    IconButton(
                      onPressed: () {
                        showSelectCategoryBottomSheet(
                          context,
                          onSelected:(CategoryOjbModel category){
                            context.read<AccountProvider>().handleChangeCategory(category);
                          },
                          isFromChangeCategory: true
                        );
                      },
                      icon: Icon(Icons.drive_file_move, color: Colors.white, size: 24.sp),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Xoá tài khoản đã chọn"),
                              actionsPadding: const EdgeInsets.only(bottom: 2, right: 5),
                              contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Huỷ"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<AccountProvider>().handleDeleteAllAccount();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Xoá tất cả"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete_rounded, color: Colors.redAccent, size: 24.sp),
                          const SizedBox(width: 5),
                          Text(accountSelected.length.toString(), style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ]
                  : [
                    // Theme toggle button
                    // IconButton(
                    //   icon: Icon(
                    //     isDark ? Icons.light_mode : Icons.dark_mode,
                    //     color: Theme.of(context).colorScheme.primary,
                    //   ),
                    //   onPressed: () => themeProvider.toggleTheme(),
                    // ),
                    Visibility(
                      visible: !widget.isDesktop,
                      child: IconButton(
                        icon: const Icon(Icons.settings_rounded, size: 24),
                        onPressed: () {
                          AppRoutes.navigateTo(context, AppRoutes.settings);
                        },
                      ),
                    ),
                  ],
        );
      },
    );
  }
}
