import 'dart:io';

import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/secure/secure_app_manager.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/widgets/app_custom_switch/app_custom_switch.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UseBiometricLogin extends StatefulWidget {
  const UseBiometricLogin({super.key});

  @override
  State<UseBiometricLogin> createState() => _UseBiometricLoginState();
}

class _UseBiometricLoginState extends State<UseBiometricLogin> {
  bool isCanUseBiometric = false;
  bool isOpenUseBiometric = false;

  @override
  void initState() {
    super.initState();
    checkBiometric();
  }

  void changeBiometric(bool value) async {
    bool isAuth = await LocalAuthConfig.instance.authenticate();
    if (isAuth) {
      if (!value) {
        setState(() {
          isOpenUseBiometric = false;
        });
        if (mounted) showLoadingDialog(context: context);
        await SecureAppManager.disableBiometric();
        hideLoadingDialog();
      } else {
        if (mounted) showLoadingDialog(context: context);
        await SecureAppManager.enableBiometric();
        hideLoadingDialog();
        setState(() {
          isOpenUseBiometric = true;
        });
      }
    }

    await LocalAuthConfig.instance.init();
  }

  void checkBiometric() async {
    bool? enableLocalAuth = await SecureStorage.instance.readBool(
      SecureStorageKey.isEnableLocalAuth,
    );

    setState(() {
      isOpenUseBiometric = enableLocalAuth ?? false;
    });
    bool canCheckBiometrics = LocalAuthConfig.instance.isAvailableBiometrics;

    setState(() {
      isCanUseBiometric = canCheckBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isCanUseBiometric
        ? CardCustomWidget(
          padding: const EdgeInsets.all(0),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      context.appLocale.settingsLocale.getText(SettingsLocale.biometric),
                      style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppCustomSwitch(
                        value: isOpenUseBiometric,
                        onChanged: (value) {
                          changeBiometric(value);
                        },
                      ),
                      const SizedBox(width: 5),
                      if (Platform.isIOS)
                        SvgPicture.asset(
                          'assets/icons/face_id.svg',
                          width: 20.w,
                          height: 20.h,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      if (Platform.isAndroid)
                        Icon(
                          Icons.fingerprint_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.sp,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        : const SizedBox.shrink();
  }
}
