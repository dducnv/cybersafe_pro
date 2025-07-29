import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle get base => const TextStyle(fontFamily: 'IBMPlexSans');

  static TextStyle regular({double? fontSize, FontWeight? fontWeight, FontStyle? fontStyle, Color? color, double? letterSpacing, double? height, TextDecoration? decoration, TextOverflow? overflow}) {
    return base.copyWith(fontSize: fontSize, fontWeight: fontWeight, fontStyle: fontStyle, color: color, letterSpacing: letterSpacing, height: height, decoration: decoration, overflow: overflow);
  }
}
