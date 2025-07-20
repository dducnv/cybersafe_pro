import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';

class OldDataDecrypt {
  
  Future<List<Map<String, dynamic>>> decryptOldData() async {
    final accounts = await AccountBox.getAll();
    final accountsJson = await _accountsToDecryptedJsonBatch(accounts);
    return accountsJson;
  }

  Future<List<Map<String, dynamic>>> _accountsToDecryptedJsonBatch(List<AccountOjbModel> accounts) async {
    return await Future.wait(accounts.map((acc) => acc.toDecryptedJson()));
  }
}
