import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotSupportWidget extends StatelessWidget {
  const NotSupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 300.h, child: Lottie.asset('assets/animations/not_support.json')),
            SizedBox(
              width: 300.w,
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Text('This feature is currently not supported on your screen size. We are working to add support in the future.',
                  style: TextStyle(fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
