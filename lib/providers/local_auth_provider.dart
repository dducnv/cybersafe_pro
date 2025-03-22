import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';

class LocalAuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  final encryptAppDataService = EncryptAppDataService.instance;

  //login master password
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  Function? onCallBack;
  Function(TextEditingController controller, GlobalKey<AppPinCodeFieldsState> appPinCodeKey)? onCallBackWithPin;
  GlobalKey<AppPinCodeFieldsState> appPinCodeKey = GlobalKey<AppPinCodeFieldsState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _pinCodeConfirm = '';

  void init() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    appPinCodeKey = GlobalKey<AppPinCodeFieldsState>();
    formKey = GlobalKey<FormState>();
  }

  void authenticate() {
    isAuthenticated = true;
  }

  void setPinCodeToConfirm(String pinCode) async {
    if (pinCode.isEmpty) return;
    _pinCodeConfirm = pinCode;
    notifyListeners();
  }

  //save pin code
  Future<bool> savePinCode() async {
    if (_pinCodeConfirm.isEmpty) return false;
    String pinCodeEncrypted = await encryptAppDataService.encryptPinCode(_pinCodeConfirm);
    await SecureStorage.instance.save(key: SecureStorageKey.pinCode, value: pinCodeEncrypted);
    return true;
  }

  bool verifyRegisterPinCode(String pinCode) {
    if (_pinCodeConfirm.isEmpty) return false;
    return _pinCodeConfirm == pinCode;
  }

  Future<bool> handleLogin() async {
    formKey.currentState!.validate();
    String pinCode = textEditingController.text;
    if (pinCode.length == 6) {
      bool verify = await verifyLoginPinCode(pinCode);
      if (!verify) {
        appPinCodeKey.currentState!.triggerErrorAnimation();
        textEditingController.clear();
        Future.delayed(Duration.zero, () {
          focusNode.requestFocus();
        });
        return false;
      }
      return true;
    } else {
      appPinCodeKey.currentState!.triggerErrorAnimation();
    }
    return false;
  }

  void onBiometric() async {
    bool isAuth = await checkLocalAuth();
    if (isAuth) {
      navigatorToHome();
    }
  }

  Future<bool> verifyLoginPinCode(String pinCode) async {
    String? pinCodeEncryptedFromStorage = await SecureStorage.instance.read(key: SecureStorageKey.pinCode);
    if (pinCodeEncryptedFromStorage == null) return false;
    String pinCodeEncrypted = await encryptAppDataService.decryptPinCode(pinCodeEncryptedFromStorage);
    return pinCodeEncrypted == pinCode;
  }

  void navigatorToHome() {
    AppRoutes.navigateAndRemoveUntil(GlobalKeys.appRootNavigatorKey.currentContext!, AppRoutes.home);
  }
}
