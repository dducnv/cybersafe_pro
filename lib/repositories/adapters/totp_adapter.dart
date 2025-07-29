import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class TOTPAdapter {
  final DriftSqliteDatabase _database;

  TOTPAdapter(this._database);

  // ==================== CRUD Operations ====================

  Future<void> insertOrUpdateTOTP(int accountId, String secretKey, bool isShowToHome) async {
    final existing = await (_database.select(_database.tOTPDriftModel)..where((t) => t.accountId.equals(accountId))).getSingleOrNull();

    if (existing == null) {
      await _database.into(_database.tOTPDriftModel).insert(TOTPDriftModelCompanion(accountId: Value(accountId), secretKey: Value(secretKey), isShowToHome: Value(isShowToHome)));
    } else {
      await (_database.update(_database.tOTPDriftModel)
        ..where((t) => t.accountId.equals(accountId))).write(TOTPDriftModelCompanion(secretKey: Value(secretKey), isShowToHome: Value(isShowToHome), updatedAt: Value(DateTime.now())));
    }
  }

  Future<void> deleteTOTP(int accountId) async {
    await (_database.delete(_database.tOTPDriftModel)..where((t) => t.accountId.equals(accountId))).go();
  }

  /// Lấy tất cả TOTP
  Future<List<TOTPDriftModelData>> getAll() async {
    try {
      final totps = await _database.select(_database.tOTPDriftModel).get();
      return totps;
    } catch (e) {
      logError('Error getting all TOTPs: $e');
      return [];
    }
  }

  Future<List<MapEntry<AccountDriftModelData, TOTPDriftModelData>>> getAllWithOTP() async {
    try {
      final query = _database.select(_database.accountDriftModel).join([innerJoin(_database.tOTPDriftModel, _database.tOTPDriftModel.accountId.equalsExp(_database.accountDriftModel.id))]);

      final rows = await query.get();

      return rows.map((row) {
        final account = row.readTable(_database.accountDriftModel);
        final totp = row.readTable(_database.tOTPDriftModel);
        return MapEntry(account, totp);
      }).toList();
    } catch (e) {
      logError('Error getting all accounts with TOTP: $e');
      return [];
    }
  }

  /// Lấy TOTP theo ID
  Future<TOTPDriftModelData?> getById(int id) async {
    try {
      final query = _database.select(_database.tOTPDriftModel)..where((t) => t.id.equals(id));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting TOTP by ID: $e');
      return null;
    }
  }

  /// Lấy TOTP theo account ID
  Future<TOTPDriftModelData?> getByAccountId(int accountId) async {
    try {
      final query = _database.select(_database.tOTPDriftModel)..where((t) => t.accountId.equals(accountId));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting TOTP by account ID: $e');
      return null;
    }
  }

  /// Lấy TOTP hiển thị trên home
  Future<List<TOTPDriftModelData>> getShowToHome() async {
    try {
      final query =
          _database.select(_database.tOTPDriftModel)
            ..where((t) => t.isShowToHome.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);

      return await query.get();
    } catch (e) {
      logError('Error getting TOTPs show to home: $e');
      return [];
    }
  }

  /// Đếm số lượng TOTP
  Future<int> count() async {
    try {
      final rows = await _database.selectOnly(_database.tOTPDriftModel).get();
      return rows.length;
    } catch (e) {
      logError('Error counting TOTPs: $e');
      return 0;
    }
  }

  /// Đếm số lượng TOTP hiển thị trên home
  Future<int> countShowToHome() async {
    try {
      final query = _database.selectOnly(_database.tOTPDriftModel)..where(_database.tOTPDriftModel.isShowToHome.equals(true));

      final rows = await query.get();
      return rows.length;
    } catch (e) {
      logError('Error counting TOTPs show to home: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật TOTP
  Future<int> put(TOTPDriftModelData totp) async {
    try {
      final updatedTotp = totp.copyWith(updatedAt: DateTime.now());

      if (totp.id == 0) {
        // Insert new TOTP
        return await _database.into(_database.tOTPDriftModel).insert(updatedTotp);
      } else {
        // Update existing TOTP
        await _database.update(_database.tOTPDriftModel).replace(updatedTotp);
        return totp.id;
      }
    } catch (e) {
      logError('Error putting TOTP: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật nhiều TOTP
  Future<List<int>> putMany(List<TOTPDriftModelData> totps) async {
    try {
      final updatedTotps = totps.map((totp) => totp.copyWith(updatedAt: DateTime.now())).toList();

      final ids = <int>[];
      for (final totp in updatedTotps) {
        final id = await put(totp);
        ids.add(id);
      }
      return ids;
    } catch (e) {
      logError('Error putting many TOTPs: $e');
      return [];
    }
  }

  /// Xóa TOTP theo ID
  Future<bool> delete(int id) async {
    try {
      return await _database.delete(_database.tOTPDriftModel).delete(TOTPDriftModelCompanion(id: Value(id))) > 0;
    } catch (e) {
      logError('Error deleting TOTP: $e');
      return false;
    }
  }

  /// Xóa TOTP theo account ID
  Future<bool> deleteByAccountId(int accountId) async {
    try {
      final totp = await getByAccountId(accountId);
      if (totp != null) {
        return await delete(totp.id);
      }
      return false;
    } catch (e) {
      logError('Error deleting TOTP by account ID: $e');
      return false;
    }
  }

  /// Xóa tất cả TOTP
  Future<void> deleteAll() async {
    try {
      await _database.delete(_database.tOTPDriftModel).go();
    } catch (e) {
      logError('Error deleting all TOTPs: $e');
    }
  }

  /// Kiểm tra xem TOTP có tồn tại không
  Future<bool> exists(int id) async {
    try {
      final totp = await getById(id);
      return totp != null;
    } catch (e) {
      logError('Error checking if TOTP exists: $e');
      return false;
    }
  }

  /// Kiểm tra xem account có TOTP không
  Future<bool> existsByAccountId(int accountId) async {
    try {
      final totp = await getByAccountId(accountId);
      return totp != null;
    } catch (e) {
      logError('Error checking if TOTP exists by account ID: $e');
      return false;
    }
  }

  /// Lấy TOTP đầu tiên
  Future<TOTPDriftModelData?> getFirst() async {
    try {
      final query =
          _database.select(_database.tOTPDriftModel)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting first TOTP: $e');
      return null;
    }
  }

  /// Lấy TOTP cuối cùng
  Future<TOTPDriftModelData?> getLast() async {
    try {
      final query =
          _database.select(_database.tOTPDriftModel)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting last TOTP: $e');
      return null;
    }
  }
}
