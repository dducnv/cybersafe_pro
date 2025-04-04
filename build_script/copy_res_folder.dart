import 'dart:io';

import 'configs.dart';

import 'package:path/path.dart' as p;

Future<void> copyResFolderAndroid(String appVersion) async {
  final String sourcePath = '${Config.appDataPath}/$appVersion/res';
  final String targetPath = 'android/app/src/main/res';

  final sourceDir = Directory(sourcePath);
  final targetDir = Directory(targetPath);

  // Kiểm tra nguồn tồn tại
  if (!sourceDir.existsSync()) {
    throw Exception('❌ Source folder không tồn tại: $sourcePath');
  }

  // Xoá toàn bộ thư mục res cũ nếu có
  if (targetDir.existsSync()) {
    targetDir.deleteSync(recursive: true);
  }

  // Tạo lại thư mục đích
  targetDir.createSync(recursive: true);

  // Duyệt tất cả file/folder trong source và sao chép vào target
  for (final entity in sourceDir.listSync(recursive: true)) {
    if (entity is File) {
      final relativePath = p.relative(entity.path, from: sourcePath);
      final newFile = File(p.join(targetPath, relativePath));

      // Tạo folder cha nếu chưa tồn tại
      newFile.parent.createSync(recursive: true);
      entity.copySync(newFile.path);
    }
  }

  logSuccess('✅ Đã sao chép thư mục res từ $sourcePath vào $targetPath');
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
