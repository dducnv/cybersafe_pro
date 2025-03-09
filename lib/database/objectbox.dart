import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';
import 'models/account_ojb_model.dart';
import 'models/category_ojb_model.dart';
import 'models/icon_custom_model.dart';
import 'models/totp_ojb_model.dart';
import 'models/account_custom_field.dart';
import 'models/password_history_model.dart';

class ObjectBox {
  late final Store store;
  Admin? admin;
  
  // Boxes
  late final Box<AccountOjbModel> accountBox;
  late final Box<CategoryOjbModel> categoryBox;
  late final Box<IconCustomModel> iconCustomBox;
  late final Box<TOTPOjbModel> totpBox;
  late final Box<AccountCustomFieldOjbModel> customFieldBox;
  late final Box<PasswordHistory> passwordHistoryBox;
  
  static late final ObjectBox instance;

  ObjectBox._create(this.store) {
    accountBox = Box<AccountOjbModel>(store);
    categoryBox = Box<CategoryOjbModel>(store);
    iconCustomBox = Box<IconCustomModel>(store);
    totpBox = Box<TOTPOjbModel>(store);
    customFieldBox = Box<AccountCustomFieldOjbModel>(store);
    passwordHistoryBox = Box<PasswordHistory>(store);
    // Chỉ khởi tạo Admin trong chế độ debug
    if (Admin.isAvailable()) {
      print("Khởi tạo Admin");
      admin = Admin(store);
    }
  }

  static Future<void> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(docsDir.path, "cyber_safe");
    final store = await openStore(directory: dbPath, macosApplicationGroup: "group.duc_app_lab_ind.cyber_safe");
    instance = ObjectBox._create(store);
    print("Đường dẫn db: $dbPath");
  }

  void dispose() {
    admin?.close();
    store.close();
  }
} 