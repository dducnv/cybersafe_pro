import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../theme/app_colors.dart';

class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final colors = selectableAccentColors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Switch cho theme mặc định
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Sử dụng theme mặc định',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Switch(
                value: themeProvider.isDefaultTheme,
                onChanged: (_) => themeProvider.toggleDefaultTheme(),
              ),
            ],
          ),
        ),
        const Divider(),
        // Theme color picker
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Màu sắc chủ đề',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (!themeProvider.isDefaultTheme)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              final isSelected = themeProvider.accentColor.value == color.value;
              return InkWell(
                onTap: () => themeProvider.changeAccentColor(color),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark 
                      ? const Color(0xFF212121) 
                      : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark 
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1),
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getColorName(color),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  String _getColorName(Color color) {
    if (color.value == AppThemeColor.blue.color.value) return 'Mặc định';
    if (color.value == Colors.green.shade400.value) return 'Xanh lá';
    if (color.value == Colors.teal.shade400.value) return 'Xanh lục';
    if (color.value == Colors.cyan.shade400.value) return 'Xanh ngọc';
    if (color.value == Colors.blue.shade400.value) return 'Xanh dương';
    if (color.value == Colors.indigo.shade500.value) return 'Chàm';
    if (color.value == Colors.deepPurple.shade400.value) return 'Tím đậm';
    if (color.value == Colors.purple.shade400.value) return 'Tím';
    if (color.value == Colors.pink.shade400.value) return 'Hồng';
    if (color.value == Colors.red.shade400.value) return 'Đỏ';
    if (color.value == Colors.deepOrange.shade400.value) return 'Cam đậm';
    if (color.value == Colors.orange.shade400.value) return 'Cam';
    if (color.value == Colors.brown.shade400.value) return 'Nâu';
    if (color.value == Colors.yellow.shade400.value) return 'Vàng';
    if (color.value == Colors.blueGrey.shade400.value) return 'Xám xanh';
    if (color.value == Colors.grey.shade400.value) return 'Xám';
    return 'Màu khác';
  }
} 