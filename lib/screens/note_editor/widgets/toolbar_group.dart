import 'package:cybersafe_pro/screens/note_editor/widgets/icon_toolbar_button.dart';
import 'package:flutter/material.dart';

class ToolbarGroup extends StatefulWidget {
  final IconData? iconExpand;
  final bool canExpand;
  final Widget child;
  const ToolbarGroup({super.key, required this.child, this.iconExpand, this.canExpand = false});

  @override
  State<ToolbarGroup> createState() => ToolbarGroupState();
}

class ToolbarGroupState extends State<ToolbarGroup> with TickerProviderStateMixin {
  late bool isExpand;

  @override
  void initState() {
    super.initState();
    isExpand = (widget.canExpand == true) ? false : true;
  }

  void handleExpand() {
    setState(() {
      isExpand = !isExpand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.iconExpand != null)
            IconToolbarButton(icon: widget.iconExpand!, onTap: handleExpand),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: isExpand ? const BoxConstraints() : const BoxConstraints(maxWidth: 0),
              child: AnimatedOpacity(
                opacity: isExpand ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
