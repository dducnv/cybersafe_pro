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

  /// Xóa custom icon theo ID
  Future<bool> delete(int id) async {
    try {
      return await _database.delete(_database.iconCustomDriftModel).delete(IconCustomDriftModelCompanion(id: Value(id))) > 0;
    } catch (e) {
      logError('Error deleting custom icon: $e');
      return false;
    }
  }

  /// Xóa nhiều custom icons
  Future<int> deleteMany(List<int> ids) async {
    try {
      int deletedCount = 0;
      for (final id in ids) {
        if (await delete(id)) {
          deletedCount++;
        }
      }
      return deletedCount;
    } catch (e) {
      logError('Error deleting many custom icons: $e');
      return 0;
    }
  }

  /// Xóa tất cả custom icons
  Future<void> deleteAll() async {
    try {
      await _database.delete(_database.iconCustomDriftModel).go();
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

  /// Xóa custom icons không được sử dụng
  Future<int> deleteUnusedIcons() async {
    try {
      final unusedIcons = await getUnusedIcons();
      return await deleteMany(unusedIcons.map((icon) => icon.id).toList());
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
}
