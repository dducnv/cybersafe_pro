import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class AccountAdapter {
  final DriftSqliteDatabase _database;

  AccountAdapter(this._database);

  // ==================== CRUD Operations ====================

  Future<int> insertAccount(AccountDriftModelCompanion data) async {
    final account = AccountDriftModelCompanion.insert(
      title: data.title.value,
      icon: data.icon.present ? Value(data.icon.value) : const Value.absent(),
      username: data.username.present ? Value(data.username.value) : const Value.absent(),
      password: data.password.present ? Value(data.password.value) : const Value.absent(),
      notes: data.notes.present ? Value(data.notes.value) : const Value.absent(),
      categoryId: data.categoryId.value,
      iconCustomId: data.iconCustomId.present ? Value(data.iconCustomId.value) : const Value.absent(),
    );
    final id = await _database.accountDriftModel.insertOne(account);
    return id;
  }

  Future<void> updateAccount(int id, AccountDriftModelCompanion newData) async {
    await (_database.update(_database.accountDriftModel)..where((tbl) => tbl.id.equals(id))).write(newData);
  }

  Future<void> deleteAccount(int id) async {
    await _database.transaction(() async {
      // Delete related TOTP
      await (_database.delete(_database.tOTPDriftModel)..where((tbl) => tbl.accountId.equals(id))).go();

      // Delete related Custom Fields
      await (_database.delete(_database.accountCustomFieldDriftModel)..where((tbl) => tbl.accountId.equals(id))).go();

      // Delete Password History (optional)
      await (_database.delete(_database.passwordHistoryDriftModel)..where((tbl) => tbl.accountId.equals(id))).go();

      // Delete Account itself
      await (_database.delete(_database.accountDriftModel)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  /// Lấy tất cả tài khoản
  Future<List<AccountDriftModelData>> getAll() async {
    try {
      final accounts = await _database.select(_database.accountDriftModel).get();
      return accounts;
    } catch (e) {
      logError('Error getting all accounts: $e');
      return [];
    }
  }

  Future<List<AccountDriftModelData>> getAllBasicInfo() async {
    try {
      final rows =
          await _database
              .customSelect(
                '''
                SELECT id, title, username, category_id, created_at, updated_at
                FROM account_drift_model
                WHERE deleted_at IS NULL
                ''',
                readsFrom: {_database.accountDriftModel},
              )
              .get();

      return rows.map((row) {
        return AccountDriftModelData(
          id: row.read<int>('id'),
          title: row.read<String>('title'),
          username: row.read<String?>('username'),
          categoryId: row.read<int>('category_id'),
          createdAt: row.read<DateTime>('created_at'),
          updatedAt: row.read<DateTime>('updated_at'),
        );
      }).toList();
    } catch (e) {
      logError('Error getting basic info: $e');
      return [];
    }
  }

  /// Lấy tất cả tài khoản có giới hạn số lượng
  Future<List<AccountDriftModelData>> getAllWithLimit(int limit, int offset) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(limit, offset: offset);

      return await query.get();
    } catch (e) {
      logError('Error getting accounts with limit: $e');
      return [];
    }
  }

  /// Lấy tài khoản theo ID
  Future<AccountDriftModelData?> getById(int id) async {
    try {
      final query = _database.select(_database.accountDriftModel)..where((t) => t.id.equals(id));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting account by ID: $e');
      return null;
    }
  }

  /// Lấy tài khoản theo category
  Future<List<AccountDriftModelData>> getByCategory(int categoryId) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..where((t) => t.categoryId.equals(categoryId))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

      return await query.get();
    } catch (e) {
      logError('Error getting accounts by category: $e');
      return [];
    }
  }

  Future<Map<int, List<AccountDriftModelData>>> getByCategoriesWithLimit(List<CategoryDriftModelData> categories, int limitPerCategory) async {
    // Tạo danh sách các Future để thực hiện song song
    final futures =
        categories.map((category) async {
          final accounts = await getBasicByCategoryWithLimit(categoryId: category.id, limit: limitPerCategory, offset: 0);
          return MapEntry(category.id, accounts);
        }).toList();

    // Thực hiện tất cả queries song song
    final results = await Future.wait(futures);

    // Chuyển đổi kết quả thành Map
    return Map.fromEntries(results);
  }

  /// Lấy tài khoản theo category có giới hạn số lượng
  Future<List<AccountDriftModelData>> getBasicByCategoryWithLimit({required int categoryId, int? limit, int? offset}) async {
    try {
      final buffer = StringBuffer();
      final variables = <Variable>[];

      buffer.write('''
      SELECT id, icon, title, username, icon_custom_id, category_id, created_at, updated_at, icon
      FROM account_drift_model
      WHERE category_id = ? AND deleted_at IS NULL
      ORDER BY updated_at DESC
    ''');
      variables.add(Variable.withInt(categoryId));

      if (limit != null) {
        buffer.write(' LIMIT ?');
        variables.add(Variable.withInt(limit));
      }

      if (offset != null) {
        buffer.write(' OFFSET ?');
        variables.add(Variable.withInt(offset));
      }

      final rows = await _database.customSelect(buffer.toString(), variables: variables, readsFrom: {_database.accountDriftModel}).get();

      return rows.map((row) {
        return AccountDriftModelData(
          id: row.read<int>('id'),
          title: row.read<String>('title'),
          username: row.read<String?>('username'),
          password: null,
          notes: null,
          icon: row.read<String?>('icon'),
          categoryId: row.read<int>('category_id'),
          iconCustomId: row.read<int?>('icon_custom_id'),
          passwordUpdatedAt: null,
          createdAt: row.read<DateTime>('created_at'),
          updatedAt: row.read<DateTime>('updated_at'),
          deletedAt: null,
        );
      }).toList();
    } catch (e) {
      logError('Error getting basic accounts by category with limit: $e');
      return [];
    }
  }

  /// Lấy tài khoản có TOTP
  Future<List<AccountDriftModelData>> getAllWithOTP() async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..where(
              (t) => t.id.isInQuery(
                _database.selectOnly(_database.tOTPDriftModel)
                  ..addColumns([_database.tOTPDriftModel.accountId])
                  ..where(_database.tOTPDriftModel.secretKey.isNotNull()),
              ),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

      return await query.get();
    } catch (e) {
      logError('Error getting accounts with TOTP: $e');
      return [];
    }
  }

  /// Tìm kiếm tài khoản theo title
  Future<List<AccountDriftModelData>> searchByTitle(String keyword) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..where((t) => t.title.contains(keyword))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]);

      return await query.get();
    } catch (e) {
      logError('Error searching accounts by title: $e');
      return [];
    }
  }

  /// Tìm kiếm tài khoản theo title có giới hạn số lượng
  Future<List<AccountDriftModelData>> searchByTitleWithLimit(String keyword, int limit) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..where((t) => t.title.contains(keyword))
            ..orderBy([(t) => OrderingTerm.asc(t.title)])
            ..limit(limit);

      return await query.get();
    } catch (e) {
      logError('Error searching accounts by title with limit: $e');
      return [];
    }
  }

  /// Tìm kiếm tài khoản theo username
  Future<List<AccountDriftModelData>> searchByUsername(String username) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..where((t) => t.username.contains(username))
            ..orderBy([(t) => OrderingTerm.asc(t.username)]);

      return await query.get();
    } catch (e) {
      logError('Error searching accounts by username: $e');
      return [];
    }
  }

  /// Tìm kiếm tài khoản tổng quát
  Future<List<AccountDriftModelData>> searchAccounts(String query) async {
    try {
      final queryBuilder =
          _database.select(_database.accountDriftModel)
            ..where((t) => t.title.contains(query) | t.username.contains(query))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

      return await queryBuilder.get();
    } catch (e) {
      logError('Error searching accounts: $e');
      return [];
    }
  }

  /// Lấy tài khoản được tạo gần đây
  Future<List<AccountDriftModelData>> getRecentAccounts({int limit = 10}) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit);

      return await query.get();
    } catch (e) {
      logError('Error getting recent accounts: $e');
      return [];
    }
  }

  /// Lấy tài khoản được cập nhật gần đây
  Future<List<AccountDriftModelData>> getRecentlyUpdated({int limit = 10}) async {
    try {
      final query =
          _database.select(_database.accountDriftModel)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(limit);

      return await query.get();
    } catch (e) {
      logError('Error getting recently updated accounts: $e');
      return [];
    }
  }

  /// Đếm số lượng tài khoản
  Future<int> count() async {
    try {
      return await _database.selectOnly(_database.accountDriftModel).get().then((rows) => rows.length);
    } catch (e) {
      logError('Error counting accounts: $e');
      return 0;
    }
  }

  /// Đếm số lượng tài khoản theo category
  Future<int> countByCategory(int categoryId) async {
    try {
      final query =
          _database.selectOnly(_database.accountDriftModel)
            ..addColumns([_database.accountDriftModel.id.count()])
            ..where(_database.accountDriftModel.categoryId.equals(categoryId));

      final row = await query.getSingleOrNull();
      return row?.read<int>(_database.accountDriftModel.id.count()) ?? 0;
    } catch (e) {
      logError('Error counting accounts by category: $e');
      return 0;
    }
  }

  /// Đếm số lượng tài khoản theo nhiều categories (song song)
  Future<Map<int, int>> countByCategories(List<int> categoryIds) async {
    try {
      // Tạo danh sách các Future để đếm song song
      final futures = categoryIds.map((categoryId) => countByCategory(categoryId)).toList();

      // Thực hiện tất cả queries song song
      final results = await Future.wait(futures);

      // Tạo map từ results
      final Map<int, int> resultMap = {};
      for (int i = 0; i < categoryIds.length; i++) {
        resultMap[categoryIds[i]] = results[i];
      }

      return resultMap;
    } catch (e) {
      logError('Error counting accounts by categories: $e');
      return {};
    }
  }

  /// Thêm hoặc cập nhật tài khoản
  Future<int> put(AccountDriftModelData account) async {
    try {
      final updatedAccount = account.copyWith(updatedAt: DateTime.now());

      if (account.id == 0) {
        // Insert new account
        return await _database.into(_database.accountDriftModel).insert(updatedAccount);
      } else {
        // Update existing account
        await _database.update(_database.accountDriftModel).replace(updatedAccount);
        return account.id;
      }
    } catch (e) {
      logError('Error putting account: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật nhiều tài khoản (song song)
  Future<List<int>> putMany(List<AccountDriftModelData> accounts) async {
    try {
      final updatedAccounts = accounts.map((account) => account.copyWith(updatedAt: DateTime.now())).toList();

      // Thực hiện insert song song
      final futures = updatedAccounts.map((account) => _database.into(_database.accountDriftModel).insert(account)).toList();

      return await Future.wait(futures);
    } catch (e) {
      logError('Error putting many accounts: $e');
      return [];
    }
  }

  /// Xóa tài khoản theo ID (bao gồm tất cả dữ liệu liên quan)
  Future<bool> delete(int id) async {
    try {
      await _database.transaction(() async {
        // Delete related TOTP first
        await (_database.delete(_database.tOTPDriftModel)..where((tbl) => tbl.accountId.equals(id))).go();

        // Delete related Custom Fields
        await (_database.delete(_database.accountCustomFieldDriftModel)..where((tbl) => tbl.accountId.equals(id))).go();

        // Delete Password History
        await (_database.delete(_database.passwordHistoryDriftModel)..where((tbl) => tbl.accountId.equals(id))).go();

        // Finally delete the account itself
        await (_database.delete(_database.accountDriftModel)..where((tbl) => tbl.id.equals(id))).go();
      });

      return true;
    } catch (e) {
      logError('Error deleting account with relations: $e');
      return false;
    }
  }

  /// Xóa nhiều tài khoản (bao gồm tất cả dữ liệu liên quan)
  Future<int> deleteMany(List<int> ids) async {
    try {
      await _database.transaction(() async {
        // Delete related TOTPs for all accounts
        await (_database.delete(_database.tOTPDriftModel)..where((tbl) => tbl.accountId.isIn(ids))).go();

        // Delete related Custom Fields for all accounts
        await (_database.delete(_database.accountCustomFieldDriftModel)..where((tbl) => tbl.accountId.isIn(ids))).go();

        // Delete Password History for all accounts
        await (_database.delete(_database.passwordHistoryDriftModel)..where((tbl) => tbl.accountId.isIn(ids))).go();

        // Finally delete all accounts
        await (_database.delete(_database.accountDriftModel)..where((tbl) => tbl.id.isIn(ids))).go();
      });

      return ids.length; // Return the number of accounts that were supposed to be deleted
    } catch (e) {
      logError('Error deleting many accounts with relations: $e');
      return 0;
    }
  }

  /// Xóa tất cả tài khoản (bao gồm tất cả dữ liệu liên quan)
  Future<void> deleteAll() async {
    try {
      await _database.transaction(() async {
        // Delete all TOTPs first
        await _database.delete(_database.tOTPDriftModel).go();

        // Delete all Custom Fields
        await _database.delete(_database.accountCustomFieldDriftModel).go();

        // Delete all Password History
        await _database.delete(_database.passwordHistoryDriftModel).go();

        // Finally delete all accounts
        await _database.delete(_database.accountDriftModel).go();
      });
    } catch (e) {
      logError('Error deleting all accounts with relations: $e');
    }
  }

  // ==================== Stream Operations ====================

  /// Theo dõi thay đổi tất cả tài khoản
  Stream<List<AccountDriftModelData>> watchAll() {
    final query = _database.select(_database.accountDriftModel)..orderBy([(t) => OrderingTerm.asc(t.title)]);
    return query.watch();
  }

  /// Theo dõi thay đổi tất cả tài khoản có giới hạn số lượng
  Stream<List<AccountDriftModelData>> watchAllWithLimit(int limit) {
    final query =
        _database.select(_database.accountDriftModel)
          ..orderBy([(t) => OrderingTerm.asc(t.title)])
          ..limit(limit);
    return query.watch();
  }

  /// Theo dõi thay đổi tài khoản theo category
  Stream<List<AccountDriftModelData>> watchByCategory(int categoryId) {
    final query =
        _database.select(_database.accountDriftModel)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.title)]);
    return query.watch();
  }

  /// Theo dõi thay đổi tài khoản theo category có giới hạn số lượng
  Stream<List<AccountDriftModelData>> watchByCategoryWithLimit(int categoryId, int limit) {
    final query =
        _database.select(_database.accountDriftModel)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.title)])
          ..limit(limit);
    return query.watch();
  }

  /// Theo dõi số lượng tài khoản
  Stream<int> watchCount() {
    return _database.selectOnly(_database.accountDriftModel).watch().map((rows) => rows.length);
  }

  // ==================== Parallel Operations ====================

  /// Lấy tài khoản với thông tin category theo categories (song song)
  Future<Map<int, List<Map<String, dynamic>>>> getWithCategoryInfoByCategories(List<int> categoryIds) async {
    try {
      // Tạo danh sách các Future để lấy song song
      final futures =
          categoryIds.map((categoryId) async {
            final accounts = await getByCategory(categoryId);
            final accountsWithCategory = await Future.wait(
              accounts.map((account) async {
                final category = await DriffDbManager.instance.categoryAdapter.getById(categoryId);
                return {'account': account, 'category': category};
              }),
            );
            return MapEntry(categoryId, accountsWithCategory);
          }).toList();

      // Thực hiện tất cả queries song song
      final results = await Future.wait(futures);

      return Map.fromEntries(results);
    } catch (e) {
      logError('Error getting accounts with category info by categories: $e');
      return {};
    }
  }

  /// Xóa nhiều tài khoản (song song với transaction)
  Future<int> deleteManyParallel(List<int> ids) async {
    try {
      // Use the same transaction-based deleteMany method for consistency
      return await deleteMany(ids);
    } catch (e) {
      logError('Error deleting many accounts in parallel: $e');
      return 0;
    }
  }

  /// Lấy thống kê tài khoản theo categories (song song)
  Future<Map<int, Map<String, dynamic>>> getStatisticsByCategories(List<int> categoryIds) async {
    try {
      // Tạo danh sách các Future để lấy thống kê song song
      final futures =
          categoryIds.map((categoryId) async {
            final accounts = await getByCategory(categoryId);
            final count = accounts.length;
            final recentAccounts = accounts.take(5).toList(); // Lấy 5 accounts gần nhất

            return MapEntry(categoryId, {'count': count, 'recentAccounts': recentAccounts, 'lastUpdated': accounts.isNotEmpty ? accounts.first.updatedAt : null});
          }).toList();

      // Thực hiện tất cả queries song song
      final results = await Future.wait(futures);

      return Map.fromEntries(results);
    } catch (e) {
      logError('Error getting statistics by categories: $e');
      return {};
    }
  }

  /// Tìm kiếm tài khoản theo nhiều keywords (song song)
  Future<Map<String, List<AccountDriftModelData>>> searchByMultipleKeywords(List<String> keywords) async {
    try {
      // Tạo danh sách các Future để tìm kiếm song song
      final futures =
          keywords.map((keyword) async {
            final accounts = await searchAccounts(keyword);
            return MapEntry(keyword, accounts);
          }).toList();

      // Thực hiện tất cả queries song song
      final results = await Future.wait(futures);

      return Map.fromEntries(results);
    } catch (e) {
      logError('Error searching accounts by multiple keywords: $e');
      return {};
    }
  }
}
