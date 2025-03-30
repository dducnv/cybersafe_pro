import 'package:cybersafe_pro/database/models/account_custom_field.dart';
import 'package:cybersafe_pro/database/objectbox.dart';
import 'package:cybersafe_pro/objectbox.g.dart';
import 'package:cybersafe_pro/utils/logger.dart';

class AccountCustomFieldBox {
  static final box = ObjectBox.instance.store.box<AccountCustomFieldOjbModel>();

  static Future<bool> removeById(int id) async {
    try {
      return await ObjectBox.instance.store.runInTransaction(TxMode.write, () {
        return box.remove(id);
      });
    } catch (e) {
      logError('Error removing custom field: $e');
      return false;
    }
  }

  static Future<void> removeByAccountId(int accountId) async {
    try {
      final fields = box.query(AccountCustomFieldOjbModel_.account.equals(accountId)).build().find();
      ObjectBox.instance.store.runInTransaction(TxMode.write,() {
        for (var field in fields) {
          box.remove(field.id);
        }
      });
    } catch (e) {
      logError('Error removing custom fields by account: $e');
    }
  }

  static Future<void> deleteAll() async {
    try {
      ObjectBox.instance.store.runInTransaction(TxMode.write, () {
        box.removeAll();
      });
    } catch (e) {
      logError('Error deleting all custom fields: $e');
    }
  }
}
