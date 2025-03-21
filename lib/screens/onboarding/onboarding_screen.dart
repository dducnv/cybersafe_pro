import 'package:cybersafe_pro/constants/secure_storage_key.dart' show SecureStorageKey;
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/setting_item_widget/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

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

  void initialization() async {}

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
        body: Stack(alignment: Alignment.bottomCenter, children: [buildBackground(width), buildContent(theme), buildBottomSection(theme)]),
      ),
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
        children: [buildLogo(theme), const SizedBox(height: 20), buildWelcomeText(theme), const SizedBox(height: 40), buildAnimation()],
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
    return Column(children: [Text('CyberSafe', style: TextStyle(color: theme.colorScheme.primary, fontSize: 25.sp, fontWeight: FontWeight.bold))]);
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
        // bottomSheetChooseLanguage(context, () {});
      },
      child: Row(mainAxisSize: MainAxisSize.min, children: [Text("Vietnamese", style: theme.textTheme.titleSmall), const Icon(Icons.arrow_drop_down_rounded)]),
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
      child: const Icon(Icons.arrow_forward, color: Colors.white),
    );
  }

  Future<void> bottomSheetChooseLanguage(BuildContext context, Function() callBack) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.all(16), child: Text("Chọn ngôn ngữ", style: Theme.of(context).textTheme.titleMedium)),
              // Expanded(
              //   child: ListView.builder(
              //       itemCount: ,
              //       itemBuilder: (context, index) {
              //         return ListTile(
              //           title: Text("Vietnamese"),
              //           selected: context.read<RootPR>().appLanguage ==
              //               AppLangsList().appLangs[index].code,
              //           onTap: () {
              //             context.read<RootPR>().language(
              //                   AppLangsList().appLangs[index].code,
              //                 );

              //             callBack.call();
              //             Navigator.pop(context);
              //           },
              //         );
              //       }),
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<void> privacyBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingItemWidget(icon: Icons.arrow_forward_ios_rounded, titleWidth: 400, title: "Chính sách bảo mật", onTap: () {}),
                const SizedBox(height: 10),
                SettingItemWidget(icon: Icons.arrow_forward_ios_rounded, titleWidth: 400, title: "Điều khoản dịch vụ", onTap: () {}),
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
                                child: Text("Đồng ý với chính sách và điều khoản", maxLines: 2, style: TextStyle(fontSize: 14.sp), overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButtonWidget(
                          isDisabled: !value,
                          kMargin: 0,
                          onPressed: () async {
                            await SecureStorage.instance.save(key: SecureStorageKey.firstOpenApp, value: "false");
                            if (context.mounted) {
                              Navigator.pushNamed(context, AppRoutes.registerMasterPin);
                            }
                          },
                          text: "Tiếp tục",
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
