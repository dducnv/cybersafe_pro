import 'package:cybersafe_pro/widgets/encrypt_animation/encrypt_animation.dart';
import 'package:flutter/material.dart';

class EncryptAnimationExample extends StatelessWidget {
  const EncryptAnimationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiệu ứng mã hóa với dấu phân cách
            const EncryptAnimation(
              plainText: 'Your account',
              encryptedText: '#\$%^&*()_+=',
              textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
