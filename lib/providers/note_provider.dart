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

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  int _currentFilterYear = DateTime.now().year;
  int get currentFilterYear => _currentFilterYear;

  int _currentFilterMonth = DateTime.now().month;
  int get currentFilterMonth => _currentFilterMonth;

  TextNotesDriftModelData? textNotesDriftModelData;
  final String titleDefault = formatDateTime(DateTime.now());

  final Map<int, List<TextNotesDriftModelData>> _groupedByDay = {};
  Map<int, List<TextNotesDriftModelData>> get groupedByDay => Map.unmodifiable(_groupedByDay);

  final Map<int, String> _decryptedTitleCache = {};
  final Map<int, String> _decryptedPreviewCache = {};
  static const int _maxCacheSize = 20;
  final List<int> _recentlyAccessedNotes = [];

  final List<int> _selectedNotes = [];
  List<int> get selectedNotes => _selectedNotes;

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

      final notes = await DriffDbManager.instance.textNotesAdapter.getByYearAndMonth(_currentFilterYear, _currentFilterMonth);
      notes.sort((a, b) => b.createdAt.day.compareTo(a.createdAt.day)); // Sort by createdAt descending
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
    clearAllCache();
    await init(isRefresh: true);
  }

  // Lấy nội dung preview từ chuỗi Delta JSON thô (chưa mã hoá)
  String getPlainText(String content) {
    if (content.isEmpty) return '';
    try {
      final document = Document.fromJson(jsonDecode(content));
      String plainText = document.toPlainText().replaceAll('\n', ' ').trim();
      return plainText.length > 150 ? '${plainText.substring(0, 150)}...' : plainText;
    } catch (e) {
      String plainText = content.replaceAll('\n', ' ').trim();
      return plainText.length > 150 ? '${plainText.substring(0, 150)}...' : plainText;
    }
  }

  // Lấy preview nội dung đã giải mã từ cache hoặc giải mã mới
  Future<String> getDecryptedPreview(int noteId, String? encryptedPreview, String? encryptedContent) async {
    // Kiểm tra cache trước
    if (_decryptedPreviewCache.containsKey(noteId)) {
      return _decryptedPreviewCache[noteId]!;
    }

    // Ưu tiên giải mã trường previewContent trước vì nó ngắn
    if (encryptedPreview != null && encryptedPreview.isNotEmpty) {
      final preview = await DataSecureService.decryptInfo(encryptedPreview);
      _addToCache(_decryptedPreviewCache, noteId, preview);
      return preview;
    }

    // Fallback cho người dùng cũ: Tải nội dung content, giải mã và trích xuất
    if (encryptedContent == null || encryptedContent.isEmpty) return '';
    final decryptedContent = await DataSecureService.decryptNote(encryptedContent);
    final previewFallback = getPlainText(decryptedContent);

    // Lưu vào cache
    _addToCache(_decryptedPreviewCache, noteId, previewFallback);
    return previewFallback;
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
    final preview = await getDecryptedPreview(note.id, note.previewContent, note.content);
    return NoteCardData(
      id: note.id,
      title: title,
      content: preview, // Chỉ lưu preview, không lưu toàn bộ nội dung đã giải mã
      time: DateFormat('HH:mm').format(note.updatedAt),
      updatedAt: note.updatedAt,
      color: getColorFromHex(note.color), // Thêm màu sắc của ghi chú
      isPinned: note.isPinned,
    );
  }

  /// Lấy danh sách NoteCardData đã giải mã cho một nhóm ghi chú
  Future<List<NoteCardData>> getDecryptedNoteCards(List<TextNotesDriftModelData> notes) async {
    final noteCards = await Future.wait(notes.map((note) => convertToNoteCard(note)), eagerError: true);

    // Sắp xếp: Pinned trước, sau đó theo thời gian cập nhật mới nhất
    noteCards.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
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

  String? _lastSavedTitle;
  bool _hasSignificantChanges = false;

  /// Gọi hàm này từ _NoteEditorState khi Quill thay đổi. KHÔNG được truyền content đã jsonEncode để tránh lag UI!
  void markAsDirty({String? title, required Document Function() getQuillDocument}) {
    // Chỉ đánh dấu cơ bản để gọi debounce, chưa encode JSON vội.
    _hasSignificantChanges = true;

    _debounce?.cancel();

    // Hiện indicator "Đang lưu..."
    _isSaving = true;
    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 1500), () async {
      await _executeSave(title: title, document: getQuillDocument());
    });
  }

  Future<void> _executeSave({String? title, required Document document}) async {
    final titleChanged = title != null && title != _lastSavedTitle;

    // Ngay lúc timer chạy, tiến hành Extract và JSON Serialize ngoài UI build loop
    final String contentRawJSON = jsonEncode(document.toDelta().toJson());
    final String plainTextChunk = document.toPlainText().replaceAll('\n', ' ').trim();
    final String parsedPreview = plainTextChunk.length > 150 ? '${plainTextChunk.substring(0, 150)}...' : plainTextChunk;

    if (noteId == null) {
      final titleSave = (title != null && title.isNotEmpty) ? title : titleDefault;
      final titleEncrypt = await DataSecureService.encryptInfo(titleSave);
      final previewEncrypt = await DataSecureService.encryptInfo(parsedPreview);
      final contentEncrypt = await DataSecureService.encryptNote(contentRawJSON);
      noteId = await insertNote(title: titleEncrypt, content: contentEncrypt, previewContent: previewEncrypt);

      if (noteId != null) {
        textNotesDriftModelData = await findById(noteId!);
        _lastSavedTitle = title;
      }
    } else if (_hasSignificantChanges || titleChanged) {
      await updateNote(title: title, contentRawJSON: contentRawJSON, parsedPreview: parsedPreview);

      _lastSavedTitle = title;
      _hasSignificantChanges = false;
    }

    _isSaving = false;

    if (_hasSignificantChanges || titleChanged || noteId != null) {
      await init();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<int> insertNote({required String title, required String content, required String previewContent}) async {
    final id = await DriffDbManager.instance.textNotesAdapter.insertNote(TextNotesDriftModelCompanion.insert(title: title, content: Value(content), previewContent: Value(previewContent)));
    return id;
  }

  Future<void> updateNote({String? title, required String contentRawJSON, required String parsedPreview}) async {
    if (textNotesDriftModelData == null) return;
    final titleSave = (title != null && title.isNotEmpty) ? title : titleDefault;
    final titleEncrypt = title != null ? await DataSecureService.encryptInfo(titleSave) : textNotesDriftModelData!.title;

    final previewEncrypt = await DataSecureService.encryptInfo(parsedPreview);
    final contentEncrypt = await DataSecureService.encryptNote(contentRawJSON);

    textNotesDriftModelData = textNotesDriftModelData!.copyWith(title: titleEncrypt, content: Value(contentEncrypt), previewContent: Value(previewEncrypt), updatedAt: DateTime.now());
    await DriffDbManager.instance.textNotesAdapter.update(textNotesDriftModelData!);
  }

  Future<TextNotesDriftModelData?> findById(int id) async {
    TextNotesDriftModelData? note = await DriffDbManager.instance.textNotesAdapter.getById(id);
    textNotesDriftModelData = note;
    noteId = note?.id;
    return note;
  }

  Future<void> updateColor(int id, String? color) async {
    try {
      // Cập nhật màu trong database
      await DriffDbManager.instance.textNotesAdapter.updateColor(id, color);

      // Cập nhật cache nếu có
      if (_groupedByDay.isNotEmpty) {
        for (final dayNotes in _groupedByDay.values) {
          final noteIndex = dayNotes.indexWhere((note) => note.id == id);
          if (noteIndex != -1) {
            dayNotes[noteIndex] = dayNotes[noteIndex].copyWith(color: Value(color));
            break;
          }
        }
      }

      // Xóa cache của note này để force rebuild NoteCard
      clearNoteCache(id);

      // Thông báo UI cập nhật
      notifyListeners();

      debugPrint('Updated color for note $id to $color');
    } catch (e) {
      debugPrint('Error updating note color: $e');
      rethrow;
    }
  }

  Future<void> togglePinNote(int id) async {
    try {
      final note = await DriffDbManager.instance.textNotesAdapter.getById(id);
      if (note != null) {
        final newIsPinned = !note.isPinned;
        final updatedNote = note.copyWith(isPinned: newIsPinned);
        await DriffDbManager.instance.textNotesAdapter.update(updatedNote);

        if (_groupedByDay.isNotEmpty) {
          for (final dayNotes in _groupedByDay.values) {
            final noteIndex = dayNotes.indexWhere((n) => n.id == id);
            if (noteIndex != -1) {
              dayNotes[noteIndex] = updatedNote;
              break;
            }
          }
        }

        clearNoteCache(id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling note pin status: $e');
      rethrow;
    }
  }

  void addSelectedNote(int id) {
    if (_selectedNotes.contains(id)) {
      _selectedNotes.remove(id);
    } else {
      _selectedNotes.add(id);
    }
    notifyListeners();
  }

  void clearSelectedNotes() {
    _selectedNotes.clear();
    notifyListeners();
  }

  void selectAllNotes() {
    _selectedNotes.clear();
    for (final dayNotes in _groupedByDay.values) {
      for (final note in dayNotes) {
        _selectedNotes.add(note.id);
      }
    }
    notifyListeners();
  }

  /// Xóa tất cả ghi chú đã chọn
  Future<bool> deleteSelectedNotes() async {
    if (_selectedNotes.isEmpty) return false;

    try {
      final selectedIds = List<int>.from(_selectedNotes);
      int deletedCount = 0;

      for (final id in selectedIds) {
        final result = await DriffDbManager.instance.textNotesAdapter.delete(id);
        if (result > 0) {
          deletedCount++;
          clearNoteCache(id);
        }
      }

      // Clear selection
      _selectedNotes.clear();

      // Refresh data if any notes were deleted
      if (deletedCount > 0) {
        await init();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting selected notes: $e');
      return false;
    }
  }

  /// Cập nhật màu cho tất cả ghi chú đã chọn
  Future<void> updateColorForSelectedNotes(String? color) async {
    if (_selectedNotes.isEmpty) return;

    try {
      final selectedIds = List<int>.from(_selectedNotes);

      for (final id in selectedIds) {
        await DriffDbManager.instance.textNotesAdapter.updateColor(id, color);

        // Cập nhật cache
        for (final dayNotes in _groupedByDay.values) {
          final noteIndex = dayNotes.indexWhere((note) => note.id == id);
          if (noteIndex != -1) {
            dayNotes[noteIndex] = dayNotes[noteIndex].copyWith(color: Value(color));
            break;
          }
        }

        // Xóa cache của note này để force rebuild NoteCard
        clearNoteCache(id);
      }

      // Clear selection sau khi cập nhật
      _selectedNotes.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating colors for selected notes: $e');
      rethrow;
    }
  }

  void clearValue() {
    noteId = null;
    textNotesDriftModelData = null;
  }

  void clearAllCache() {
    _selectedNotes.clear();
    _decryptedTitleCache.clear();
    _decryptedPreviewCache.clear();
    _recentlyAccessedNotes.clear();
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
