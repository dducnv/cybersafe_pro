import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/encrypt_animation/encrypt_animation.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

/// Dialog đang hiển thị hay không
bool _isLoadingDialogShowing = false;

/// Hiển thị dialog loading
Future<void> showLoadingDialog({
  BuildContext? context,
  bool animationReverse = true,
  ValueNotifier<double>? loadingProgress,
  ValueNotifier<String>? loadingText,
}) async {
  // Nếu dialog đã hiển thị, không hiển thị lại
  if (_isLoadingDialogShowing) return;

  // Đánh dấu dialog đang hiển thị
  _isLoadingDialogShowing = true;

  try {
    return await showDialog(
      barrierColor: Colors.black.withValues(alpha: 0.7),
      barrierDismissible: false,
      context: context ?? GlobalKeys.appRootNavigatorKey.currentContext!,
      builder: (context) {
        return PopScope(
          // Ngăn không cho back bằng nút back
          canPop: false,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: EncryptAnimation(
                      plainText: 'Abcdefgh',
                      encryptedText: '#\$%^&*()_+=',
                      reverse: animationReverse,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: loadingText ?? ValueNotifier<String>(''),
                    builder: (context, value, child) {
                      if (value.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8),
                        child: Text(
                          value,
                          style: CustomTextStyle.regular(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ],
              ),
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
