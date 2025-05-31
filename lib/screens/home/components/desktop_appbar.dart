import 'package:cybersafe_pro/components/bottom_sheets/search_bottom_sheet.dart';
import 'package:cybersafe_pro/providers/desktop_home_provider.dart';
import 'package:cybersafe_pro/screens/create_account/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/screens/settings/layouts/mobile_layout.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/modal_side_sheet/modal_side_sheet.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
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
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButtonWidget(
            borderRaidus: 100,
            margin: EdgeInsets.all(0),
            width: 50,
            height: 50,
            onPressed: () {
              showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: CreateAccountMobileLayout());
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
                showSearchBottomSheet(context,
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
            backgroundColor: Colors.grey[300],
            borderRaidus: 100,
            margin: EdgeInsets.all(0),
            width: 50,
            height: 50,
            onPressed: () {
              showModalSideSheet(context: context, ignoreAppBar: true, barrierDismissible: true, withCloseControll: false, body: SettingMobileLayout());
            },
            text: "",
            child: Icon(Icons.settings, size: 22),
          ),
        ],
      ),
    );
  }
}
