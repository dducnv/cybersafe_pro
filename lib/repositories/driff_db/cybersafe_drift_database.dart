import 'dart:io';

import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/secure/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'models/models.dart';

part 'cybersafe_drift_database.g.dart';

@DriftDatabase(tables: [AccountDriftModel, CategoryDriftModel, TOTPDriftModel, PasswordHistoryDriftModel, AccountCustomFieldDriftModel, IconCustomDriftModel, TextNotesDriftModel])
class DriftSqliteDatabase extends _$DriftSqliteDatabase {
  DriftSqliteDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  /// Mở kết nối với SQLite3MultipleCiphers encryption
  /// Hỗ trợ migration kdf_iter từ 64000 → 256000
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      try {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'cybersafe_secure.db.enc'));

        // Lấy password từ KeyManager
        final password = await KeyManager.getKey(KeyType.database);

        // Kiểm tra trạng thái migration kdf_iter
        final secureStorage = SecureStorage.instance;
        final kdfMigrated = await secureStorage.read(key: SecureStorageKey.dbKdfMigrated);
        final isKdfMigrated = kdfMigrated == 'true';
        final isNewDatabase = !file.existsSync();

        logInfo(
          'Opening Drift database at: ${file.path} '
          '(kdfMigrated=$isKdfMigrated, isNew=$isNewDatabase)',
        );

        return NativeDatabase.createInBackground(
          file,
          setup: (database) {
            // Kiểm tra SQLite3MultipleCiphers đã được load
            assert(database.select('PRAGMA cipher;').isNotEmpty, 'SQLite3MultipleCiphers is not available! Check build hooks config.');

            // Cấu hình SQLCipher compatibility
            database.execute("PRAGMA cipher = 'sqlcipher'");
            database.execute('PRAGMA legacy = 4');

            if (isNewDatabase || isKdfMigrated) {
              // User mới hoặc đã migrate → dùng kdf_iter=256000
              database.execute('PRAGMA kdf_iter = 256000');
              database.execute('PRAGMA key = "$password"');
            } else {
              // User cũ chưa migrate → mở với 64000 rồi rekey sang 256000
              database.execute('PRAGMA kdf_iter = 64000');
              database.execute('PRAGMA key = "$password"');

              // Verify mở được với key cũ
              database.select('SELECT COUNT(*) FROM sqlite_master');

              // Re-encrypt với kdf_iter=256000
              database.execute('PRAGMA kdf_iter = 256000');
              database.execute('PRAGMA rekey = "$password"');

              logInfo('Database re-keyed with kdf_iter=256000');
            }

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

  /// Gọi sau khi database mở thành công để lưu trạng thái migration
  static Future<void> markKdfMigrationComplete() async {
    try {
      final secureStorage = SecureStorage.instance;
      final kdfMigrated = await secureStorage.read(key: SecureStorageKey.dbKdfMigrated);
      if (kdfMigrated != 'true') {
        await secureStorage.save(key: SecureStorageKey.dbKdfMigrated, value: 'true');
        logInfo('KDF migration flag saved');
      }
    } catch (e) {
      logError('Failed to save KDF migration flag: $e');
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await markKdfMigrationComplete();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        await m.addColumn(textNotesDriftModel, textNotesDriftModel.color);
      }
      if (from == 2) {
        await m.addColumn(accountDriftModel, accountDriftModel.openCount);
      }
    },
    beforeOpen: (details) async {
      await markKdfMigrationComplete();
    },
  );
}
