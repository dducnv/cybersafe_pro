import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(T item, int index);

class CardItem<T> extends StatefulWidget {
  final List<T> items;
  final String title;
  final ItemBuilder<T> itemBuilder;
  final bool? showSeeMore;
  final Function? onSeeMoreItems;
  final int? totalItems;
  
  const CardItem({
    super.key, 
    required this.items, 
    required this.title, 
    required this.itemBuilder, 
    this.onSeeMoreItems, 
    this.showSeeMore = false,
    this.totalItems,
  });

  @override
  State<CardItem<T>> createState() => _CardItemState<T>();
}

class _CardItemState<T> extends State<CardItem<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }
  
  @override
  void didUpdateWidget(CardItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      // Khi số lượng items thay đổi, chạy animation
      _controller.reset();
      _controller.forward();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingItems = (widget.totalItems ?? widget.items.length) - widget.items.length;
    final shouldShowSeeMore = widget.showSeeMore == true && remainingItems > 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
            if (widget.totalItems != null)
              Text('${widget.totalItems} mục', style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: FadeTransition(
                    opacity: _animation,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        return widget.itemBuilder(widget.items[index], index);
                      },
                    ),
                  ),
                ),
                if (shouldShowSeeMore)
                  Material(
                    color:Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onSeeMoreItems?.call(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                remainingItems > 10 
                                  ? 'Xem thêm 10 mục tiếp theo' 
                                  : 'Xem thêm $remainingItems mục còn lại',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
