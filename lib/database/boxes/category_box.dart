import 'package:cybersafe_pro/objectbox.g.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:flutter/foundation.dart';

import '../models/category_ojb_model.dart';
import '../objectbox.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';

class CategoryBox {
  static final box = ObjectBox.instance.store.box<CategoryOjbModel>();

  static List<CategoryOjbModel> getAll() {
    return box.getAll();
  }

  static Future<List<CategoryOjbModel>> getAllAsync() async {
    return await box.getAllAsync();
  }

  static CategoryOjbModel? getById(int id) {
    return box.get(id);
  }

  static Future<CategoryOjbModel?> getByIdAsync(int id) async {
    return await box.getAsync(id);
  }

  static CategoryOjbModel? findCategoryByName(String name) {
    return box.query(CategoryOjbModel_.categoryName.equals(name)).build().findFirst();
  }

  static int put(CategoryOjbModel category) {
    category.updatedAt = DateTime.now();
    category.indexPos = _getNextIndexPos();
    return box.put(category);
  }

  static int _getNextIndexPos() {
    final queryBuilder = box.query()..order(CategoryOjbModel_.indexPos, flags: Order.descending);
    final query = queryBuilder.build();
    final highestIndexPos = query.property(CategoryOjbModel_.indexPos).max();
    query.close();
    return (highestIndexPos) + 1;
  }

  static Future<List<int>> putMany(List<CategoryOjbModel> categories) async {
    for (var category in categories) {
      category.updatedAt = DateTime.now();
    }
    return await box.putManyAsync(categories);
  }

  static Future<bool> delete(int id) async {
    final category = box.get(id);
    if (category == null) return false;

    try {
      return await ObjectBox.instance.store.runInTransaction(TxMode.write, () {
        // Xóa tất cả account trong category
        for (var account in category.accounts) {
          AccountBox.delete(account.id);
        }
        return box.remove(id);
      });
    } catch (e) {
      logError('Error deleting category: $e');
      return false;
    }
  }

  static Future<void> deleteAll() async {
    try {
      await box.removeAllAsync();
    } catch (e) {
      logError('Error deleting all categories: $e');
    }
  }

  static Stream<List<CategoryOjbModel>> watchAll() {
    return box.query().watch(triggerImmediately: true).map((query) => query.find());
  }
}
