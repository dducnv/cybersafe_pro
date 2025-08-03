# Tích hợp Drift với SQLCipher trong CyberSafe Pro

## 📋 Tổng quan

Hướng dẫn này giải thích cách tích hợp **Drift** với **SQLCipher** và **SQLite helper** hiện có trong project CyberSafe Pro. Bạn có thể dùng **song song** cả ObjectBox và Drift với SQLCipher.

## 🔧 Cấu hình Dependencies

Dependencies đã được thêm vào `pubspec.yaml`:

```yaml
dependencies:
  # Database existing
  objectbox: ^4.1.0
  sqflite: ^2.4.2
  sqlcipher_flutter_libs: ^0.6.7
  
  # Drift integration
  drift: ^2.27.0
  drift_flutter: ^0.2.4
  sqlite3_flutter_libs: ^0.5.34

dev_dependencies:
  drift_dev: ^2.27.0
  build_runner: ^2.4.15
```

## 📁 Cấu trúc File

```
lib/repositories/sqlite/
├── sqlite_helper.dart              # SQLite helper với SQLCipher (đã có)
├── sqlite_management.dart          # SQLite management (đã có)
├── drift_database.dart             # Drift database với SQLCipher
├── drift_database.g.dart           # Generated file (sẽ được tạo)
└── drift_usage_example.dart        # Example sử dụng
```

## 🔍 Hiểu về customSelect và customStatement

### customSelect()
- **Mục đích**: Thực hiện SELECT queries với raw SQL
- **Trả về**: `Selectable<QueryRow>` - có thể `.get()` hoặc `.getSingle()`
- **Sử dụng**: Khi cần SQL queries phức tạp không thể dùng Drift API

### customStatement()
- **Mục đích**: Thực hiện INSERT, UPDATE, DELETE, PRAGMA, DDL
- **Trả về**: `Future<void>` hoặc `Future<int>` (affected rows)
- **Sử dụng**: Khi cần thực hiện SQL statements không phải SELECT

## 🚀 Implementation Example

### 1. Tạo Drift Database Class

```dart
// lib/repositories/sqlite/drift_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:cybersafe_pro/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';

part 'drift_database.g.dart';

// Định nghĩa tables
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().withLength(min: 1, max: 255)();
  TextColumn get value => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [AppSettings, AuditLogs])
class CyberSafeDriftDatabase extends _$CyberSafeDriftDatabase {
  CyberSafeDriftDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Connection với SQLCipher
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      try {
        // Android SQLCipher setup
        if (Platform.isAndroid) {
          open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
        }

        // Database path
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'cybersafe_drift.db'));

        // Lấy password từ KeyManager (tương tự sqlite_helper.dart)
        final password = await KeyManager.getKey(KeyType.database);
        
        logInfo('Opening Drift database with encryption at: ${file.path}');

        return NativeDatabase.createInBackground(
          file,
          setup: (database) {
            // SQLCipher configuration (giống sqlite_helper.dart)
            database.execute('PRAGMA key = "$password"');
            database.execute('PRAGMA cipher_page_size = 4096');
            database.execute('PRAGMA kdf_iter = 64000');
            database.execute('PRAGMA cipher_hmac_algorithm = HMAC_SHA512');
            database.execute('PRAGMA cipher_kdf_algorithm = PBKDF2_HMAC_SHA512');
            
            // Performance optimization
            database.execute('PRAGMA journal_mode = WAL');
            database.execute('PRAGMA synchronous = NORMAL');
            database.execute('PRAGMA temp_store = MEMORY');
            database.execute('PRAGMA mmap_size = 268435456'); // 256MB
            database.execute('PRAGMA foreign_keys = ON');
            
            // Verify encryption
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
}
```

### 2. Sử dụng customSelect và customStatement

```dart
extension CyberSafeDriftDatabaseExtensions on CyberSafeDriftDatabase {
  
  /// ===== customSelect Examples =====
  
  /// Kiểm tra database có encrypted không
  Future<bool> isDatabaseEncrypted() async {
    try {
      final result = await customSelect('PRAGMA cipher_version').get();
      return result.isNotEmpty;
    } catch (e) {
      logError('Failed to check encryption status: $e');
      return false;
    }
  }
  
  /// Lấy database size
  Future<int> getDatabaseSize() async {
    final pageCountResult = await customSelect('PRAGMA page_count').getSingle();
    final pageSizeResult = await customSelect('PRAGMA page_size').getSingle();
    
    final pageCount = pageCountResult.data['page_count'] as int;
    final pageSize = pageSizeResult.data['page_size'] as int;
    
    return pageCount * pageSize;
  }
  
  /// Lấy tất cả tables
  Future<List<String>> getAllTables() async {
    final result = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    ).get();
    
    return result.map((row) => row.data['name'] as String).toList();
  }
  
  /// Complex query với parameters
  Future<List<Map<String, dynamic>>> getSettingsByPattern(String pattern) async {
    final result = await customSelect(
      'SELECT * FROM app_settings WHERE key LIKE ? ORDER BY created_at DESC',
      variables: [Variable.withString('%$pattern%')]
    ).get();
    
    return result.map((row) => row.data).toList();
  }
  
  /// Test connection
  Future<bool> testConnection() async {
    try {
      await customSelect('SELECT 1').getSingle();
      return true;
    } catch (e) {
      logError('Database connection test failed: $e');
      return false;
    }
  }
  
  /// ===== customStatement Examples =====
  
  /// Change password
  Future<void> changePassword(String newPassword) async {
    await customStatement('PRAGMA rekey = ?', [newPassword]);
    logInfo('Drift database password changed successfully');
  }
  
  /// Vacuum database
  Future<void> vacuumDatabase() async {
    await customStatement('VACUUM');
    logInfo('Database vacuumed successfully');
  }
  
  /// Create custom table
  Future<void> createCustomTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS user_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        session_token TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        expires_at DATETIME NOT NULL
      )
    ''');
  }
  
  /// Insert với custom SQL
  Future<void> insertUserSession(String userId, String token, DateTime expiresAt) async {
    await customStatement(
      'INSERT INTO user_sessions (user_id, session_token, expires_at) VALUES (?, ?, ?)',
      [userId, token, expiresAt.toIso8601String()]
    );
  }
  
  /// Update với custom SQL
  Future<void> updateSettingByKey(String key, String newValue) async {
    await customStatement(
      'UPDATE app_settings SET value = ?, updated_at = CURRENT_TIMESTAMP WHERE key = ?',
      [newValue, key]
    );
  }
  
  /// Delete với custom SQL
  Future<void> deleteExpiredSessions() async {
    await customStatement(
      'DELETE FROM user_sessions WHERE expires_at < CURRENT_TIMESTAMP'
    );
  }
  
  /// Backup database (SQLCipher specific)
  Future<void> backupDatabase(String backupPath, String backupPassword) async {
    await customStatement('ATTACH DATABASE ? AS backup_db KEY ?', [backupPath, backupPassword]);
    await customStatement("SELECT sqlcipher_export('backup_db')");
    await customStatement('DETACH DATABASE backup_db');
    logInfo('Drift database backup completed: $backupPath');
  }
  
  /// Restore database (SQLCipher specific)
  Future<void> restoreDatabase(String backupPath, String backupPassword) async {
    await customStatement('ATTACH DATABASE ? AS backup_db KEY ?', [backupPath, backupPassword]);
    await customStatement("SELECT sqlcipher_export('main', 'backup_db')");
    await customStatement('DETACH DATABASE backup_db');
    logInfo('Drift database restore completed from: $backupPath');
  }
}
```

### 3. Helper Class

```dart
// lib/repositories/sqlite/drift_helper.dart
class DriftHelper {
  static CyberSafeDriftDatabase? _instance;
  static CyberSafeDriftDatabase get instance => _instance ??= CyberSafeDriftDatabase();

  /// Initialize database
  static Future<void> initialize() async {
    try {
      _instance = CyberSafeDriftDatabase();
      
      // Test connection
      final connected = await _instance!.testConnection();
      if (!connected) {
        throw Exception('Failed to connect to database');
      }
      
      // Check encryption
      final isEncrypted = await _instance!.isDatabaseEncrypted();
      logInfo('Drift database initialized - Encrypted: $isEncrypted');
      
    } catch (e) {
      logError('Failed to initialize Drift database: $e');
      rethrow;
    }
  }

  /// Close database
  static Future<void> close() async {
    if (_instance != null) {
      await _instance!.close();
      _instance = null;
      logInfo('Drift database closed');
    }
  }
}
```

## 🔧 Cách Generate Code

### 1. Chạy Build Runner

```bash
# Generate file .g.dart
flutter packages pub run build_runner build --delete-conflicting-outputs

# Hoặc watch mode (tự động generate khi có thay đổi)
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

### 2. Verify Generated Files

Sau khi chạy build_runner, bạn sẽ có:
- `drift_database.g.dart` - Generated code
- Các method `customSelect()` và `customStatement()` đã available

## 🔄 Tích hợp với Hệ thống Hiện tại

### 1. Sử dụng chung KeyManager

```dart
// Cả sqlite_helper.dart và drift_database.dart đều dùng:
final password = await KeyManager.getKey(KeyType.database);
```

### 2. Dual Database Architecture

```dart
// Trong main.dart hoặc app initialization
await Future.wait([
  // ObjectBox cho main data
  ObjectBox.create(),
  
  // SQLite helper cho legacy/relational data
  SqliteHelper.instance.init(),
  
  // Drift cho complex queries và analytics
  DriftHelper.initialize(),
]);
```

### 3. Data Flow Strategy

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ObjectBox     │    │  SQLite Helper  │    │  Drift Database │
│                 │    │                 │    │                 │
│ • Account Data  │    │ • App Settings  │    │ • Analytics     │
│ • Categories    │    │ • User Prefs    │    │ • Audit Logs    │
│ • TOTP          │    │ • Cache Data    │    │ • Reports       │
│ • Passwords     │    │ • Metadata      │    │ • Backups       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                       │                       │
        └───────────────────────┼───────────────────────┘
                                │
                    ┌─────────────────┐
                    │   KeyManager    │
                    │ (Shared Keys)   │
                    └─────────────────┘
```

## 💡 Best Practices

### 1. Parameter Binding

```dart
// ❌ Không an toàn - SQL injection risk
await customStatement("DELETE FROM users WHERE id = '$userId'");

// ✅ An toàn - Parameter binding
await customStatement('DELETE FROM users WHERE id = ?', [userId]);
```

### 2. Error Handling

```dart
Future<List<Map<String, dynamic>>> safeQuery(String sql, [List<dynamic>? params]) async {
  try {
    final result = await customSelect(sql, variables: params?.map((p) => Variable(p)).toList()).get();
    return result.map((row) => row.data).toList();
  } catch (e) {
    logError('Query failed: $sql', e);
    return [];
  }
}
```

### 3. Transaction Support

```dart
Future<void> performTransaction() async {
  await transaction(() async {
    // Sử dụng Drift API
    await into(appSettings).insert(AppSettingsCompanion.insert(/* ... */));
    
    // Hoặc custom SQL
    await customStatement('INSERT INTO audit_logs (action) VALUES (?)', ['transaction_test']);
  });
}
```

## 🚀 Usage Examples

### 1. Settings Management

```dart
class SettingsService {
  final _drift = DriftHelper.instance;
  
  Future<String?> getSetting(String key) async {
    return await _drift.getSettingValue(key);
  }
  
  Future<void> saveSetting(String key, String value) async {
    await _drift.saveSetting(key, value);
  }
  
  Future<Map<String, String>> getAllSettings() async {
    final result = await _drift.customSelect('SELECT key, value FROM app_settings').get();
    return Map.fromEntries(result.map((row) => MapEntry(row.data['key'] as String, row.data['value'] as String)));
  }
}
```

### 2. Analytics & Reporting

```dart
class AnalyticsService {
  final _drift = DriftHelper.instance;
  
  Future<Map<String, int>> getActionStats() async {
    final result = await _drift.customSelect('''
      SELECT action, COUNT(*) as count 
      FROM audit_logs 
      WHERE timestamp > datetime('now', '-30 days')
      GROUP BY action
      ORDER BY count DESC
    ''').get();
    
    return Map.fromEntries(result.map((row) => MapEntry(
      row.data['action'] as String,
      row.data['count'] as int
    )));
  }
}
```

## 🔒 Security Considerations

1. **Shared Password**: Cả SQLite helper và Drift dùng cùng password từ KeyManager
2. **Same Encryption**: Cùng cấu hình SQLCipher và performance settings
3. **Consistent Security**: Audit logs, backup/restore với cùng security level
4. **Parameter Binding**: Luôn sử dụng parameterized queries

## 🎯 Kết luận

Với setup này, bạn có thể:

✅ **Dùng song song** ObjectBox + SQLite Helper + Drift  
✅ **Chia sẻ encryption** thông qua KeyManager  
✅ **Sử dụng customSelect/customStatement** cho complex queries  
✅ **Maintain security** với SQLCipher encryption  
✅ **Flexible architecture** cho different data types  

**Recommendation**: Sử dụng Drift cho analytics, reporting, và complex relational queries, giữ nguyên ObjectBox cho main app data. 