import 'dart:io';

import 'configs.dart';

String proPackageId = 'com.duc_app_lab_ind.cyber_safe';
String litePackageId = 'com.duc_app_lab_ind.cybersafe_lmt';

Future<void> changeAppInfo(String appVersion) async {
  File file = File('android/local.properties');
  String content = await file.readAsString();
  String appId = proPackageId;
  if (appVersion == 'lite') {
    appId = litePackageId;
  }
  String newContent = content.replaceAll('flutter.applicationId=.{0,}', 'flutter.applicationId=$appId');
  await file.writeAsString(newContent);
  logSuccess('Updated android/local.properties with new app id: $appId');
}
