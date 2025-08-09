import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MonthList extends StatefulWidget {
  const MonthList({super.key});

  @override
  State<MonthList> createState() => _MonthListState();
}

class _MonthListState extends State<MonthList> {
  late ScrollController _scrollController;

  static const double itemWidth = 56.0;
  static const double separatorWidth = 8.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentMonth = DateTime.now().month;
      if (_scrollController.hasClients) {
        final offset =
            (currentMonth - 1) * (itemWidth + separatorWidth) -
            (MediaQuery.of(context).size.width - itemWidth) / 2;

        _scrollController.jumpTo(offset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<NoteProvider, int>(
      selector: (context, noteProvider) => noteProvider.currentFilterMonth,
      builder: (context, currentFilterMonth, child) {
        return SizedBox(
          height: 60,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 12,
            separatorBuilder: (_, __) => const SizedBox(width: separatorWidth),
            itemBuilder: (context, index) {
              final isSelected = currentFilterMonth == index + 1;
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuint,
                tween: Tween<double>(begin: 0, end: isSelected ? 1.0 : 0.0),
                builder: (context, value, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutQuint,
                    width: itemWidth + (value * 6), // Tăng độ rộng khi được chọn
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        Theme.of(context).colorScheme.surfaceContainer,
                        Theme.of(context).colorScheme.primary,
                        value,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            Color.lerp(
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                              Theme.of(context).colorScheme.primary,
                              value * 0.8, // Giảm độ tương phản
                            )!,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2 * value),
                          blurRadius: 4 * value,
                          spreadRadius: value * 0.5,
                          offset: Offset(0, 1 * value),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          // Thêm phản hồi xúc giác nhẹ
                          HapticFeedback.selectionClick();

                          // Cập nhật tháng được chọn
                          context.read<NoteProvider>().setFilter(month: index + 1);

                          // Tính toán vị trí cuộn
                          final screenWidth = MediaQuery.of(context).size.width;
                          final targetOffset =
                              (index * (itemWidth + separatorWidth)) -
                              (screenWidth - itemWidth) / 2;

                          final safeOffset = targetOffset.clamp(
                            0.0,
                            _scrollController.position.maxScrollExtent,
                          );

                          // Cuộn đến vị trí mới với animation nhanh hơn
                          _scrollController.animateTo(
                            safeOffset,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutQuint,
                          );
                        },
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: CustomTextStyle.regular(
                              fontSize: 18 + (value * 3), // Tăng kích thước chữ khi được chọn
                              fontWeight:
                                  value > 0.5 ? FontWeight.w700 : FontWeight.w600, // Tăng độ đậm
                              color:
                                  Color.lerp(
                                    Theme.of(context).colorScheme.onSurface,
                                    Colors.white,
                                    value,
                                  )!,
                            ),
                            child: Text("${index + 1}"),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
