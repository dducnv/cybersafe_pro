import 'dart:math';

import 'package:flutter/material.dart';

class ParticlesPainter extends CustomPainter {
  final Color color;
  final int particleCount;
  final Random _random = Random();
  final List<Particle> _particles = [];
  int _animationTick = 0;

  // Thêm biến repaint notifier để cập nhật liên tục
  final Listenable? repaint;

  ParticlesPainter({required this.color, this.particleCount = 15, this.repaint})
    : super(repaint: repaint) {
    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < particleCount; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble() * 40,
          y: _random.nextDouble() * 40,
          size: _random.nextDouble() * 2 + 0.5,
          opacity: _random.nextDouble() * 0.5 + 0.2,
          speedX: (_random.nextDouble() - 0.5) * 0.8,
          speedY: (_random.nextDouble() - 0.5) * 0.8,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Tăng biến đếm animation
    _animationTick++;

    // Cập nhật và vẽ các hạt
    for (final particle in _particles) {
      // Di chuyển hạt với tốc độ khác nhau
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      // Thay đổi độ trong suốt theo thời gian
      particle.opacity = 0.2 + (0.3 * (sin(_animationTick / 20 + particle.x) + 1) / 2);

      // Quay lại nếu ra khỏi vùng
      if (particle.x < 0 || particle.x > size.width) {
        particle.speedX *= -1;
        // Thay đổi tốc độ ngẫu nhiên khi va chạm
        particle.speedX += (_random.nextDouble() - 0.5) * 0.2;
      }
      if (particle.y < 0 || particle.y > size.height) {
        particle.speedY *= -1;
        // Thay đổi tốc độ ngẫu nhiên khi va chạm
        particle.speedY += (_random.nextDouble() - 0.5) * 0.2;
      }

      // Giới hạn tốc độ tối đa
      if (particle.speedX.abs() > 1.5) {
        particle.speedX = particle.speedX.sign * 1.5;
      }
      if (particle.speedY.abs() > 1.5) {
        particle.speedY = particle.speedY.sign * 1.5;
      }

      // Vẽ hạt với hiệu ứng phát sáng
      paint.color = color.withOpacity(particle.opacity);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);

      // Vẽ hiệu ứng phát sáng
      paint.color = color.withOpacity(particle.opacity * 0.3);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size * 1.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    // Luôn vẽ lại để tạo hiệu ứng chuyển động
    return true;
  }
}

class Particle {
  double x;
  double y;
  double size;
  double opacity;
  double speedX;
  double speedY;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speedX,
    required this.speedY,
  });
}
