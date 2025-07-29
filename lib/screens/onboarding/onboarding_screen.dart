import 'package:cybersafe_pro/components/bottom_sheets/choose_lang_bottom_sheet.dart';
import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart' show SecureStorageKey;
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/keys/onboarding_text.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/setting_item_widget/setting_item_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final ValueNotifier<bool> isDegreed = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: theme.colorScheme.secondaryContainer,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: theme.colorScheme.secondaryContainer,
        body: Stack(alignment: Alignment.bottomCenter, children: [buildVNFlagMapBg(), buildBackground(width), buildContent(theme), buildBottomSection(theme)]),
      ),
    );
  }

  Positioned buildVNFlagMapBg() {
    return Positioned.fill(
      child: Padding(padding: const EdgeInsets.all(16), child: SvgPicture.asset("assets/images/flag_map.svg", color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2))),
    );
  }

  Positioned buildBackground(double width) {
    return Positioned(top: 0, left: 0, child: SvgPicture.asset('assets/images/onboarding_bg.svg', fit: BoxFit.fitWidth, width: width));
  }

  Positioned buildContent(ThemeData theme) {
    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [buildLogo(theme), const SizedBox(height: 16), buildWelcomeText(theme), const SizedBox(height: 40), buildAnimation()],
      ),
    );
  }

  Widget buildLogo(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(30), child: Image.asset('assets/images/app_logo.png', width: 100.h, height: 100.h)),
    );
  }

  Widget buildWelcomeText(ThemeData theme) {
    return Column(children: [Text('CyberSafe', style: CustomTextStyle.regular(color: theme.colorScheme.primary, fontSize: 25.sp, fontWeight: FontWeight.bold))]);
  }

  Widget buildAnimation() {
    return Lottie.asset('assets/animations/onboarding.json', width: 250.w, height: 250.h, fit: BoxFit.contain, frameRate: FrameRate.max);
  }

  Positioned buildBottomSection(ThemeData theme) {
    return Positioned(
      bottom: 50,
      left: 16,
      right: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [buildLanguageSelector(theme), const SizedBox(height: 20), buildNextButton(context)],
      ),
    );
  }

  Widget buildLanguageSelector(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        showLanguageBottomSheet(context);
      },
      child: Selector<AppLocale, (Locale, String)>(
        selector: (_, provider) => (provider.locale, provider.currentLocaleModel.languageNativeName),
        shouldRebuild: (prev, next) => prev.$1 != next.$1,
        builder: (context, data, child) {
          final (locale, nativeName) = data;
          return Row(mainAxisSize: MainAxisSize.min, children: [Text(nativeName, style: theme.textTheme.titleSmall), const Icon(Icons.arrow_drop_down_rounded)]);
        },
      ),
    );
  }

  Widget buildNextButton(BuildContext context) {
    return CustomButtonWidget(
      borderRaidus: 100,
      width: 75.h,
      height: 75.h,
      onPressed: () {
        privacyBottomSheet(context);
      },
      text: "",
      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
    );
  }

  Future<void> privacyBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingItemWidget(
                    icon: Icons.arrow_forward_ios_rounded,
                    titleWidth: 400,
                    title: context.appLocale.onboardingLocale.getText(OnboardingText.policy),
                    onTap: () {
                      AppConfig.showDialogRedirectLink(context, url: AppConfig.privacyPolicyUrl(context.localeRead.languageCode));
                    },
                  ),
                  const SizedBox(height: 10),
                  SettingItemWidget(
                    icon: Icons.arrow_forward_ios_rounded,
                    titleWidth: 400,
                    title: context.appLocale.onboardingLocale.getText(OnboardingText.terms),
                    onTap: () {
                      AppConfig.showDialogRedirectLink(context, url: AppConfig.termsOfServiceUrl(context.localeRead.languageCode));
                    },
                  ),
                  const SizedBox(height: 5),
                  ValueListenableBuilder(
                    valueListenable: isDegreed,
                    builder: ((context, value, child) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: value,
                                onChanged: (value) {
                                  isDegreed.value = value!;
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    isDegreed.value = !isDegreed.value;
                                  },
                                  child: Text(
                                    context.appLocale.onboardingLocale.getText(OnboardingText.termsAndConditions),
                                    maxLines: 2,
                                    style: CustomTextStyle.regular(fontSize: 14.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomButtonWidget(
                            isDisabled: !value,
                            kMargin: 0,
                            onPressed: () async {
                              showLoadingDialog();
                              await context.read<CategoryProvider>().initDataCategory(context);
                              await SecureStorage.instance.save(key: SecureStorageKey.firstOpenApp, value: "false");
                              if (context.mounted) {
                                Navigator.pushNamed(context, AppRoutes.registerMasterPin);
                              }
                            },
                            text: context.appLocale.onboardingLocale.getText(OnboardingText.continueText),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
