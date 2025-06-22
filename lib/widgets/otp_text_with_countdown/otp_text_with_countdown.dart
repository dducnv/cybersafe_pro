import 'package:cybersafe_pro/resources/app_config.dart';
import 'package:cybersafe_pro/services/otp.dart';
import 'package:cybersafe_pro/utils/refetch_totp.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/utils/app_error.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';
import 'package:cybersafe_pro/widgets/circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class OtpTextWithCountdown extends StatefulWidget {
  final String keySecret;
  final double? height;
  final double? width;
  final int? duration;
  final int? initialDuration;
  final TextStyle? otpTextStyle;
  final TextStyle? countDownTextStyle;
  final bool isSubTimeCountDown;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  OtpTextWithCountdown({
    super.key,
    required String keySecret,
    this.otpTextStyle,
    this.countDownTextStyle,
    this.height,
    this.width,
    this.duration,
    this.initialDuration,
    this.isSubTimeCountDown = false,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  }) : keySecret = _validateAndFormatKey(keySecret);

  static String _validateAndFormatKey(String key) {
    if (key.isEmpty) {
      throwAppError(ErrorText.emptySecretKey);
    }
    if (!OTP.isKeyValid(key)) {
      throwAppError(ErrorText.invalidSecretKey);
    }
    return key.toUpperCase();
  }

  @override
  OtpTextWithCountdownState createState() => OtpTextWithCountdownState();
}

class OtpTextWithCountdownState extends State<OtpTextWithCountdown> {
  String totp = "";
  late RefetchTotp refetchTotp;
  late int nowValueCountDown;
  final CountDownController countDownController = CountDownController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _initializeCountDown();
    totp = generateTOTPCode(keySecret: widget.keySecret);

    refetchTotp = RefetchTotp(
      refetchTotp: () {
        totp = generateTOTPCode(keySecret: widget.keySecret);
        setState(() {});
      },
    );

    _subscription = refetchTotp.elapsedStream.listen((event) {
      // Có thể xử lý event nếu cần
    });
  }

  void _initializeCountDown() {
    final nowSeconds = DateTime.now().second;
    nowValueCountDown = nowSeconds < 30 ? nowSeconds : nowSeconds - 30;
  }

  void resetCountDown() {
    _initializeCountDown();
    countDownController.restart(duration: widget.duration ?? 30);
    setState(() {});
  }

  @override
  void dispose() {
    _subscription?.cancel();
    refetchTotp.dispose();
    super.dispose();
  }

  Widget _buildCountDownTimer() {
    return CircularCountDownTimer(
      width: widget.width ?? 20.h,
      height: widget.height ?? 20.h,
      duration: widget.duration ?? 30,
      initialDuration: widget.initialDuration ?? nowValueCountDown,
      fillColor: Theme.of(context).colorScheme.primary,
      ringColor: Colors.grey[300]!,
      backgroundColor: Colors.grey[300],
      controller: countDownController,
      strokeWidth: 5,
      textStyle: widget.countDownTextStyle ?? const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500),
      autoStart: true,
      isReverse: true,
      strokeCap: StrokeCap.round,
      isTimerTextShown: true,
      onComplete: resetCountDown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        if (!widget.isSubTimeCountDown) _buildCountDownTimer(),
        if (!widget.isSubTimeCountDown) const SizedBox(width: 10),
        Text(totp, style: widget.otpTextStyle ?? TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary)),
        if (widget.isSubTimeCountDown) _buildCountDownTimer(),
      ],
    );
  }
}
