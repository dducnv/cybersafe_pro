import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';

class ItemPrivateValue extends StatelessWidget {
  final bool isLastItem;
  final String title;
  final String value;
  const ItemPrivateValue({super.key, this.isLastItem = false, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: !isLastItem ? EdgeInsets.only(bottom: 10.h) : null,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, border: !isLastItem ? Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest)) : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis, fontSize: 14.sp, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, size: 20.sp)),
        ],
      ),
    );
  }
}
