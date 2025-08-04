import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/screens/note_list/widgets/month_list.dart';
import 'package:cybersafe_pro/screens/note_list/widgets/note_list_widgets.dart';
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
      appBar: AppBar(title: const Text("Ghi chú"), elevation: 0, scrolledUnderElevation: 0, backgroundColor: Theme.of(context).colorScheme.surface),
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
              selector: (context, noteProvider) => Tuple2(noteProvider.currentFilterYear, noteProvider.currentFilterMonth),
              builder: (context, currentFilter, child) {
                return YearMonthHeader(year: currentFilter.item1, month: currentFilter.item2);
              },
            ),
            const MonthList(),
            SizedBox(height: 8),
            Expanded(
              child: Selector<NoteProvider, Map<int, List<TextNotesDriftModelData>>>(
                selector: (context, noteProvider) => noteProvider.groupedByDay,
                builder: (context, currentFilterMonth, child) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8).copyWith(right: 16, left: 8, bottom:90),
                    shrinkWrap: true,
                    children:
                        currentFilterMonth.entries.map((entry) {
                          final day = entry.key;
                          final notes = entry.value;
                          notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                          final month = notes.isNotEmpty ? notes.first.updatedAt.month : DateTime.now().month;
                          final year = DateTime.now().year;

                          return FutureBuilder(
                            future: context.read<NoteProvider>().getDecryptedNoteCards(notes),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              final noteCards = snapshot.data ?? [];
                              return IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(4).copyWith(right: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  getWeekdayName(DateTime(year, month, day)),
                                                  style: CustomTextStyle.regular(fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                                                ),
                                                Text("$day", style: CustomTextStyle.regular(fontWeight: FontWeight.w600, fontSize: 24, color: Theme.of(context).colorScheme.onSurface)),
                                              ],
                                            ),
                                            if (notes.length > 1)
                                              Expanded(child: Container(margin: const EdgeInsets.only(top: 4), width: 2, color: Theme.of(context).colorScheme.surfaceContainerHighest)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for (final note in noteCards) ...[NoteCard(note: note, noteProvider: context.read<NoteProvider>()), const SizedBox(height: 8)],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
