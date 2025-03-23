import 'package:cybersafe_pro/env/env.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_utils.dart';

class OldEncryptData {
  static String decryptInfo(String info) {
  try {
    if (info.isEmpty) return '';
    String decryptResult = OldEncryptUtils.instance.decryptFernet(
      key:  Env.infoEncryptKey,
      value: info,
    );
    return decryptResult;
  } catch (e) {
    // customLogger(msg: "decryptInfo: $e", typeLogger: TypeLogger.error);
    return "";
  }
}

  static String decryptPassword(String password) {
  if (password.isEmpty) return '';
  try {
    String decryptResult = OldEncryptUtils.instance.decryptFernet(
      key: Env.passwordEncryptKey,
      value: password,
    );
    return decryptResult;
  } catch (e) {
    return "";
  }
}

  static String decryptTOTPKey(String totpKey) {
  try {
    if (totpKey.isEmpty) return '';
    String decryptResult = OldEncryptUtils.instance.decryptFernet(
      key: Env.totpEncryptKey,
      value: totpKey,
    );
    return decryptResult;
  } catch (e) {
    return "";
  }
}

  static String decriptPinCode(String pinCode) {
  try {
    if (pinCode.isEmpty) return '';
    String decryptResult = OldEncryptUtils.instance.decryptFernet(
      key:  Env.pinCodeKeyEncrypt,
      value: pinCode,
    );
    return decryptResult;
  } catch (e) {
    return "";
  }
}

}