import 'dart:io';

import 'package:cybersafe_pro/database/objectbox.dart';
import 'package:cybersafe_pro/migrate_data/old_data_decrypt.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MigrateFromObjDb {
  Future<bool> startMigrate() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(docsDir.path, "cyber_safe");
      if (File(dbPath).existsSync()) {
        return false;
      }
      await ObjectBox.create();
      final oldData = await OldDataDecrypt().decryptOldData();
      return true;
    } catch (e) {
      logError('Error migrating data: $e');
      return false;
    }
  }
}
