import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:drift/drift.dart';

class TextNotesAdapter {
  final DriftSqliteDatabase _database;

  TextNotesAdapter(this._database);

  Future<List<TextNotesDriftModelData>> getAll() async {
    try {
      final notes = await _database.select(_database.textNotesDriftModel).get();
      return notes;
    } catch (e) {
      logError('Error getting all categories: $e');
      return [];
    }
  }

  Future<List<TextNotesDriftModelData>> getByYearAndMonth(int year, int month) async {
    try {
      final query = _database.select(_database.textNotesDriftModel)
        ..where((tbl) => tbl.updatedAt.year.equals(year) & tbl.updatedAt.month.equals(month));
      return await query.get();
    } catch (e) {
      logError('Error getting notes by year and month: $e');
      return [];
    }
  }

  Future<void> insertAll(List<TextNotesDriftModelData> textNotes) async {
    await _database.batch((b) {
      for (var textNote in textNotes) {
        final note = TextNotesDriftModelCompanion.insert(
          title: textNote.title,
          content: Value(textNote.content),
          isFavorite: Value(textNote.isFavorite),
          isPinned: Value(textNote.isPinned),
          indexPos: Value(textNote.indexPos),
          createdAt: Value(textNote.createdAt),
          updatedAt: Value(textNote.updatedAt),
        );
        b.insert(_database.textNotesDriftModel, note);
      }
    });
  }

  Future<int> insertNote(TextNotesDriftModelCompanion data) async {
    final indexPos = await _getNextIndexPos();

    final note = TextNotesDriftModelCompanion.insert(
      title: data.title.value,
      content: data.content,
      isFavorite: data.isFavorite,
      isPinned: data.isPinned,
      indexPos: Value(indexPos),
    );
    final id = await _database.textNotesDriftModel.insertOne(note);
    return id;
  }

  Future<int> update(TextNotesDriftModelData data) async {
    return await (_database.update(_database.textNotesDriftModel)
      ..where((tbl) => tbl.id.equals(data.id))).write(data);
  }

  Future<int> _getNextIndexPos() async {
    try {
      final query =
          _database.selectOnly(_database.textNotesDriftModel)
            ..addColumns([_database.textNotesDriftModel.indexPos])
            ..orderBy([OrderingTerm.desc(_database.textNotesDriftModel.indexPos)])
            ..limit(1);

      final rows = await query.get();
      if (rows.isEmpty) return 0;

      final maxIndexPos = rows.first.read(_database.textNotesDriftModel.indexPos);
      return (maxIndexPos ?? 0) + 1;
    } catch (e) {
      logError('Error getting next index position: $e');
      return 0;
    }
  }

  Future<TextNotesDriftModelData?> getById(int id) async {
    try {
      final query = _database.select(_database.textNotesDriftModel)..where((t) => t.id.equals(id));
      return await query.getSingleOrNull();
    } catch (e) {
      logError('Error getting category by ID: $e');
      return null;
    }
  }

  Future<void> updateColor(int id, String? color) async {
    final note = await getById(id);
    if (note == null) return;
    await update(note.copyWith(color: Value(color)));
  }

  Future<int> delete(int id) async {
    return await (_database.delete(_database.textNotesDriftModel)
      ..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteAll() async {
    await _database.delete(_database.textNotesDriftModel).go();
  }
}
