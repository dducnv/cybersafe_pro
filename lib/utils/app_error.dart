import 'package:flutter/material.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';

/// Class AppError để quản lý lỗi trong ứng dụng với hỗ trợ đa ngôn ngữ
class AppError {
  static final AppError _instance = AppError._internal();
  factory AppError() => _instance;
  AppError._internal();

  static final AppError instance = AppError();

  BuildContext? get _context => GlobalKeys.appRootNavigatorKey.currentContext;

  /// Log một lỗi và trả về thông báo lỗi đã được dịch
  String logAndGetMessage(String errorKey, {Object? error, String? functionName}) {
    if (error != null) {
      logError('$errorKey: $error', functionName: functionName);
    } else {
      logError(errorKey, functionName: functionName);
    }
    
    // Cố gắng lấy context và dịch thông báo lỗi
    if (_context != null) {
      return _context!.trSafe(errorKey);
    }
    
    // Fallback trong trường hợp không có context
    return errorKey;
  }

  /// Tạo một Exception với thông báo đa ngôn ngữ
  Exception createException(String errorKey, {Object? error, String? functionName}) {
    return Exception(logAndGetMessage(errorKey, error: error, functionName: functionName));
  }

  /// Hiển thị SnackBar với thông báo lỗi đa ngôn ngữ
  void showErrorSnackBar(BuildContext context, String errorKey, {Duration? duration}) {
    final message = context.trSafe(errorKey);
    logError(message, functionName: "AppError.showErrorSnackBar");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Hiển thị SnackBar thành công với thông báo đa ngôn ngữ
  void showSuccessSnackBar(BuildContext context, String errorKey, {Duration? duration}) {
    final message = context.trSafe(errorKey);
    logInfo(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// Hiển thị SnackBar thông báo với thông báo đa ngôn ngữ
  void showInfoSnackBar(BuildContext context, String errorKey, {Duration? duration}) {
    final message = context.trSafe(errorKey);
    logInfo(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// Kiểm tra điều kiện và ném exception nếu không thoả mãn
  void throwIfNot(bool condition, String errorKey, {Object? error}) {
    if (!condition) {
      throw createException(errorKey, error: error, functionName: "AppError.throwIfNot");
    }
  }

  /// Kiểm tra điều kiện và ném exception nếu thoả mãn
  void throwIf(bool condition, String errorKey, {Object? error}) {
    if (condition) {
      throw createException(errorKey, error: error, functionName: "AppError.throwIf");
    }
  }

  /// Kiểm tra giá trị null và ném exception nếu là null
  void throwIfNull(Object? value, String errorKey, {Object? error}) {
    throwIf(value == null, errorKey, error: error);
  }

  /// Kiểm tra chuỗi trống và ném exception nếu là chuỗi trống
  void throwIfEmpty(String? value, String errorKey, {Object? error}) {
    throwIf(value == null || value.isEmpty, errorKey, error: error);
  }
}

// Một số helper function để sử dụng dễ dàng hơn
void throwAppError(String errorKey, {Object? error, String? functionName}) {
  throw AppError.instance.createException(errorKey, error: error, functionName: functionName);
}

void showErrorSnackBar(BuildContext context, String errorKey, {Duration? duration}) {
  AppError.instance.showErrorSnackBar(context, errorKey, duration: duration);
}

void showSuccessSnackBar(BuildContext context, String errorKey, {Duration? duration}) {
  AppError.instance.showSuccessSnackBar(context, errorKey, duration: duration);
}

void showInfoSnackBar(BuildContext context, String errorKey, {Duration? duration}) {
  AppError.instance.showInfoSnackBar(context, errorKey, duration: duration);
} 