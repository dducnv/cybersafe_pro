import 'package:cybersafe_pro/widgets/encrypt_animation/marquee_text_animation.dart';
import 'package:flutter/material.dart';

class MarqueeExample extends StatefulWidget {
  const MarqueeExample({super.key});

  @override
  State<MarqueeExample> createState() => _MarqueeExampleState();
}

class _MarqueeExampleState extends State<MarqueeExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Marquee Text Animation'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiệu ứng marquee đơn giản với ListView
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blueGrey.shade800,
              child: const MarqueeTextAnimation(
                text: 'Đây là một đoạn văn bản dài sẽ chạy từ phải sang trái như hiệu ứng marquee',
                fontSize: 18,
                velocity: 50.0,
              ),
            ),

            const SizedBox(height: 40),

            // Hiệu ứng marquee với gradient
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blueGrey.shade800,
              child: const MarqueeTextAnimation(
                text: 'Văn bản này có hiệu ứng gradient làm mờ dần ở hai bên',
                fontSize: 18,
                velocity: 40.0,
                gradient: true,
              ),
            ),

            const SizedBox(height: 40),

            // Hiệu ứng marquee với gradient tùy chỉnh
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blueGrey.shade800,
              child: MarqueeTextAnimation(
                text: 'Văn bản này có màu gradient tùy chỉnh từ xanh sang đỏ',
                fontSize: 18,
                velocity: 30.0,
                gradient: true,
                gradientColors: [
                  Colors.blue,
                  Colors.blue,
                  Colors.blue,
                  Colors.purple,
                  Colors.red,
                  Colors.red.withOpacity(0.5),
                  Colors.red.withOpacity(0.0),
                ],
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 40),

            // Hiệu ứng không loop
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blueGrey.shade800,
              child: const MarqueeTextAnimation(
                text: 'Văn bản này chỉ chạy một lần và dừng lại khi đến cuối',
                fontSize: 18,
                velocity: 60.0,
                loop: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
