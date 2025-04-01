import 'dart:io';

import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TabletLayout extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginSuccess;

  const TabletLayout({super.key, this.showBiometric = true, this.isFromBackup = false, this.callBackLoginSuccess});

  @override
  State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {

  Widget _buildPinCodeFields() {
    final localAuthProvider = Provider.of<LocalAuthProvider>(context, listen: false);
    return AppPinCodeFields(
      autoFocus: localAuthProvider.focusNode.hasFocus,
      key: localAuthProvider.appPinCodeKey,
      formKey: localAuthProvider.formKey,
      textEditingController: localAuthProvider.textEditingController,
      focusNode: localAuthProvider.focusNode,
      onSubmitted: (value) async {
        await handleLogin();
      },
      onEnter: () async {
        await handleLogin();
      },
      validator: (value) {
        if (value!.length < 6) {
          return context. trSafe(LoginText.pinCodeRequired);
        }
        return null;
      },
      onCompleted: (value, state) {},
      onChanged: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showBiometric ? AppBar(elevation: 0, backgroundColor: Theme.of(context).colorScheme.surface, scrolledUnderElevation: 0) : null,
      body: Consumer<LocalAuthProvider>(
        builder: (context, provider, child) {
          // Buộc kiểm tra lại trạng thái khóa mỗi khi build
          final isCurrentlyLocked = provider.isLocked;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Login with Master Password", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Hiển thị thông báo khi tài khoản bị khóa
              if (isCurrentlyLocked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      Text("Tài khoản đã bị khóa do nhập sai mật khẩu nhiều lần", textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Vui lòng thử lại sau ${provider.formattedRemainingTime}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 5),
                      Text("Thời gian chờ sẽ tăng sau mỗi lần đăng nhập không thành công", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                      // Timer để cập nhật đếm ngược
                      _buildCountdownTimer(provider),
                    ],
                  ),
                ),

              // Hiện PinCodeFields chỉ khi không bị khóa
              if (!isCurrentlyLocked) Container(constraints: BoxConstraints(maxWidth: 500), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30), child: _buildPinCodeFields()),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.showBiometric && LocalAuthConfig.instance.isAvailableBiometrics && LocalAuthConfig.instance.isOpenUseBiometric)
                      IconButton(
                        onPressed: () {
                          context.read<LocalAuthProvider>().onBiometric();
                        },
                        icon: Platform.isIOS ? SvgPicture.asset('assets/icons/face_id.svg', width: 20.w, height: 20.h, color: Theme.of(context).colorScheme.primary) : const Icon(Icons.fingerprint),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomButtonWidget(
                borderRaidus: 100,
                width: 75.h,
                height: 75.h,
                onPressed:
                    isCurrentlyLocked
                        ? null
                        : () async {
                          await handleLogin();
                        },
                text: "",
                child: Icon(Icons.arrow_forward, size: 24.sp, color: isCurrentlyLocked ? Colors.grey : Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> handleLogin() async {
    if (widget.isFromBackup) {
      if (widget.callBackLoginSuccess != null) {
        widget.callBackLoginSuccess!(isLoginSuccess: true, pin: context.read<LocalAuthProvider>().textEditingController.text, appPinCodeKey: context.read<LocalAuthProvider>().appPinCodeKey);
      }
      return;
    }

    bool isLoginSuccess = await context.read<LocalAuthProvider>().handleLogin();

    // Kiểm tra mounted trước khi sử dụng context
    if (isLoginSuccess && mounted) {
      if (widget.callBackLoginSuccess != null) {
        widget.callBackLoginSuccess!(isLoginSuccess: true, pin: context.read<LocalAuthProvider>().textEditingController.text, appPinCodeKey: context.read<LocalAuthProvider>().appPinCodeKey);
        return;
      }

      // Sử dụng try-catch để xử lý ngoại lệ
      try {
        if (mounted) {
          AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
          appProvider.initializeTimer();
          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
        }
      } catch (e) {
        logError('Error navigating after login: $e');
      }
    }
  }

  // Widget hiển thị đếm ngược
  Widget _buildCountdownTimer(LocalAuthProvider provider) {
    // Xây dựng StatefulWidget để cập nhật mỗi giây
    return StatefulBuilder(
      builder: (context, setState) {
        // Chạy timer để cập nhật mỗi giây
        if (provider.isLocked) {
          Future.delayed(const Duration(seconds: 1), () async {
            if (mounted) {
              // Làm mới widget để cập nhật thời gian
              setState(() {});

              // Nếu thời gian đã hết, cập nhật trạng thái
              if (provider.remainingLockTimeSeconds <= 0) {
                // Kiểm tra và cập nhật trạng thái khóa
                await provider.checkAndUpdateLockStatus();

                if (mounted && context.mounted) {
                  // Đảm bảo trạng thái được cập nhật đúng
                  context.read<LocalAuthProvider>().init(widget.showBiometric && !widget.isFromBackup);
                  setState(() {});
                }
              }
            }
          });
        }

        return Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
          child: Text(provider.formattedRemainingTime, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.error)),
        );
      },
    );
  }
}
