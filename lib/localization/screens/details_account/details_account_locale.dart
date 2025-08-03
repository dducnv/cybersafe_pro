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
    DetailsAccountText.otpCode: "Mã xác thực",
    DetailsAccountText.baseInfo: "Thông tin tài khoản",
    DetailsAccountText.category: "Danh mục",
    DetailsAccountText.note: "Ghi chú",
    DetailsAccountText.customFields: "Thông tin bổ sung",
    DetailsAccountText.passwordHistory: "Lịch sử thay đổi mật khẩu",
    DetailsAccountText.updatedAt: "Cập nhật gần nhất",
    DetailsAccountText.cancel: "Hủy bỏ",
    DetailsAccountText.confirm: "Xác nhận",
    DetailsAccountText.username: "Tên tài khoản",
    DetailsAccountText.password: "Mật khẩu",
    DetailsAccountText.email: "Email",
    DetailsAccountText.passwordHistoryDetail: "Chi tiết",
    DetailsAccountText.passwordHistoryTitle: "Lịch sử thay đổi mật khẩu",
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
    DetailsAccountText.otpCode: "Authentication Code",
    DetailsAccountText.baseInfo: "Account Information",
    DetailsAccountText.category: "Category",
    DetailsAccountText.note: "Note",
    DetailsAccountText.customFields: "Additional Information",
    DetailsAccountText.passwordHistory: "Password Change History",
    DetailsAccountText.updatedAt: "Last Updated",
    DetailsAccountText.cancel: "Cancel",
    DetailsAccountText.confirm: "Confirm",
    DetailsAccountText.username: "Account Name",
    DetailsAccountText.password: "Password",
    DetailsAccountText.email: "Email",
    DetailsAccountText.passwordHistoryDetail: "Details",
    DetailsAccountText.passwordHistoryTitle: "Password Change History",
  };

  @override
  Map<String, String> get pt => {
    DetailsAccountText.editAccount: "Editar Conta",
    DetailsAccountText.deleteAccount: "Excluir Conta",
    DetailsAccountText.copy: "Copiar",
    DetailsAccountText.show: "Mostrar",
    DetailsAccountText.hide: "Ocultar",
    DetailsAccountText.copied: "Copiado",
    DetailsAccountText.deleteConfirmation: "Excluir Conta",
    DetailsAccountText.deleteAccountQuestion: "Tem certeza de que deseja excluir esta conta?",
    DetailsAccountText.otpCode: "Código de autenticação",
    DetailsAccountText.baseInfo: "Informações da Conta",
    DetailsAccountText.category: "Categoria",
    DetailsAccountText.note: "Nota",
    DetailsAccountText.customFields: "Informações adicionais",
    DetailsAccountText.passwordHistory: "Histórico de alteração de senha",
    DetailsAccountText.updatedAt: "Última atualização",
    DetailsAccountText.cancel: "Cancelar",
    DetailsAccountText.confirm: "Confirmar",
    DetailsAccountText.username: "Nome da Conta",
    DetailsAccountText.password: "Senha",
    DetailsAccountText.email: "Email",
    DetailsAccountText.passwordHistoryDetail: "Detalhes",
    DetailsAccountText.passwordHistoryTitle: "Histórico de alteração de senha",
  };

  @override
  Map<String, String> get hi => {
    DetailsAccountText.editAccount: "खाता संपादित करें",
    DetailsAccountText.deleteAccount: "खाता हटाएं",
    DetailsAccountText.copy: "कॉपी करें",
    DetailsAccountText.show: "दिखाएँ",
    DetailsAccountText.hide: "छिपाएँ",
    DetailsAccountText.copied: "कॉपी किया गया",
    DetailsAccountText.deleteConfirmation: "खाता हटाएं",
    DetailsAccountText.deleteAccountQuestion: "क्या आप वाकई इस खाते को हटाना चाहते हैं?",
    DetailsAccountText.otpCode: "प्रमाणीकरण कोड",
    DetailsAccountText.baseInfo: "खाता जानकारी",
    DetailsAccountText.category: "श्रेणी",
    DetailsAccountText.note: "नोट",
    DetailsAccountText.customFields: "अतिरिक्त जानकारी",
    DetailsAccountText.passwordHistory: "पासवर्ड परिवर्तन इतिहास",
    DetailsAccountText.updatedAt: "अंतिम अपडेट",
    DetailsAccountText.cancel: "रद्द करें",
    DetailsAccountText.confirm: "पुष्टि करें",
    DetailsAccountText.username: "खाता नाम",
    DetailsAccountText.password: "पासवर्ड",
    DetailsAccountText.email: "ईमेल",
    DetailsAccountText.passwordHistoryDetail: "विवरण",
    DetailsAccountText.passwordHistoryTitle: "पासवर्ड परिवर्तन इतिहास",
  };

  @override
  Map<String, String> get ja => {
    DetailsAccountText.editAccount: "アカウント編集",
    DetailsAccountText.deleteAccount: "アカウント削除",
    DetailsAccountText.copy: "コピー",
    DetailsAccountText.show: "表示",
    DetailsAccountText.hide: "非表示",
    DetailsAccountText.copied: "コピー済み",
    DetailsAccountText.deleteConfirmation: "アカウント削除",
    DetailsAccountText.deleteAccountQuestion: "本当にこのアカウントを削除しますか？",
    DetailsAccountText.otpCode: "認証コード",
    DetailsAccountText.baseInfo: "アカウント情報",
    DetailsAccountText.category: "カテゴリ",
    DetailsAccountText.note: "メモ",
    DetailsAccountText.customFields: "追加情報",
    DetailsAccountText.passwordHistory: "パスワード変更履歴",
    DetailsAccountText.updatedAt: "最終更新",
    DetailsAccountText.cancel: "キャンセル",
    DetailsAccountText.confirm: "確認",
    DetailsAccountText.username: "アカウント名",
    DetailsAccountText.password: "パスワード",
    DetailsAccountText.email: "メール",
    DetailsAccountText.passwordHistoryDetail: "詳細",
    DetailsAccountText.passwordHistoryTitle: "パスワード変更履歴",
  };

  @override
  Map<String, String> get ru => {
    DetailsAccountText.editAccount: "Редактировать аккаунт",
    DetailsAccountText.deleteAccount: "Удалить аккаунт",
    DetailsAccountText.copy: "Копировать",
    DetailsAccountText.show: "Показать",
    DetailsAccountText.hide: "Скрыть",
    DetailsAccountText.copied: "Скопировано",
    DetailsAccountText.deleteConfirmation: "Удалить аккаунт",
    DetailsAccountText.deleteAccountQuestion: "Вы уверены, что хотите удалить этот аккаунт?",
    DetailsAccountText.otpCode: "Код аутентификации",
    DetailsAccountText.baseInfo: "Информация об аккаунте",
    DetailsAccountText.category: "Категория",
    DetailsAccountText.note: "Заметка",
    DetailsAccountText.customFields: "Дополнительная информация",
    DetailsAccountText.passwordHistory: "История изменения пароля",
    DetailsAccountText.updatedAt: "Последнее обновление",
    DetailsAccountText.cancel: "Отмена",
    DetailsAccountText.confirm: "Подтвердить",
    DetailsAccountText.username: "Имя аккаунта",
    DetailsAccountText.password: "Пароль",
    DetailsAccountText.email: "Электронная почта",
    DetailsAccountText.passwordHistoryDetail: "Детали",
    DetailsAccountText.passwordHistoryTitle: "История изменения пароля",
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
    DetailsAccountText.otpCode: "Kode autentikasi",
    DetailsAccountText.baseInfo: "Informasi Akun",
    DetailsAccountText.category: "Kategori",
    DetailsAccountText.note: "Catatan",
    DetailsAccountText.customFields: "Informasi tambahan",
    DetailsAccountText.passwordHistory: "Riwayat perubahan kata sandi",
    DetailsAccountText.updatedAt: "Terakhir diperbarui",
    DetailsAccountText.cancel: "Batal",
    DetailsAccountText.confirm: "Setuju",
    DetailsAccountText.username: "Nama Akun",
    DetailsAccountText.password: "Kata Sandi",
    DetailsAccountText.email: "Email",
    DetailsAccountText.passwordHistoryDetail: "Detail",
    DetailsAccountText.passwordHistoryTitle: "Riwayat perubahan kata sandi",
  };

  @override
  Map<String, String> get tr => {
    DetailsAccountText.editAccount: "Hesabı Düzenle",
    DetailsAccountText.deleteAccount: "Hesabı Sil",
    DetailsAccountText.copy: "Kopyala",
    DetailsAccountText.show: "Göster",
    DetailsAccountText.hide: "Gizle",
    DetailsAccountText.copied: "Kopyalandı",
    DetailsAccountText.deleteConfirmation: "Hesabı Sil",
    DetailsAccountText.deleteAccountQuestion: "Bu hesabı silmek istediğinizden emin misiniz?",
    DetailsAccountText.otpCode: "Doğrulama Kodu",
    DetailsAccountText.baseInfo: "Hesap Bilgileri",
    DetailsAccountText.category: "Kategori",
    DetailsAccountText.note: "Not",
    DetailsAccountText.customFields: "Ek bilgi",
    DetailsAccountText.passwordHistory: "Şifre Değişiklik Geçmişi",
    DetailsAccountText.updatedAt: "Son Güncelleme",
    DetailsAccountText.cancel: "İptal",
    DetailsAccountText.confirm: "Onayla",
    DetailsAccountText.username: "Hesap Adı",
    DetailsAccountText.password: "Şifre",
    DetailsAccountText.email: "E-posta",
    DetailsAccountText.passwordHistoryDetail: "Detaylar",
    DetailsAccountText.passwordHistoryTitle: "Şifre Değişiklik Geçmişi",
  };

  @override
  // TODO: implement es
  Map<String, String> get es => {
    DetailsAccountText.editAccount: 'Editar cuenta',
    DetailsAccountText.deleteAccount: 'Eliminar cuenta',
    DetailsAccountText.copy: 'Copiar',
    DetailsAccountText.show: 'Mostrar',
    DetailsAccountText.hide: 'Ocultar',
    DetailsAccountText.copied: 'Copiado',
    DetailsAccountText.deleteConfirmation: 'Eliminar cuenta',
    DetailsAccountText.deleteAccountQuestion: '¿Estás seguro de que deseas eliminar esta cuenta?',
    DetailsAccountText.otpCode: 'Código de autenticación',
    DetailsAccountText.baseInfo: 'Información de la cuenta',
    DetailsAccountText.category: 'Categoría',
    DetailsAccountText.note: 'Nota',
    DetailsAccountText.customFields: 'Información adicional',
    DetailsAccountText.passwordHistory: 'Historial de contraseñas',
    DetailsAccountText.updatedAt: 'Última actualización',
    DetailsAccountText.cancel: 'Cancelar',
    DetailsAccountText.confirm: 'Confirmar',
    DetailsAccountText.username: 'Nombre de la cuenta',
    DetailsAccountText.password: 'Contraseña',
    DetailsAccountText.email: 'Correo electrónico',
    DetailsAccountText.passwordHistoryDetail: 'Detalles',
    DetailsAccountText.passwordHistoryTitle: 'Historial de contraseñas',
  };
}
