
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

class SecurityCheckItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData? subIcon;

  final int value;
  final Function()? onTap;
  const SecurityCheckItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.value,
      this.onTap,
      this.subIcon});

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 24.sp,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: CustomTextStyle.regular(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines:2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Text(
                      value.toString(),
                      style: CustomTextStyle.regular(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    subIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Icon(
                              subIcon,
                              size: 18.sp,
                            ),
                          )
                        : const SizedBox(),
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
