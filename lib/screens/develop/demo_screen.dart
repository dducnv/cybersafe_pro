import 'package:cybersafe_pro/routes/app_routes.dart';
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
                  AppRoutes.navigateTo(context, AppRoutes.noteEditor);
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
