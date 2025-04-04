import 'dart:developer';
import 'dart:io';

import 'configs.dart';

Future<void> copyResFolderAndroid(String appVersion) async {
  String resFolder = '${Config.appDataPath}/$appVersion/res';
  String toAndroidRes = 'android/app/src/main/res';
  Directory directory = Directory(toAndroidRes);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  //delete all files and folder in the directory
  directory.listSync().forEach((element) {
    if (element is Directory) {
      element.deleteSync(recursive: true);
    } else {
      element.deleteSync();
    }
  });
  //copy all files and folder from resFoder to toAndroidRes
  Directory(resFolder).listSync().forEach((element) {
    if (element is Directory) {
      Directory('$toAndroidRes/${element.path.split('/').last}').createSync();
      Directory(element.path).listSync(recursive: true).forEach((subElement) {
        if (subElement is File) {
          final relativePath = subElement.path.substring(element.path.length);
          File(subElement.path).copySync('$toAndroidRes/${element.path.split('/').last}$relativePath');
        }
      });
    } else {
      File(element.path).copySync('$toAndroidRes/${element.path.split('/').last}');
    }
  });
  logSuccess('Copy res folder to $toAndroidRes');
  //delete all files and folder in the directory
}


//copy Assets.xcassets to ios/Runner/Assets.xcassets
Future<void> copyResFolderIOS(String appVersion) async {
  String resFolder = '${Config.appDataPath}/$appVersion/Assets.xcassets';
  String toIOSRes = 'ios/Runner/Assets.xcassets';
  Directory directory = Directory(toIOSRes);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  //delete all files and folder in the directory
  directory.listSync().forEach((element) {
    if (element is Directory) {
      element.deleteSync(recursive: true);
    } else {
      element.deleteSync();
    }
  });
  //copy all files and folder from resFoder to toAndroidRes
  Directory(resFolder).listSync().forEach((element) {
    if (element is Directory) {
      Directory('$toIOSRes/${element.path.split('/').last}').createSync();
      Directory(element.path).listSync(recursive: true).forEach((subElement) {
        if (subElement is File) {
          final relativePath = subElement.path.substring(element.path.length);
          File(subElement.path).copySync('$toIOSRes/${element.path.split('/').last}$relativePath');
        }
      });
    } else {
      File(element.path).copySync('$toIOSRes/${element.path.split('/').last}');
    }
  });
  logSuccess('Copy res folder to $toIOSRes');
}