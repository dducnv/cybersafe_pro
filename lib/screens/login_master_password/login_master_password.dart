import 'package:cybersafe_pro/migrate_data/migrate_from_old_data.dart';
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
  final Function({
    bool? isLoginSuccess,
    String? pin,
    GlobalKey<AppPinCodeFieldsState>? appPinCodeKey,
  })?
  callBackLoginCallback;

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
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    SecureApplicationUtil.instance.pause();
    FlutterNativeSplash.remove();
    Future.microtask(() async {
      await _handleMigrateData();

      if (!mounted) return;

      try {
        final authProvider = Provider.of<LocalAuthProvider>(context, listen: false);
        await authProvider.init(
          widget.showBiometric && !widget.isFromBackup && !widget.isFromRestore,
          () {},
          isNavigateToHome: widget.secureApplicationController == null,
        );
        if (mounted) {
          context.read<AppProvider>().stopTimer();
        }
      } catch (e) {
        logError('Error initializing login screen: $e');
      }
    });
  }

  Future<void> _handleMigrateData() async {
    await MigrateFromOldData.startMigrate(context);
  }

  @override
  void dispose() {
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
