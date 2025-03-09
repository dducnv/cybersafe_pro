
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension BuildContextExtension<T> on BuildContext {
  bool get darkMode => watch<ThemeProvider>().isDarkMode;
}
