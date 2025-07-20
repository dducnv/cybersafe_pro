// import 'package:cybersafe_pro/database/models/password_history_model.dart';
// import 'package:cybersafe_pro/database/objectbox.dart';
// import 'package:cybersafe_pro/objectbox.g.dart';
// import 'package:cybersafe_pro/utils/logger.dart';

// class PasswordHistoryBox {
//   static final box = ObjectBox.instance.store.box<PasswordHistory>();

//   static Future<bool> removeById(int id) async {
//     try {
//       return await ObjectBox.instance.store.runInTransaction(TxMode.write, () {
//         return box.remove(id);
//       });
//     } catch (e) {
//       logError('Error removing password history: $e');
//       return false;
//     }
//   }

//   static Future<void> removeByAccountId(int accountId) async {
//     try {
//       final histories = box.query(PasswordHistory_.account.equals(accountId)).build().find();
//       ObjectBox.instance.store.runInTransaction(TxMode.write,() {
//         for (var history in histories) {
//           box.remove(history.id);
//         }
//       });
//     } catch (e) {
//       logError('Error removing password histories by account: $e');
//     }
//   }

//   static Future<void> removeAll() async {
//     try {
//       ObjectBox.instance.store.runInTransaction(TxMode.write, () {
//         box.removeAll();
//       });
//     } catch (e) {
//       logError('Error removing all password histories: $e');
//     }
//   }

//   static Future<void> deleteAllAsync() async {
//     await box.removeAllAsync();
//   }
// }
