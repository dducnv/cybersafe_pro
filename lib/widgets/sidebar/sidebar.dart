import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/sidebar_text.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
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
              Text(context.trSidebar(SidebarText.appName), style: TextStyle(color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold)),
            ],
          ), //UserAccountDrawerHeader
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.category, size: 24.sp),
          title: Text(context.trSidebar(SidebarText.categoryManager), style: drawerTitleStyle),
          onTap: () {
            AppRoutes.pop(context);
            AppRoutes.navigateTo(context, AppRoutes.categoryManager);
          },
        ),
        ListTile(
          leading: Icon(Icons.info_rounded, size: 24.sp), 
          title: Text(context.trSidebar(SidebarText.about), style: drawerTitleStyle), 
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.question_mark_rounded, size: 24.sp), 
          title: Text(context.trSidebar(SidebarText.faqs), style: drawerTitleStyle), 
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.mail_rounded, size: 24.sp), 
          title: Text(context.trSidebar(SidebarText.featureRequest), style: drawerTitleStyle), 
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip, size: 24.sp), 
          title: Text(context.trSidebar(SidebarText.privacyPolicy), style: drawerTitleStyle), 
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.article, size: 24.sp), 
          title: Text(context.trSidebar(SidebarText.termsOfService), style: drawerTitleStyle), 
          onTap: () {}
        ),
      ],
    );
  }
}
