import 'dart:math';

import 'package:cybersafe_pro/utils/global_keys.dart';
import 'package:flutter/material.dart';

class PasswordGenerateProvider extends ChangeNotifier {
  bool isFromForm = false;
  Function(String)? onPasswordChanged;

  int passLength = 8;
  bool isNumber = true;
  bool isSymbol = true;

  String password = "";
  List<InlineSpan> passwordInline = [];

  final String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  final String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final String numbers = "0123456789";
  final String special = "@#=+!£\$%&?[](){}";

  void init(bool isFromForm, Function(String)? onPasswordChanged) {
    this.isFromForm = isFromForm;
    this.onPasswordChanged = onPasswordChanged;
  }

  void setPassLength(int length) {
    passLength = length;
    notifyListeners();
  }

  void setIsNumber(bool value) {
    isNumber = value;
    notifyListeners();
  }

  void setIsSymbol(bool value) {
    isSymbol = value;
    notifyListeners();
  }

  void generatePassword() {
    String allowedChars = "";
    passwordInline = [];
    allowedChars += (_lowerCaseLetters);
    allowedChars += (_upperCaseLetters);
    if (isNumber) {
      allowedChars += (numbers);
    }
    if (isSymbol) {
      allowedChars += (special);
    }

    String result = "";
    for (int i = 0; i < passLength; i++) {
      result += allowedChars[Random().nextInt(allowedChars.length)];
    }
    password = result;

    //if symbol is allowed add TextSpan color red
    for (int i = 0; i < result.length; i++) {
      if (special.contains(result[i])) {
        passwordInline.add(
          TextSpan(
            text: result[i],
            style: const TextStyle(color: Colors.redAccent),
          ),
        );
      } else if (numbers.contains(result[i])) {
        passwordInline.add(
          TextSpan(
            text: result[i],
            style: const TextStyle(color: Colors.blueAccent),
          ),
        );
      } else {
        passwordInline.add(
          TextSpan(
            text: result[i],
            style: TextStyle(
                color: Theme.of(GlobalKeys.appRootNavigatorKey.currentContext!)
                    .colorScheme
                    .onSecondaryContainer),
          ),
        );
      }
    }
    notifyListeners();
  }
}