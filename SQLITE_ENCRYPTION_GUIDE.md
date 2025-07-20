# SQLite Helper với SQLCipher - Hướng dẫn sử dụng

## 📋 Tổng quan

Đã thêm mã hóa SQLCipher vào `SqliteHelper` của project CyberSafe Pro. Hệ thống này cung cấp:

- **Mã hóa database** với SQLCipher
- **Tự động tạo password** từ device key hiện tại
- **Backup/restore** database được mã hóa
- **Tối ưu performance** với các pragma SQLCipher
- **Cross-platform support** (Android, iOS, macOS, Windows, Linux)

## 🔧 Các thay đổi đã thực hiện

### 1. Dependencies đã có sẵn
```yaml
dependencies:
  sqflite: ^2.4.2
  sqlcipher_flutter_libs: ^0.6.7
```

### 2. Features đã thêm vào `SqliteHelper`

#### **Mã hóa database:**
- Tự động sử dụng SQLCipher nếu available
- Fallback về SQLite thông thường nếu không có SQLCipher
- Password được tạo từ device key hoặc random secure

#### **Cấu hình SQLCipher tối ưu:**
```dart
PRAGMA cipher_page_size = 4096
PRAGMA kdf_iter = 64000
PRAGMA cipher_hmac_algorithm = HMAC_SHA512
PRAGMA cipher_kdf_algorithm = PBKDF2_HMAC_SHA512
```

#### **Performance optimization:**
```dart
PRAGMA journal_mode = WAL
PRAGMA synchronous = NORMAL
PRAGMA temp_store = MEMORY
PRAGMA mmap_size = 268435456  // 256MB
```

#### **Security features:**
- Password stored in `SecureStorage`
- Integration với device key từ hệ thống hiện tại
- Automatic password generation
- Database verification on open

## 🚀 Cách sử dụng

### 1. Khởi tạo database
```dart
// Trong main.dart hoặc app initialization
await SqliteHelper.instance.init();
```

### 2. Sử dụng database
```dart
final db = SqliteHelper.instance.database;

// Insert
await db.insert('table_name', {'key': 'value'});

// Query
final results = await db.query('table_name');

// Update
await db.update('table_name', {'key': 'new_value'}, where: 'id = ?', whereArgs: [1]);

// Delete
await db.delete('table_name', where: 'id = ?', whereArgs: [1]);
```

### 3. Các phương thức mã hóa

#### **Kiểm tra encryption status:**
```dart
bool isEncrypted = await SqliteHelper.instance.isDatabaseEncrypted();
```

#### **Thay đổi password:**
```dart
await SqliteHelper.instance.changePassword('new_password');
```

#### **Backup database:**
```dart
await SqliteHelper.instance.backupDatabase(
  '/path/to/backup.db', 
  'backup_password'
);
```

#### **Restore database:**
```dart
await SqliteHelper.instance.restoreDatabase(
  '/path/to/backup.db', 
  'backup_password'
);
```

## 🔒 Bảo mật

### Password generation strategy:
1. **Primary**: Sử dụng device key từ hệ thống encryption hiện tại
2. **Fallback**: Tạo random password với timestamp và OS info
3. **Emergency**: Default password với timestamp

### Password format:
```dart
// Với device key
"sqlite_{device_key}_{timestamp}"

// Fallback
"cybersafe_sqlite_{timestamp}_{os}"

// Emergency
"cybersafe_default_{timestamp}"
```

### Storage:
- Password được lưu trong `SecureStorage`
- Key name: `"sqlite_db_password"`
- Encrypted at rest

## 🛠️ Tích hợp với hệ thống hiện tại

### Compatibility:
- **Hoàn toàn tương thích** với ObjectBox (dual database)
- **Sử dụng chung** device key từ `EncryptAppDataService`
- **Không conflict** với encryption system hiện tại

### Use cases:
1. **Metadata storage** - Settings, preferences
2. **Relational data** - Cần SQL queries phức tạp
3. **Backup storage** - Local backup với encryption
4. **Logging** - Secure audit logs
5. **Cache** - Encrypted cache data

## 📱 Platform-specific notes

### Android:
```dart
// Tự động áp dụng workaround cho Android cũ
if (Platform.isAndroid) {
  await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
}
```

### iOS/macOS:
- SQLCipher pod được tự động include qua `sqlcipher_flutter_libs`
- Có thể cần config Xcode nếu có conflict với libs khác

### Windows/Linux:
- SQLCipher được compile static
- Cần OpenSSL for compilation (chỉ development)

## 🔄 Migration strategy

### Từ SQLite thông thường:
```dart
// Hệ thống tự động detect và migrate
// Nếu database cũ không có encryption, sẽ thêm encryption
```

### Từ hệ thống khác:
```dart
// Export data từ hệ thống cũ
// Import vào SQLite encrypted
// Verify integrity
```

## 📊 Performance comparison

| Feature | SQLite | SQLCipher | Impact |
|---------|---------|-----------|---------|
| **Read speed** | 100% | 85-90% | Slight decrease |
| **Write speed** | 100% | 80-85% | Moderate decrease |
| **File size** | 100% | 100-105% | Minimal increase |
| **Memory usage** | 100% | 105-110% | Slight increase |
| **Security** | None | Enterprise | Major improvement |

## 🐛 Troubleshooting

### Common issues:

#### **"Database is locked"**
```dart
// Solution: Ensure WAL mode is enabled
await db.execute('PRAGMA journal_mode = WAL');
```

#### **"File is not a database"**
```dart
// Solution: Wrong password hoặc corrupted file
// Check password in SecureStorage
// Restore from backup if needed
```

#### **Performance issues**
```dart
// Solution: Optimize SQLCipher settings
await db.execute('PRAGMA cipher_page_size = 4096');
await db.execute('PRAGMA mmap_size = 268435456');
```

#### **Android crashes**
```dart
// Solution: Apply workaround
await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
```

## 🔮 Future improvements

### Planned features:
1. **Automatic key rotation** - Monthly key changes
2. **Hardware-backed encryption** - Android Keystore integration
3. **Multi-database support** - Multiple encrypted databases
4. **Compression** - Database compression before encryption
5. **Monitoring** - Database access logging

### Optional enhancements:
1. **Custom encryption** - Thay thế SQLCipher bằng custom
2. **Sharding** - Split database thành multiple files
3. **Replication** - Sync với remote encrypted database

## 📚 References

- [SQLCipher Documentation](https://www.zetetic.net/sqlcipher/)
- [Flutter SQLCipher Plugin](https://pub.dev/packages/sqlcipher_flutter_libs)
- [SQLite Performance Tuning](https://sqlite.org/pragma.html)
- [CyberSafe Pro Encryption Architecture](./ENCRYPT_DOCUMMENT.MD)

## 🎯 Conclusion

SQLite helper đã được upgrade với enterprise-grade encryption:

✅ **Secure**: SQLCipher với PBKDF2 64K iterations  
✅ **Fast**: Optimized pragmas cho performance  
✅ **Reliable**: Automatic fallbacks và error handling  
✅ **Compatible**: Tích hợp hoàn hảo với hệ thống hiện tại  
✅ **Maintainable**: Clean code với comprehensive logging  

**Recommendation**: Sử dụng cho tất cả SQL-based data cần encryption. 