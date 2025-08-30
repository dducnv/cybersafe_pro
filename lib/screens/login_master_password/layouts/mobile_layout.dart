import 'dart:async';
import 'dart:io';

import 'package:cybersafe_pro/components/dialog/confirm_exit_dialog.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/login_text.dart';
import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/local_auth_service.dart';
import 'package:cybersafe_pro/utils/device_type.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/utils/toast_noti.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:cybersafe_pro/widgets/button/custom_button_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application_controller.dart';

class MobileLayout extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final bool isFromRestore;
  final bool isFromDeleteData;
  final String? title;
  final SecureApplicationController? secureApplicationController;
  final Function({
    bool? isLoginSuccess,
    String? pin,
    GlobalKey<AppPinCodeFieldsState>? appPinCodeKey,
  })?
  callBackLoginCallback;

  const MobileLayout({
    super.key,
    this.title,
    this.showBiometric = true,
    this.isFromBackup = false,
    this.isFromRestore = false,
    this.isFromDeleteData = false,
    this.callBackLoginCallback,
    this.secureApplicationController,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  StreamSubscription? _lockStatusSubscription;
  final FocusNode _pinCodeFocusNode = FocusNode();
  final GlobalKey<AppPinCodeFieldsState> _pinCodeKey = GlobalKey<AppPinCodeFieldsState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setupLockStatusCheck();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<LocalAuthProvider>();
        provider.restartLockTimer();
      }
    });
  }

  void _setupLockStatusCheck() {
    _lockStatusSubscription = Stream.periodic(const Duration(seconds: 1), (count) => count).listen((
      _,
    ) {
      if (mounted) {
        final provider = context.read<LocalAuthProvider>();
        provider.updateLockStatus();
      }
    });
  }

  @override
  void dispose() {
    _lockStatusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isFromBackup || widget.isFromRestore || widget.isFromDeleteData
              ? AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surface,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    final result = await showConfirmExitDialog(context);
                    if (result == true && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
              : null,
      body: Consumer<LocalAuthProvider>(
        builder: (context, provider, child) {
          final isCurrentlyLocked = provider.isLocked;
          final isLoading = provider.isLoading;

          return KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                if (!isCurrentlyLocked) {
                  handleLogin(provider);
                }
              }
            },
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title ??
                          (widget.isFromBackup
                              ? context.trLogin(LoginText.enterAnyPin)
                              : context.trLogin(LoginText.enterPin)),
                      style: CustomTextStyle.regular(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (widget.isFromBackup)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
                        child: Text(
                          context.trLogin(LoginText.backupNote),
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.regular(fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                      ),
                    if (widget.isFromRestore)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
                        child: Text(
                          context.trLogin(LoginText.restoreNote),
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.regular(fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                      ),
                    if (isCurrentlyLocked) _buildLockedStatus(provider),

                    if (!isCurrentlyLocked) _buildPinCodeFields(provider),

                    if (!isCurrentlyLocked)
                      if (widget.showBiometric &&
                          LocalAuthConfig.instance.isAvailableBiometrics &&
                          LocalAuthConfig.instance.isOpenUseBiometric) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                provider.onBiometric();
                              },
                              icon:
                                  Platform.isIOS
                                      ? SvgPicture.asset(
                                        'assets/icons/face_id.svg',
                                        width: 20.w,
                                        height: 20.h,
                                        color: Theme.of(context).colorScheme.primary,
                                      )
                                      : const Icon(Icons.fingerprint),
                            ),
                          ],
                        ),
                      ] else ...[
                        SizedBox(height: 20),
                      ],

                    CustomButtonWidget(
                      borderRaidus: 100,
                      width: 75,
                      height: 75,
                      onPressed:
                          (isCurrentlyLocked || isLoading) // ✅ Disable khi loading
                              ? null
                              : () async {
                                await handleLogin(provider);
                              },
                      text: "",
                      child:
                          isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                              : Icon(
                                Icons.arrow_forward,
                                size: 24,
                                color:
                                    (isCurrentlyLocked || isLoading) ? Colors.grey : Colors.white,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLockedStatus(LocalAuthProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10).copyWith(bottom: 24),
      child: Column(
        children: [
          Text(
            context.trLogin(LoginText.loginLockDescription),
            textAlign: TextAlign.center,
            style: CustomTextStyle.regular(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            context
                .trLogin(LoginText.pleaseTryAgainLater)
                .replaceAll("{0}", provider.formattedRemainingTime),
            textAlign: TextAlign.center,
            style: CustomTextStyle.regular(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          _buildCountdownDisplay(provider),
        ],
      ),
    );
  }

  Widget _buildCountdownDisplay(LocalAuthProvider provider) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        provider.formattedRemainingTime,
        style: CustomTextStyle.regular(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  Widget _buildPinCodeFields(LocalAuthProvider provider) {
    if (!mounted) return const SizedBox.shrink();

    return AppPinCodeFields(
      autoFocus: _pinCodeFocusNode.hasFocus,
      key: _pinCodeKey,
      formKey: _formKey,
      autoDismissKeyboard: DeviceInfo.getDeviceType(context) == DeviceType.mobile,
      textEditingController: provider.textEditingController,
      focusNode: provider.focusNode,

      onSubmitted: (value) async {
        if (!mounted) return;
        await handleLogin(provider);
      },
      onEnter: () async {
        if (!mounted) return;
        await handleLogin(provider);
      },
      validator: (value) {
        if (value!.length < 6) {
          return context.trSafe(LoginText.pinCodeRequired);
        }
        return null;
      },
      onCompleted: (value, state) {},
      onChanged: (value) {},
    );
  }

  Future<void> handleLogin(LocalAuthProvider provider) async {
    if (!mounted) return;

    if (widget.secureApplicationController != null) {
      bool isLoginSuccess = await provider.handleLogin();

      if (isLoginSuccess) {
        if (widget.callBackLoginCallback != null) {
          widget.callBackLoginCallback!(
            isLoginSuccess: true,
            pin: provider.textEditingController.text,
            appPinCodeKey: _pinCodeKey,
          );
        }
        SecureApplicationUtil.instance.authSuccess();
      } else {
        SecureApplicationUtil.instance.authFailed();
      }
      return;
    }
    if (widget.isFromBackup || widget.isFromRestore) {
      if (widget.callBackLoginCallback != null) {
        widget.callBackLoginCallback!(
          isLoginSuccess: true,
          pin: provider.textEditingController.text,
          appPinCodeKey: _pinCodeKey,
        );
        SecureApplicationUtil.instance.unpause();
      }
      return;
    }
    bool isLoginSuccess = await provider.handleLogin();

    if (isLoginSuccess && mounted) {
      if (widget.callBackLoginCallback != null) {
        widget.callBackLoginCallback!(
          isLoginSuccess: true,
          pin: provider.textEditingController.text,
          appPinCodeKey: _pinCodeKey,
        );
        return;
      }

      try {
        if (mounted) {
          final appProvider = Provider.of<AppProvider>(context, listen: false);
          appProvider.initializeTimer();
          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
        }
      } catch (e) {
        logError('Error navigating after login: $e');
      } finally {
        SecureApplicationUtil.instance.unpause();
      }
    } else {
      if (!mounted) return;
      showToastError(
        context.trSafe(LoginText.incorrectPin),
        context: context,
        position: StyledToastPosition.top,
      );
    }
  }
}
