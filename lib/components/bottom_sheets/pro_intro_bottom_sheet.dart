import 'package:flutter/material.dart';

Future<void> showProIntroBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => const ProIntroBottomSheet(),
  );
}

class ProIntroBottomSheet extends StatelessWidget {
  const ProIntroBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Pro Intro'),
        ],
      ),
    );
  }
}
