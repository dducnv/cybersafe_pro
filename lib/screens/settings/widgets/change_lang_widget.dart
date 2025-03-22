import 'package:cybersafe_pro/resources/size_text_icon.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeLangWidget extends StatelessWidget {
  final Function() onTap;
  final Locale locale;
  const ChangeLangWidget({super.key, required this.onTap, required this.locale});

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Đổi ngôn ngữ", style: settingTitleItemStyle),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Text("", style: settingTitleItemStyle),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 24, color: Theme.of(context).colorScheme.onSurface),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
