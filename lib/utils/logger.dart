import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

void customLogger({
  required String msg,
  TypeLogger typeLogger = TypeLogger.info,
  String? functionName,
}) {
  if (!kDebugMode) return;
  var logger = Logger();
  switch (typeLogger) {
    case TypeLogger.info:
      logger.i("${functionName ?? ''} - $msg");
      break;
    case TypeLogger.error:
      logger.e("${functionName ?? ''} - $msg");
      break;
    case TypeLogger.warning:
      logger.w("${functionName ?? ''} - $msg");
      break;
    case TypeLogger.debug:
      logger.d("${functionName ?? ''} - $msg");
      break;
    case TypeLogger.trace:
      logger.t("Trace log");
      break;
  }
}

enum TypeLogger { info, error, warning, debug, trace }

logError(String msg, {String? functionName}) {
  if (!kDebugMode) return;
  customLogger(msg: msg, typeLogger: TypeLogger.error, functionName: functionName);
}

logInfo(String msg) {
  if (!kDebugMode) return;
  customLogger(msg: msg, typeLogger: TypeLogger.info);
}

logWarning(String msg) {
  if (!kDebugMode) return;
  customLogger(msg: msg, typeLogger: TypeLogger.warning);
}
