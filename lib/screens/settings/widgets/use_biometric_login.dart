import 'dart:io';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/widgets/app_custom_switch/app_custom_switch.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
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
    print("isAuth: $isAuth");
    if (isAuth) {
      if (!value) {
        setState(() {
          isOpenUseBiometric = false;
        });
        SecureStorage.instance.saveBool(SecureStorageKey.isEnableLocalAuth, false);
      } else {
        await SecureStorage.instance.saveBool(SecureStorageKey.isEnableLocalAuth, true);
        setState(() {
          isOpenUseBiometric = true;
        });
      }
    }

    await LocalAuthConfig.instance.init();
  }

  void checkBiometric() async {
    bool? enableLocalAuth = await SecureStorage.instance.readBool(SecureStorageKey.isEnableLocalAuth);

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
                  Text("Khoá sinh trắc học", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  //switch
                  Row(
                    children: [
                      AppCustomSwitch(
                        value: isOpenUseBiometric,
                        onChanged: (value) {
                          changeBiometric(value);
                        },
                      ),
                      const SizedBox(width: 5),
                      if (Platform.isIOS) SvgPicture.asset('assets/icons/face_id.svg', width: 20.w, height: 20.h, color: Theme.of(context).colorScheme.primary),
                      if (Platform.isAndroid) Icon(Icons.fingerprint_rounded, color: Theme.of(context).colorScheme.primary, size: 24.sp),
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
