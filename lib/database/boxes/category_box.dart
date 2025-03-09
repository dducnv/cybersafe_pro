import 'package:cybersafe_pro/objectbox.g.dart';

import '../models/category_ojb_model.dart';
import '../objectbox.dart';

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

  static int put(CategoryOjbModel category) {
    category.updatedAt = DateTime.now();
    category.indexPos = _getNextIndexPos();
    return box.put(category);
  }

  static int _getNextIndexPos() {
    final queryBuilder = box.query()
      ..order(CategoryOjbModel_.indexPos, flags: Order.descending);
    final query = queryBuilder.build();
    final highestIndexPos = query.property(CategoryOjbModel_.indexPos).max();
    query.close();
    return (highestIndexPos) + 1;
  }

  static List<int> putMany(List<CategoryOjbModel> categories) {
    for (var category in categories) {
      category.updatedAt = DateTime.now();
    }
    return box.putMany(categories);
  }

  static bool delete(int id) {
    return box.remove(id);
  }

  static void deleteAll() {
    box.removeAll();
  }

  static Stream<List<CategoryOjbModel>> watchAll() {
    return box.query().watch(triggerImmediately: true).map((query) => query.find());
  }
} 