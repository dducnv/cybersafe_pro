import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:flutter/foundation.dart';

class DetailsAccountProvider extends ChangeNotifier {
  AccountDriftModelData? accountDriftModelData;
  TOTPDriftModelData? totpDriftModelData;
  CategoryDriftModelData? categoryDriftModelData;
  List<AccountCustomFieldDriftModelData>? accountCustomFieldDriftModelData;
  List<PasswordHistoryDriftModelData>? passwordHistoryDriftModelData;

  bool isLoading = false;

  Future<void> loadAccountDetails(int accountId) async {
    isLoading = true;
    notifyListeners();

    try {
      // Lấy account trước vì cần categoryId từ đây
      final account = await DriffDbManager.instance.accountAdapter.getById(accountId);
      if (account == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      accountDriftModelData = account;

      // Load các dữ liệu khác song song
      final results = await Future.wait([
        DriffDbManager.instance.totpAdapter.getByAccountId(accountId),
        DriffDbManager.instance.accountCustomFieldAdapter.getByAccountId(accountId),
        DriffDbManager.instance.passwordHistoryAdapter.getByAccountId(accountId),
        DriffDbManager.instance.categoryAdapter.getById(account.categoryId),
      ]);

      totpDriftModelData = results[0] as TOTPDriftModelData?;
      accountCustomFieldDriftModelData = results[1] as List<AccountCustomFieldDriftModelData>?;
      passwordHistoryDriftModelData = results[2] as List<PasswordHistoryDriftModelData>?;
      categoryDriftModelData = results[3] as CategoryDriftModelData?;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      logError("Error loading account details: $e", functionName: "loadAccountDetails");
      isLoading = false;
      notifyListeners();
    }
  }
}
