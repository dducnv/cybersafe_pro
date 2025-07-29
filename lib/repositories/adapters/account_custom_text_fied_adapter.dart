import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class AccountCustomFieldAdapter {
  final DriftSqliteDatabase _database;

  AccountCustomFieldAdapter(this._database);

  // ==================== CRUD Operations ====================

  Future<void> insertOrUpdateCustomField(AccountCustomFieldDriftModelCompanion data) async {
    if (data.id.present && data.id.value != 0) {
      await _database.update(_database.accountCustomFieldDriftModel).replace(data);
    } else {
      await _database.into(_database.accountCustomFieldDriftModel).insert(data);
    }
  }

  Future<void> deleteCustomFieldsByAccount(int accountId) async {
    await (_database.delete(_database.accountCustomFieldDriftModel)..where((tbl) => tbl.accountId.equals(accountId))).go();
  }

  /// Lấy tất cả custom fields
  Future<List<AccountCustomFieldDriftModelData>> getAll() async {
    try {
      final fields = await _database.select(_database.accountCustomFieldDriftModel).get();
      return fields;
    } catch (e) {
      logError('Error getting all custom fields: $e');
      return [];
    }
  }

  /// Lấy custom fields theo account ID
  Future<List<AccountCustomFieldDriftModelData>> getByAccountId(int accountId) async {
    try {
      final query =
          _database.select(_database.accountCustomFieldDriftModel)
            ..where((t) => t.accountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error getting custom fields by account ID: $e');
      return [];
    }
  }

  /// Lấy custom field theo ID
  Future<AccountCustomFieldDriftModelData?> getById(int id) async {
    try {
      final query = _database.select(_database.accountCustomFieldDriftModel)..where((t) => t.id.equals(id));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting custom field by ID: $e');
      return null;
    }
  }

  /// Tìm kiếm custom fields theo tên
  Future<List<AccountCustomFieldDriftModelData>> searchByName(String keyword) async {
    try {
      final query =
          _database.select(_database.accountCustomFieldDriftModel)
            ..where((t) => t.name.contains(keyword))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error searching custom fields by name: $e');
      return [];
    }
  }

  /// Tìm kiếm custom fields theo giá trị
  Future<List<AccountCustomFieldDriftModelData>> searchByValue(String keyword) async {
    try {
      final query =
          _database.select(_database.accountCustomFieldDriftModel)
            ..where((t) => t.value.contains(keyword))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error searching custom fields by value: $e');
      return [];
    }
  }

  /// Lấy custom fields theo loại
  Future<List<AccountCustomFieldDriftModelData>> getByType(String typeField) async {
    try {
      final query =
          _database.select(_database.accountCustomFieldDriftModel)
            ..where((t) => t.typeField.equals(typeField))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]);

      return await query.get();
    } catch (e) {
      logError('Error getting custom fields by type: $e');
      return [];
    }
  }

  /// Đếm số lượng custom fields
  Future<int> count() async {
    try {
      final rows = await _database.selectOnly(_database.accountCustomFieldDriftModel).get();
      return rows.length;
    } catch (e) {
      logError('Error counting custom fields: $e');
      return 0;
    }
  }

  /// Đếm số lượng custom fields theo account
  Future<int> countByAccountId(int accountId) async {
    try {
      final query = _database.selectOnly(_database.accountCustomFieldDriftModel).join([
        leftOuterJoin(_database.accountDriftModel, _database.accountCustomFieldDriftModel.accountId.equalsExp(_database.accountDriftModel.id)),
      ])..where(_database.accountCustomFieldDriftModel.accountId.equals(accountId));

      final rows = await query.get();
      return rows.length;
    } catch (e) {
      logError('Error counting custom fields by account: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật custom field
  Future<int> put(AccountCustomFieldDriftModelData field) async {
    try {
      if (field.id == 0) {
        // Insert new field
        return await _database.into(_database.accountCustomFieldDriftModel).insert(field);
      } else {
        // Update existing field
        await _database.update(_database.accountCustomFieldDriftModel).replace(field);
        return field.id;
      }
    } catch (e) {
      logError('Error putting custom field: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật nhiều custom fields
  Future<List<int>> putMany(List<AccountCustomFieldDriftModelData> fields) async {
    try {
      final ids = <int>[];
      for (final field in fields) {
        final id = await put(field);
        ids.add(id);
      }
      return ids;
    } catch (e) {
      logError('Error putting many custom fields: $e');
      return [];
    }
  }

  /// Xóa custom field theo ID
  Future<bool> delete(int id) async {
    try {
      return await _database.delete(_database.accountCustomFieldDriftModel).delete(AccountCustomFieldDriftModelCompanion(id: Value(id))) > 0;
    } catch (e) {
      logError('Error deleting custom field: $e');
      return false;
    }
  }

  /// Xóa custom fields theo account ID
  Future<bool> deleteByAccountId(int accountId) async {
    try {
      final fields = await getByAccountId(accountId);
      int deletedCount = 0;

      for (final field in fields) {
        if (await delete(field.id)) {
          deletedCount++;
        }
      }

      return deletedCount == fields.length;
    } catch (e) {
      logError('Error deleting custom fields by account: $e');
      return false;
    }
  }

  /// Xóa nhiều custom fields
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
      logError('Error deleting many custom fields: $e');
      return 0;
    }
  }

  /// Xóa tất cả custom fields
  Future<void> deleteAll() async {
    try {
      await _database.delete(_database.accountCustomFieldDriftModel).go();
    } catch (e) {
      logError('Error deleting all custom fields: $e');
    }
  }

  /// Lấy custom fields với thông tin account
  Future<List<Map<String, dynamic>>> getWithAccountInfo() async {
    try {
      final query = _database.select(_database.accountCustomFieldDriftModel).join([
        leftOuterJoin(_database.accountDriftModel, _database.accountCustomFieldDriftModel.accountId.equalsExp(_database.accountDriftModel.id)),
      ])..orderBy([OrderingTerm.asc(_database.accountCustomFieldDriftModel.name)]);

      final results = await query.get();
      return results.map((row) {
        final field = row.readTable(_database.accountCustomFieldDriftModel);
        final account = row.readTableOrNull(_database.accountDriftModel);

        return {'field': field, 'account': account};
      }).toList();
    } catch (e) {
      logError('Error getting custom fields with account info: $e');
      return [];
    }
  }

  /// Lấy custom fields theo loại với thông tin account
  Future<List<Map<String, dynamic>>> getByTypeWithAccountInfo(String typeField) async {
    try {
      final query =
          _database.select(_database.accountCustomFieldDriftModel).join([
              leftOuterJoin(_database.accountDriftModel, _database.accountCustomFieldDriftModel.accountId.equalsExp(_database.accountDriftModel.id)),
            ])
            ..where(_database.accountCustomFieldDriftModel.typeField.equals(typeField))
            ..orderBy([OrderingTerm.asc(_database.accountCustomFieldDriftModel.name)]);

      final results = await query.get();
      return results.map((row) {
        final field = row.readTable(_database.accountCustomFieldDriftModel);
        final account = row.readTableOrNull(_database.accountDriftModel);

        return {'field': field, 'account': account};
      }).toList();
    } catch (e) {
      logError('Error getting custom fields by type with account info: $e');
      return [];
    }
  }

  /// Kiểm tra xem custom field có tồn tại không
  Future<bool> exists(int id) async {
    try {
      final field = await getById(id);
      return field != null;
    } catch (e) {
      logError('Error checking if custom field exists: $e');
      return false;
    }
  }

  /// Kiểm tra xem account có custom fields không
  Future<bool> hasCustomFields(int accountId) async {
    try {
      final count = await countByAccountId(accountId);
      return count > 0;
    } catch (e) {
      logError('Error checking if account has custom fields: $e');
      return false;
    }
  }
}
