import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:flutter/material.dart';

class ItemCopyValue extends StatefulWidget {
  final bool isLastItem;
  final String title;
  final String value;
  final bool isPrivateValue;
  const ItemCopyValue({super.key, this.isLastItem = false, required this.title, required this.value, this.isPrivateValue = false});

  @override
  State<ItemCopyValue> createState() => _ItemCopyValueState();
}

class _ItemCopyValueState extends State<ItemCopyValue> {
  bool _isShowValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: !widget.isLastItem ? EdgeInsets.only(bottom: 10.h) : EdgeInsets.only(top: 5 .h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: !widget.isLastItem ? Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis, fontSize: 14.sp, fontWeight: FontWeight.w600)),
                SizedBox(height:5,),
                if (widget.isPrivateValue ? _isShowValue : true)
                  DecryptText(
                    style: TextStyle(fontSize: 14.sp, overflow: TextOverflow.ellipsis),
                    value: widget.value,
                    decryptTextType: widget.isPrivateValue ? DecryptTextType.password : DecryptTextType.info,
                  )
                else
                  Text("***********", style: TextStyle(fontSize: 14.sp, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Row(
            children: [
              if (widget.isPrivateValue)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isShowValue = !_isShowValue;
                    });
                  },
                  icon: _isShowValue ? Icon(Icons.visibility_off, size: 24.sp, color: Theme.of(context).colorScheme.primary) : Icon(Icons.visibility, size: 24.sp),
                ),
              widget.value != ""
                  ? IconButton(
                    onPressed: () {
                      clipboardCustom(context: context, text: "");
                    },
                    icon: Icon(Icons.copy, size: 20.sp),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
