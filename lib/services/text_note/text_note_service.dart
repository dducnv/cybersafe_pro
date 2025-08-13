import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';

class TextNoteService {
  static final instance = TextNoteService._();
  TextNoteService._();

  Future<void> saveTextNotesFromTextNotes(List<TextNotesDriftModelData> textNotes) async {
    if (textNotes.isEmpty) return;
    await DriffDbManager.instance.textNotesAdapter.insertAll(textNotes);
  }

  Future<List<TextNotesDriftModelData>> toEncryptedList(List<dynamic> textNotes) async {
    return await Future.wait(textNotes.map((e) => toEncryptedFromJson(textNote: e)));
  }

  Future<TextNotesDriftModelData> toEncryptedFromJson({
    required Map<String, dynamic> textNote,
  }) async {
    final futures = await Future.wait([
      DataSecureService.encryptInfo(textNote['title']),
      DataSecureService.encryptNote(textNote['content'] ?? ''),
    ]);

    return TextNotesDriftModelData(
      id: textNote['id'],
      title: futures[0],
      content: futures[1],
      color: textNote['color'],
      isFavorite: textNote['isFavorite'],
      isPinned: textNote['isPinned'],
      indexPos: textNote['indexPos'],
      createdAt: DateTime.parse(textNote['createdAt']),
      updatedAt: DateTime.parse(textNote['updatedAt']),
    );
  }

  Future<List<Map<String, dynamic>>> toDataDecryptedListJson(
    List<TextNotesDriftModelData> textNotes,
  ) async {
    return await Future.wait(textNotes.map((e) => toDataDecryptedJson(textNote: e)));
  }

  Future<Map<String, dynamic>> toDataDecryptedJson({
    required TextNotesDriftModelData textNote,
  }) async {
    final futures = await Future.wait([
      DataSecureService.decryptInfo(textNote.title),
      DataSecureService.decryptNote(textNote.content ?? ''),
    ]);

    return {
      'id': textNote.id,
      'title': futures[0],
      'content': futures[1],
      'color': textNote.color,
      'isFavorite': textNote.isFavorite,
      'isPinned': textNote.isPinned,
      'indexPos': textNote.indexPos,
      'createdAt': textNote.createdAt.toIso8601String(),
      'updatedAt': textNote.updatedAt.toIso8601String(),
    };
  }
}
