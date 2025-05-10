import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:flutter/foundation.dart';

class DesktopHomeProvider extends ChangeNotifier {
  AccountOjbModel? _selectedAccount;
  
  AccountOjbModel? get selectedAccount => _selectedAccount;
  
  void selectAccount(AccountOjbModel account) {
    _selectedAccount = account;
    notifyListeners();
  }
  
  void clearSelectedAccount() {
    _selectedAccount = null;
    notifyListeners();
  }
  
  bool get hasSelectedAccount => _selectedAccount != null;
}
