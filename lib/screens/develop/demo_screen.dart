import 'package:cybersafe_pro/screens/develop/test_text_note.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestTextNote()));
                },
                child: Text("TextNote"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
