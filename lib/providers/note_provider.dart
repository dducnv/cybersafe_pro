import 'dart:async';
import 'dart:convert';

import 'package:cybersafe_pro/models/note_models.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/repositories/driff_db/driff_db_manager.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/utils/utils.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

class NoteProvider extends ChangeNotifier {
  int? noteId;
  Timer? _debounce;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  int _currentFilterYear = DateTime.now().year;
  int get currentFilterYear => _currentFilterYear;

  int _currentFilterMonth = DateTime.now().month;
  int get currentFilterMonth => _currentFilterMonth;

  TextNotesDriftModelData? textNotesDriftModelData;
  final String titleDefault = "Note ${formatDateTime(DateTime.now())}";

  final Map<int, List<TextNotesDriftModelData>> _groupedByDay = {};
  Map<int, List<TextNotesDriftModelData>> get groupedByDay => Map.unmodifiable(_groupedByDay);

  final Map<int, String> _decryptedTitleCache = {};
  final Map<int, String> _decryptedPreviewCache = {};
  static const int _maxCacheSize = 20;
  final List<int> _recentlyAccessedNotes = [];

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setRefreshing(bool value) {
    _isRefreshing = value;
    notifyListeners();
  }

  void _addToCache<T>(Map<int, T> cache, int id, T value) {
    if (cache.containsKey(id)) {
      _recentlyAccessedNotes.remove(id);
    } else if (cache.length >= _maxCacheSize && _recentlyAccessedNotes.isNotEmpty) {
      final leastRecentId = _recentlyAccessedNotes.removeAt(0);
      cache.remove(leastRecentId);
    }

    // Thêm vào cache và cập nhật thứ tự truy cập
    cache[id] = value;
    _recentlyAccessedNotes.add(id);
  }

  Future<void> init({bool isRefresh = false}) async {
    if (_isLoading && !isRefresh) return;

    if (isRefresh) {
      _setRefreshing(true);
    } else {
      _setLoading(true);
    }

    try {
      _groupedByDay.clear();
      // Không xóa toàn bộ cache để tận dụng dữ liệu đã giải mã

      final notes = await DriffDbManager.instance.textNotesAdapter.getByYearAndMonth(
        _currentFilterYear,
        _currentFilterMonth,
      );
      notes.sort(
        (a, b) => b.createdAt.day.compareTo(a.createdAt.day),
      ); // Sort by createdAt descending
      for (final note in notes) {
        final day = note.updatedAt.day;
        _groupedByDay.putIfAbsent(day, () => <TextNotesDriftModelData>[]);
        _groupedByDay[day]!.add(note);
      }

      // Không giải mã trước tất cả ghi chú, sẽ giải mã khi cần thiết

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      if (isRefresh) {
        _setRefreshing(false);
      } else {
        _setLoading(false);
      }
    }
  }

  Future<void> setFilter({int? year, int? month}) async {
    if (_isLoading || _isRefreshing) return;
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

  // Phương thức refresh dữ liệu với hiệu ứng loading
  Future<void> refreshData() async {
    if (_isRefreshing) return;
    await init(isRefresh: true);
  }

  // Lấy nội dung preview từ chuỗi đã giải mã
  String getPlainText(String content) {
    if (content.isEmpty) return '';
    try {
      final document = Document.fromJson(jsonDecode(content));
      String plainText = document.toPlainText().trim();
      return plainText.length > 150 ? '${plainText.substring(0, 150)}...' : plainText;
    } catch (e) {
      return content.length > 150 ? '${content.substring(0, 150)}...' : content;
    }
  }

  // Lấy preview nội dung đã giải mã từ cache hoặc giải mã mới
  Future<String> getDecryptedPreview(int noteId, String? encryptedContent) async {
    // Kiểm tra cache trước
    if (_decryptedPreviewCache.containsKey(noteId)) {
      return _decryptedPreviewCache[noteId]!;
    }

    // Giải mã và tạo preview
    if (encryptedContent == null || encryptedContent.isEmpty) return '';
    final decryptedContent = await DataSecureService.decryptNote(encryptedContent);
    final preview = getPlainText(decryptedContent);

    // Lưu vào cache
    _addToCache(_decryptedPreviewCache, noteId, preview);
    return preview;
  }

  // Lấy tiêu đề đã giải mã từ cache hoặc giải mã mới
  Future<String> getDecryptedTitle(int noteId, String encryptedTitle) async {
    // Kiểm tra cache trước
    if (_decryptedTitleCache.containsKey(noteId)) {
      return _decryptedTitleCache[noteId]!;
    }

    // Giải mã tiêu đề
    final title = await DataSecureService.decryptInfo(encryptedTitle);

    // Lưu vào cache
    _addToCache(_decryptedTitleCache, noteId, title);
    return title;
  }

  /// Convert note thành NoteCardData với nội dung đã giải mã
  Future<NoteCardData> convertToNoteCard(TextNotesDriftModelData note) async {
    final title = await getDecryptedTitle(note.id, note.title);
    final preview = await getDecryptedPreview(note.id, note.content);
    return NoteCardData(
      id: note.id,
      title: title,
      content: preview, // Chỉ lưu preview, không lưu toàn bộ nội dung đã giải mã
      time: DateFormat('HH:mm').format(note.updatedAt),
      updatedAt: note.updatedAt,
      color: getColorFromHex(note.color), // Thêm màu sắc của ghi chú
    );
  }

  /// Lấy danh sách NoteCardData đã giải mã cho một nhóm ghi chú
  Future<List<NoteCardData>> getDecryptedNoteCards(List<TextNotesDriftModelData> notes) async {
    final noteCards = await Future.wait(
      notes.map((note) => convertToNoteCard(note)),
      eagerError: true,
    );

    // Sắp xếp theo thời gian cập nhật mới nhất
    noteCards.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
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

  String? _lastSavedContent;
  String? _lastSavedTitle;
  DateTime _lastSaveTime = DateTime.now();
  bool _hasSignificantChanges = false;

  bool _hasContentChangedSignificantly(String oldContent, String newContent) {
    if (oldContent.isEmpty || newContent.isEmpty) return true;

    if ((oldContent.length - newContent.length).abs() > oldContent.length * 0.2) {
      return true;
    }

    try {
      final oldDoc = Document.fromJson(jsonDecode(oldContent));
      final newDoc = Document.fromJson(jsonDecode(newContent));

      final oldLines = oldDoc.toPlainText().split('\n').length;
      final newLines = newDoc.toPlainText().split('\n').length;
      if ((oldLines - newLines).abs() >= 3) {
        return true;
      }

      if (DateTime.now().difference(_lastSaveTime).inMinutes >= 1) {
        return true;
      }

      return false;
    } catch (e) {
      return true;
    }
  }

  void onContentChanged({String? title, required String content}) {
    final titleChanged = title != null && title != _lastSavedTitle;

    if (_lastSavedContent != null) {
      _hasSignificantChanges =
          _hasContentChangedSignificantly(_lastSavedContent!, content) || titleChanged;
    } else {
      _hasSignificantChanges = true;
    }

    _debounce?.cancel();

    final debounceTime =
        _hasSignificantChanges ? const Duration(milliseconds: 1500) : const Duration(seconds: 5);

    _debounce = Timer(debounceTime, () async {
      if (noteId == null) {
        final titleSave = (title != null && title.isNotEmpty) ? title : titleDefault;
        final titleEncrypt = await DataSecureService.encryptInfo(titleSave);
        final contentEncrypt = await DataSecureService.encryptNote(content);
        noteId = await insertNote(title: titleEncrypt, content: contentEncrypt);
        if (noteId != null) {
          textNotesDriftModelData = await findById(noteId!);

          _lastSavedContent = content;
          _lastSavedTitle = title;
          _lastSaveTime = DateTime.now();
        }
      } else if (_hasSignificantChanges || titleChanged) {
        await updateNote(title: title, content: content);

        _lastSavedContent = content;
        _lastSavedTitle = title;
        _lastSaveTime = DateTime.now();
        _hasSignificantChanges = false;
      }

      if (_hasSignificantChanges || titleChanged) {
        await init();
        notifyListeners();
      }
    });
  }

  Future<int> insertNote({required String title, required String content}) async {
    final id = await DriffDbManager.instance.textNotesAdapter.insertNote(
      TextNotesDriftModelCompanion.insert(title: title, content: Value(content)),
    );
    return id;
  }

  Future<void> updateNote({String? title, required String content}) async {
    if (textNotesDriftModelData == null) return;
    final titleSave = (title != null && title.isNotEmpty) ? title : titleDefault;
    final titleEncrypt =
        title != null
            ? await DataSecureService.encryptInfo(titleSave)
            : textNotesDriftModelData!.title;
    final contentEncrypt = await DataSecureService.encryptNote(content);

    textNotesDriftModelData = textNotesDriftModelData!.copyWith(
      title: titleEncrypt,
      content: Value(contentEncrypt),
      updatedAt: DateTime.now(),
    );
    await DriffDbManager.instance.textNotesAdapter.update(textNotesDriftModelData!);
  }

  Future<TextNotesDriftModelData?> findById(int id) async {
    TextNotesDriftModelData? note = await DriffDbManager.instance.textNotesAdapter.getById(id);
    textNotesDriftModelData = note;
    noteId = note?.id;
    return note;
  }

  void clearValue() {
    noteId = null;
    textNotesDriftModelData = null;
  }

  void clearAllCache() {
    _decryptedTitleCache.clear();
    _decryptedPreviewCache.clear();
    _recentlyAccessedNotes.clear();
    debugPrint('Cache đã được xóa hoàn toàn');
  }

  /// Xóa ghi chú theo ID
  Future<bool> deleteNote(int id) async {
    try {
      // Xóa cache liên quan đến ghi chú này
      clearNoteCache(id);

      // Xóa ghi chú từ database
      final result = await DriffDbManager.instance.textNotesAdapter.delete(id);

      // Cập nhật lại danh sách ghi chú
      if (result > 0) {
        await init();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting note: $e');
      return false;
    }
  }

  /// Xóa cache của một ghi chú cụ thể
  void clearNoteCache(int noteId) {
    _decryptedTitleCache.remove(noteId);
    _decryptedPreviewCache.remove(noteId);
    _recentlyAccessedNotes.remove(noteId);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    clearAllCache();
    super.dispose();
  }
}
