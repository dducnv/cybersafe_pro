import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/note_text.dart';

class TextNoteLocale extends BaseLocale {
  final AppLocale appLocale;

  TextNoteLocale(this.appLocale);

  @override
  String get languageCode => appLocale.currentLocaleModel.languageCode;
  @override
  String get countryCode => appLocale.currentLocaleModel.countryCode;
  @override
  String get languageName => appLocale.currentLocaleModel.languageName;
  @override
  String get languageNativeName => appLocale.currentLocaleModel.languageNativeName;
  @override
  String get flagEmoji => appLocale.currentLocaleModel.flagEmoji;

  @override
  Map<String, String> get en => {
    NoteText.title: "Title",
    NoteText.notes: "Notes",
    NoteText.note: "Note",
    NoteText.delete: "Delete",
    NoteText.deleteTitle: "Delete note",
    NoteText.confirmDelete: "Delete",
    NoteText.cancelDelete: "Cancel",
    NoteText.deleteConfirmation: "Are you sure you want to delete this note?",
    NoteText.deleteManyConfirmation: "Are you sure you want to delete [number] notes?",
    NoteText.selectNote: "Select Note",
    NoteText.choseNoteColor: "Chose note color",
  };

  @override
  Map<String, String> get es => {
    NoteText.title: "Título",
    NoteText.notes: "Notas",
    NoteText.note: "Nota",
    NoteText.delete: "Eliminar",
    NoteText.deleteTitle: "Eliminar nota",
    NoteText.confirmDelete: "Eliminar",
    NoteText.cancelDelete: "Cancelar",
    NoteText.deleteConfirmation: "¿Estás seguro de querer eliminar esta nota?",
    NoteText.deleteManyConfirmation: "¿Estás seguro de querer eliminar [number] notas?",
    NoteText.selectNote: "Seleccionar nota",
    NoteText.choseNoteColor: "Elegir color de nota",
  };

  @override
  Map<String, String> get hi => {
    NoteText.title: "शीर्षक",
    NoteText.notes: "नोट्स",
    NoteText.note: "नोट",
    NoteText.delete: "हटाएं",
    NoteText.deleteTitle: "नोट हटाएं",
    NoteText.confirmDelete: "हटाएं",
    NoteText.cancelDelete: "रद्द करें",
    NoteText.deleteConfirmation: "क्या आप इस नोट को हटाना चाहते हैं?",
    NoteText.deleteManyConfirmation: "क्या आप [number] नोट हटाना चाहते हैं?",
    NoteText.selectNote: "नोट चुनें",
    NoteText.choseNoteColor: "नोट का रंग चुनें",
  };

  @override
  Map<String, String> get id => {
    NoteText.title: "Judul",
    NoteText.notes: "Catatan",
    NoteText.note: "Catatan",
    NoteText.delete: "Hapus",
    NoteText.deleteTitle: "Hapus Catatan",
    NoteText.confirmDelete: "Hapus",
    NoteText.cancelDelete: "Batal",
    NoteText.deleteConfirmation: "Apakah Anda yakin ingin menghapus catatan ini?",
    NoteText.deleteManyConfirmation: "Apakah Anda yakin ingin menghapus [number] catatan?",
    NoteText.selectNote: "Pilih catatan",
    NoteText.choseNoteColor: "Pilih warna catatan",
  };

  @override
  Map<String, String> get ja => {
    NoteText.title: "タイトル",
    NoteText.notes: "ノート",
    NoteText.note: "ノート",
    NoteText.delete: "削除",
    NoteText.deleteTitle: "ノートを削除",
    NoteText.confirmDelete: "削除",
    NoteText.cancelDelete: "キャンセル",
    NoteText.deleteConfirmation: "このノートを削除してもよろしいですか？",
    NoteText.deleteManyConfirmation: "[number]件のノートを削除してもよろしいですか？",
    NoteText.selectNote: "ノートを選択",
    NoteText.choseNoteColor: "ノートの色を選択",
  };

  @override
  Map<String, String> get pt => {
    NoteText.title: "Título",
    NoteText.notes: "Notas",
    NoteText.note: "Nota",
    NoteText.deleteTitle: "Excluir nota",
    NoteText.delete: "Excluir",
    NoteText.confirmDelete: "Excluir",
    NoteText.cancelDelete: "Cancelar",
    NoteText.deleteConfirmation: "Tem certeza que deseja excluir esta nota?",
    NoteText.deleteManyConfirmation: "Tem certeza que deseja excluir [number] notas?",
    NoteText.selectNote: "Selecionar nota",
    NoteText.choseNoteColor: "Escolher cor da Nota",
  };

  @override
  Map<String, String> get ru => {
    NoteText.title: "Заголовок",
    NoteText.notes: "Заметки",
    NoteText.note: "Заметка",
    NoteText.delete: "Удалить",
    NoteText.deleteTitle: "Удалить заметку",
    NoteText.confirmDelete: "Удалить",
    NoteText.cancelDelete: "Отмена",
    NoteText.deleteConfirmation: "Вы уверены, что хотите удалить эту заметку?",
    NoteText.deleteManyConfirmation: "Вы уверены, что хотите удалить [number] заметок?",
    NoteText.selectNote: "Выбрать заметку",
    NoteText.choseNoteColor: "Выбрать цвет заметки",
  };

  @override
  Map<String, String> get tr => {
    NoteText.title: "Başlık",
    NoteText.notes: "Notlar",
    NoteText.note: "Not",
    NoteText.delete: "Sil",
    NoteText.deleteTitle: "Notu sil",
    NoteText.confirmDelete: "Sil",
    NoteText.cancelDelete: "İptal",
    NoteText.deleteConfirmation: "Bu notu silmek istediğinize emin misiniz?",
    NoteText.deleteManyConfirmation: "[number] notları silmek istediğinize emin misiniz?",
    NoteText.selectNote: "Not seç",
    NoteText.choseNoteColor: "Not rengini seç",
  };

  @override
  Map<String, String> get vi => {
    NoteText.title: "Tiêu đề",
    NoteText.notes: "Ghi chú",
    NoteText.note: "Ghi chú",
    NoteText.delete: "Xóa",
    NoteText.deleteTitle: "Xóa ghi chú",
    NoteText.confirmDelete: "Xóa",
    NoteText.cancelDelete: "Hủy",
    NoteText.deleteConfirmation: "Bạn có chắc chắn muốn xóa ghi chú này không?",
    NoteText.deleteManyConfirmation: "Bạn có chắc chắn muốn xóa [number] ghi chú không?",
    NoteText.selectNote: "Chọn ghi chú",
    NoteText.choseNoteColor: "Chọn màu ghi chú",
  };

  @override
  Map<String, String> get it => {
    NoteText.title: "Titolo",
    NoteText.notes: "Note", // "Note" (số nhiều)
    NoteText.note: "Nota", // "Nota" (số ít)
    NoteText.delete: "Elimina",
    NoteText.deleteTitle: "Elimina nota",
    NoteText.confirmDelete: "Elimina", // Nút xác nhận xóa
    NoteText.cancelDelete: "Annulla",
    NoteText.deleteConfirmation: "Sei sicuro di voler eliminare questa nota?",
    NoteText.deleteManyConfirmation:
        "Sei sicuro di voler eliminare [number] note?", // Giữ nguyên placeholder
    NoteText.selectNote: "Seleziona Nota",
    NoteText.choseNoteColor: "Scegli colore nota", // Dịch là "Choose note color" (Chọn màu ghi chú)
  };
}
