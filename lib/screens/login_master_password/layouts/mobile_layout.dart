import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final localAuthProvider = Provider.of<LocalAuthProvider>(context, listen: false);
    print(LocalAuthConfig.instance.isAvailableBiometrics);
    print(LocalAuthConfig.instance.isOpenUseBiometric);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Login with Master Password", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          AppPinCodeFields(
              autoFocus: true,
              key: localAuthProvider.appPinCodeKey,
              formKey: localAuthProvider.formKey,
              focusNode: localAuthProvider.focusNode,
              onSubmitted: (value) {},
              onEnter: () {},
              validator: (value) {
                if (value!.length < 6) {
                  return "Please enter a valid master password";
                }
                return null;
              },
              onCompleted: (value, state) {},
              onChanged: (value) {},
              textEditingController: localAuthProvider.textEditingController,
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Row(
                  //   children: [
                  //     const Text("You forgot your pin? "),
                  //     InkWell(
                  //       borderRadius: BorderRadius.circular(5),
                  //       onTap: () {},
                  //       child: const Padding(
                  //         padding: EdgeInsets.all(3.0),
                  //         child: Text(
                  //           "Reset",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  if (LocalAuthConfig.instance.isAvailableBiometrics && LocalAuthConfig.instance.isOpenUseBiometric)
                    IconButton(
                      onPressed: () {
                        localAuthProvider.onBiometric();
                      },
                      icon: const Icon(Icons.fingerprint),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            CustomButtonWidget(
              borderRaidus: 100,
              width: 75.h,
              height: 75.h,
              onPressed: () async {
                bool isLoginSuccess = await localAuthProvider.handleLogin();
                if (isLoginSuccess && context.mounted) {
                  AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
                }
              },
              text: "",
              child: Icon(Icons.arrow_forward, size: 24.sp, color: Colors.white),
            ),
          ],
      ),
    );
  }
}
