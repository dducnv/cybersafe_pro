import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
import 'package:cybersafe_pro/providers/theme_provider.dart';
import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/theme/app_colors.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_custom_switch/app_custom_switch.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetThemeColor extends StatefulWidget {
  const SetThemeColor({super.key});

  @override
  State<SetThemeColor> createState() => _SetThemeColorState();
}

class _SetThemeColorState extends State<SetThemeColor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Set initial animation state based on theme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      Future.delayed(Duration(milliseconds: 250), () {
        if (!provider.isDefaultTheme) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              CardCustomWidget(
                padding: const EdgeInsets.all(0),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.appLocale.settingsLocale.getText(SettingsLocale.theme), style: settingTitleItemStyle),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            AppCustomSwitch(
                              value: !provider.isDefaultTheme,
                              onChanged: (value) {
                                provider.toggleDefaultTheme();
                                if (!provider.isDefaultTheme) {
                                  _controller.forward();
                                } else {
                                  _controller.reverse();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: _animation,
                child: FadeTransition(
                  opacity: _animation,
                  child: SizedBox(
                    height: 50,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 5),
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      shrinkWrap: true,
                      itemCount: selectableAccentColors(context).length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final color = selectableAccentColors(context)[index];
                        final isSelected = provider.accentColor.value == color.value;
                        return TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 200),
                          tween: Tween(begin: 0.8, end: isSelected ? 1.1 : 1.0),
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: GestureDetector(
                                onTap: () => provider.changeAccentColor(color),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)] : null,
                                      ),
                                    ),
                                    if (isSelected) const Align(alignment: Alignment.center, child: Icon(Icons.check, color: Colors.white)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
