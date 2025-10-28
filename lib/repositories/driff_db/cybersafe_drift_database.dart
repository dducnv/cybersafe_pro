import 'dart:ffi';
import 'dart:io';

import 'package:cybersafe_pro/secure/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

import 'models/models.dart';

part 'cybersafe_drift_database.g.dart';

@DriftDatabase(
  tables: [
    AccountDriftModel,
    CategoryDriftModel,
    TOTPDriftModel,
    PasswordHistoryDriftModel,
    AccountCustomFieldDriftModel,
    IconCustomDriftModel,
    TextNotesDriftModel,
  ],
)
class DriftSqliteDatabase extends _$DriftSqliteDatabase {
  DriftSqliteDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  /// Mở kết nối với SQLCipher encryption
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      try {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'cybersafe_secure.db.enc'));

        // Lấy password từ KeyManager
        final password = await KeyManager.getKey(KeyType.database);

        logInfo('Opening Drift database with encryption at: ${file.path}');

        return NativeDatabase.createInBackground(
          file,
          isolateSetup: () async {
            open
              ..overrideFor(OperatingSystem.android, openCipherOnAndroid)
              ..overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlcipher.so'))
              ..overrideFor(OperatingSystem.windows, () => DynamicLibrary.open('sqlcipher.dll'));
          },
          setup: (database) {
            // Cấu hình SQLCipher
            database.execute('PRAGMA key = "$password"');
            database.execute('PRAGMA cipher_page_size = 4096');
            database.execute('PRAGMA kdf_iter = 64000');
            database.execute('PRAGMA cipher_hmac_algorithm = HMAC_SHA512');
            database.execute('PRAGMA cipher_kdf_algorithm = PBKDF2_HMAC_SHA512');

            // Cấu hình performance
            database.execute('PRAGMA journal_mode = WAL');
            database.execute('PRAGMA synchronous = NORMAL');
            database.execute('PRAGMA temp_store = MEMORY');
            database.execute('PRAGMA mmap_size = 268435456'); // 256MB
            database.execute('PRAGMA foreign_keys = ON');

            // Verify database
            try {
              database.select('SELECT COUNT(*) FROM sqlite_master');
              logInfo('Drift database opened successfully with encryption');
            } catch (e) {
              logError('Failed to verify encrypted database: $e');
              rethrow;
            }
          },
        );
      } catch (e) {
        logError('Failed to open Drift database: $e');
        rethrow;
      }
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        await m.addColumn(textNotesDriftModel, textNotesDriftModel.color);
      }
      if (from == 2) {
        await m.addColumn(accountDriftModel, accountDriftModel.openCount);
      }
    },
  );
}
