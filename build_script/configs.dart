import 'dart:io';

class Config {
  static String get appDataPath {
    var user = Platform.environment['USER'];
    if (user != null && user.isNotEmpty) {
      return "/Users/$user/cybersafe_assets";
    }
    return "${Directory.current.path}/assets";
  }

  static const String rootImagePath = 'assets/images';
}

enum MyPlatform { ios, android }

MyPlatform? getTypeByStr(String text) {
  if (text == 'ios') {
    return MyPlatform.ios;
  }
  if (text == 'android') {
    return MyPlatform.android;
  }
  return null;
}

enum LogType { info, error, success, warning }

void logError(String message) {
  log(message, LogType.error);
}

void logSuccess(String message) {
  log(message, LogType.success);
}

void logWarning(String message) {
  log(message, LogType.warning);
}

void log(String message, [LogType? type]) {
  if (type == LogType.warning) {
    print('\x1B[33m$message\x1B[0m');
    return;
  }
  if (type == LogType.error) {
    print('\x1B[31m$message\x1B[0m');
    return;
  }
  if (type == LogType.success) {
    print('\x1B[32m$message\x1B[0m');
    return;
  }
  print(message);
}

Future<void> updateFile(File file, String data, String position) async {
  await file.writeAsString(data);
  logSuccess("Updated file ${file.path}");
}
