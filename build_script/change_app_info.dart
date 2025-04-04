import 'dart:io';

import 'configs.dart';

String proPackageId = 'com.duc_app_lab_ind.cyber_safe';
String litePackageId = 'com.duc_app_lab_ind.cybersafe_lmt';

Future<void> changeAppInfo(String appVersion) async {
  File file = File('android/local.properties');
  File fileAppConfig = File('lib/resources/app_config.dart');
  String content = await file.readAsString();
  String contentAppConfig = await fileAppConfig.readAsString();
  String appId = proPackageId;
  bool isPro = true;
  if (appVersion == 'lite') {
    appId = litePackageId;
    isPro = false;
  }

  String newContentAppConfig = contentAppConfig.replaceAll(RegExp("static bool isProApp =.{0,}"), "static bool isProApp = $isPro;");
  await fileAppConfig.writeAsString(newContentAppConfig);
  logSuccess('Updated lib/resources/config/app_config.dart with new app id: $appId');
  String newContent = content.replaceAll(RegExp("flutter.applicationId=.{0,}"), "flutter.applicationId=$appId");
  await file.writeAsString(newContent);
  logSuccess('Updated android/local.properties with new app id: $appId');
}
