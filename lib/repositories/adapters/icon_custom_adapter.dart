import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class IconCustomAdapter {
  final DriftSqliteDatabase _database;

  IconCustomAdapter(this._database);

  // ==================== CRUD Operations ====================

  Future<int> insertCustomIcon(String name, String imageBase64) async {
    return _database.into(_database.iconCustomDriftModel).insert(IconCustomDriftModelCompanion(name: Value(name), imageBase64: Value(imageBase64)));
  }

  Future<void> deleteCustomIcon(int id) async {
    await (_database.delete(_database.iconCustomDriftModel)..where((t) => t.id.equals(id))).go();
  }

  /// Lấy tất cả custom icons
  Future<List<IconCustomDriftModelData>> getAll() async {
    try {
      final icons = await _database.select(_database.iconCustomDriftModel).get();
      return icons;
    } catch (e) {
      logError('Error getting all custom icons: $e');
      return [];
    }
  }

  /// Lấy custom icon theo ID
  Future<IconCustomDriftModelData?> getById(int id) async {
    try {
      final query = _database.select(_database.iconCustomDriftModel)..where((t) => t.id.equals(id));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting custom icon by ID: $e');
      return null;
    }
  }

  Future<List<IconCustomDriftModelData>> getByIds(List<int> ids) async {
    try {
      // Nếu danh sách rỗng, trả về ngay để tránh query lỗi
      if (ids.isEmpty) return [];

      final query = _database.select(_database.iconCustomDriftModel)..where((t) => t.id.isIn(ids));

      return await query.get();
    } catch (e) {
      logError('Error getting custom icons by IDs: $e');
      return [];
    }
  }

  /// Tìm custom icon theo tên
  Future<IconCustomDriftModelData?> findByName(String name) async {
    try {
      final query = _database.select(_database.iconCustomDriftModel)..where((t) => t.name.equals(name));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error finding custom icon by name: $e');
      return null;
    }
  }

  /// Tìm custom icon theo base64 image
  Future<IconCustomDriftModelData?> findByBase64Image(String base64Image) async {
    try {
      final query = _database.select(_database.iconCustomDriftModel)..where((t) => t.imageBase64.equals(base64Image));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error finding custom icon by base64 image: $e');
      return null;
    }
  }

  /// Tìm kiếm custom icons theo tên
  Future<List<IconCustomDriftModelData>> searchByName(String keyword) async {
    try {
      final query =
          _database.select(_database.iconCustomDriftModel)
            ..where((t) => t.name.contains(keyword))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error searching custom icons by name: $e');
      return [];
    }
  }

  /// Đếm số lượng custom icons
  Future<int> count() async {
    try {
      final rows = await _database.selectOnly(_database.iconCustomDriftModel).get();
      return rows.length;
    } catch (e) {
      logError('Error counting custom icons: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật custom icon
  Future<int> put(IconCustomDriftModelData icon) async {
    try {
      if (icon.id == 0) {
        // Insert new icon
        return await _database.into(_database.iconCustomDriftModel).insert(icon);
      } else {
        // Update existing icon
        await _database.update(_database.iconCustomDriftModel).replace(icon);
        return icon.id;
      }
    } catch (e) {
      logError('Error putting custom icon: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật nhiều custom icons
  Future<List<int>> putMany(List<IconCustomDriftModelData> icons) async {
    try {
      final ids = <int>[];
      for (final icon in icons) {
        final id = await put(icon);
        ids.add(id);
      }
      return ids;
    } catch (e) {
      logError('Error putting many custom icons: $e');
      return [];
    }
  }

  /// Xóa custom icon theo ID (set NULL cho accounts đang sử dụng icon này)
  Future<bool> delete(int id) async {
    try {
      // Kiểm tra xem icon có tồn tại không
      final icon = await getById(id);
      if (icon == null) {
        logInfo('Icon with ID $id does not exist');
        return false;
      }

      await _database.transaction(() async {
        // Sử dụng raw SQL để bypass foreign key constraints
        // 1. Update accounts để set iconCustomId = NULL
        final updateCount = await _database.customUpdate(
          'UPDATE account_drift_model SET icon_custom_id = NULL WHERE icon_custom_id = ?',
          variables: [Variable.withInt(id)],
          updates: {_database.accountDriftModel},
        );

        logInfo('Updated $updateCount accounts to remove icon reference');

        // 2. Xóa icon bằng raw SQL
        final deleteCount = await _database.customUpdate('DELETE FROM icon_custom_drift_model WHERE id = ?', variables: [Variable.withInt(id)], updates: {_database.iconCustomDriftModel});

        logInfo('Deleted $deleteCount icon records');
      });

      return true;
    } catch (e) {
      logError('Error deleting custom icon $id: $e');
      return false;
    }
  }

  /// Xóa nhiều custom icons (set NULL cho accounts đang sử dụng)
  Future<int> deleteMany(List<int> ids) async {
    try {
      await _database.transaction(() async {
        // Sử dụng raw SQL để bypass foreign key constraints
        // 1. Update accounts để set iconCustomId = NULL
        final updateCount = await _database.customUpdate(
          'UPDATE account_drift_model SET icon_custom_id = NULL WHERE icon_custom_id IN (${ids.map((_) => '?').join(',')})',
          variables: ids.map((id) => Variable.withInt(id)).toList(),
          updates: {_database.accountDriftModel},
        );

        logInfo('Updated $updateCount accounts to remove icon references');

        // 2. Xóa tất cả icons bằng raw SQL
        final deleteCount = await _database.customUpdate(
          'DELETE FROM icon_custom_drift_model WHERE id IN (${ids.map((_) => '?').join(',')})',
          variables: ids.map((id) => Variable.withInt(id)).toList(),
          updates: {_database.iconCustomDriftModel},
        );

        logInfo('Deleted $deleteCount icon records');
      });

      return ids.length;
    } catch (e) {
      logError('Error deleting many custom icons: $e');
      return 0;
    }
  }

  /// Xóa tất cả custom icons (set NULL cho tất cả accounts)
  Future<void> deleteAll() async {
    try {
      await _database.transaction(() async {
        // Sử dụng raw SQL để bypass foreign key constraints
        // 1. Update accounts để set iconCustomId = NULL
        final updateCount = await _database.customUpdate('UPDATE account_drift_model SET icon_custom_id = NULL WHERE icon_custom_id IS NOT NULL', updates: {_database.accountDriftModel});

        logInfo('Updated $updateCount accounts to remove all icon references');

        // 2. Xóa tất cả custom icons bằng raw SQL
        final deleteCount = await _database.customUpdate('DELETE FROM icon_custom_drift_model', updates: {_database.iconCustomDriftModel});

        logInfo('Deleted $deleteCount icon records');
      });
    } catch (e) {
      logError('Error deleting all custom icons: $e');
    }
  }

  // ==================== Stream Operations ====================

  /// Theo dõi thay đổi tất cả custom icons
  Stream<List<IconCustomDriftModelData>> watchAll() {
    final query = _database.select(_database.iconCustomDriftModel)..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch();
  }

  /// Theo dõi số lượng custom icons
  Stream<int> watchCount() {
    return _database.selectOnly(_database.iconCustomDriftModel).watch().map((rows) => rows.length);
  }

  // ==================== Utility Methods ====================

  /// Lấy custom icons với thông tin accounts
  Future<List<Map<String, dynamic>>> getWithAccountInfo() async {
    try {
      final query = _database.select(_database.iconCustomDriftModel).join([
        leftOuterJoin(_database.accountDriftModel, _database.iconCustomDriftModel.id.equalsExp(_database.accountDriftModel.iconCustomId)),
      ])..orderBy([OrderingTerm.asc(_database.iconCustomDriftModel.name)]);

      final results = await query.get();
      return results.map((row) {
        final icon = row.readTable(_database.iconCustomDriftModel);
        final account = row.readTableOrNull(_database.accountDriftModel);

        return {'icon': icon, 'account': account};
      }).toList();
    } catch (e) {
      logError('Error getting custom icons with account info: $e');
      return [];
    }
  }

  /// Kiểm tra xem custom icon có tồn tại không
  Future<bool> exists(int id) async {
    try {
      final icon = await getById(id);
      return icon != null;
    } catch (e) {
      logError('Error checking if custom icon exists: $e');
      return false;
    }
  }

  /// Kiểm tra xem tên custom icon có tồn tại không
  Future<bool> nameExists(String name) async {
    try {
      final icon = await findByName(name);
      return icon != null;
    } catch (e) {
      logError('Error checking if custom icon name exists: $e');
      return false;
    }
  }

  /// Kiểm tra xem base64 image có tồn tại không
  Future<bool> base64ImageExists(String base64Image) async {
    try {
      final icon = await findByBase64Image(base64Image);
      return icon != null;
    } catch (e) {
      logError('Error checking if base64 image exists: $e');
      return false;
    }
  }

  /// Lấy custom icon đầu tiên
  Future<IconCustomDriftModelData?> getFirst() async {
    try {
      final query =
          _database.select(_database.iconCustomDriftModel)
            ..orderBy([(t) => OrderingTerm.asc(t.name)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting first custom icon: $e');
      return null;
    }
  }

  /// Lấy custom icon cuối cùng
  Future<IconCustomDriftModelData?> getLast() async {
    try {
      final query =
          _database.select(_database.iconCustomDriftModel)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting last custom icon: $e');
      return null;
    }
  }

  /// Lấy custom icons theo kích thước image (ước tính từ base64)
  Future<List<IconCustomDriftModelData>> getByImageSize({int? minSizeBytes, int? maxSizeBytes}) async {
    try {
      final query = _database.select(_database.iconCustomDriftModel);

      if (minSizeBytes != null || maxSizeBytes != null) {
        // Tính toán kích thước từ base64
        query.where((t) {
          final sizeCondition = t.imageBase64.length;

          if (minSizeBytes != null && maxSizeBytes != null) {
            return sizeCondition.isBiggerOrEqualValue(minSizeBytes) & sizeCondition.isSmallerOrEqualValue(maxSizeBytes);
          } else if (minSizeBytes != null) {
            return sizeCondition.isBiggerOrEqualValue(minSizeBytes);
          } else {
            return sizeCondition.isSmallerOrEqualValue(maxSizeBytes!);
          }
        });
      }

      query.orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error getting custom icons by image size: $e');
      return [];
    }
  }

  /// Tìm kiếm custom icons theo nhiều tiêu chí
  Future<List<IconCustomDriftModelData>> searchAdvanced({String? name, String? base64Image, int? minSizeBytes, int? maxSizeBytes}) async {
    try {
      final query = _database.select(_database.iconCustomDriftModel);

      // Build where conditions
      if (name != null && name.isNotEmpty) {
        query.where((t) => t.name.contains(name));
      }

      if (base64Image != null && base64Image.isNotEmpty) {
        query.where((t) => t.imageBase64.contains(base64Image));
      }

      if (minSizeBytes != null || maxSizeBytes != null) {
        query.where((t) {
          final sizeCondition = t.imageBase64.length;

          if (minSizeBytes != null && maxSizeBytes != null) {
            return sizeCondition.isBiggerOrEqualValue(minSizeBytes) & sizeCondition.isSmallerOrEqualValue(maxSizeBytes);
          } else if (minSizeBytes != null) {
            return sizeCondition.isBiggerOrEqualValue(minSizeBytes);
          } else {
            return sizeCondition.isSmallerOrEqualValue(maxSizeBytes!);
          }
        });
      }

      query.orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error in advanced search: $e');
      return [];
    }
  }

  /// Lấy custom icons được sử dụng bởi accounts
  Future<List<IconCustomDriftModelData>> getUsedIcons() async {
    try {
      final query =
          _database.select(_database.iconCustomDriftModel)
            ..where(
              (t) => t.id.isInQuery(
                _database.selectOnly(_database.accountDriftModel)
                  ..addColumns([_database.accountDriftModel.iconCustomId])
                  ..where(_database.accountDriftModel.iconCustomId.isNotNull()),
              ),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error getting used custom icons: $e');
      return [];
    }
  }

  /// Lấy custom icons không được sử dụng
  Future<List<IconCustomDriftModelData>> getUnusedIcons() async {
    try {
      final query =
          _database.select(_database.iconCustomDriftModel)
            ..where(
              (t) => t.id.isNotInQuery(
                _database.selectOnly(_database.accountDriftModel)
                  ..addColumns([_database.accountDriftModel.iconCustomId])
                  ..where(_database.accountDriftModel.iconCustomId.isNotNull()),
              ),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error getting unused custom icons: $e');
      return [];
    }
  }

  /// Xóa custom icons không được sử dụng (an toàn)
  Future<int> deleteUnusedIcons() async {
    try {
      final unusedIcons = await getUnusedIcons();
      if (unusedIcons.isNotEmpty) {
        final unusedIds = unusedIcons.map((icon) => icon.id).toList();
        return await deleteMany(unusedIds);
      }
      return 0;
    } catch (e) {
      logError('Error deleting unused custom icons: $e');
      return 0;
    }
  }

  /// Lấy thống kê custom icons
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final totalCount = await count();
      final usedIcons = await getUsedIcons();
      final unusedIcons = await getUnusedIcons();

      // Tính tổng kích thước
      final allIcons = await getAll();
      int totalSize = 0;
      for (final icon in allIcons) {
        totalSize += icon.imageBase64.length;
      }

      return {
        'totalCount': totalCount,
        'usedCount': usedIcons.length,
        'unusedCount': unusedIcons.length,
        'totalSizeBytes': totalSize,
        'averageSizeBytes': totalCount > 0 ? totalSize ~/ totalCount : 0,
      };
    } catch (e) {
      logError('Error getting custom icons statistics: $e');
      return {'totalCount': 0, 'usedCount': 0, 'unusedCount': 0, 'totalSizeBytes': 0, 'averageSizeBytes': 0};
    }
  }

  /// Kiểm tra xem icon có đang được sử dụng bởi accounts không
  Future<bool> isIconUsed(int iconId) async {
    try {
      final query =
          _database.selectOnly(_database.accountDriftModel)
            ..where(_database.accountDriftModel.iconCustomId.equals(iconId))
            ..limit(1);

      final rows = await query.get();
      return rows.isNotEmpty;
    } catch (e) {
      logError('Error checking if icon is used: $e');
      return false;
    }
  }

  /// Lấy danh sách accounts đang sử dụng icon
  Future<List<AccountDriftModelData>> getAccountsUsingIcon(int iconId) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..where((tbl) => tbl.iconCustomId.equals(iconId))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]);

      return await query.get();
    } catch (e) {
      logError('Error getting accounts using icon: $e');
      return [];
    }
  }

  /// Lấy số lượng accounts đang sử dụng icon
  Future<int> getUsageCount(int iconId) async {
    try {
      final query = _database.selectOnly(_database.accountDriftModel)..where(_database.accountDriftModel.iconCustomId.equals(iconId));

      final rows = await query.get();
      return rows.length;
    } catch (e) {
      logError('Error getting usage count for icon: $e');
      return 0;
    }
  }

  /// Kiểm tra trạng thái foreign key constraints
  Future<bool> checkForeignKeyConstraints() async {
    try {
      final result = await _database.customSelect('PRAGMA foreign_keys').getSingle();
      final foreignKeysEnabled = result.data.values.first == 1;
      logInfo('Foreign key constraints are ${foreignKeysEnabled ? 'enabled' : 'disabled'}');
      return foreignKeysEnabled;
    } catch (e) {
      logError('Error checking foreign key constraints: $e');
      return false;
    }
  }

  /// Xóa icon an toàn với kiểm tra sử dụng
  Future<bool> safeDelete(int id) async {
    try {
      // Kiểm tra xem icon có đang được sử dụng không
      final usageCount = await getUsageCount(id);
      if (usageCount > 0) {
        logInfo('Icon $id is used by $usageCount accounts. Setting iconCustomId to NULL for these accounts.');

        // Lấy danh sách accounts đang sử dụng
        final accounts = await getAccountsUsingIcon(id);
        logInfo('Accounts using icon $id: ${accounts.map((a) => a.title).join(', ')}');
      }

      return await delete(id);
    } catch (e) {
      logError('Error in safe delete for icon $id: $e');
      return false;
    }
  }

  /// Test raw SQL operations
  Future<bool> testRawSqlOperations() async {
    try {
      // Test 1: Kiểm tra foreign key constraints
      final fkResult = await _database.customSelect('PRAGMA foreign_keys').getSingle();
      logInfo('Foreign keys status: ${fkResult.data.values.first}');

      // Test 2: Kiểm tra có thể update accounts không
      final testUpdate = await _database.customUpdate(
        'UPDATE account_drift_model SET icon_custom_id = icon_custom_id WHERE icon_custom_id IS NOT NULL LIMIT 1',
        updates: {_database.accountDriftModel},
      );
      logInfo('Test update result: $testUpdate');

      return true;
    } catch (e) {
      logError('Test raw SQL operations failed: $e');
      return false;
    }
  }
}
