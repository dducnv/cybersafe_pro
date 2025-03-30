import 'package:cybersafe_pro/objectbox.g.dart';

import '../models/icon_custom_model.dart';
import '../objectbox.dart';

class IconCustomBox {
  static final box = ObjectBox.instance.store.box<IconCustomModel>();

  static List<IconCustomModel> getAll() {
    return box.getAll();
  }

  static IconCustomModel? getById(int id) {
    return box.get(id);
  }

  static int put(IconCustomModel icon) {
    return box.put(icon);
  }

  static List<int> putMany(List<IconCustomModel> icons) {
    return box.putMany(icons);
  }

  static bool delete(int id) {
    return box.remove(id);
  }

  static IconCustomModel? findIconByName(String name) {
    return box.query(IconCustomModel_.name.equals(name)).build().findFirst();
  }

  static IconCustomModel? findIconByBase64Image(String base64Image) {
    return box.query(IconCustomModel_.imageBase64.equals(base64Image)).build().findFirst();
  }

  static void deleteAll() {
    box.removeAll();
  }

  static Stream<List<IconCustomModel>> watchAll() {
    return box.query().watch(triggerImmediately: true).map((query) => query.find());
  }

  static Future<void> deleteAllAsync() async {
    await box.removeAllAsync();
  }
}
