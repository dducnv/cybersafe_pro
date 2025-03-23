import 'package:logger/logger.dart';

void customLogger({required String msg, TypeLogger typeLogger = TypeLogger.info}) {
  var logger = Logger();
  switch (typeLogger) {
    case TypeLogger.info:
      logger.i(msg);
      break;
    case TypeLogger.error:
      logger.e(msg);
      break;
    case TypeLogger.warning:
      logger.w(msg);
      break;
    case TypeLogger.debug:
      logger.d(msg);
      break;
    case TypeLogger.trace:
      logger.t("Trace log");
      break;
  }
}

enum TypeLogger { info, error, warning, debug, trace }
