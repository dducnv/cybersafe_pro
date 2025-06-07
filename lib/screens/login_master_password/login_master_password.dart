import 'package:cybersafe_pro/providers/app_provider.dart';
import 'package:cybersafe_pro/providers/local_auth_provider.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
// import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application_controller.dart';
// import 'package:secure_application/secure_application_controller.dart';
import 'layouts/mobile_layout.dart';

class LoginMasterPassword extends StatefulWidget {
  final bool showBiometric;
  final bool isFromBackup;
  final bool isFromRestore;
  final bool isFromDeleteData;
  final bool fromSecureGate;
  final SecureApplicationController? secureApplicationController;
  final Function({bool? isLoginSuccess, String? pin, GlobalKey<AppPinCodeFieldsState>? appPinCodeKey})? callBackLoginCallback;

  const LoginMasterPassword({
    super.key,
    this.showBiometric = true,
    this.isFromBackup = false,
    this.isFromRestore = false,
    this.isFromDeleteData = false,
    this.fromSecureGate = false,
    this.callBackLoginCallback,
    this.secureApplicationController,
  });

  @override
  State<LoginMasterPassword> createState() => _LoginMasterPasswordState();
}

class _LoginMasterPasswordState extends State<LoginMasterPassword> {
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!widget.fromSecureGate) {
      SecureApplicationUtil.instance.unlock();
    }

    if (!_mounted) return;
    FlutterNativeSplash.remove();
    try {
      // Sử dụng provider có sẵn thay vì tạo mới
      final authProvider = Provider.of<LocalAuthProvider>(context, listen: false);
      // if (SecureApplicationUtil.instance.secureApplicationController != null) SecureApplicationUtil.instance.secureApplicationController?.open();
      await authProvider.init(widget.showBiometric && !widget.isFromBackup && !widget.isFromRestore, () {
        if (widget.secureApplicationController != null) widget.secureApplicationController?.unlock();
        widget.callBackLoginCallback?.call(isLoginSuccess: true);
        SecureApplicationUtil.instance.init();
      }, isNavigateToHome: widget.secureApplicationController == null);
      // Dừng timer
      if (_mounted) {
        context.read<AppProvider>().stopTimer();
      }
    } catch (e) {
      logError('Error initializing login screen: $e');
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      showBiometric: widget.showBiometric,
      isFromBackup: widget.isFromBackup,
      isFromRestore: widget.isFromRestore,
      isFromDeleteData: widget.isFromDeleteData,
      callBackLoginCallback: widget.callBackLoginCallback,
      secureApplicationController: widget.secureApplicationController,
    );
  }
}
