import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/note_text.dart';
import 'package:cybersafe_pro/models/note_models.dart';
import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/note_list/widgets/month_list.dart';
import 'package:cybersafe_pro/screens/note_list/widgets/note_appbar.dart';
import 'package:cybersafe_pro/screens/note_list/widgets/note_list_widgets.dart';
import 'package:cybersafe_pro/screens/note_list/widgets/year_month_header.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final noteProvider = context.read<NoteProvider>();
      noteProvider.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NoteAppbar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AppRoutes.navigateTo(context, AppRoutes.noteEditor);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Selector<NoteProvider, Tuple2<int, int>>(
              selector:
                  (context, noteProvider) =>
                      Tuple2(noteProvider.currentFilterYear, noteProvider.currentFilterMonth),
              builder: (context, currentFilter, child) {
                return YearMonthHeader(year: currentFilter.item1, month: currentFilter.item2);
              },
            ),
            const MonthList(),
            SizedBox(height: 8),
            Expanded(
              child: Selector<NoteProvider, Tuple2<Map<int, List<TextNotesDriftModelData>>, bool>>(
                selector:
                    (context, noteProvider) =>
                        Tuple2(noteProvider.groupedByDay, noteProvider.isLoading),
                builder: (context, data, child) {
                  final currentFilterMonth = data.item1;
                  final isLoading = data.item2;

                  return RefreshIndicator(
                    onRefresh: () {
                      return context.read<NoteProvider>().refreshData();
                    },
                    child:
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : currentFilterMonth.entries.isEmpty
                            ? Center(
                              child: Image.asset(
                                "assets/images/exclamation-mark.png",
                                width: 60.w,
                                height: 60.h,
                              ),
                            )
                            : ListView(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ).copyWith(right: 16, left: 8, bottom: 90),
                              shrinkWrap: true,
                              children:
                                  currentFilterMonth.entries.map((entry) {
                                    final day = entry.key;
                                    final notes = entry.value;
                                    notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                                    final month =
                                        notes.isNotEmpty
                                            ? notes.first.updatedAt.month
                                            : DateTime.now().month;
                                    final year = DateTime.now().year;

                                    return _NoteDayGroup(
                                      day: day,
                                      month: month,
                                      year: year,
                                      notes: notes,
                                      onLongPress: bottomSheetOptionItem,
                                    );
                                  }).toList(),
                            ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> bottomSheetOptionItem({required NoteCardData note}) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Tùy chọn chọn màu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trNote(NoteText.choseNoteColor),
                          style: CustomTextStyle.regular(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // Không màu (mặc định)
                              _buildColorOption(context, "", note),
                              _buildColorOption(context, '#FFC107', note), // Amber
                              _buildColorOption(context, '#4CAF50', note), // Green
                              _buildColorOption(context, '#2196F3', note), // Blue
                              _buildColorOption(context, '#9C27B0', note), // Purple
                              _buildColorOption(context, '#F44336', note), // Red
                              _buildColorOption(context, '#FF9800', note), // Orange
                              _buildColorOption(context, '#795548', note), // Brown
                              _buildColorOption(context, '#607D8B', note), // Blue Grey
                              // Màu bổ sung (đậm, dễ phân biệt)
                              _buildColorOption(context, '#0288D1', note), // Strong Sky Blue
                              _buildColorOption(context, '#388E3C', note), // Strong Green
                              _buildColorOption(context, '#F57C00', note), // Deep Orange
                              _buildColorOption(context, '#E91E63', note), // Hot Pink
                              _buildColorOption(context, '#7B1FA2', note), // Deep Purple
                              _buildColorOption(context, '#009688', note), // Teal
                              _buildColorOption(context, '#FBC02D', note), // Vivid Yellow
                              _buildColorOption(context, '#455A64', note), // Dark Blue Grey
                              // Màu pastel nhẹ hơn để tạo cảm giác dịu mắt
                              _buildColorOption(context, '#A5D6A7', note), // Light Green
                              _buildColorOption(context, '#90CAF9', note), // Light Blue
                              _buildColorOption(context, '#CE93D8', note), // Light Purple
                              _buildColorOption(context, '#FFCCBC', note), // Soft Coral
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.check_circle_outline, size: 24.sp),
                    title: Text(
                      context.trNote(NoteText.selectNote),
                      style: CustomTextStyle.regular(fontWeight: FontWeight.w500),
                    ),
                    onTap: () async {
                      // Đóng bottom sheet
                      Navigator.of(context).pop();
                      context.read<NoteProvider>().addSelectedNote(note.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_outline, size: 24.sp, color: Colors.red),
                    title: Text(
                      context.trNote(NoteText.deleteTitle),
                      style: CustomTextStyle.regular(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await context.read<NoteProvider>().deleteNote(note.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorOption(BuildContext context, String? colorHex, NoteCardData note) {
    final Color color = getColorFromHex(colorHex) ?? Theme.of(context).colorScheme.surface;

    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pop();
        // Cập nhật màu cho ghi chú thông qua provider
        await context.read<NoteProvider>().updateColor(note.id, colorHex);
      },
      child:
          //icon có đấu gạch tréo hình tròn
          colorHex == null || colorHex.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.cancel_outlined, size: 40.sp, color: Colors.redAccent),
              )
              : Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
    );
  }
}

class _NoteDayGroup extends StatefulWidget {
  final int day;
  final int month;
  final int year;
  final List<TextNotesDriftModelData> notes;
  final Future<void> Function({required NoteCardData note}) onLongPress;

  const _NoteDayGroup({
    required this.day,
    required this.month,
    required this.year,
    required this.notes,
    required this.onLongPress,
  });

  @override
  State<_NoteDayGroup> createState() => _NoteDayGroupState();
}

class _NoteDayGroupState extends State<_NoteDayGroup> {
  List<NoteCardData>? _cachedNoteCards;
  String? _cacheKey;

  @override
  Widget build(BuildContext context) {
    return Selector<NoteProvider, List<TextNotesDriftModelData>>(
      selector: (context, noteProvider) {
        return noteProvider.groupedByDay[widget.day] ?? widget.notes;
      },
      shouldRebuild: (previous, next) {
        if (previous.length != next.length) return true;

        for (int i = 0; i < previous.length; i++) {
          if (previous[i].id != next[i].id ||
              previous[i].updatedAt != next[i].updatedAt ||
              previous[i].color != next[i].color) {
            return true;
          }
        }
        return false;
      },
      builder: (context, selectedNotes, child) {
        final currentCacheKey = selectedNotes
            .map((note) => '${note.id}_${note.updatedAt}_${note.color}')
            .join('|');

        if (_cacheKey != currentCacheKey || _cachedNoteCards == null) {
          _cacheKey = currentCacheKey;
          return FutureBuilder<List<NoteCardData>>(
            future: context.read<NoteProvider>().getDecryptedNoteCards(selectedNotes),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              _cachedNoteCards = snapshot.data ?? [];
              return _buildDayGroup(_cachedNoteCards!);
            },
          );
        }
        return _buildDayGroup(_cachedNoteCards!);
      },
    );
  }

  Widget _buildDayGroup(List<NoteCardData> noteCards) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 46,
              child: Padding(
                padding: const EdgeInsets.all(4).copyWith(right: 8, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          getWeekdayName(DateTime(widget.year, widget.month, widget.day)),
                          style: CustomTextStyle.regular(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          "${widget.day}",
                          style: CustomTextStyle.regular(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (widget.notes.length > 1)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 2,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final note in noteCards) ...[
                    NoteCard(note: note, onLongPress: (note) => widget.onLongPress(note: note)),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
