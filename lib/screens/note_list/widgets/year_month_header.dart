import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearMonthHeader extends StatelessWidget {
  final int year;
  final int month;
  const YearMonthHeader({super.key, required this.year, required this.month});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pickYearBottomSheet(context, selectedYear: year);
      },
      child: Padding(
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
      ),
    );
  }

  void _pickYearBottomSheet(BuildContext context, {int? selectedYear}) {
    final currentYear = DateTime.now().year;
    final years = List.generate(24, (index) => currentYear - index);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Thanh kéo nhỏ ở trên
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: context.darkMode ? Colors.grey[800] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    final year = years[index];
                    final isSelected = selectedYear == year;
                    final isCurrentYear = year == currentYear;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context, year),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary.withValues(alpha: .1)
                                  : context.darkMode
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              year.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : (isCurrentYear
                                            ? Theme.of(context).colorScheme.primary
                                            : context.darkMode
                                            ? Colors.white60
                                            : Colors.black87),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((pickedYear) {
      if (pickedYear != null) {
        // ignore: use_build_context_synchronously
        context.read<NoteProvider>().setFilter(year: pickedYear);
      }
    });
  }
}
