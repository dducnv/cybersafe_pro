import '../models/totp_ojb_model.dart';
import '../objectbox.dart';

class TOTPBox {
  static final box = ObjectBox.instance.store.box<TOTPOjbModel>();

  static List<TOTPOjbModel> getAll() {
    return box.getAll();
  }

  static TOTPOjbModel? getById(int id) {
    return box.get(id);
  }

  static int put(TOTPOjbModel totp) {
    totp.updatedAt = DateTime.now();
    return box.put(totp);
  }

  static List<int> putMany(List<TOTPOjbModel> totps) {
    for (var totp in totps) {
      totp.updatedAt = DateTime.now();
    }
    return box.putMany(totps);
  }

  static bool delete(int id) {
    return box.remove(id);
  }

  static void deleteAll() {
    box.removeAll();
  }

  static Stream<List<TOTPOjbModel>> watchAll() {
    return box.query().watch(triggerImmediately: true).map((query) => query.find());
  }

  static Future<void> deleteAllAsync() async {
    await box.removeAllAsync();
  }
}
