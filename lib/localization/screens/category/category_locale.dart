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
    CategoryText.deleteWarningWithAccounts:
        'Danh mục này đã có tài khoản. Nếu xóa, tất cả tài khoản trong danh mục này sẽ bị xóa.',
    CategoryText.deleteWarningEmpty: 'Bạn có chắc chắn muốn xoá danh mục này?',
    CategoryText.categoryCount: '{0} mục',
    CategoryText.createCategory: 'Tạo danh mục',
    CategoryText.editCategory: 'Sửa danh mục',
    CategoryText.categoryName: 'Tên danh mục',
    CategoryText.categoryIcon: 'Icon danh mục',
    CategoryText.cancel: 'Huỷ',
    CategoryText.bank: '💰 Ngân hàng',
    CategoryText.job: '💼 Công việc',
    CategoryText.study: '🎓 Học tập',
    CategoryText.shopping: '🛍️ Mua sắm',
    CategoryText.entertainment: '🎮 Giải trí',
    CategoryText.other: '🔍 Khác',
    CategoryText.updateCategory: 'Cập nhật danh mục',
  };

  @override
  Map<String, String> get en => {
    CategoryText.title: 'Category Management',
    CategoryText.deleteCategory: 'Delete Category',
    CategoryText.confirmDelete: 'Confirm Delete',
    CategoryText.cancelDelete: 'Cancel',
    CategoryText.deleteConfirmation: 'Are you sure you want to delete this category?',
    CategoryText.deleteWarningWithAccounts:
        'This category already has accounts. If deleted, all accounts in this category will be deleted.',
    CategoryText.deleteWarningEmpty: 'Are you sure you want to delete this category?',
    CategoryText.categoryCount: '{0} items',
    CategoryText.createCategory: 'Create Category',
    CategoryText.editCategory: 'Edit Category',
    CategoryText.categoryName: 'Category Name',
    CategoryText.categoryIcon: 'Category Icon',
    CategoryText.cancel: 'Cancel',
    CategoryText.bank: '💰 Bank',
    CategoryText.job: '💼 Work',
    CategoryText.study: '🎓 Study',
    CategoryText.shopping: '🛍️ Shopping',
    CategoryText.entertainment: '🎮 Entertainment',
    CategoryText.other: '🔍 Other',
    CategoryText.updateCategory: 'Update Category',
  };

  @override
  Map<String, String> get pt => {
    CategoryText.title: 'Gerenciamento de Categorias',
    CategoryText.deleteCategory: 'Excluir Categoria',
    CategoryText.confirmDelete: 'Confirmar Exclusão',
    CategoryText.cancelDelete: 'Cancelar',
    CategoryText.deleteConfirmation: 'Tem certeza de que deseja excluir esta categoria?',
    CategoryText.deleteWarningWithAccounts:
        'Esta categoria já possui contas. Se excluída, todas as contas nesta categoria serão excluídas.',
    CategoryText.deleteWarningEmpty: 'Tem certeza de que deseja excluir esta categoria?',
    CategoryText.categoryCount: '{0} itens',
    CategoryText.createCategory: 'Criar Categoria',
    CategoryText.editCategory: 'Editar Categoria',
    CategoryText.categoryName: 'Nome da Categoria',
    CategoryText.categoryIcon: 'Ícone da Categoria',
    CategoryText.cancel: 'Cancelar',
    CategoryText.bank: '💰 Banco',
    CategoryText.job: '💼 Trabalho',
    CategoryText.study: '🎓 Estudo',
    CategoryText.shopping: '🛍️ Compras',
    CategoryText.entertainment: '🎮 Entretenimento',
    CategoryText.other: '🔍 Outro',
    CategoryText.updateCategory: 'Atualizar Categoria',
  };

  @override
  Map<String, String> get hi => {
    CategoryText.title: 'श्रेणी प्रबंधन',
    CategoryText.deleteCategory: 'श्रेणी हटाएं',
    CategoryText.confirmDelete: 'हटाने की पुष्टि करें',
    CategoryText.cancelDelete: 'रद्द करें',
    CategoryText.deleteConfirmation: 'क्या आप वाकई इस श्रेणी को हटाना चाहते हैं?',
    CategoryText.deleteWarningWithAccounts:
        'इस श्रेणी में पहले से खाते हैं। यदि हटाया गया, तो इस श्रेणी के सभी खाते हटा दिए जाएंगे।',
    CategoryText.deleteWarningEmpty: 'क्या आप वाकई इस श्रेणी को हटाना चाहते हैं?',
    CategoryText.categoryCount: '{0} आइटम',
    CategoryText.createCategory: 'श्रेणी बनाएं',
    CategoryText.editCategory: 'श्रेणी संपादित करें',
    CategoryText.categoryName: 'श्रेणी का नाम',
    CategoryText.categoryIcon: 'श्रेणी आइकन',
    CategoryText.cancel: 'रद्द करें',
    CategoryText.bank: '💰 बैंक',
    CategoryText.job: '💼 काम',
    CategoryText.study: '🎓 अध्ययन',
    CategoryText.shopping: '🛍️ खरीदारी',
    CategoryText.entertainment: '🎮 मनोरंजन',
    CategoryText.other: '🔍 अन्य',
    CategoryText.updateCategory: 'श्रेणी अपडेट करें',
  };

  @override
  Map<String, String> get ja => {
    CategoryText.title: 'カテゴリ管理',
    CategoryText.deleteCategory: 'カテゴリを削除',
    CategoryText.confirmDelete: '削除を確認',
    CategoryText.cancelDelete: 'キャンセル',
    CategoryText.deleteConfirmation: 'このカテゴリを削除してもよろしいですか？',
    CategoryText.deleteWarningWithAccounts: 'このカテゴリにはすでにアカウントがあります。削除すると、このカテゴリのすべてのアカウントが削除されます。',
    CategoryText.deleteWarningEmpty: 'このカテゴリを削除してもよろしいですか？',
    CategoryText.categoryCount: '{0} アイテム',
    CategoryText.createCategory: 'カテゴリを作成',
    CategoryText.editCategory: 'カテゴリを編集',
    CategoryText.categoryName: 'カテゴリ名',
    CategoryText.categoryIcon: 'カテゴリアイコン',
    CategoryText.cancel: 'キャンセル',
    CategoryText.bank: '💰 銀行',
    CategoryText.job: '💼 仕事',
    CategoryText.study: '🎓 学習',
    CategoryText.shopping: '🛍️ 買い物',
    CategoryText.entertainment: '🎮 娯楽',
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
    CategoryText.deleteWarningWithAccounts:
        'В этой категории уже есть аккаунты. Если удалить, все аккаунты в этой категории будут удалены.',
    CategoryText.deleteWarningEmpty: 'Вы уверены, что хотите удалить эту категорию?',
    CategoryText.categoryCount: '{0} элементов',
    CategoryText.createCategory: 'Создать категорию',
    CategoryText.editCategory: 'Редактировать категорию',
    CategoryText.categoryName: 'Название категории',
    CategoryText.categoryIcon: 'Иконка категории',
    CategoryText.cancel: 'Отмена',
    CategoryText.bank: '💰 Банк',
    CategoryText.job: '💼 Работа',
    CategoryText.study: '🎓 Учёба',
    CategoryText.shopping: '🛍️ Покупки',
    CategoryText.entertainment: '🎮 Развлечения',
    CategoryText.other: '🔍 Другое',
    CategoryText.updateCategory: 'Обновить категорию',
  };

  @override
  Map<String, String> get id => {
    CategoryText.title: 'Manajemen Kategori',
    CategoryText.deleteCategory: 'Hapus Kategori',
    CategoryText.confirmDelete: 'Konfirmasi Hapus',
    CategoryText.cancelDelete: 'Batal',
    CategoryText.deleteConfirmation: 'Apakah Anda yakin ingin menghapus kategori ini?',
    CategoryText.deleteWarningWithAccounts:
        'Kategori ini sudah memiliki akun. Jika dihapus, semua akun dalam kategori ini akan dihapus.',
    CategoryText.deleteWarningEmpty: 'Apakah Anda yakin ingin menghapus kategori ini?',
    CategoryText.categoryCount: '{0} item',
    CategoryText.createCategory: 'Buat Kategori',
    CategoryText.editCategory: 'Edit Kategori',
    CategoryText.categoryName: 'Nama Kategori',
    CategoryText.categoryIcon: 'Ikon Kategori',
    CategoryText.cancel: 'Batal',
    CategoryText.bank: '💰 Bank',
    CategoryText.job: '💼 Pekerjaan',
    CategoryText.study: '🎓 Belajar',
    CategoryText.shopping: '🛍️ Belanja',
    CategoryText.entertainment: '🎮 Hiburan',
    CategoryText.other: '🔍 Lainnya',
    CategoryText.updateCategory: 'Perbarui Kategori',
  };

  @override
  Map<String, String> get tr => {
    CategoryText.title: 'Kategori Yönetimi',
    CategoryText.deleteCategory: 'Kategoriyi Sil',
    CategoryText.confirmDelete: 'Silme Onayı',
    CategoryText.cancelDelete: 'İptal',
    CategoryText.deleteConfirmation: 'Bu kategoriyi silmek istediğinizden emin misiniz?',
    CategoryText.deleteWarningWithAccounts:
        'Bu kategoride zaten hesaplar var. Silinirse, bu kategorideki tüm hesaplar silinecek.',
    CategoryText.deleteWarningEmpty: 'Bu kategoriyi silmek istediğinizden emin misiniz?',
    CategoryText.categoryCount: '{0} öğe',
    CategoryText.createCategory: 'Kategori Oluştur',
    CategoryText.editCategory: 'Kategoriyi Düzenle',
    CategoryText.categoryName: 'Kategori Adı',
    CategoryText.categoryIcon: 'Kategori Simgesi',
    CategoryText.cancel: 'İptal',
    CategoryText.bank: '💰 Banka',
    CategoryText.job: '💼 İş',
    CategoryText.study: '🎓 Öğrenim',
    CategoryText.shopping: '🛍️ Alışveriş',
    CategoryText.entertainment: '🎮 Eğlence',
    CategoryText.other: '🔍 Diğer',
    CategoryText.updateCategory: 'Kategoriyi Güncelle',
  };

  @override
  Map<String, String> get es => {
    CategoryText.title: 'Gestión de categorías',
    CategoryText.deleteCategory: 'Eliminar categoría',
    CategoryText.confirmDelete: 'Confirmar eliminación',
    CategoryText.cancelDelete: 'Cancelar',
    CategoryText.deleteConfirmation: '¿Estás seguro de que deseas eliminar esta categoría?',
    CategoryText.deleteWarningWithAccounts:
        'Esta categoría ya contiene cuentas. Si la eliminas, todas las cuentas en esta categoría también serán eliminadas.',
    CategoryText.deleteWarningEmpty: '¿Estás seguro de que deseas eliminar esta categoría?',
    CategoryText.categoryCount: '{0} elementos',
    CategoryText.createCategory: 'Crear categoría',
    CategoryText.editCategory: 'Editar categoría',
    CategoryText.categoryName: 'Nombre de la categoría',
    CategoryText.categoryIcon: 'Ícono de la categoría',
    CategoryText.cancel: 'Cancelar',
    CategoryText.bank: '💰 Banco',
    CategoryText.job: '💼 Trabajo',
    CategoryText.study: '🎓 Estudio',
    CategoryText.shopping: '🛍️ Compras',
    CategoryText.entertainment: '🎮 Entretenimiento',
    CategoryText.other: '🔍 Otro',
    CategoryText.updateCategory: 'Actualizar categoría',
  };

  @override
  Map<String, String> get it => {
    CategoryText.title: 'Gestione Categorie',
    CategoryText.deleteCategory: 'Elimina Categoria',
    CategoryText.confirmDelete: 'Conferma Eliminazione',
    CategoryText.cancelDelete: 'Annulla',
    CategoryText.deleteConfirmation: 'Sei sicuro di voler eliminare questa categoria?',
    CategoryText.deleteWarningWithAccounts:
        'Questa categoria contiene già degli account. Se eliminata, tutti gli account in questa categoria verranno eliminati.',
    CategoryText.deleteWarningEmpty: 'Sei sicuro di voler eliminare questa categoria?',
    CategoryText.categoryCount: '{0} elementi',
    CategoryText.createCategory: 'Crea Categoria',
    CategoryText.editCategory: 'Modifica Categoria',
    CategoryText.categoryName: 'Nome Categoria',
    CategoryText.categoryIcon: 'Icona Categoria',
    CategoryText.cancel: 'Annulla',
    CategoryText.bank: '💰 Banca',
    CategoryText.job: '💼 Lavoro',
    CategoryText.study: '🎓 Studio',
    CategoryText.shopping: '🛍️ Shopping',
    CategoryText.entertainment: '🎮 Intrattenimento',
    CategoryText.other: '🔍 Altro',
    CategoryText.updateCategory: 'Aggiorna Categoria',
  };
}
