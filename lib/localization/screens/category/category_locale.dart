import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/category_text.dart';

class CategoryLocale extends BaseLocale {
  final AppLocale appLocale;

  CategoryLocale(this.appLocale);

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
    CategoryText.title: 'Quản lý danh mục',
    CategoryText.deleteCategory: 'Xoá danh mục',
    CategoryText.confirmDelete: 'Xác nhận xoá',
    CategoryText.cancelDelete: 'Huỷ',
    CategoryText.deleteConfirmation: 'Bạn có chắc chắn muốn xoá danh mục này?',
    CategoryText.deleteWarningWithAccounts: 'Danh mục này có tài khoản. Nếu xóa, tất cả tài khoản trong danh mục này sẽ bị xóa.',
    CategoryText.deleteWarningEmpty: 'Bạn có chắc chắn muốn xoá danh mục này?',
    CategoryText.categoryCount: '{0} mục',
    CategoryText.createCategory: 'Tạo danh mục',
    CategoryText.editCategory: 'Sửa danh mục',
    CategoryText.categoryName: 'Tên danh mục',
    CategoryText.categoryIcon: 'Icon danh mục',
    CategoryText.cancel: 'Huỷ',
    CategoryText.bank: '💰 Tài chính',
    CategoryText.job: '💼 Công việc',
    CategoryText.study: '🎓 Học tập',
    CategoryText.shopping: '🛍️ Mua sắm',
    CategoryText.entertainment: '🎮 Giải trí',
    CategoryText.other: '🔍 Khác',
    CategoryText.updateCategory: 'Cập nhật danh mục',
  };

  @override
  Map<String, String> get en => {
    CategoryText.title: 'Category Manager',
    CategoryText.deleteCategory: 'Delete Category',
    CategoryText.confirmDelete: 'Confirm Delete',
    CategoryText.cancelDelete: 'Cancel',
    CategoryText.deleteConfirmation: 'Are you sure you want to delete this category?',
    CategoryText.deleteWarningWithAccounts: 'This category has accounts. If deleted, all accounts in this category will be deleted.',
    CategoryText.deleteWarningEmpty: 'Are you sure you want to delete this category?',
    CategoryText.categoryCount: '{0} items',
    CategoryText.createCategory: 'Create Category',
    CategoryText.editCategory: 'Edit Category',
    CategoryText.categoryName: 'Category Name',
    CategoryText.categoryIcon: 'Category Icon',
    CategoryText.cancel: 'Cancel',
    CategoryText.bank: '💰 Finance',
    CategoryText.job: '💼 Works',
    CategoryText.study: '🎓 Education',
    CategoryText.shopping: '🛍️ Shopping',
    CategoryText.entertainment: '🎮 Entertainment',
    CategoryText.other: '🔍 Other',
    CategoryText.updateCategory: 'Update Category',
  };

  @override
  Map<String, String> get pt => {
    CategoryText.title: 'Gerenciador de Categorias',
    CategoryText.deleteCategory: 'Excluir Categoria',
    CategoryText.confirmDelete: 'Confirmar Exclusão',
    CategoryText.cancelDelete: 'Cancelar',
    CategoryText.deleteConfirmation: 'Tem certeza que deseja excluir esta categoria?',
    CategoryText.deleteWarningWithAccounts: 'Esta categoria possui contas. Se excluída, todas as contas nesta categoria serão excluídas.',
    CategoryText.deleteWarningEmpty: 'Tem certeza que deseja excluir esta categoria?',
    CategoryText.categoryCount: '{0} itens',
    CategoryText.createCategory: 'Criar Categoria',
    CategoryText.editCategory: 'Editar Categoria',
    CategoryText.categoryName: 'Nome da Categoria',
    CategoryText.categoryIcon: 'Ícone da Categoria',
    CategoryText.cancel: 'Cancelar',

    //pt lang
    CategoryText.bank: '💰 Finance',
    CategoryText.job: '💼 Works',
    CategoryText.study: '🎓 Education',
    CategoryText.shopping: '🛍️ Shopping',
    CategoryText.entertainment: '🎮 Entertainment',
    CategoryText.other: '🔍 Other',

    CategoryText.updateCategory: 'Atualizar Categoria',
  };

  @override
  Map<String, String> get hi => {
    CategoryText.title: 'श्रेणी प्रबंधक',
    CategoryText.deleteCategory: 'श्रेणी हटाएं',
    CategoryText.confirmDelete: 'हटाने की पुष्टि करें',
    CategoryText.cancelDelete: 'रद्द करें',
    CategoryText.deleteConfirmation: 'क्या आप वाकई इस श्रेणी को हटाना चाहते हैं?',
    CategoryText.deleteWarningWithAccounts: 'इस श्रेणी में खाते हैं। यदि हटा दिया गया, तो इस श्रेणी के सभी खाते हटा दिए जाएंगे।',
    CategoryText.deleteWarningEmpty: 'क्या आप वाकई इस श्रेणी को हटाना चाहते हैं?',
    CategoryText.categoryCount: '{0} आइटम',
    CategoryText.createCategory: 'श्रेणी बनाएं',
    CategoryText.editCategory: 'श्रेणी संपादित करें',
    CategoryText.categoryName: 'श्रेणी का नाम',
    CategoryText.categoryIcon: 'श्रेणी आइकन',
    CategoryText.cancel: 'रद्द करें',
    //hi lang
    CategoryText.bank: '💰 वित्त',
    CategoryText.job: '💼 कार्य',
    CategoryText.study: '🎓 शिक्षा',
    CategoryText.shopping: '🛍️ खरीदारी',
    CategoryText.entertainment: '🎮 मनोरंजन',
    CategoryText.other: '🔍 अन्य',

    CategoryText.updateCategory: 'श्रेणी अपडेट करें',
  };

  @override
  Map<String, String> get ja => {
    CategoryText.title: 'カテゴリマネージャー',
    CategoryText.deleteCategory: 'カテゴリを削除',
    CategoryText.confirmDelete: '削除を確認',
    CategoryText.cancelDelete: 'キャンセル',
    CategoryText.deleteConfirmation: 'このカテゴリを削除してもよろしいですか？',
    CategoryText.deleteWarningWithAccounts: 'このカテゴリにはアカウントがあります。削除すると、このカテゴリのすべてのアカウントが削除されます。',
    CategoryText.deleteWarningEmpty: 'このカテゴリを削除してもよろしいですか？',
    CategoryText.categoryCount: '{0} アイテム',
    CategoryText.createCategory: 'カテゴリを作成',
    CategoryText.editCategory: 'カテゴリを編集',
    CategoryText.categoryName: 'カテゴリ名',
    CategoryText.categoryIcon: 'カテゴリアイコン',
    CategoryText.cancel: 'キャンセル',

    //ja lang
    CategoryText.bank: '💰 銀行',
    CategoryText.job: '💼 仕事',
    CategoryText.study: '🎓 勉強',
    CategoryText.shopping: '🛍️ 買い物',
    CategoryText.entertainment: '🎮 楽しい',
    CategoryText.other: '🔍 その他',

    CategoryText.updateCategory: 'カテゴリを更新',
  };

  @override
  Map<String, String> get ru => {
    CategoryText.title: 'Управление категориями',
    CategoryText.deleteCategory: 'Удалить категорию',
    CategoryText.confirmDelete: 'Подтвердить удаление',
    CategoryText.cancelDelete: 'Отмена',
    CategoryText.deleteConfirmation: 'Вы уверены, что хотите удалить эту категорию?',
    CategoryText.deleteWarningWithAccounts: 'В этой категории есть учетные записи. При удалении все учетные записи в этой категории будут удалены.',
    CategoryText.deleteWarningEmpty: 'Вы уверены, что хотите удалить эту категорию?',
    CategoryText.categoryCount: '{0} элементов',
    CategoryText.createCategory: 'Создать категорию',
    CategoryText.editCategory: 'Редактировать категорию',
    CategoryText.categoryName: 'Название категории',
    CategoryText.categoryIcon: 'Значок категории',
    CategoryText.cancel: 'Отмена',
    //ru lang
    CategoryText.bank: '💰 Банк',
    CategoryText.job: '💼 Работа',
    CategoryText.study: '🎓 Учеба',
    CategoryText.shopping: '🛍️ Покупки',
    CategoryText.entertainment: '🎮 Развлечения',
    CategoryText.other: '🔍 Другое',
    CategoryText.updateCategory: 'Обновить категорию',
  };

  @override
  Map<String, String> get id => {
    CategoryText.title: 'Pengelola Kategori',
    CategoryText.deleteCategory: 'Hapus Kategori',
    CategoryText.confirmDelete: 'Konfirmasi Hapus',
    CategoryText.cancelDelete: 'Batal',
    CategoryText.deleteConfirmation: 'Apakah Anda yakin ingin menghapus kategori ini?',
    CategoryText.deleteWarningWithAccounts: 'Kategori ini memiliki akun. Jika dihapus, semua akun dalam kategori ini akan dihapus.',
    CategoryText.deleteWarningEmpty: 'Apakah Anda yakin ingin menghapus kategori ini?',
    CategoryText.categoryCount: '{0} item',
    CategoryText.createCategory: 'Buat Kategori',
    CategoryText.editCategory: 'Edit Kategori',
    CategoryText.categoryName: 'Nama Kategori',
    CategoryText.categoryIcon: 'Ikon Kategori',
    CategoryText.cancel: 'Batal',
    //id lang
    CategoryText.bank: '💰 Keuangan',
    CategoryText.job: '💼 Pekerjaan',
    CategoryText.study: '🎓 Belajar',
    CategoryText.shopping: '🛍️ Belanja',
    CategoryText.entertainment: '🎮 Hiburan',
    CategoryText.other: '🔍 Lainnya',
    CategoryText.updateCategory: 'Perbarui Kategori',
  };

  @override
  Map<String, String> get tr => {
    CategoryText.title: 'Kategori Yöneticisi',
    CategoryText.deleteCategory: 'Kategori Sil',
    CategoryText.confirmDelete: 'Silmeyi Onayla',
    CategoryText.cancelDelete: 'İptal',
    CategoryText.deleteConfirmation: 'Bu kategoriyi silmek istediğinize emin misiniz?',
    CategoryText.deleteWarningWithAccounts: 'Bu kategoriye hesaplarınız var. Silindiğinde, bu kategoriye ait tüm hesaplar silinecektir.',
    CategoryText.deleteWarningEmpty: 'Bu kategoriyi silmek istediğinize emin misiniz?',
    CategoryText.categoryCount: '{0} öğe',
    CategoryText.createCategory: 'Kategori Oluştur',
    CategoryText.editCategory: 'Kategori Düzenle',
    CategoryText.categoryName: 'Kategori Adı',

    CategoryText.updateCategory: 'Kategori Güncelle',
    CategoryText.cancel: 'İptal',
    CategoryText.bank: '💰 Finans',
    CategoryText.job: '💼 İş',
    CategoryText.study: '🎓 Eğitim',
    CategoryText.shopping: '🛍️ Alışveriş',
    CategoryText.entertainment: '🎮 Eğlence',
    CategoryText.other: '🔍 Diğer',
    CategoryText.categoryIcon: 'Kategori Simgesi',
  };

}
