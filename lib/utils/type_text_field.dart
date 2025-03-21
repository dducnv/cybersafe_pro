import 'package:flutter/material.dart';

class TypeTextField {
  final String title;
  final String type;

  TypeTextField({
    required this.title,
    required this.type,
  });
}

class DynamicTextField {
  final String key;

  final TextEditingController controller;
  final Widget field;
  final CustomField customField;
  DynamicTextField({
    required this.key,
    required this.controller,
    required this.customField,
    required this.field,
  });
}

class CustomField {
  final String key;
  final String hintText;
  final TypeTextField typeField;

  CustomField({
    required this.key,
    required this.hintText,
    required this.typeField,
  });
}
