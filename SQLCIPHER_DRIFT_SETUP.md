# Hướng dẫn cấu hình SQLCipher với Drift

## Tổng quan
SQLCipher là một extension mã hóa cho SQLite, cho phép bạn mã hóa toàn bộ database file. Drift có thể làm việc với SQLCipher thông qua package `sqlcipher_flutter_libs`.

## Cấu hình Dependencies

Trong `pubspec.yaml`, thêm các dependencies sau:

```yaml
dependencies:
  drift: ^2.27.0
  drift_flutter: ^0.2.4
  sqlcipher_flutter_libs: ^0.6.7
  sqlite3_flutter_libs: ^0.5.34
  path_provider: ^2.1.5

dev_dependencies:
  drift_dev: ^2.27.0
  build_runner: ^2.6.0
```

## Cấu hình Database Class

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

part 'database.g.dart';

// Định nghĩa table
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Accounts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'encrypted_db.db'));

      // Cấu hình cho Android - QUAN TRỌNG!
      if (Platform.isAndroid) {
        open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
      }

      return NativeDatabase.createInBackground(
        file,
        setup: (database) {
          // Kiểm tra SQLCipher có khả dụng không
          if (database.select('PRAGMA cipher_version;').isEmpty) {
            throw StateError(
              'SQLCipher library không khả dụng!'
            );
          }

          // Đặt khóa mã hóa - THAY ĐỔI KHÓA NÀY!
          database.execute("PRAGMA key = 'your_secure_password_here';");
          
          // Cấu hình tối ưu
          database.execute('PRAGMA foreign_keys = ON;');
          database.execute('PRAGMA journal_mode = WAL;');
          database.execute('PRAGMA synchronous = NORMAL;');
        },
      );
    });
  }
}
```

## Cách sử dụng

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final database = AppDatabase();
  
  // Thêm dữ liệu
  await database.into(database.accounts).insert(
    AccountsCompanion.insert(
      name: 'John Doe',
      email: 'john@example.com',
      password: 'hashed_password',
    ),
  );
  
  // Truy vấn dữ liệu
  final accounts = await database.select(database.accounts).get();
  print('Accounts: $accounts');
  
  await database.close();
}
```

## Lưu ý quan trọng

### 1. Cấu hình Android
Trên Android, **bắt buộc** phải gọi `open.overrideFor()` trước khi sử dụng SQLCipher:

```dart
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

// Trong setup code
if (Platform.isAndroid) {
  open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
}
```

### 2. Vấn đề trên iOS và macOS
Trên iOS và macOS, có thể xảy ra xung đột với các library khác (như `firebase_messaging`, `google_mobile_ads`). Để khắc phục:

1. Thêm `-framework SQLCipher` vào "Other Linker Flags" trong Xcode
2. Hoặc thêm vào `ios/Podfile`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # Ngăn các pod khác link sqlite3
    target.build_configurations.each do |config|
      config.build_settings['OTHER_LDFLAGS'] ||= ['$(inherited)']
      config.build_settings['OTHER_LDFLAGS'] << '-framework SQLCipher'
    end
  end
end
```

### 3. Vấn đề trên Android 6
Nếu gặp lỗi trên Android 6, thêm vào `android/gradle.properties`:

```properties
android.bundle.enableUncompressedNativeLibs=false
```

Hoặc sử dụng workaround:

```dart
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

// Gọi trước khi sử dụng database
await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
```

### 4. Quản lý khóa mã hóa
- **Không** hard-code khóa mã hóa trong source code
- Sử dụng user input (PIN, password) để tạo khóa
- Cân nhắc sử dụng key derivation functions (PBKDF2, Argon2)
- Lưu trữ khóa an toàn với `flutter_secure_storage`

### 5. Hiệu suất
- SQLCipher có thể chậm hơn SQLite thông thường 5-15%
- Sử dụng connection pooling cho apps lớn
- Cân nhắc mã hóa chỉ dữ liệu nhạy cảm

## Các pragma SQLCipher hữu ích

```dart
// Thay đổi khóa mã hóa
database.execute("PRAGMA rekey = 'new_key';");

// Kiểm tra version SQLCipher
final version = database.select('PRAGMA cipher_version;');

// Cấu hình thuật toán mã hóa
database.execute('PRAGMA cipher = "aes-256-cbc";');

// Cấu hình KDF iterations
database.execute('PRAGMA kdf_iter = 64000;');

// Backup database mã hóa
database.execute("ATTACH DATABASE 'backup.db' AS backup KEY 'backup_key';");
database.execute("SELECT sqlcipher_export('backup');");
database.execute("DETACH DATABASE backup;");
```

## Troubleshooting

1. **Lỗi "database is locked"**: Đảm bảo sử dụng WAL mode
2. **Lỗi "file is not a database"**: Kiểm tra khóa mã hóa có đúng không
3. **Crash trên Android**: Thử sử dụng workaround cho Android cũ
4. **Lỗi build iOS**: Kiểm tra cấu hình Xcode và Podfile

## Tích hợp với hệ thống hiện tại

Vì project của bạn đang sử dụng ObjectBox, bạn có thể:

1. **Migration dần dần**: Sử dụng SQLCipher cho dữ liệu mới, giữ ObjectBox cho dữ liệu cũ
2. **Dual database**: Sử dụng cả hai, SQLCipher cho dữ liệu nhạy cảm
3. **Full migration**: Chuyển toàn bộ từ ObjectBox sang Drift + SQLCipher

Tùy thuộc vào nhu cầu và timeline của project mà bạn có thể chọn phương án phù hợp. 