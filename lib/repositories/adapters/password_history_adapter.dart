import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class PasswordHistoryAdapter {
  final DriftSqliteDatabase _database;

  PasswordHistoryAdapter(this._database);

  // ==================== CRUD Operations ====================

  Future<void> insertPasswordHistory(int accountId, String password) async {
    await _database.into(_database.passwordHistoryDriftModel).insert(PasswordHistoryDriftModelCompanion(accountId: Value(accountId), password: Value(password)));
  }

  Future<List<PasswordHistoryDriftModelData>> getPasswordHistory(int accountId) async {
    return (_database.select(_database.passwordHistoryDriftModel)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<void> deletePasswordHistory(int accountId) async {
    await (_database.delete(_database.passwordHistoryDriftModel)..where((t) => t.accountId.equals(accountId))).go();
  }

  /// Lấy tất cả password history
  Future<List<PasswordHistoryDriftModelData>> getAll() async {
    try {
      final histories = await _database.select(_database.passwordHistoryDriftModel).get();
      return histories;
    } catch (e) {
      logError('Error getting all password histories: $e');
      return [];
    }
  }

  /// Lấy password history theo ID
  Future<PasswordHistoryDriftModelData?> getById(int id) async {
    try {
      final query = _database.select(_database.passwordHistoryDriftModel)..where((t) => t.id.equals(id));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting password history by ID: $e');
      return null;
    }
  }

  /// Lấy password history theo account ID
  Future<List<PasswordHistoryDriftModelData>> getByAccountId(int accountId) async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel)
            ..where((t) => t.accountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

      return await query.get();
    } catch (e) {
      logError('Error getting password histories by account ID: $e');
      return [];
    }
  }

  /// Lấy password history theo account ID với giới hạn
  Future<List<PasswordHistoryDriftModelData>> getByAccountIdWithLimit(int accountId, int limit) async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel)
            ..where((t) => t.accountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit);

      return await query.get();
    } catch (e) {
      logError('Error getting password histories by account ID with limit: $e');
      return [];
    }
  }

  /// Thêm password history mới
  Future<int> add(PasswordHistoryDriftModelData history) async {
    try {
      return await _database.into(_database.passwordHistoryDriftModel).insert(history);
    } catch (e) {
      logError('Error adding password history: $e');
      return 0;
    }
  }

  /// Thêm nhiều password histories
  Future<List<int>> addMany(List<PasswordHistoryDriftModelData> histories) async {
    try {
      final ids = <int>[];
      for (final history in histories) {
        final id = await add(history);
        ids.add(id);
      }
      return ids;
    } catch (e) {
      logError('Error adding many password histories: $e');
      return [];
    }
  }

  /// Cập nhật password history
  Future<bool> update(PasswordHistoryDriftModelData history) async {
    try {
      await _database.update(_database.passwordHistoryDriftModel).replace(history);
      return true;
    } catch (e) {
      logError('Error updating password history: $e');
      return false;
    }
  }

  /// Xóa password history theo ID
  Future<bool> removeById(int id) async {
    try {
      return await _database.delete(_database.passwordHistoryDriftModel).delete(PasswordHistoryDriftModelCompanion(id: Value(id))) > 0;
    } catch (e) {
      logError('Error removing password history by ID: $e');
      return false;
    }
  }

  /// Xóa password history theo account ID
  Future<int> removeByAccountId(int accountId) async {
    try {
      final histories = await getByAccountId(accountId);
      int deletedCount = 0;

      for (final history in histories) {
        if (await removeById(history.id)) {
          deletedCount++;
        }
      }

      return deletedCount;
    } catch (e) {
      logError('Error removing password histories by account ID: $e');
      return 0;
    }
  }

  /// Xóa tất cả password histories
  Future<void> removeAll() async {
    try {
      await _database.delete(_database.passwordHistoryDriftModel).go();
    } catch (e) {
      logError('Error removing all password histories: $e');
    }
  }

  /// Xóa password histories cũ hơn một thời gian nhất định
  Future<int> removeOlderThan(DateTime dateTime) async {
    try {
      final query = _database.select(_database.passwordHistoryDriftModel)..where((t) => t.createdAt.isSmallerThanValue(dateTime));

      final oldHistories = await query.get();
      int deletedCount = 0;

      for (final history in oldHistories) {
        if (await removeById(history.id)) {
          deletedCount++;
        }
      }

      return deletedCount;
    } catch (e) {
      logError('Error removing password histories older than date: $e');
      return 0;
    }
  }

  /// Xóa password histories cũ hơn số ngày nhất định
  Future<int> removeOlderThanDays(int days) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      return await removeOlderThan(cutoffDate);
    } catch (e) {
      logError('Error removing password histories older than days: $e');
      return 0;
    }
  }

  // ==================== Stream Operations ====================

  /// Theo dõi thay đổi tất cả password histories
  Stream<List<PasswordHistoryDriftModelData>> watchAll() {
    final query = _database.select(_database.passwordHistoryDriftModel)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch();
  }

  /// Theo dõi thay đổi password histories theo account
  Stream<List<PasswordHistoryDriftModelData>> watchByAccountId(int accountId) {
    final query =
        _database.select(_database.passwordHistoryDriftModel)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch();
  }

  /// Theo dõi số lượng password histories
  Stream<int> watchCount() {
    return _database.selectOnly(_database.passwordHistoryDriftModel).watch().map((rows) => rows.length);
  }

  /// Theo dõi số lượng password histories theo account
  Stream<int> watchCountByAccountId(int accountId) {
    final query = _database.selectOnly(_database.passwordHistoryDriftModel)..where(_database.passwordHistoryDriftModel.accountId.equals(accountId));
    return query.watch().map((rows) => rows.length);
  }

  // ==================== Utility Methods ====================

  /// Lấy password histories với thông tin account
  Future<List<Map<String, dynamic>>> getWithAccountInfo() async {
    try {
      final query = _database.select(_database.passwordHistoryDriftModel).join([
        leftOuterJoin(_database.accountDriftModel, _database.passwordHistoryDriftModel.accountId.equalsExp(_database.accountDriftModel.id)),
      ])..orderBy([OrderingTerm.desc(_database.passwordHistoryDriftModel.createdAt)]);

      final results = await query.get();
      return results.map((row) {
        final history = row.readTable(_database.passwordHistoryDriftModel);
        final account = row.readTableOrNull(_database.accountDriftModel);

        return {'history': history, 'account': account};
      }).toList();
    } catch (e) {
      logError('Error getting password histories with account info: $e');
      return [];
    }
  }

  /// Lấy password histories với thông tin account theo account ID
  Future<List<Map<String, dynamic>>> getWithAccountInfoByAccountId(int accountId) async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel).join([
              leftOuterJoin(_database.accountDriftModel, _database.passwordHistoryDriftModel.accountId.equalsExp(_database.accountDriftModel.id)),
            ])
            ..where(_database.passwordHistoryDriftModel.accountId.equals(accountId))
            ..orderBy([OrderingTerm.desc(_database.passwordHistoryDriftModel.createdAt)]);

      final results = await query.get();
      return results.map((row) {
        final history = row.readTable(_database.passwordHistoryDriftModel);
        final account = row.readTableOrNull(_database.accountDriftModel);

        return {'history': history, 'account': account};
      }).toList();
    } catch (e) {
      logError('Error getting password histories with account info by account ID: $e');
      return [];
    }
  }

  /// Kiểm tra xem password history có tồn tại không
  Future<bool> exists(int id) async {
    try {
      final history = await getById(id);
      return history != null;
    } catch (e) {
      logError('Error checking if password history exists: $e');
      return false;
    }
  }

  /// Kiểm tra xem password có tồn tại trong lịch sử của account không
  Future<bool> passwordExistsInAccount(int accountId, String password) async {
    try {
      final query = _database.select(_database.passwordHistoryDriftModel)..where((t) => t.accountId.equals(accountId) & t.password.equals(password));

      final history = await query.getSingleOrNull();
      return history != null;
    } catch (e) {
      logError('Error checking if password exists in account history: $e');
      return false;
    }
  }

  /// Đếm số lượng password histories
  Future<int> count() async {
    try {
      final rows = await _database.selectOnly(_database.passwordHistoryDriftModel).get();
      return rows.length;
    } catch (e) {
      logError('Error counting password histories: $e');
      return 0;
    }
  }

  /// Đếm số lượng password histories theo account
  Future<int> countByAccountId(int accountId) async {
    try {
      final query = _database.selectOnly(_database.passwordHistoryDriftModel)..where(_database.passwordHistoryDriftModel.accountId.equals(accountId));

      final rows = await query.get();
      return rows.length;
    } catch (e) {
      logError('Error counting password histories by account ID: $e');
      return 0;
    }
  }

  /// Lấy password history đầu tiên
  Future<PasswordHistoryDriftModelData?> getFirst() async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting first password history: $e');
      return null;
    }
  }

  /// Lấy password history cuối cùng
  Future<PasswordHistoryDriftModelData?> getLast() async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting last password history: $e');
      return null;
    }
  }

  /// Lấy password history cuối cùng của account
  Future<PasswordHistoryDriftModelData?> getLastByAccountId(int accountId) async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel)
            ..where((t) => t.accountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting last password history by account ID: $e');
      return null;
    }
  }

  /// Lấy password histories theo khoảng thời gian
  Future<List<PasswordHistoryDriftModelData>> getByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel)
            ..where((t) => t.createdAt.isBiggerOrEqualValue(startDate) & t.createdAt.isSmallerOrEqualValue(endDate))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

      return await query.get();
    } catch (e) {
      logError('Error getting password histories by date range: $e');
      return [];
    }
  }

  /// Lấy password histories theo khoảng thời gian của account
  Future<List<PasswordHistoryDriftModelData>> getByAccountIdAndDateRange(int accountId, DateTime startDate, DateTime endDate) async {
    try {
      final query =
          _database.select(_database.passwordHistoryDriftModel)
            ..where((t) => t.accountId.equals(accountId) & t.createdAt.isBiggerOrEqualValue(startDate) & t.createdAt.isSmallerOrEqualValue(endDate))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

      return await query.get();
    } catch (e) {
      logError('Error getting password histories by account ID and date range: $e');
      return [];
    }
  }

  /// Lấy thống kê password histories
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final totalCount = await count();
      final allHistories = await getAll();

      if (allHistories.isEmpty) {
        return {'totalCount': 0, 'uniqueAccounts': 0, 'oldestDate': null, 'newestDate': null, 'averagePerAccount': 0};
      }

      // Tính số account unique
      final uniqueAccounts = allHistories.map((h) => h.accountId).toSet().length;

      // Tìm ngày cũ nhất và mới nhất
      final dates = allHistories.map((h) => h.createdAt).toList();
      dates.sort();

      final oldestDate = dates.first;
      final newestDate = dates.last;

      return {
        'totalCount': totalCount,
        'uniqueAccounts': uniqueAccounts,
        'oldestDate': oldestDate.toIso8601String(),
        'newestDate': newestDate.toIso8601String(),
        'averagePerAccount': uniqueAccounts > 0 ? totalCount ~/ uniqueAccounts : 0,
      };
    } catch (e) {
      logError('Error getting password histories statistics: $e');
      return {'totalCount': 0, 'uniqueAccounts': 0, 'oldestDate': null, 'newestDate': null, 'averagePerAccount': 0};
    }
  }

  /// Lấy thống kê password histories theo account
  Future<Map<String, dynamic>> getStatisticsByAccountId(int accountId) async {
    try {
      final histories = await getByAccountId(accountId);
      final count = histories.length;

      if (histories.isEmpty) {
        return {'accountId': accountId, 'count': 0, 'oldestDate': null, 'newestDate': null};
      }

      // Tìm ngày cũ nhất và mới nhất
      final dates = histories.map((h) => h.createdAt).toList();
      dates.sort();

      final oldestDate = dates.first;
      final newestDate = dates.last;

      return {'accountId': accountId, 'count': count, 'oldestDate': oldestDate.toIso8601String(), 'newestDate': newestDate.toIso8601String()};
    } catch (e) {
      logError('Error getting password histories statistics by account ID: $e');
      return {'accountId': accountId, 'count': 0, 'oldestDate': null, 'newestDate': null};
    }
  }

  /// Dọn dẹp password histories cũ (tự động)
  Future<int> cleanupOldHistories({int maxDays = 365, int maxPerAccount = 50}) async {
    try {
      int totalDeleted = 0;

      // Xóa histories cũ hơn maxDays
      totalDeleted += await removeOlderThanDays(maxDays);

      // Giới hạn số lượng histories per account
      final allAccounts =
          _database.selectOnly(_database.passwordHistoryDriftModel)
            ..addColumns([_database.passwordHistoryDriftModel.accountId])
            ..groupBy([_database.passwordHistoryDriftModel.accountId]);

      final accountRows = await allAccounts.get();

      for (final row in accountRows) {
        final accountId = row.read(_database.passwordHistoryDriftModel.accountId);
        if (accountId != null) {
          final histories = await getByAccountId(accountId);

          if (histories.length > maxPerAccount) {
            // Xóa histories cũ nhất, giữ lại maxPerAccount mới nhất
            final toDelete = histories.skip(maxPerAccount).toList();
            for (final history in toDelete) {
              if (await removeById(history.id)) {
                totalDeleted++;
              }
            }
          }
        }
      }

      return totalDeleted;
    } catch (e) {
      logError('Error cleaning up old password histories: $e');
      return 0;
    }
  }
}
