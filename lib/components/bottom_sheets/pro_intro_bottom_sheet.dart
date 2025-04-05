import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/general.dart';
import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';

Future<void> showProIntroBottomSheet(BuildContext context) {
  return showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) => const ProIntroBottomSheet());
}

class ProIntroBottomSheet extends StatelessWidget {
  const ProIntroBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thanh kéo
            Container(width: 40, height: 5, margin: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(10))),

            // Logo + Medal
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    // // Medal icon trên cùng
                    // Image.asset(
                    //   'assets/images/medal_icon.png',
                    //   width: 100,
                    //   height: 100,
                    // ),

                    // Logo giữa
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(color: const Color(0xFF2963DD), borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset('assets/images/pro_app_logo.png', width: 80, height: 80),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Tiêu đề
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("CyberSafe", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: context.darkMode ? Colors.white : Colors.black)),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                    gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.6), Theme.of(context).colorScheme.primary]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("PRO", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Mô tả
            Text(context.trAbout(GeneralText.proIntroTitle), textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),

            const SizedBox(height: 24),

            // Danh sách tính năng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  _buildFeatureItem(context, Icons.key, context.trAbout(GeneralText.twoFactorAuthDesc)),
                  _buildFeatureItem(context, Icons.copy_rounded, context.trAbout(GeneralText.statisticsDuplicatePasswordDesc)),
                  _buildFeatureItem(context, Icons.image, context.trAbout(GeneralText.customIconDesc)),
                  _buildFeatureItem(context, Icons.palette, context.trAbout(GeneralText.customThemeColorDesc)),
                  _buildFeatureItem(context, Icons.history, context.trAbout(GeneralText.passwordHistoryDetailDesc)),
                  // _buildFeatureItem(context, Icons.diamond, context.trAbout(GeneralText.proIntroTitle)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Nút nâng cấp
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButtonWidget(
                margin: const EdgeInsets.all(0),
                onPressed: () {
                  openUrl(AppConfig.proPlayStoreUrl, context: context);
                },
                text: context.trAbout(GeneralText.updateNowText),
              ),
            ),

            const SizedBox(height: 16),

            // Nút đóng
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.trAbout(GeneralText.notNowText), style: TextStyle(fontSize: 14.sp)),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16.sp))),
        ],
      ),
    );
  }
}
