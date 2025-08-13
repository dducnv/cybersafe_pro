import 'package:cybersafe_pro/components/bottom_sheets/search_bottom_sheet.dart';
import 'package:cybersafe_pro/components/bottom_sheets/select_category_bottom_sheets.dart';
import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/providers/desktop_home_provider.dart';
import 'package:cybersafe_pro/providers/home_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/screens/create_account/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/settings/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/modal_side_sheet/modal_side_sheet.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesktopAppbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<DesktopAppbar> createState() => _DesktopAppbarState();

  @override
  final Size preferredSize;
  const DesktopAppbar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _DesktopAppbarState extends State<DesktopAppbar> {
  @override
  Widget build(BuildContext context) {
    return Selector<HomeProvider, List<AccountDriftModelData>>(
      selector: (context, provider) => provider.accountSelected,
      builder: (context, accountSelected, child) {
        bool isHasAccountSelected = accountSelected.isNotEmpty;
        return AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor:
              isHasAccountSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder:
                (child, animation) => FadeTransition(opacity: animation, child: child),
            child:
                isHasAccountSelected
                    ? Row(
                      key: const ValueKey('selected'),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
                          onPressed: () {
                            context.read<HomeProvider>().handleClearAccountsSelected();
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showSelectCategoryBottomSheet(
                                  context,
                                  onSelected: (CategoryDriftModelData category) {
                                    final homeProvider = context.read<HomeProvider>();
                                    context.read<AccountProvider>().handleChangeCategory(
                                      accountSelected: homeProvider.accountSelected,
                                      category: category,
                                    );
                                  },
                                  isFromChangeCategory: true,
                                );
                              },
                              icon: Icon(Icons.drive_file_move, color: Colors.white, size: 24.sp),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                showAppCustomDialog(
                                  context,
                                  AppCustomDialog(
                                    title: "",
                                    message: context.trSafe(HomeLocale.deleteAllAccount),
                                    confirmText: context.trSafe(HomeLocale.delete),
                                    cancelText: context.trSafe(HomeLocale.cancel),
                                    confirmButtonColor: Colors.red,
                                    cancelButtonColor: Theme.of(context).colorScheme.primary,
                                    isCountDownTimer: true,
                                    onConfirm: () async {
                                      Navigator.pop(context);
                                      final homeProvider = context.read<HomeProvider>();
                                      await context
                                          .read<AccountProvider>()
                                          .handleDeleteAllSelectedAccounts(
                                            accountSelected: homeProvider.accountSelected,
                                          );
                                      if (context.mounted) {
                                        context
                                            .read<DesktopHomeProvider>()
                                            .handleClearAccountsSelected();
                                        context.read<HomeProvider>().refreshData();
                                      }
                                    },
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.delete_rounded, color: Colors.redAccent, size: 24.sp),
                                  const SizedBox(width: 5),
                                  Text(
                                    accountSelected.length.toString(),
                                    style: CustomTextStyle.regular(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : Row(
                      key: const ValueKey('unselected'),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonWidget(
                          borderRaidus: 100,
                          margin: EdgeInsets.all(0),
                          width: 50,
                          height: 50,
                          onPressed: () {
                            showModalSideSheet(
                              context: context,
                              ignoreAppBar: true,
                              barrierDismissible: true,
                              withCloseControll: false,
                              body: CreateAccountMobileLayout(),
                            );
                          },
                          text: "",
                          child: Icon(Icons.add, color: Colors.white, size: 22),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: CustomTextField(
                            borderRadius: BorderRadius.circular(100),
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.search,
                            hintText: "Search",
                            textAlign: TextAlign.center,
                            onTap: () {
                              showSearchBottomSheet(
                                context,
                                onTapAccount: (account) {
                                  context.read<DesktopHomeProvider>().selectAccount(account);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            readOnly: true,
                          ),
                        ),
                        CustomButtonWidget(
                          backgroundColor: context.darkMode ? Colors.grey[800] : Colors.grey[200],
                          borderRaidus: 100,
                          margin: EdgeInsets.all(0),
                          width: 50,
                          height: 50,
                          onPressed: () {
                            showModalSideSheet(
                              context: context,
                              ignoreAppBar: true,
                              barrierDismissible: true,
                              withCloseControll: false,
                              body: SettingMobileLayout(),
                            );
                          },
                          text: "",
                          child: Icon(
                            Icons.settings,
                            size: 22,
                            color: context.darkMode ? Colors.white : Colors.grey[700],
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
