import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:flutter/foundation.dart';

class DesktopHomeProvider extends ChangeNotifier {
  AccountDriftModelData? _selectedAccount;
  
  AccountDriftModelData? get selectedAccount => _selectedAccount;

  void selectAccount(AccountDriftModelData account) {
    _selectedAccount = account;
    notifyListeners();
  }
  
  void clearSelectedAccount() {
    _selectedAccount = null;
    notifyListeners();
  }
  
  bool get hasSelectedAccount => _selectedAccount != null;

  void toggleAccountSelection(AccountDriftModelData account) {
    if (_selectedAccount == account) {
      clearSelectedAccount();
    } else {
      selectAccount(account);
    }
  }
  void handleClearAccountsSelected() {
    _selectedAccount = null;
    notifyListeners();
  }
}
