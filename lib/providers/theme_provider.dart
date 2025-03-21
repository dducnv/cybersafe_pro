import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode themeMode = ThemeMode.light;
  late Color accentColor = AppThemeColor.blue.color;
  late bool isDefaultTheme = true;

  ThemeProvider() {
    initTheme();
  }

  // Khởi tạo theme từ storage
  Future<void> initTheme() async {
    themeMode = await getThemeMode();
    accentColor = await getAccentColor();
    isDefaultTheme = await getIsDefaultTheme();
    notifyListeners();
  }

  // Lấy theme mode từ storage
  Future<ThemeMode> getThemeMode() async {
    int? value = await SecureStorage.instance.readInt(SecureStorageKeys.themeMode.name);
    if (value != null && value > -1 && value < ThemeMode.values.length) {
      return ThemeMode.values[value];
    }
    return ThemeMode.light;
  }

  // Lấy accent color từ storage
  Future<Color> getAccentColor() async {
    int? value = await SecureStorage.instance.readInt(SecureStorageKeys.themeColor.name);
    if (value != null) {
      return Color(value);
    }
    return const Color(0xFF2D5BD3);
  }

  // Lấy trạng thái theme mặc định từ storage
  Future<bool> getIsDefaultTheme() async {
    String? value = await SecureStorage.instance.read(key: SecureStorageKeys.isDefaultTheme.name) ?? 'true';
    return value == 'true';
  }

  // Thay đổi theme mode
  void changeTheme(ThemeMode mode) {
    themeMode = mode;
    SecureStorage.instance.saveInt(SecureStorageKeys.themeMode.name, mode.index);
    notifyListeners();
  }

  // Thay đổi accent color
  void changeAccentColor(Color color) {
    accentColor = color;
    SecureStorage.instance.saveInt(SecureStorageKeys.themeColor.name, color.value);
    notifyListeners();
  }

  // Toggle theme mode
  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    SecureStorage.instance.saveInt(SecureStorageKeys.themeMode.name, themeMode.index);
    notifyListeners();
  }

  // Toggle theme mặc định/tùy chỉnh
  void toggleDefaultTheme() {
    isDefaultTheme = !isDefaultTheme;
    SecureStorage.instance.save(key: SecureStorageKeys.isDefaultTheme.name, value: isDefaultTheme.toString());
    notifyListeners();
  }

  // Getters
  bool get isDarkMode => themeMode == ThemeMode.dark;
  
  // Lấy màu accent hiện tại
  Color get currentAccentColor => accentColor;
  
  // Lấy theme data theo mode và color hiện tại
  ThemeData get lightTheme {
    final colorScheme = isDefaultTheme 
      ? ColorScheme(
          shadow: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
          brightness: Brightness.light,
          error: const Color.fromARGB(255, 129, 21, 21),
          onError: const Color(0xFF000000),
          onPrimary: const Color(0xFFFFFFFF),
          onSecondary: const Color(0xFF000000),
          onSurface: const Color(0xFF000000),
          primary: const Color(0xFF2D5BD3),
          secondary: const Color(0xFFE9E9E9),
          surface: const Color(0xFFE9E9E9),
          surfaceContainer:const Color(0xFFFFFFFF),
          surfaceContainerHighest: const Color.fromARGB(255, 219, 219, 219),
          secondaryContainer: const Color(0xFFFFFFFF),
        )
      : ColorScheme.fromSeed(
          seedColor: currentAccentColor,
          brightness: Brightness.light,
          background: lightenPastel(currentAccentColor, amount: 0.91),
        );

    final baseTheme = ThemeData(
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      useMaterial3: true,
      applyElevationOverlayColor: false,
      typography: Typography.material2014(),
      splashColor: Colors.transparent,
    );

    return baseTheme.copyWith(
      extensions: [
        AppColors(
          colors: {
            'accent': currentAccentColor,
            'lightDarkAccent': Colors.white,
            'background': Colors.white,
            'card': Colors.white,
            'cardSelected': lightenPastel(currentAccentColor, amount: 0.85),
            'text': isDefaultTheme ? const Color(0xFF000000) : Colors.black,
            'textSecondary': isDefaultTheme ? const Color(0xFF757575) : Colors.black54,
            'border': Colors.black12,
            'divider': Colors.black12,
            'error': const Color(0xFFB00020),
            'success': const Color(0xFF1B873D),
            'warning': const Color(0xFFFF6B00),
            'info': const Color(0xFF2D5BD3),
          },
        ),
      ],
    );
  }
  
  ThemeData get darkTheme {
    final colorScheme = isDefaultTheme
      ? ColorScheme(
          brightness: Brightness.dark,
          error: const Color(0xFFCF6679),
          onError: const Color(0xFFFFFFFF),
          onPrimary: const Color(0xFFFFFFFF),
          onSecondary: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFFFFFFFF),
          primary: const Color(0xFF2D5BD3),
          secondary: const Color(0xFF121212),
          surface: const Color(0xFF121212),
          surfaceContainer:const Color(0xFF212121),
          secondaryContainer: const Color(0xFF212121),
          surfaceContainerHighest: const Color.fromARGB(255, 42, 42, 42),
        )
      : ColorScheme.fromSeed(
          seedColor: currentAccentColor,
          brightness: Brightness.dark,
          background: Colors.black,
        );

    final baseTheme = ThemeData(
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      useMaterial3: true,
      typography: Typography.material2014(),
      splashColor: Colors.transparent,
    );

    return baseTheme.copyWith(
      extensions: [
        AppColors(
          colors: {
            'accent': currentAccentColor,
            'lightDarkAccent': Colors.black,
            'background': Colors.black,
            'card': const Color(0xFF212121),
            'cardSelected': darkenPastel(currentAccentColor, amount: 0.85),
            'text': isDefaultTheme ? const Color(0xFFFFFFFF) : Colors.white,
            'textSecondary': isDefaultTheme ? const Color(0xFFBDBDBD) : Colors.white70,
            'border': Colors.white24,
            'divider': Colors.white24,
            'error': const Color(0xFFCF6679),
            'success': const Color(0xFF1B873D),
            'warning': const Color(0xFFFF6B00),
            'info': const Color(0xFF2D5BD3),
          },
        ),
      ],
    );
  }
}