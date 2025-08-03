import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/general.dart';
import 'package:cybersafe_pro/main.dart';
import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(context.trAbout(GeneralText.aboutAppTitle)),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildLogo(Theme.of(context)),
                const SizedBox(height: 24),
                Text(
                  AppConfig.isProApp ? "CyberSafe PRO" : "CyberSafe",
                  style: CustomTextStyle.regular(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  "v${packageInfo.version} (${packageInfo.buildNumber})",
                  style: CustomTextStyle.regular(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                _buildFeatureCard(
                  context,
                  icon: Icons.security,
                  title: context.trAbout(GeneralText.securityOfflineTitle),
                  description: context.trAbout(GeneralText.securityOfflineDesc),
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.folder,
                  title: context.trAbout(GeneralText.categoryOrganizeTitle),
                  description: context.trAbout(GeneralText.categoryOrganizeDesc),
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.backup,
                  title: context.trAbout(GeneralText.backupRestoreTitle),
                  description: context.trAbout(GeneralText.backupRestoreDesc),
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.privacy_tip,
                  title: context.trAbout(GeneralText.privacyMaxTitle),
                  description: context.trAbout(GeneralText.privacyMaxDesc),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: CustomTextStyle.regular(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogo(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: theme.colorScheme.shadow, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset('assets/images/app_logo.png', width: 100.h, height: 100.h),
      ),
    );
  }
}
