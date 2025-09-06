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

  // Constants để dễ bảo trì và tái sử dụng
  static const double _maxWidth = 300.0;
  static const double _spacing = 20.0;
  static const double _buttonSize = 75.0;
  static const double _iconSize = 24.0;
  static const double _smallSpacing = 10.0;
  static const double _horizontalPadding = 30.0;
  static const double _borderRadius = 20.0;
  static const double _countdownMargin = 24.0;
  static const double _countdownPadding = 16.0;
  static const double _countdownFontSize = 18.0;

  @override
  void initState() {
    super.initState();
    _setupLockStatusCheck();
    _initializeProvider();
    _ensureTimerRunning();
  }

  void _ensureTimerRunning() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<LocalAuthProvider>();
        if (provider.isLocked) {
          provider.restartLockTimer();
        }
      }
    });
  }

  void _initializeProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final provider = context.read<LocalAuthProvider>();
        await provider.checkAndUpdateLockStatus();
        if (provider.isLocked) {
          provider.restartLockTimer();
        }
      }
    });
  }

  void _setupLockStatusCheck() {
    _lockStatusSubscription = Stream.periodic(const Duration(seconds: 1), (count) => count).listen((
      _,
    ) {
      if (mounted) {
        final provider = context.read<LocalAuthProvider>();
        // Cập nhật trạng thái lock
        provider.updateLockStatus();

        // Đảm bảo timer luôn chạy khi bị lock
        if (provider.isLocked) {
          provider.restartLockTimer();
        }
      }
    });
  }

  @override
  void dispose() {
    _lockStatusSubscription?.cancel();
    _pinCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<LocalAuthProvider>(
        builder: (context, provider, child) {
          final isCurrentlyLocked = provider.isLocked;
          final isLoading = provider.isLoading;

          // Đảm bảo timer được khởi động lại khi widget rebuild
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && isCurrentlyLocked) {
              // Kiểm tra và khởi động lại timer
              provider.restartLockTimer();
            }
          });

          return KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _handleKeyboardEvent(event, isCurrentlyLocked, provider),
            child: _buildMainContent(provider, isCurrentlyLocked, isLoading),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (!widget.isFromBackup && !widget.isFromRestore && !widget.isFromDeleteData) {
      return null;
    }

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBackPress),
    );
  }

  Future<void> _handleBackPress() async {
    final result = await showConfirmExitDialog(context);
    if (result == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleKeyboardEvent(KeyEvent event, bool isCurrentlyLocked, LocalAuthProvider provider) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        !isCurrentlyLocked) {
      handleLogin(provider);
    }
  }

  Widget _buildMainContent(LocalAuthProvider provider, bool isCurrentlyLocked, bool isLoading) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTitle(),
            const SizedBox(height: _spacing),
            _buildNoteText(),
            if (isCurrentlyLocked) _buildLockedStatus(provider),
            if (!isCurrentlyLocked) _buildPinCodeFields(provider),
            _buildBiometricButton(provider),
            _buildLoginButton(provider, isCurrentlyLocked, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final title = widget.title ?? _getDefaultTitle();
    return Text(
      title,
      style: CustomTextStyle.regular(fontSize: 20.sp, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  String _getDefaultTitle() {
    if (widget.isFromBackup) {
      return context.trLogin(LoginText.enterAnyPin);
    }
    return context.trLogin(LoginText.enterPin);
  }

  Widget _buildNoteText() {
    if (widget.isFromBackup) {
      return _buildNoteContainer(context.trLogin(LoginText.backupNote));
    }
    if (widget.isFromRestore) {
      return _buildNoteContainer(context.trLogin(LoginText.restoreNote));
    }
    return const SizedBox.shrink();
  }

  Widget _buildNoteContainer(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
      ).copyWith(bottom: _smallSpacing),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: CustomTextStyle.regular(fontSize: 14, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildBiometricButton(LocalAuthProvider provider) {
    if (!widget.showBiometric ||
        !LocalAuthConfig.instance.isAvailableBiometrics ||
        !LocalAuthConfig.instance.isOpenUseBiometric) {
      return const SizedBox(height: _spacing);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [IconButton(onPressed: () => provider.onBiometric(), icon: _buildBiometricIcon())],
    );
  }

  Widget _buildBiometricIcon() {
    if (Platform.isIOS) {
      return SvgPicture.asset(
        'assets/icons/face_id.svg',
        width: 20.w,
        height: 20.h,
        color: Theme.of(context).colorScheme.primary,
      );
    }
    return const Icon(Icons.fingerprint);
  }

  Widget _buildLoginButton(LocalAuthProvider provider, bool isCurrentlyLocked, bool isLoading) {
    final isDisabled = isCurrentlyLocked || isLoading;

    return CustomButtonWidget(
      borderRaidus: 100,
      width: _buttonSize,
      height: _buttonSize,
      onPressed: isDisabled ? null : () => handleLogin(provider),
      text: "",
      child: _buildButtonContent(isLoading, isDisabled),
    );
  }

  Widget _buildButtonContent(bool isLoading, bool isDisabled) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Icon(
      Icons.arrow_forward,
      size: _iconSize,
      color: isDisabled ? Colors.grey : Colors.white,
    );
  }

  Widget _buildLockedStatus(LocalAuthProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _smallSpacing,
        vertical: _smallSpacing,
      ).copyWith(bottom: _countdownMargin),
      child: Column(
        children: [
          Text(
            context.trLogin(LoginText.loginLockDescription),
            textAlign: TextAlign.center,
            style: CustomTextStyle.regular(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: _smallSpacing),
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
      margin: const EdgeInsets.only(top: _smallSpacing),
      padding: const EdgeInsets.symmetric(horizontal: _countdownPadding, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Text(
        provider.formattedRemainingTime,
        style: CustomTextStyle.regular(
          fontWeight: FontWeight.bold,
          fontSize: _countdownFontSize,
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
      onSubmitted: (value) => _handlePinSubmission(provider),
      onEnter: () => _handlePinSubmission(provider),
      validator: _validatePinCode,
      onCompleted: (value, state) {},
      onChanged: (value) {},
    );
  }

  Future<void> _handlePinSubmission(LocalAuthProvider provider) async {
    if (!mounted) return;
    await handleLogin(provider);
  }

  String? _validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return context.trSafe(LoginText.pinCodeRequired);
    }
    if (value.length < 6) {
      return context.trSafe(LoginText.pinCodeRequired);
    }
    return null;
  }

  Future<void> handleLogin(LocalAuthProvider provider) async {
    if (!mounted) return;

    if (widget.secureApplicationController != null) {
      await _handleSecureApplicationLogin(provider);
      return;
    }

    if (widget.isFromBackup || widget.isFromRestore) {
      await _handleBackupRestoreLogin(provider);
      return;
    }

    await _handleNormalLogin(provider);
  }

  Future<void> _handleSecureApplicationLogin(LocalAuthProvider provider) async {
    final isLoginSuccess = await provider.handleLogin();

    if (isLoginSuccess) {
      _callLoginCallback(provider);
      provider.textEditingController.clear();
      SecureApplicationUtil.instance.authSuccess();
    } else {
      SecureApplicationUtil.instance.authFailed();
    }
  }

  Future<void> _handleBackupRestoreLogin(LocalAuthProvider provider) async {
    _callLoginCallback(provider);
    provider.textEditingController.clear();
    SecureApplicationUtil.instance.unpause();
  }

  Future<void> _handleNormalLogin(LocalAuthProvider provider) async {
    final isLoginSuccess = await provider.handleLogin();

    if (isLoginSuccess && mounted) {
      _callLoginCallback(provider);
      provider.textEditingController.clear();
      await _navigateToHome();
    } else {
      _showErrorToast();
    }
  }

  void _callLoginCallback(LocalAuthProvider provider) {
    if (widget.callBackLoginCallback != null) {
      widget.callBackLoginCallback!(
        isLoginSuccess: true,
        pin: provider.textEditingController.text,
        appPinCodeKey: _pinCodeKey,
      );
    }
  }

  Future<void> _navigateToHome() async {
    try {
      if (mounted) {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.initializeTimer();
        AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
      }
    } catch (e) {
      logError('Error navigating after login: $e');
      // Fallback navigation nếu có lỗi
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      }
    } finally {
      SecureApplicationUtil.instance.unpause();
    }
  }

  void _showErrorToast() {
    if (!mounted) return;

    showToastError(
      context.trSafe(LoginText.incorrectPin),
      context: context,
      position: StyledToastPosition.top,
    );
  }
}
