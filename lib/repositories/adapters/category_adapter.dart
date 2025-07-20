import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class CategoryAdapter {
  final DriftSqliteDatabase _database;

  CategoryAdapter(this._database);

  // ==================== CRUD Operations ====================

  Future<int> insertCategory(String name) async {
    final indexPos = await _getNextIndexPos();
    return _database.into(_database.categoryDriftModel).insert(CategoryDriftModelCompanion(categoryName: Value(name), indexPos: Value(indexPos)));
  }

  Future<int> updateCategory(int id, String newName) async {
    return await (_database.update(_database.categoryDriftModel)..where((tbl) => tbl.id.equals(id))).write(CategoryDriftModelCompanion(categoryName: Value(newName)));
  }

  /// Lấy tất cả categories
  Future<List<CategoryDriftModelData>> getAll() async {
    try {
      final categories = await _database.select(_database.categoryDriftModel).get();
      return categories;
    } catch (e) {
      logError('Error getting all categories: $e');
      return [];
    }
  }

  /// Lấy category theo ID
  Future<CategoryDriftModelData?> getById(int id) async {
    try {
      final query = _database.select(_database.categoryDriftModel)..where((t) => t.id.equals(id));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting category by ID: $e');
      return null;
    }
  }

  /// Tìm category theo tên
  Future<CategoryDriftModelData?> findByName(String name) async {
    try {
      final query = _database.select(_database.categoryDriftModel)..where((t) => t.categoryName.equals(name));

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error finding category by name: $e');
      return null;
    }
  }

  /// Tìm kiếm categories theo tên
  Future<List<CategoryDriftModelData>> searchByName(String keyword) async {
    try {
      final query =
          _database.select(_database.categoryDriftModel)
            ..where((t) => t.categoryName.contains(keyword))
            ..orderBy([(t) => OrderingTerm.asc(t.categoryName)]);

      return await query.get();
    } catch (e) {
      logError('Error searching categories by name: $e');
      return [];
    }
  }

  /// Lấy categories theo thứ tự indexPos
  Future<List<CategoryDriftModelData>> getAllOrderedByIndex() async {
    try {
      final query = _database.select(_database.categoryDriftModel)..orderBy([(t) => OrderingTerm.asc(t.indexPos)]);

      return await query.get();
    } catch (e) {
      logError('Error getting categories ordered by index: $e');
      return [];
    }
  }

  /// Đếm số lượng categories
  Future<int> count() async {
    try {
      final rows = await _database.selectOnly(_database.categoryDriftModel).get();
      return rows.length;
    } catch (e) {
      logError('Error counting categories: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật category
  Future<int> put(CategoryDriftModelData category) async {
    try {
      final updatedCategory = category.copyWith(updatedAt: DateTime.now(), indexPos: category.indexPos == 0 ? await _getNextIndexPos() : category.indexPos);

      if (category.id == 0) {
        // Insert new category
        return await _database.into(_database.categoryDriftModel).insert(updatedCategory);
      } else {
        // Update existing category
        await _database.update(_database.categoryDriftModel).replace(updatedCategory);
        return category.id;
      }
    } catch (e) {
      logError('Error putting category: $e');
      return 0;
    }
  }

  /// Thêm hoặc cập nhật nhiều categories
  Future<List<int>> putMany(List<CategoryDriftModelData> categories) async {
    try {
      final updatedCategories = categories.map((category) => category.copyWith(updatedAt: DateTime.now())).toList();

      final ids = <int>[];
      for (final category in updatedCategories) {
        final id = await put(category);
        ids.add(id);
      }
      return ids;
    } catch (e) {
      logError('Error putting many categories: $e');
      return [];
    }
  }

  /// Xóa category theo ID
  Future<bool> delete(int id) async {
    try {
      final category = await getById(id);
      if (category == null) return false;

      // Xóa tất cả accounts trong category trước
      await _deleteAccountsInCategory(id);

      // Xóa category
      return await _database.delete(_database.categoryDriftModel).delete(CategoryDriftModelCompanion(id: Value(id))) > 0;
    } catch (e) {
      logError('Error deleting category: $e');
      return false;
    }
  }

  /// Xóa tất cả categories
  Future<void> deleteAll() async {
    try {
      await _database.delete(_database.categoryDriftModel).go();
    } catch (e) {
      logError('Error deleting all categories: $e');
    }
  }

  // ==================== Stream Operations ====================

  /// Theo dõi thay đổi tất cả categories
  Stream<List<CategoryDriftModelData>> watchAll() {
    final query = _database.select(_database.categoryDriftModel)..orderBy([(t) => OrderingTerm.asc(t.indexPos)]);
    return query.watch();
  }

  /// Theo dõi thay đổi categories theo thứ tự indexPos
  Stream<List<CategoryDriftModelData>> watchAllOrderedByIndex() {
    final query = _database.select(_database.categoryDriftModel)..orderBy([(t) => OrderingTerm.asc(t.indexPos)]);
    return query.watch();
  }

  /// Theo dõi số lượng categories
  Stream<int> watchCount() {
    return _database.selectOnly(_database.categoryDriftModel).watch().map((rows) => rows.length);
  }

  // ==================== Index Position Management ====================

  /// Lấy indexPos tiếp theo
  Future<int> _getNextIndexPos() async {
    try {
      final query =
          _database.selectOnly(_database.categoryDriftModel)
            ..addColumns([_database.categoryDriftModel.indexPos])
            ..orderBy([OrderingTerm.desc(_database.categoryDriftModel.indexPos)])
            ..limit(1);

      final rows = await query.get();
      if (rows.isEmpty) return 0;

      final maxIndexPos = rows.first.read(_database.categoryDriftModel.indexPos);
      return (maxIndexPos ?? 0) + 1;
    } catch (e) {
      logError('Error getting next index position: $e');
      return 0;
    }
  }

  /// Cập nhật thứ tự categories
  Future<bool> updateIndexPositions(List<int> categoryIds) async {
    try {
      for (int i = 0; i < categoryIds.length; i++) {
        final category = await getById(categoryIds[i]);
        if (category != null) {
          final updatedCategory = category.copyWith(indexPos: i);
          await _database.update(_database.categoryDriftModel).replace(updatedCategory);
        }
      }
      return true;
    } catch (e) {
      logError('Error updating index positions: $e');
      return false;
    }
  }

  // ==================== Utility Methods ====================

  /// Lấy categories với thông tin accounts
  Future<List<Map<String, dynamic>>> getWithAccountInfo() async {
    try {
      final query = _database.select(_database.categoryDriftModel).join([leftOuterJoin(_database.accountDriftModel, _database.categoryDriftModel.id.equalsExp(_database.accountDriftModel.categoryId))])
        ..orderBy([OrderingTerm.asc(_database.categoryDriftModel.indexPos)]);

      final results = await query.get();
      return results.map((row) {
        final category = row.readTable(_database.categoryDriftModel);
        final account = row.readTableOrNull(_database.accountDriftModel);

        return {'category': category, 'account': account};
      }).toList();
    } catch (e) {
      logError('Error getting categories with account info: $e');
      return [];
    }
  }

  /// Kiểm tra xem category có tồn tại không
  Future<bool> exists(int id) async {
    try {
      final category = await getById(id);
      return category != null;
    } catch (e) {
      logError('Error checking if category exists: $e');
      return false;
    }
  }

  /// Kiểm tra xem tên category có tồn tại không
  Future<bool> nameExists(String name) async {
    try {
      final category = await findByName(name);
      return category != null;
    } catch (e) {
      logError('Error checking if category name exists: $e');
      return false;
    }
  }

  /// Lấy category đầu tiên
  Future<CategoryDriftModelData?> getFirst() async {
    try {
      final query =
          _database.select(_database.categoryDriftModel)
            ..orderBy([(t) => OrderingTerm.asc(t.indexPos)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting first category: $e');
      return null;
    }
  }

  /// Lấy category cuối cùng
  Future<CategoryDriftModelData?> getLast() async {
    try {
      final query =
          _database.select(_database.categoryDriftModel)
            ..orderBy([(t) => OrderingTerm.desc(t.indexPos)])
            ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting last category: $e');
      return null;
    }
  }

  // ==================== Private Helper Methods ====================

  /// Xóa tất cả accounts trong category
  Future<void> _deleteAccountsInCategory(int categoryId) async {
    try {
      final query = _database.select(_database.accountDriftModel)..where((t) => t.categoryId.equals(categoryId));

      final accounts = await query.get();
      for (final account in accounts) {
        await _database.delete(_database.accountDriftModel).delete(AccountDriftModelCompanion(id: Value(account.id)));
      }
    } catch (e) {
      logError('Error deleting accounts in category: $e');
    }
  }
}
