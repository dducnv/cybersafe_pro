import 'dart:async';
import 'dart:convert';

import 'package:cybersafe_pro/models/note_models.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appflowy_editor/appflowy_editor.dart';

class NoteProvider extends ChangeNotifier {
  int? noteId;
  Timer? _debounce;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentFilterYear = DateTime.now().year;
  int get currentFilterYear => _currentFilterYear;

  int _currentFilterMonth = DateTime.now().month;
  int get currentFilterMonth => _currentFilterMonth;

  TextNotesDriftModelData? textNotesDriftModelData;
  final String titleDefault = formatDateTime(DateTime.now());

  final Map<int, List<TextNotesDriftModelData>> _groupedByDay = {};
  Map<int, List<TextNotesDriftModelData>> get groupedByDay => Map.unmodifiable(_groupedByDay);

  final Map<int, List<NoteCardData>> _decryptedNotesCache = {};

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> init() async {
    if (_isLoading) return;
    _setLoading(true);

    try {
      _groupedByDay.clear();
      _decryptedNotesCache.clear();

      final notes = await DriffDbManager.instance.textNotesAdapter.getByYearAndMonth(_currentFilterYear, _currentFilterMonth);

      for (final note in notes) {
        final day = note.updatedAt.day;
        _groupedByDay.putIfAbsent(day, () => <TextNotesDriftModelData>[]);
        _groupedByDay[day]!.add(note);
      }

      // Pre-decrypt notes for better performance
      for (final entry in _groupedByDay.entries) {
        _decryptedNotesCache[entry.key] = await getDecryptedNoteCards(entry.value);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setFilter({int? year, int? month}) async {
    if (_isLoading) return;
    bool changed = false;
    if (year != null && year != _currentFilterYear) {
      _currentFilterYear = year;
      changed = true;
    }
    if (month != null && month != _currentFilterMonth) {
      _currentFilterMonth = month;
      changed = true;
    }
    if (changed) {
      await init();
      notifyListeners();
    }
  }

  String getPlainText(String content) {
    if (content.isEmpty) return '';
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(content);
      final document = Document.fromJson(jsonMap);
      final buffer = StringBuffer();
      for (final node in document.root.children) {
        final delta = node.delta;
        for (final op in delta!.toList()) {
          final insert = op.data;
          if (insert is String) buffer.write(insert);
        }
        buffer.write(' ');
      }
      String plainText = buffer.toString().trim();
      return plainText.length > 150 ? '${plainText.substring(0, 150)}...' : plainText;
    } catch (e) {
      return content.length > 150 ? '${content.substring(0, 150)}...' : content;
    }
  }

  /// Convert note thành NoteCardData với nội dung đã giải mã
  Future<NoteCardData> convertToNoteCard(TextNotesDriftModelData note) async {
    final title = await decryptTitle(note.title);
    final content = await decryptContent(note.content);
    return NoteCardData(id: note.id, title: title, content: content, time: DateFormat('HH:mm').format(note.updatedAt), updatedAt: note.updatedAt);
  }

  /// Lấy danh sách NoteCardData đã giải mã cho một nhóm ghi chú
  Future<List<NoteCardData>> getDecryptedNoteCards(List<TextNotesDriftModelData> notes) async {
    final day = notes.isNotEmpty ? notes.first.updatedAt.day : -1;

    // Kiểm tra cache trước
    if (_decryptedNotesCache.containsKey(day)) {
      return _decryptedNotesCache[day]!;
    }

    final noteCards = await Future.wait(notes.map((note) => convertToNoteCard(note)), eagerError: true);

    // Sắp xếp theo thời gian cập nhật mới nhất
    noteCards.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // Lưu vào cache
    if (day != -1) {
      _decryptedNotesCache[day] = noteCards;
    }

    return noteCards;
  }

  /// Giải mã tiêu đề ghi chú
  Future<String> decryptTitle(String encryptedTitle) async {
    return await DataSecureService.decryptInfo(encryptedTitle);
  }

  /// Giải mã nội dung ghi chú
  Future<String> decryptContent(String? encryptedContent) async {
    if (encryptedContent == null || encryptedContent.isEmpty) return '';
    return await DataSecureService.decryptNote(encryptedContent);
  }

  /// Lấy tất cả ghi chú từ DB
  Future<List<TextNotesDriftModelData>> getAllNotes() async {
    return DriffDbManager.instance.textNotesAdapter.getAll();
  }

  /// Xử lý khi nội dung hoặc tiêu đề thay đổi
  void onContentChanged({String? title, required String content}) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () async {
      if (noteId == null) {
        // Tạo mới ghi chú
        final titleSave = (title != null && title.isNotEmpty) ? title : titleDefault;
        final titleEncrypt = await DataSecureService.encryptInfo(titleSave);
        final contentEncrypt = await DataSecureService.encryptNote(content);
        noteId = await insertNote(title: titleEncrypt, content: contentEncrypt);
        if (noteId != null) {
          textNotesDriftModelData = await findById(noteId!);
        }
      } else {
        // Cập nhật ghi chú hiện tại
        await updateNote(title: title, content: content);
      }
      await init(); // Cập nhật lại danh sách ghi chú
      notifyListeners();
    });
  }

  /// Thêm ghi chú mới, trả về id
  Future<int> insertNote({required String title, required String content}) async {
    final id = await DriffDbManager.instance.textNotesAdapter.insertNote(TextNotesDriftModelCompanion.insert(title: title, content: Value(content)));
    return id;
  }

  /// Cập nhật ghi chú hiện tại
  Future<void> updateNote({String? title, required String content}) async {
    if (textNotesDriftModelData == null) return;
    final titleSave = (title != null && title.isNotEmpty) ? title : titleDefault;
    final titleEncrypt = title != null ? await DataSecureService.encryptInfo(titleSave) : textNotesDriftModelData!.title;
    final contentEncrypt = await DataSecureService.encryptNote(content);

    textNotesDriftModelData = textNotesDriftModelData!.copyWith(title: titleEncrypt, content: Value(contentEncrypt), updatedAt: DateTime.now());
    await DriffDbManager.instance.textNotesAdapter.update(textNotesDriftModelData!);
  }

  /// Tìm ghi chú theo id
  Future<TextNotesDriftModelData?> findById(int id) async {
    TextNotesDriftModelData? note = await DriffDbManager.instance.textNotesAdapter.getById(id);
    textNotesDriftModelData = note;
    noteId = note?.id;
    return note;
  }

  /// Reset trạng thái ghi chú (dùng khi tạo mới)
  void clearValue() {
    noteId = null;
    textNotesDriftModelData = null;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
