import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(T item, int index);

class CardItem<T> extends StatelessWidget {
  final List<T> items;
  final String title;
  final ItemBuilder<T> itemBuilder;
  const CardItem(
      {super.key,
      required this.items,
      required this.title,
      required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainerHighest),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return itemBuilder(items[index], index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
