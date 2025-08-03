import 'dart:math';

import 'package:cybersafe_pro/widgets/encrypt_animation/marquee_text_animation.dart';
import 'package:cybersafe_pro/widgets/encrypt_animation/particles_painter.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

class EncryptAnimation extends StatefulWidget {
  final String plainText;
  final String? encryptedText;
  final TextStyle? textStyle;
  final Duration duration;
  final VoidCallback? onCompleted;
  final bool autoPlay;
  final bool loop;
  final String? prefix;

  const EncryptAnimation({
    super.key,
    required this.plainText,
    this.encryptedText,
    this.textStyle,
    this.duration = const Duration(milliseconds: 1500),
    this.onCompleted,
    this.autoPlay = true,
    this.loop = false,
    this.prefix = '',
  });

  @override
  State<EncryptAnimation> createState() => _EncryptAnimationState();
}

class _EncryptAnimationState extends State<EncryptAnimation> with TickerProviderStateMixin {
  late String _encryptedText;
  final Random _random = Random();
  late AnimationController _particleController;

  // Các ký tự dùng cho mã hóa
  static const String _encryptChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?/~`';

  @override
  void initState() {
    super.initState();
    _encryptedText = widget.encryptedText ?? _generateRandomEncryptedText(widget.plainText.length);

    // Khởi tạo controller cho hiệu ứng hạt
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // 1 giây cho mỗi chu kỳ
    );

    // Lặp lại liên tục để cập nhật hiệu ứng hạt
    _particleController.repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  String _generateRandomEncryptedText(int length) {
    return List.generate(
      length,
      (_) => _encryptChars[_random.nextInt(_encryptChars.length)],
    ).join();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Sử dụng MarqueeTextAnimation cho hiệu ứng chạy văn bản
              Row(
                key: const ValueKey('encrypt_animation_row'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MarqueeTextAnimation(
                      key: const ValueKey('encrypted_marquee'),
                      text: widget.plainText,
                      textStyle: CustomTextStyle.regular(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      velocity: 60.0,
                      blankSpace: 0,
                      gradient: true,
                      gradientColors: [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.lightBlueAccent,
                        Colors.lightBlueAccent.withValues(alpha: 0.7),
                        Colors.lightBlueAccent.withValues(alpha: 0.3),
                        Colors.lightBlueAccent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: MarqueeTextAnimation(
                      key: const ValueKey('plaintext_marquee'),
                      text: _encryptedText,
                      textStyle: CustomTextStyle.regular(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      velocity: 60.0,
                      gradient: true,
                      blankSpace: 10,
                      gradientColors: [
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.5),
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ],
              ),
              // Hiệu ứng ánh sáng ở giữa
              Center(
                child: Container(
                  width: 60,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.8,
                      colors: [Colors.lightBlueAccent.withValues(alpha: 0.3), Colors.transparent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlueAccent.withValues(alpha: 0.2),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),

              // Đường ánh sáng chính giữa
              Center(
                child: Container(
                  width: 2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.lightBlueAccent.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlueAccent.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Hiệu ứng hạt sáng với AnimatedBuilder để cập nhật liên tục
              Center(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 40,
                      height: 40,
                      child: CustomPaint(
                        painter: ParticlesPainter(
                          particleCount: 10,
                          color: Colors.lightBlueAccent.withValues(alpha: 0.6),
                          repaint: _particleController,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
