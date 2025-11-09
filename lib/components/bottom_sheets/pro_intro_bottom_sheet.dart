import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/general.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

Future<void> showProIntroBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (context) => const ProIntroBottomSheet(),
  );
}

class ProIntroBottomSheet extends StatelessWidget {
  const ProIntroBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.darkMode;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          left: 12,
          right: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [colorScheme.surfaceContainerHighest, colorScheme.surface]
                : [colorScheme.surface, colorScheme.surfaceContainerHighest],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.12),
                    colorScheme.primary.withValues(alpha: 0.06),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/images/pro_app_logo.png', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'CyberSafe',
                              style: CustomTextStyle.regular(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.8),
                                    colorScheme.primary,
                                  ],
                                ),
                              ),
                              child: Text(
                                'PRO',
                                style: CustomTextStyle.regular(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.trAbout(GeneralText.proIntroTitle),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.regular(
                            fontSize: 14.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Features
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _FeatureRow(
                    icon: Icons.key,
                    text: context.trAbout(GeneralText.twoFactorAuthDesc),
                    color: colorScheme.primary,
                  ),
                  _FeatureRow(
                    icon: Icons.copy_rounded,
                    text: context.trAbout(GeneralText.statisticsDuplicatePasswordDesc),
                    color: Colors.teal,
                  ),
                  _FeatureRow(
                    icon: Icons.image,
                    text: context.trAbout(GeneralText.customIconDesc),
                    color: Colors.deepPurple,
                  ),
                  _FeatureRow(
                    icon: Icons.palette,
                    text: context.trAbout(GeneralText.customThemeColorDesc),
                    color: Colors.orange,
                  ),
                  _FeatureRow(
                    icon: Icons.history,
                    text: context.trAbout(GeneralText.passwordHistoryDetailDesc),
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CustomButtonWidget(
                        margin: const EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          openUrl(AppConfig.proPlayStoreUrl, context: context);
                        },
                        text: context.trSettings(SettingsLocale.installNow),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      context.trAbout(GeneralText.notNowText),
                      style: CustomTextStyle.regular(
                        fontSize: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _FeatureRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.16), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(text, style: CustomTextStyle.regular(fontSize: 15.sp)),
          ),
        ],
      ),
    );
  }
}
