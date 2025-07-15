import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Dialog đang hiển thị hay không
bool _isLoadingDialogShowing = false;

/// Hiển thị dialog loading
Future<void> showLoadingDialog({BuildContext? context, ValueNotifier<double>? loadingProgress}) async {
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
            child:
                loadingProgress != null
                    ? ValueListenableBuilder<double>(
                      valueListenable: loadingProgress,
                      builder: (context, progress, child) {
                        return Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(progress * 100).toStringAsFixed(0)}%',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyle.regular(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: 200,
                                  child: LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(30),
                                    value: progress,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey[300],
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : Lottie.asset("assets/animations/loading.json", fit: BoxFit.contain, width: 350, height: 350, frameRate: const FrameRate(120)),
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
