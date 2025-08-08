import 'package:cybersafe_pro/models/note_models.dart';
import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';

class YearMonthHeader extends StatelessWidget {
  final int year;
  final int month;
  const YearMonthHeader({super.key, required this.year, required this.month});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4, left: 16),
      child: RichText(
        text: TextSpan(
          style: CustomTextStyle.regular(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          children: [
            TextSpan(
              text: '$year',
              style: CustomTextStyle.regular(
                fontSize: 42.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2.7,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: getMonthName(month),
              style: CustomTextStyle.regular(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.36,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  final NoteCardData note;
  final NoteProvider noteProvider;
  final Function(NoteCardData) onLongPress;
  const NoteCard({
    super.key,
    required this.note,
    required this.noteProvider,
    required this.onLongPress,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isPressed) {
      _controller.forward();
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: () => widget.onLongPress(widget.note),
      onTap: () async {
        await AppRoutes.navigateTo(
          context,
          AppRoutes.noteEditor,
          arguments: {"noteId": widget.note.id},
        );
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder:
            (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: CardCustomWidget(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 6,
                  ),
                  right: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 1.4,
                  ),
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 1.4,
                  ),
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 1.4,
                  ),
                ),
                borderRadius: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (widget.note.color != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(radius: 4, backgroundColor: widget.note.color),
                          ),
                        Expanded(
                          child: Text(
                            widget.note.title,
                            style: CustomTextStyle.regular(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.note.time,
                          style: CustomTextStyle.regular(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.noteProvider.getPlainText(widget.note.content),
                            style: CustomTextStyle.regular(
                              fontSize: 14,
                              height: 1.3,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .8),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
