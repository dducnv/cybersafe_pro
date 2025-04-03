import 'dart:io';
import 'dart:async';

import 'package:cybersafe_pro/components/dialog/confirm_exit_dialog.dart';
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

class MobileLayout extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final bool isFromRestore;
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginSuccess;

  const MobileLayout({
    super.key, 
    this.showBiometric = true, 
    this.isFromBackup = false, 
    this.isFromRestore = false, 
    this.callBackLoginSuccess
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  StreamSubscription? _lockStatusSubscription;
  LocalAuthProvider? _authProvider;
  final TextEditingController _pinCodeController = TextEditingController();
  final FocusNode _pinCodeFocusNode = FocusNode();
  final GlobalKey<AppPinCodeFieldsState> _pinCodeKey = GlobalKey<AppPinCodeFieldsState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setupLockStatusCheck();
    _authProvider = context.read<LocalAuthProvider>();
    _authProvider?.textEditingController = _pinCodeController;
    _authProvider?.focusNode = _pinCodeFocusNode;
    _authProvider?.appPinCodeKey = _pinCodeKey;
    _authProvider?.formKey = _formKey;
  }

  void _setupLockStatusCheck() {
    _lockStatusSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (count) => count,
    ).listen((_) {
      if (mounted) {
        _authProvider?.updateLockStatus();
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: widget.isFromBackup ? AppBar(
          elevation: 0, 
          backgroundColor: Theme.of(context).colorScheme.surface, 
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final result = await showConfirmExitDialog(context);
              if (result == true && mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ) : null,
        body: Consumer<LocalAuthProvider>(
          builder: (context, provider, child) {
            final isCurrentlyLocked = provider.isLocked;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.isFromBackup ? context.trLogin(LoginText.enterAnyPin) : context.trLogin(LoginText.enterPin),
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (widget.isFromBackup)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
                        child: Text(context.trLogin(LoginText.backupNote), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                      ),
                    if (widget.isFromRestore)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
                        child: Text(context.trLogin(LoginText.restoreNote), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                      ),
                    if (isCurrentlyLocked)
                      _buildLockedStatus(provider),

                    if (!isCurrentlyLocked)
                      _buildPinCodeFields(provider),

                    if (!isCurrentlyLocked)
                      if (widget.showBiometric && LocalAuthConfig.instance.isAvailableBiometrics && LocalAuthConfig.instance.isOpenUseBiometric) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                _authProvider?.onBiometric();
                              },
                              icon:
                                  Platform.isIOS ? SvgPicture.asset('assets/icons/face_id.svg', width: 20.w, height: 20.h, color: Theme.of(context).colorScheme.primary) : const Icon(Icons.fingerprint),
                            ),
                          ],
                        ),
                      ] else ...[
                        SizedBox(height: 20),
                      ],

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
                ),
              ),
            );
          },
        ),
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
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          Text(
            context.trLogin(LoginText.pleaseTryAgainLater)
              .replaceAll("{0}", provider.formattedRemainingTime),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
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
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(
        provider.formattedRemainingTime,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Theme.of(context).colorScheme.error
        ),
      ),
    );
  }

  Widget _buildPinCodeFields(LocalAuthProvider provider) {
    if (!mounted) return const SizedBox.shrink();
    
    return AppPinCodeFields(
      autoFocus: provider.focusNode.hasFocus,
      key: provider.appPinCodeKey,
      formKey: provider.formKey,
      textEditingController: provider.textEditingController,
      focusNode: provider.focusNode,
      onSubmitted: (value) async {
        if (!mounted) return;
        await handleLogin();
      },
      onEnter: () async {
        if (!mounted) return;
        await handleLogin();
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

  Future<void> handleLogin() async {
    if (!mounted) return;

    if (widget.isFromBackup || widget.isFromRestore) {
      if (widget.callBackLoginSuccess != null) {
        widget.callBackLoginSuccess!(
          isLoginSuccess: true,
          pin: _authProvider?.textEditingController.text ?? '',
          appPinCodeKey: _authProvider?.appPinCodeKey
        );
      }
      return;
    }

    bool isLoginSuccess = await _authProvider?.handleLogin() ?? false;

    if (isLoginSuccess && mounted) {
      if (widget.callBackLoginSuccess != null) {
        widget.callBackLoginSuccess!(
          isLoginSuccess: true,
          pin: _authProvider?.textEditingController.text ?? '',
          appPinCodeKey: _authProvider?.appPinCodeKey
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
      }
    }
  }
}
