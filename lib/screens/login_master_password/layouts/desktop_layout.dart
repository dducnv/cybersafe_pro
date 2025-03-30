import 'dart:io';

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

class DesktopLayout extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginSuccess;

  const DesktopLayout({super.key, this.showBiometric = true, this.isFromBackup = false, this.callBackLoginSuccess});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  void initState() {
    super.initState();
    context.read<LocalAuthProvider>().init(widget.showBiometric && !widget.isFromBackup);
  }

  Widget _buildPinCodeFields() {
    final localAuthProvider = Provider.of<LocalAuthProvider>(context, listen: false);
    return AppPinCodeFields(
      autoFocus: localAuthProvider.focusNode.hasFocus,
      key: localAuthProvider.appPinCodeKey,
      formKey: localAuthProvider.formKey,
      textEditingController: localAuthProvider.textEditingController!,
      focusNode: localAuthProvider.focusNode,
      onSubmitted: (value) async {
        await handleLogin();
      },
      onEnter: () async {
        await handleLogin();
      },
      validator: (value) {
        if (value!.length < 6) {
          return "Please enter a valid master password";
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
      body: Consumer<LocalAuthProvider>(
        builder: (context, provider, child) {
          // Buộc kiểm tra lại trạng thái khóa mỗi khi build
          final isCurrentlyLocked = provider.isLocked;
          
          return Row(
            children: [
              // Panel bên trái - Vùng thương hiệu
              Expanded(
                flex: 4,
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo ứng dụng
                      Icon(
                        Icons.shield,
                        size: 120.sp,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "CYBER SAFE PRO",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Bảo vệ mật khẩu và dữ liệu quan trọng của bạn",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Panel bên phải - Đăng nhập
              Expanded(
                flex: 5,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Nhập mật khẩu chính để truy cập tài khoản của bạn",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 50),
                              
                              // Hiển thị thông báo khi tài khoản bị khóa
                              if (isCurrentlyLocked)
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.lock_clock,
                                        size: 50.sp,
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        "Tài khoản đã bị khóa do nhập sai mật khẩu nhiều lần",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        "Vui lòng thử lại sau ${provider.formattedRemainingTime}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Thời gian chờ sẽ tăng sau mỗi lần đăng nhập không thành công",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontStyle: FontStyle.italic,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      // Timer để cập nhật đếm ngược
                                      _buildCountdownTimer(provider),
                                    ],
                                  ),
                                ),
                                
                              // Hiện PinCodeFields chỉ khi không bị khóa
                              if (!isCurrentlyLocked) 
                                _buildPinCodeFields(),
                              
                              const SizedBox(height: 40),
                              
                              // Nút đăng nhập
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: isCurrentlyLocked ? null : () async {
                                      await handleLogin();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 3,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Đăng nhập",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Icon(Icons.login, size: 20.sp),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 20),
                                  
                                  // Sinh trắc học
                                  if (widget.showBiometric && LocalAuthConfig.instance.isAvailableBiometrics && LocalAuthConfig.instance.isOpenUseBiometric)
                                    OutlinedButton(
                                      onPressed: () {
                                        context.read<LocalAuthProvider>().onBiometric();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Sinh trắc học",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Platform.isIOS
                                            ? SvgPicture.asset(
                                                'assets/icons/face_id.svg',
                                                width: 20.sp,
                                                height: 20.sp,
                                                color: Theme.of(context).colorScheme.primary,
                                              )
                                            : Icon(
                                                Icons.fingerprint,
                                                size: 20.sp,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> handleLogin() async {
    if (widget.isFromBackup) {
      if (widget.callBackLoginSuccess != null && context.read<LocalAuthProvider>().textEditingController != null) {
        widget.callBackLoginSuccess!(
          isLoginSuccess: true, 
          pin: context.read<LocalAuthProvider>().textEditingController!.text, 
          appPinCodeKey: context.read<LocalAuthProvider>().appPinCodeKey
        );
      }
      return;
    }

    bool isLoginSuccess = await context.read<LocalAuthProvider>().handleLogin();

    // Kiểm tra mounted trước khi sử dụng context
    if (isLoginSuccess && mounted) {
      if (widget.callBackLoginSuccess != null && context.read<LocalAuthProvider>().textEditingController != null) {
        widget.callBackLoginSuccess!(
          isLoginSuccess: true, 
          pin: context.read<LocalAuthProvider>().textEditingController!.text, 
          appPinCodeKey: context.read<LocalAuthProvider>().appPinCodeKey
        );
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
    // Xây dựng StatefulBuilder để cập nhật mỗi giây
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
          margin: const EdgeInsets.only(top: 25),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            provider.formattedRemainingTime,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        );
      },
    );
  }
}