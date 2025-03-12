
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: <SystemUiOverlay>[
          SystemUiOverlay.bottom,
          SystemUiOverlay.top,
        ]);
  }

  void initialization() async {
   
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.secondaryContainer,
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            buildBackground(width),
            buildContent(theme),
            buildBottomSection(theme),
          ],
        ),
      ),
    );
  }

  Positioned buildBackground(double width) {
    return Positioned(
      top: 0,
      left: 0,
      child: SvgPicture.asset(
        'assets/images/onboarding_bg.svg',
        fit: BoxFit.fitWidth,
        width: width,
      ),
    );
  }

  Positioned buildContent(ThemeData theme) {
    return Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildLogo(theme),
          const SizedBox(height: 20),
          buildWelcomeText(theme),
          buildAnimation(),
        ],
      ),
    );
  }

  Widget buildLogo(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          'assets/images/app_logo.png',
          width: 100.h,
          height: 100.h,
        ),
      ),
    );
  }

  Widget buildWelcomeText(ThemeData theme) {
    return Column(
      children: [

        Text(
          'CyberSafe',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildAnimation() {
    return Lottie.asset(
      'assets/animations/onboarding.json',
      width: 250.w,
      height: 250.h,
      fit: BoxFit.contain,
      frameRate: FrameRate.max,
    );
  }

  Positioned buildBottomSection(ThemeData theme) {
    return Positioned(
      bottom: 50,
      left: 16,
      right: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildLanguageSelector(theme),
          const SizedBox(height: 20),
          buildNextButton(context),
        ],
      ),
    );
  }

  Widget buildLanguageSelector(ThemeData theme) {
    return GestureDetector(
          onTap: () {
            // bottomSheetChooseLanguage(context, () {});
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Vietnamese",
                style: theme.textTheme.titleSmall,
              ),
              const Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        );
  }

  Widget buildNextButton(
    BuildContext context,
  ) {
    return CustomButtonWidget(
      borderRaidus: 100,
      width: 75.h,
      height: 75.h,
      onPressed: () {
      },
      text: "",
      child: const Icon(Icons.arrow_forward),
    );
  }
}
