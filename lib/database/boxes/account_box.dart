import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import '../../objectbox.g.dart';
import '../objectbox.dart';

class AccountBox {
  static final box = ObjectBox.instance.store.box<AccountOjbModel>();

  // Lấy tất cả tài khoản
  static Future<List<AccountOjbModel>> getAll() async => await box.getAllAsync();

  // Lấy tất cả tài khoản có giới hạn số lượng
  static List<AccountOjbModel> getAllWithLimit(int limit, int offset) {
    final query = ((box.query()..order(AccountOjbModel_.updatedAt, flags: Order.descending)).build());
    query.limit = limit;
    query.offset = offset;
    return query.find();
  }

  // Lấy tài khoản theo category
  static List<AccountOjbModel> getByCategory(CategoryOjbModel category) {
    return box.query(AccountOjbModel_.category.equals(category.id)).order(AccountOjbModel_.updatedAt).build().find();
  }

  static List<AccountOjbModel> getAllWithOTP() {
    final query =
        box.query(AccountOjbModel_.totp.notNull())
          ..link(AccountOjbModel_.totp, TOTPOjbModel_.secretKey.notEquals(''))
          ..order(AccountOjbModel_.updatedAt, flags: Order.descending);

    return query.build().find();
  }

  // Lấy tài khoản theo category có giới hạn số lượng
  static List<AccountOjbModel> getByCategoryWithLimit(CategoryOjbModel category, int limit, int offset) {
    final query = ((box.query(AccountOjbModel_.category.equals(category.id))..order(AccountOjbModel_.updatedAt, flags: Order.descending)).build());
    query.limit = limit;
    query.offset = offset;
    return query.find();
  }

  // Lấy tài khoản theo danh sách category có giới hạn số lượng cho mỗi category
  static Map<int, List<AccountOjbModel>> getByCategoriesWithLimit(List<CategoryOjbModel> categories, int limitPerCategory) {
    final result = <int, List<AccountOjbModel>>{};

    for (var category in categories) {
      final accounts = getByCategoryWithLimit(category, limitPerCategory, 0);
      result[category.id] = accounts;
    }

    return result;
  }

  // Lấy tài khoản theo ID
  static Future<AccountOjbModel?> getById(int id) async => await box.getAsync(id);

  // Tìm kiếm tài khoản theo title
  static List<AccountOjbModel> searchByTitle(String keyword) {
    return box.query(AccountOjbModel_.title.contains(keyword, caseSensitive: false)).order(AccountOjbModel_.title).build().find();
  }

  // Tìm kiếm tài khoản theo title có giới hạn số lượng
  static List<AccountOjbModel> searchByTitleWithLimit(String keyword, int limit) {
    final query = ((box.query(AccountOjbModel_.title.contains(keyword, caseSensitive: false))..order(AccountOjbModel_.title)).build());
    query.limit = limit;
    return query.find();
  }

  // Tìm kiếm tài khoản theo email
  static List<AccountOjbModel> searchByEmail(String email) {
    return box.query(AccountOjbModel_.email.contains(email, caseSensitive: false)).order(AccountOjbModel_.email).build().find();
  }

  // Tìm kiếm tài khoản theo email có giới hạn số lượng
  static List<AccountOjbModel> searchByEmailWithLimit(String email, int limit) {
    final query = ((box.query(AccountOjbModel_.email.contains(email, caseSensitive: false))..order(AccountOjbModel_.email)).build());
    query.limit = limit;
    return query.find();
  }

  static List<AccountOjbModel> searchAccounts(String query) {
    // Tạo query builder
    final builder = box.query(AccountOjbModel_.title.equals(query, caseSensitive: false).or(AccountOjbModel_.email.equals(query, caseSensitive: false)))
      ..order(AccountOjbModel_.updatedAt, flags: Order.descending);

    return builder.build().find();
  }

  // Lấy tài khoản được tạo gần đây
  static List<AccountOjbModel> getRecentAccounts({int limit = 10}) {
    final query = ((box.query()..order(AccountOjbModel_.createdAt, flags: Order.descending)).build());
    query.limit = limit;
    return query.find();
  }

  // Lấy tài khoản được cập nhật gần đây
  static List<AccountOjbModel> getRecentlyUpdated({int limit = 10}) {
    final query = ((box.query()..order(AccountOjbModel_.updatedAt, flags: Order.descending)).build());
    query.limit = limit;
    return query.find();
  }

  // Lấy số lượng tài khoản
  static int count() => box.count();

  // Lấy số lượng tài khoản theo category
  static int countByCategory(CategoryOjbModel category) {
    return box.query(AccountOjbModel_.category.equals(category.id)).build().count();
  }

  // Thêm hoặc cập nhật tài khoản
  static Future<int> put(AccountOjbModel account) {
    account.updatedAt = DateTime.now();
    return box.putAsync(account);
  }

  // Thêm hoặc cập nhật nhiều tài khoản
  static Future<List<int>> putMany(List<AccountOjbModel> accounts) {
    for (var account in accounts) {
      account.updatedAt = DateTime.now();
    }
    return box.putManyAsync(accounts);
  }

  // Xóa tài khoản theo ID
  static bool delete(int id) => box.remove(id);

  // Xóa tất cả tài khoản
  static void deleteAll() => box.removeAll();

  // Theo dõi thay đổi tất cả tài khoản
  static Stream<List<AccountOjbModel>> watchAll() {
    return box.query().order(AccountOjbModel_.title).watch(triggerImmediately: true).map((query) => query.find());
  }

  // Theo dõi thay đổi tất cả tài khoản có giới hạn số lượng
  static Stream<List<AccountOjbModel>> watchAllWithLimit(int limit) {
    return box.query().order(AccountOjbModel_.title).watch(triggerImmediately: true).map((query) {
      query.limit = limit;
      return query.find();
    });
  }

  // Theo dõi thay đổi tài khoản theo category
  static Stream<List<AccountOjbModel>> watchByCategory(CategoryOjbModel category) {
    return box.query(AccountOjbModel_.category.equals(category.id)).order(AccountOjbModel_.title).watch(triggerImmediately: true).map((query) => query.find());
  }

  // Theo dõi thay đổi tài khoản theo category có giới hạn số lượng
  static Stream<List<AccountOjbModel>> watchByCategoryWithLimit(CategoryOjbModel category, int limit) {
    return box.query(AccountOjbModel_.category.equals(category.id)).order(AccountOjbModel_.title).watch(triggerImmediately: true).map((query) {
      query.limit = limit;
      return query.find();
    });
  }

  // Theo dõi số lượng tài khoản
  static Stream<int> watchCount() {
    return box.query().watch(triggerImmediately: true).map((query) => query.count());
  }
}
