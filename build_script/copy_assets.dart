import 'dart:io';

import 'configs.dart';

Future<void> copyImagesAssets(String appVersion) async {
  String assetFolder = '${Config.appDataPath}/$appVersion/assets';
  String toAssetsImge = 'assets/images';

  Directory directory = Directory(toAssetsImge);
  //copy and replace all files and folder from resFoder to toAndroidRes
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  //copy and replace all files and folder from assetFoder to toAssetsImge
  Directory(assetFolder).listSync().forEach((element) {
    if (element is Directory) {
      Directory('$toAssetsImge/${element.path.split('/').last}').createSync();
      Directory(element.path).listSync(recursive: true).forEach((subElement) {
        if (subElement is File) {
          final relativePath = subElement.path.substring(element.path.length);
          File(subElement.path).copySync('$toAssetsImge/${element.path.split('/').last}$relativePath');
        }
      });
    } else {
      File(element.path).copySync('$toAssetsImge/${element.path.split('/').last}');
    }
  });
  logSuccess('Copy images assets to $toAssetsImge');
}
