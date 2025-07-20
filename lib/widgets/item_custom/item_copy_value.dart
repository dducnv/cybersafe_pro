import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
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

  BoxDecoration _buildDecoration(BuildContext context) => BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer);

  void _toggleValueVisibility() {
    setState(() => _isShowValue = !_isShowValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: _buildDecoration(context), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: _buildContent()), _buildActions(context)]));
  }

  Widget _buildContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildTitle(), const SizedBox(height: 5), _buildValue()]);
  }

  Widget _buildTitle() {
    return Text(widget.title, style: CustomTextStyle.regular(color: Colors.grey, overflow: TextOverflow.ellipsis, fontSize: 14.sp, fontWeight: FontWeight.w600));
  }

  Widget _buildValue() {
    if (widget.isPrivateValue && !_isShowValue) {
      return Text("***********", style: CustomTextStyle.regular(fontSize: 14.sp, overflow: TextOverflow.ellipsis));
    }

    return DecryptText(
      style: CustomTextStyle.regular(fontSize: 14.sp, overflow: TextOverflow.ellipsis),
      value: widget.value,
      decryptTextType: widget.isPrivateValue ? DecryptTextType.password : DecryptTextType.info,
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(children: [if (widget.isPrivateValue) _buildVisibilityToggle(context), if (widget.value.isNotEmpty) _buildCopyButton()]);
  }

  Widget _buildVisibilityToggle(BuildContext context) {
    return IconButton(
      onPressed: _toggleValueVisibility,
      icon: Icon(_isShowValue ? Icons.visibility_off : Icons.visibility, size: _isShowValue ? 20.sp : 24.sp, color: _isShowValue ? Theme.of(context).colorScheme.primary : null),
    );
  }

  Widget _buildCopyButton() {
    return IconButton(
      onPressed: () async {
        final decryptService = EncryptAppDataService.instance;
        final decryptedValue = widget.isPrivateValue ? await decryptService.decryptPassword(widget.value) : await decryptService.decryptInfo(widget.value);
        if (decryptedValue.isNotEmpty && mounted) {
          clipboardCustom(context: context, text: decryptedValue);
        }
      },
      icon: Icon(Icons.copy, size: 20.sp),
    );
  }
}
