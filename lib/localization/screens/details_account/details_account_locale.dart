import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/details_account_text.dart';

class DetailsAccountLocale extends BaseLocale {
  final AppLocale appLocale;

  DetailsAccountLocale(this.appLocale);

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
  Map<String, String> get vi => {
    DetailsAccountText.editAccount: "Chỉnh sửa tài khoản",
    DetailsAccountText.deleteAccount: "Xóa tài khoản",
    DetailsAccountText.copy: "Sao chép",
    DetailsAccountText.show: "Hiển thị",
    DetailsAccountText.hide: "Ẩn",
    DetailsAccountText.copied: "Đã sao chép",
    DetailsAccountText.deleteConfirmation: "Xóa tài khoản",
    DetailsAccountText.deleteAccountQuestion: "Bạn có chắc chắn muốn xóa tài khoản này không?",
    DetailsAccountText.otpCode: "Mã OTP",
    DetailsAccountText.baseInfo: "Thông tin cơ bản",
    DetailsAccountText.category: "Danh mục",
    DetailsAccountText.note: "Ghi chú",
    DetailsAccountText.customFields: "Trường tùy chỉnh",
    DetailsAccountText.passwordHistory: "Lịch sử mật khẩu",
    DetailsAccountText.updatedAt: "Cập nhật lần cuối",
    DetailsAccountText.cancel: "Hủy bỏ",
    DetailsAccountText.confirm: "Xác nhận",
    DetailsAccountText.username: "Tên tài khoản",
    DetailsAccountText.password: "Mật khẩu",
    DetailsAccountText.email: "Email",
    DetailsAccountText.passwordHistoryDetail: "Chi tiết",
    DetailsAccountText.passwordHistoryTitle: "Lịch sử mật khẩu",
  };

  @override
  Map<String, String> get en => {
    DetailsAccountText.editAccount: "Edit Account",
    DetailsAccountText.deleteAccount: "Delete Account",
    DetailsAccountText.copy: "Copy",
    DetailsAccountText.show: "Show",
    DetailsAccountText.hide: "Hide",
    DetailsAccountText.copied: "Copied",
    DetailsAccountText.deleteConfirmation: "Delete Account",
    DetailsAccountText.deleteAccountQuestion: "Are you sure you want to delete this account?",
    DetailsAccountText.otpCode: "OTP Code",
    DetailsAccountText.baseInfo: "Base Info",
    DetailsAccountText.category: "Category",
    DetailsAccountText.note: "Note",
    DetailsAccountText.customFields: "Custom Fields",
    DetailsAccountText.passwordHistory: "Password History",
    DetailsAccountText.updatedAt: "Updated At",
    DetailsAccountText.cancel: "Cancel",
    DetailsAccountText.confirm: "Confirm",
    DetailsAccountText.passwordHistoryTitle: "Password History",
    DetailsAccountText.username: "Username",
    DetailsAccountText.password: "Password",
    DetailsAccountText.email: "Email",
    DetailsAccountText.passwordHistoryDetail: "Details",
  };

  @override
  Map<String, String> get pt => {
    DetailsAccountText.editAccount: "Editar conta",
    DetailsAccountText.deleteAccount: "Eliminar conta",
    DetailsAccountText.copy: "Copiar",
    DetailsAccountText.show: "Mostrar",
    DetailsAccountText.hide: "Ocultar",
    DetailsAccountText.copied: "Copiado",
    DetailsAccountText.deleteConfirmation: "Eliminar conta",
    DetailsAccountText.deleteAccountQuestion: "¿Estás seguro de querer eliminar esta cuenta?",
    DetailsAccountText.otpCode: "Código OTP",
    DetailsAccountText.baseInfo: "Información básica",
    DetailsAccountText.category: "Categoría",
    DetailsAccountText.note: "Nota",
    DetailsAccountText.customFields: "Campos personalizados",
    DetailsAccountText.passwordHistory: "Historial de contraseñas",
    DetailsAccountText.updatedAt: "Última actualización",
    DetailsAccountText.cancel: "Cancelar",
    DetailsAccountText.confirm: "Confirmar",
    DetailsAccountText.passwordHistoryTitle: "Historial de contraseñas",
    DetailsAccountText.username: "Nombre de usuario",
    DetailsAccountText.password: "Contraseña",
    DetailsAccountText.email: "Correo electrónico",
    DetailsAccountText.passwordHistoryDetail: "Detalles",
  };

  @override
  Map<String, String> get hi => {
    DetailsAccountText.editAccount: "खाता संपादित करें",
    DetailsAccountText.deleteAccount: "खाता हटाएं",
    DetailsAccountText.copy: "प्रतिलिपि बनाएं",
    DetailsAccountText.show: "दिखाएं",
    DetailsAccountText.hide: "छिपाएं",
    DetailsAccountText.copied: "प्रतिलिपि बनाई गई",
    DetailsAccountText.deleteConfirmation: "खाता हटाएं",
    DetailsAccountText.deleteAccountQuestion: "क्या आप वाकई इस खाते को हटाना चाहते हैं?",
    DetailsAccountText.otpCode: "OTP कोड",
    DetailsAccountText.baseInfo: "आधार जानकारी",
    DetailsAccountText.category: "श्रेणी",
    DetailsAccountText.note: "नोट",
    DetailsAccountText.customFields: "विशेष क्षेत्र",
    DetailsAccountText.passwordHistory: "पासवर्ड इतिहास",
    DetailsAccountText.updatedAt: "अंतिम अपडेट",
    DetailsAccountText.cancel: "रद्द करें",
    DetailsAccountText.confirm: "सुनिश्चित करें",
    DetailsAccountText.passwordHistoryTitle: "पासवर्ड इतिहास",
    DetailsAccountText.username: "उपयोगकर्ता नाम",
    DetailsAccountText.password: "पासवर्ड",
    DetailsAccountText.email: "ईमेल",
    DetailsAccountText.passwordHistoryDetail: "विवरण",
  };

  @override
  Map<String, String> get ja => {
    DetailsAccountText.editAccount: "アカウントを編集",
    DetailsAccountText.deleteAccount: "アカウントを削除",
    DetailsAccountText.copy: "コピー",
    DetailsAccountText.show: "表示",
    DetailsAccountText.hide: "非表示",
    DetailsAccountText.copied: "コピーされました",
    DetailsAccountText.deleteConfirmation: "アカウントを削除",
    DetailsAccountText.deleteAccountQuestion: "本当にこのアカウントを削除しますか？",
    DetailsAccountText.otpCode: "OTPコード",
    DetailsAccountText.baseInfo: "基本情報",
    DetailsAccountText.category: "カテゴリ",
    DetailsAccountText.note: "ノート",
    DetailsAccountText.customFields: "カスタムフィールド",
    DetailsAccountText.passwordHistory: "パスワード履歴",
    DetailsAccountText.updatedAt: "最終更新日",
    DetailsAccountText.cancel: "キャンセル",
    DetailsAccountText.confirm: "確認",
    DetailsAccountText.passwordHistoryTitle: "パスワード履歴",
    DetailsAccountText.username: "ユーザー名",
    DetailsAccountText.password: "パスワード",
    DetailsAccountText.email: "メール",
    DetailsAccountText.passwordHistoryDetail: "詳細",
  };

  @override
  Map<String, String> get ru => {
    DetailsAccountText.editAccount: "Редактировать учетную запись",
    DetailsAccountText.deleteAccount: "Удалить учетную запись",
    DetailsAccountText.copy: "Копировать",
    DetailsAccountText.show: "Показать",
    DetailsAccountText.hide: "Скрыть",
    DetailsAccountText.copied: "Скопировано",
    DetailsAccountText.deleteConfirmation: "Удалить учетную запись",
    DetailsAccountText.deleteAccountQuestion: "Вы уверены, что хотите удалить эту учетную запись?",
    DetailsAccountText.otpCode: "OTP код",
    DetailsAccountText.baseInfo: "Основная информация",
    DetailsAccountText.category: "Категория",
    DetailsAccountText.note: "Заметка",
    DetailsAccountText.customFields: "Пользовательские поля",
    DetailsAccountText.passwordHistory: "История паролей",
    DetailsAccountText.updatedAt: "Последнее обновление",
    DetailsAccountText.cancel: "Отмена",
    DetailsAccountText.confirm: "Подтвердить",
    DetailsAccountText.passwordHistoryTitle: "История паролей",
    DetailsAccountText.username: "Имя пользователя",
    DetailsAccountText.password: "Пароль",
    DetailsAccountText.email: "Электронная почта",
    DetailsAccountText.passwordHistoryDetail: "Детали",
  };

  @override
  Map<String, String> get id => {
    DetailsAccountText.editAccount: "Edit Akun",
    DetailsAccountText.deleteAccount: "Hapus Akun",
    DetailsAccountText.copy: "Salin",
    DetailsAccountText.show: "Tampilkan",
    DetailsAccountText.hide: "Sembunyikan",
    DetailsAccountText.copied: "Disalin",
    DetailsAccountText.deleteConfirmation: "Hapus Akun",
    DetailsAccountText.deleteAccountQuestion: "Apakah Anda yakin ingin menghapus akun ini?",
    DetailsAccountText.otpCode: "Kode OTP",
    DetailsAccountText.baseInfo: "Informasi Dasar",
    DetailsAccountText.category: "Kategori",
    DetailsAccountText.note: "Catatan",
    DetailsAccountText.customFields: "Bidang Pribadi",
    DetailsAccountText.passwordHistory: "Riwayat Password",
    DetailsAccountText.updatedAt: "Terakhir Diperbarui",
    DetailsAccountText.cancel: "Batal",
    DetailsAccountText.confirm: "Konfirmasi",
    DetailsAccountText.passwordHistoryTitle: "Riwayat Password",
    DetailsAccountText.username: "Nama Pengguna",
    DetailsAccountText.password: "Kata Sandi",
    DetailsAccountText.email: "Email",
    DetailsAccountText.passwordHistoryDetail: "Detail",
  };
}
