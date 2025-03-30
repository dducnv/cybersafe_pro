import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Dialog đang hiển thị hay không
bool _isLoadingDialogShowing = false;

/// Hiển thị dialog loading
Future<void> showLoadingDialog({BuildContext? context}) async {
  // Nếu dialog đã hiển thị, không hiển thị lại
  if (_isLoadingDialogShowing) return;
  
  // Đánh dấu dialog đang hiển thị
  _isLoadingDialogShowing = true;
  
  try {
    return await showDialog(
      barrierDismissible: false,
      context: context ?? GlobalKeys.appRootNavigatorKey.currentContext!,
      builder: (context) {
        return PopScope(
          // Ngăn không cho back bằng nút back
          canPop: false,
          child: Center(
            child: Lottie.asset(
              "assets/animations/loading.json",
              //set color
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    const ['**', '**', '**'],
                    value: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              fit: BoxFit.contain,
              width: 350,
              height: 350,
              frameRate: const FrameRate(120),
            ),
          ),
        );
      },
    );
  } catch (e) {
    logError('Lỗi khi hiển thị loading dialog: $e');
  }
}

/// Ẩn dialog loading
Future<void> hideLoadingDialog() async {
  // Nếu dialog không hiển thị, không cần đóng
  if (!_isLoadingDialogShowing) return;
  
  try {
    // Lấy context từ key
    final context = GlobalKeys.appRootNavigatorKey.currentContext;
    
    // Kiểm tra context và có thể pop được không
    if (context != null && Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  } catch (e) {
    logError('Lỗi khi đóng loading dialog: $e');
  } finally {
    // Luôn đánh dấu dialog đã đóng
    _isLoadingDialogShowing = false;
  }
}
