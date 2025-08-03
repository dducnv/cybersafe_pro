import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ColorsDefined on ColorScheme {
  Color get selectableColorRed => Colors.red.shade400;
  Color get selectableColorGreen => Colors.green.shade400;
  Color get selectableColorBlue => Colors.blue.shade400;
  Color get selectableColorPurple => Colors.purple.shade400;
  Color get selectableColorOrange => Colors.orange.shade400;
  Color get selectableColorBlueGrey => Colors.blueGrey.shade400;
  Color get selectableColorYellow => Colors.yellow.shade400;
  Color get selectableColorAqua => Colors.teal.shade400;
  Color get selectableColorInidigo => Colors.indigo.shade500;
  Color get selectableColorGrey => Colors.grey.shade400;
  Color get selectableColorBrown => Colors.brown.shade400;
  Color get selectableColorDeepPurple => Colors.deepPurple.shade400;
  Color get selectableColorDeepOrange => Colors.deepOrange.shade400;
  Color get selectableColorCyan => Colors.cyan.shade400;
  Color get selectableColorPink => Colors.pink.shade400;
}

List<Color> selectableAccentColors(BuildContext context) {
  return [
    defaultAccentColor, // Màu mặc định
    Theme.of(context).colorScheme.selectableColorGreen,
    Theme.of(context).colorScheme.selectableColorAqua,
    Theme.of(context).colorScheme.selectableColorCyan,
    Theme.of(context).colorScheme.selectableColorBlue,
    Theme.of(context).colorScheme.selectableColorInidigo,
    Theme.of(context).colorScheme.selectableColorDeepPurple,
    Theme.of(context).colorScheme.selectableColorPurple,
    Theme.of(context).colorScheme.selectableColorPink,
    Theme.of(context).colorScheme.selectableColorRed,
    Theme.of(context).colorScheme.selectableColorDeepOrange,
    Theme.of(context).colorScheme.selectableColorOrange,
    Theme.of(context).colorScheme.selectableColorBrown,
    Theme.of(context).colorScheme.selectableColorYellow,
    Theme.of(context).colorScheme.selectableColorBlueGrey,
    Theme.of(context).colorScheme.selectableColorGrey,
  ];
}

// Định nghĩa các màu cơ bản
const defaultAccentColor = Color(0xFF2D5BD3);
const defaultLightBackground = Color(0xFFFFFFFF);
const defaultDarkBackground = Color(0xFF121212);

// Enum định nghĩa các theme màu có sẵn
enum AppThemeColor {
  blue('Xanh dương', Color(0xFF2D5BD3)),
  purple('Tím', Color(0xFF6750A4)),
  green('Xanh lá', Color(0xFF1B873D)),
  orange('Cam', Color(0xFFFF6B00)),
  red('Đỏ', Color(0xFFDC3545));

  final String name;
  final Color color;
  const AppThemeColor(this.name, this.color);
}

// Enum định nghĩa các màu nền có sẵn
enum AppSurfaceColor {
  white('Trắng', Color(0xFFFFFFFF), Color(0xFFF5F5F5)),
  grey('Xám', Color(0xFFF5F5F5), Color(0xFFE0E0E0)),
  black('Đen', Color(0xFF121212), Color(0xFF212121));

  final String name;
  final Color backgroundColor;
  final Color surfaceColor;
  const AppSurfaceColor(this.name, this.backgroundColor, this.surfaceColor);
}

// Extension để quản lý màu sắc tùy chỉnh
class AppColors extends ThemeExtension<AppColors> {
  final Map<String, Color> colors;

  AppColors({required this.colors});

  @override
  ThemeExtension<AppColors> copyWith({Map<String, Color>? colors}) {
    return AppColors(colors: colors ?? this.colors);
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(colors: {for (var entry in colors.entries) entry.key: Color.lerp(entry.value, other.colors[entry.key] ?? entry.value, t) ?? entry.value});
  }
}

// Helper function để lấy màu từ context
Color getColor(BuildContext context, String colorName) {
  return Theme.of(context).extension<AppColors>()?.colors[colorName] ?? Colors.red;
}

// Tạo AppColors dựa trên brightness và accent color
AppColors getAppColors({required Brightness brightness, required ThemeData themeData, required Color accentColor}) {
  if (brightness == Brightness.light) {
    return AppColors(
      colors: {
        'accent': accentColor,
        'lightDarkAccent': Colors.white,
        'background': Colors.white,
        'card': Colors.white,
        'cardSelected': lightenPastel(accentColor, amount: 0.85),
        'text': Colors.black,
        'textSecondary': Colors.black54,
        'border': Colors.black12,
        'divider': Colors.black12,
        'error': const Color(0xFFB00020),
        'success': const Color(0xFF1B873D),
        'warning': const Color(0xFFFF6B00),
        'info': const Color(0xFF2D5BD3),
      },
    );
  } else {
    return AppColors(
      colors: {
        'accent': accentColor,
        'lightDarkAccent': Colors.black,
        'background': Colors.black,
        'card': const Color(0xFF212121),
        'cardSelected': darkenPastel(accentColor, amount: 0.85),
        'text': Colors.white,
        'textSecondary': Colors.white70,
        'border': Colors.white24,
        'divider': Colors.white24,
        'error': const Color(0xFFCF6679),
        'success': const Color(0xFF1B873D),
        'warning': const Color(0xFFFF6B00),
        'info': const Color(0xFF2D5BD3),
      },
    );
  }
}

// Helper functions để điều chỉnh màu sắc
Color lightenPastel(Color color, {double amount = 0.1}) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}

Color darkenPastel(Color color, {double amount = 0.1}) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

// Tạo ColorScheme dựa trên brightness
ColorScheme getColorScheme(Brightness brightness) {
  if (brightness == Brightness.light) {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF2D5BD3),
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    );
  } else {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF2D5BD3),
      onPrimary: Colors.white,
      secondary: Color(0xFF212121),
      onSecondary: Colors.white,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      surface: Color(0xFF212121),
      onSurface: Colors.white,
    );
  }
}

// Tạo SystemUiOverlayStyle dựa trên theme
SystemUiOverlayStyle getSystemUiOverlayStyle(AppColors? colors, Brightness brightness) {
  if (brightness == Brightness.light) {
    return SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: colors?.colors['lightDarkAccent'] ?? Colors.white,
    );
  } else {
    return SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: colors?.colors['lightDarkAccent'] ?? Colors.black,
    );
  }
}

// Tạo ThemeData với AppColors extension
ThemeData generateThemeDataWithExtension({required ThemeData themeData, required Brightness brightness, required Color accentColor}) {
  AppColors colors = getAppColors(accentColor: accentColor, brightness: brightness, themeData: themeData);

  return themeData.copyWith(extensions: <ThemeExtension<dynamic>>[colors], appBarTheme: AppBarTheme(systemOverlayStyle: getSystemUiOverlayStyle(colors, brightness)));
}

// Tạo light theme
ThemeData getLightTheme() {
  const brightness = Brightness.light;
  const accentColor = Color(0xFF2D5BD3);

  final themeData = ThemeData(
    fontFamily: 'Inter',
    colorScheme: getColorScheme(brightness),
    useMaterial3: true,
    applyElevationOverlayColor: false,
    typography: Typography.material2014(),
    splashColor: Colors.transparent,
  );

  return generateThemeDataWithExtension(themeData: themeData, brightness: brightness, accentColor: accentColor);
}

// Tạo dark theme
ThemeData getDarkTheme() {
  const brightness = Brightness.dark;
  const accentColor = Color(0xFF2D5BD3);

  final themeData = ThemeData(fontFamily: 'Inter', colorScheme: getColorScheme(brightness), useMaterial3: true, typography: Typography.material2014(), splashColor: Colors.transparent);

  return generateThemeDataWithExtension(themeData: themeData, brightness: brightness, accentColor: accentColor);
}

// Tạo AppColors cho Light theme
AppColors getLightAppColors({Color accentColor = defaultAccentColor, Color backgroundColor = defaultLightBackground}) {
  return AppColors(
    colors: {
      'accent': accentColor,
      'lightDarkAccent': backgroundColor,
      'background': backgroundColor,
      'card': lightenPastel(backgroundColor, amount: 0.02),
      'cardSelected': lightenPastel(accentColor, amount: 0.85),
      'text': Colors.black,
      'textSecondary': Colors.black54,
      'border': Colors.black12,
      'divider': Colors.black12,
      'error': const Color(0xFFB00020),
      'success': const Color(0xFF1B873D),
      'warning': const Color(0xFFFF6B00),
      'info': const Color(0xFF2D5BD3),
    },
  );
}

// Tạo AppColors cho Dark theme
AppColors getDarkAppColors({Color accentColor = defaultAccentColor, Color backgroundColor = defaultDarkBackground}) {
  return AppColors(
    colors: {
      'accent': accentColor,
      'lightDarkAccent': backgroundColor,
      'background': backgroundColor,
      'card': darkenPastel(backgroundColor, amount: 0.02),
      'cardSelected': darkenPastel(accentColor, amount: 0.85),
      'text': Colors.white,
      'textSecondary': Colors.white70,
      'border': Colors.white24,
      'divider': Colors.white24,
      'error': const Color(0xFFCF6679),
      'success': const Color(0xFF1B873D),
      'warning': const Color(0xFFFF6B00),
      'info': const Color(0xFF2D5BD3),
    },
  );
}

// Tạo ColorScheme cho Light theme
ColorScheme getLightColorScheme({Color primary = defaultAccentColor, Color background = defaultLightBackground}) {
  return ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: lightenPastel(primary, amount: 0.3),
    onSecondary: Colors.black,
    error: const Color(0xFFB00020),
    onError: Colors.white,
    surface: lightenPastel(background, amount: 0.02),
    onSurface: Colors.black,
    surfaceContainerHighest: lightenPastel(background, amount: 0.05),
    onSurfaceVariant: Colors.black87,
    outline: Colors.black12,
    shadow: Colors.black.withOpacity(0.1),
    inverseSurface: Colors.black,
    onInverseSurface: Colors.white,
    inversePrimary: primary.withOpacity(0.8),
    surfaceTint: primary.withOpacity(0.1),
  );
}

// Tạo ColorScheme cho Dark theme
ColorScheme getDarkColorScheme({Color primary = defaultAccentColor, Color background = defaultDarkBackground}) {
  return ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.white,
    secondary: darkenPastel(primary, amount: 0.3),
    onSecondary: Colors.white,
    error: const Color(0xFFCF6679),
    onError: Colors.black,
    surface: darkenPastel(background, amount: 0.02),
    onSurface: Colors.white,
    surfaceContainerHighest: darkenPastel(background, amount: 0.05),
    onSurfaceVariant: Colors.white70,
    outline: Colors.white24,
    shadow: Colors.white.withOpacity(0.1),
    inverseSurface: Colors.white,
    onInverseSurface: Colors.black,
    inversePrimary: primary.withOpacity(0.8),
    surfaceTint: primary.withOpacity(0.1),
  );
}

// Class quản lý màu sắc cho light theme
class LightColors {
  final Color primary;
  final Color background;

  const LightColors({required this.primary, this.background = defaultLightBackground});

  AppColors toColors() => getLightAppColors(accentColor: primary, backgroundColor: background);

  ThemeData toThemeData() {
    final colorScheme = getLightColorScheme(primary: primary, background: background);
    final colors = toColors();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [colors],
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        systemOverlayStyle: getSystemUiOverlayStyle(colors, Brightness.light),
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: background),
      cardTheme: CardTheme(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), color: colors.colors['card']),
      navigationRailTheme: NavigationRailThemeData(backgroundColor: background, selectedIconTheme: IconThemeData(color: primary), unselectedIconTheme: const IconThemeData(color: Colors.black54)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}

// Class quản lý màu sắc cho dark theme
class DarkColors {
  final Color primary;
  final Color background;

  const DarkColors({required this.primary, this.background = defaultDarkBackground});

  AppColors toColors() => getDarkAppColors(accentColor: primary, backgroundColor: background);

  ThemeData toThemeData() {
    final colorScheme = getDarkColorScheme(primary: primary, background: background);
    final colors = toColors();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [colors],
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        systemOverlayStyle: getSystemUiOverlayStyle(colors, Brightness.dark),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: CustomTextStyle.regular(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: background),
      cardTheme: CardTheme(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), color: colors.colors['card']),
      navigationRailTheme: NavigationRailThemeData(backgroundColor: background, selectedIconTheme: IconThemeData(color: primary), unselectedIconTheme: const IconThemeData(color: Colors.white70)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
