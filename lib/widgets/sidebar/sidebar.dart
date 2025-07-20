import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/sidebar_text.dart';
import 'package:cybersafe_pro/main.dart';
import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/developer/developer_screen.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary), //BoxDecoration
          child: Column(
            children: [
              Image.asset('assets/images/app_icon_trans.png', width: 100.w, height: 100.h),
              Text("CyberSafe", style: CustomTextStyle.regular(color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold)),
            ],
          ), //UserAccountDrawerHeader
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.category, size: 24),
          title: Text(context.trSidebar(SidebarText.categoryManager), style: drawerTitleStyle),
          onTap: () {
            AppRoutes.pop(context);
            AppRoutes.navigateTo(context, AppRoutes.categoryManager);
          },
        ),
        ListTile(
          leading: Icon(Icons.star, size: 24),
          title: Text(context.trSidebar(SidebarText.rateApp), style: drawerTitleStyle),
          onTap: () async {
            Navigator.of(context).pop();
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            } else {
              inAppReview.openStoreListing();
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.contact_mail_rounded, size: 24),
          title: Text(context.trSidebar(SidebarText.contact), style: drawerTitleStyle),
          onTap: () {
            AppConfig.showDialogRedirectLink(context, url: AppConfig.contactUrl());
          },
        ),
        ListTile(
          leading: Icon(Icons.support_agent_rounded, size: 24),
          title: Text(context.trSidebar(SidebarText.support), style: drawerTitleStyle),
          onTap: () {
            openUrl("mailto:contact.ducnv@gmail.com?subject=[CyberSafe] Support", context: context);
          },
        ),
        ListTile(
          leading: Icon(Icons.mail_rounded, size: 24),
          title: Text(context.trSidebar(SidebarText.featureRequest), style: drawerTitleStyle),
          onTap: () {
            openUrl("mailto:contact.ducnv@gmail.com?subject=[CyberSafe] Feature Request", context: context);
          },
        ),

        //contact
        ListTile(
          leading: Icon(Icons.translate_rounded, size: 24),
          title: Text(context.trSidebar(SidebarText.requestLanguage), style: drawerTitleStyle),
          onTap: () {
            openUrl("mailto:contact.ducnv@gmail.com?subject=[CyberSafe] Request Language", context: context);
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip, size: 24),
          title: Text(context.trSidebar(SidebarText.privacyPolicy), style: drawerTitleStyle),
          onTap: () {
            AppConfig.showDialogRedirectLink(context, url: AppConfig.privacyPolicyUrl(context.localeRead.languageCode));
          },
        ),
        ListTile(
          leading: Icon(Icons.article, size: 24),
          title: Text(context.trSidebar(SidebarText.termsOfService), style: drawerTitleStyle),
          onTap: () {
            AppConfig.showDialogRedirectLink(context, url: AppConfig.termsOfServiceUrl(context.localeRead.languageCode));
          },
        ),
        ListTile(
          leading: Icon(Icons.info_rounded, size: 24),
          title: Text(context.trSidebar(SidebarText.about), style: drawerTitleStyle),
          onTap: () {
            AppRoutes.navigateTo(context, AppRoutes.aboutApp);
          },
        ),
        if(kDebugMode)
        ListTile(
          leading: Icon(Icons.developer_board_rounded, size: 24),
          title: Text("Developer", style: drawerTitleStyle),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DeveloperScreen()));
          },
        ),
      ],
    );
  }
}
