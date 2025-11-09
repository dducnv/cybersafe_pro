import 'package:cybersafe_pro/localization/app_locale.dart';
import 'package:cybersafe_pro/localization/base_locale.dart';
import 'package:cybersafe_pro/localization/keys/error_text.dart';

class ErrorLocale extends BaseLocale {
  final AppLocale appLocale;

  ErrorLocale(this.appLocale);

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
    // Common errors
    ErrorText.generalError: 'Đã xảy ra lỗi',
    ErrorText.networkError: 'Lỗi kết nối mạng',
    ErrorText.unknownError: 'Lỗi không xác định',
    ErrorText.operationFailed: 'Thao tác thất bại',
    ErrorText.invalidData: 'Dữ liệu không hợp lệ',

    // Authentication errors
    ErrorText.pinTooShort: 'PIN phải có ít nhất 6 ký tự',
    ErrorText.pinIncorrect: 'PIN không chính xác',
    ErrorText.authenticationFailed: 'Xác thực thất bại',
    ErrorText.deviceKeyMissing: 'Chưa tạo khóa thiết bị',
    ErrorText.keyVerificationFailed: 'Xác minh khóa thất bại',

    // Account errors
    ErrorText.accountEmpty: 'Tài khoản không được để trống',
    ErrorText.accountNotFound: 'Không tìm thấy tài khoản',
    ErrorText.accountNameRequired: 'Tên tài khoản không được để trống',
    ErrorText.cannotDeleteAccount: 'Không thể xóa tài khoản',
    ErrorText.cannotDeleteSomeAccounts: 'Không thể xóa một số tài khoản',

    // Category errors
    ErrorText.categoryNameEmpty: 'Tên danh mục không được để trống',
    ErrorText.categoryExists: 'Danh mục này đã tồn tại',
    ErrorText.cannotDeleteCategory: 'Không thể xóa danh mục',
    ErrorText.categoryNotFound: 'Không tìm thấy danh mục',

    // File operation errors
    ErrorText.fileNotSelected: 'Không có file nào được chọn',
    ErrorText.fileNotFound: 'Không tìm thấy file',
    ErrorText.cannotReadFile: 'Không thể đọc file',
    ErrorText.invalidFileFormat: 'Định dạng file không hợp lệ',
    ErrorText.emptyCsvFile: 'File CSV trống',
    ErrorText.invalidCsvFormat:
        'File CSV không đúng định dạng. Cần có các cột: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'File không phải backup hợp lệ',
    ErrorText.corruptedBackupFile: 'File backup không hợp lệ hoặc đã bị hỏng',
    ErrorText.missingBackupField: 'Thiếu trường trong file backup',
    ErrorText.backupTooLarge: 'Kích thước backup quá lớn',
    ErrorText.restoreFailed: 'Khôi phục dữ liệu thất bại',

    // Encryption errors
    ErrorText.encryptionFailed: 'Lỗi mã hóa dữ liệu',
    ErrorText.decryptionFailed: 'Lỗi giải mã dữ liệu',
    ErrorText.dataEncryptionMismatch: 'Dữ liệu không khớp sau khi mã hóa lại',
    ErrorText.encryptionVerificationFailed: 'Xác minh mã hóa thất bại',
    ErrorText.migrationFailed: 'Di chuyển dữ liệu thất bại',

    // TOTP errors
    ErrorText.emptySecretKey: 'Khóa bí mật trống',
    ErrorText.invalidSecretKey: 'Khóa bí mật không hợp lệ',
    ErrorText.invalidOtpUri: 'URI OTP không hợp lệ',
    ErrorText.missingOtpIssuer: 'Thiếu thông tin nhà phát hành OTP',
    ErrorText.missingOtpSecret: 'Thiếu thông tin khóa bí mật OTP',
    ErrorText.invalidUriScheme: 'Giao thức URI không hợp lệ',
    ErrorText.missingIssuer: 'Thiếu thông tin nhà phát hành',
    ErrorText.missingSecret: 'Thiếu thông tin bí mật',
    ErrorText.invalidAlgorithm: 'Thuật toán không hợp lệ',

    // Operation limits
    ErrorText.tooManyRetries: 'Đã vượt quá số lần thử lại',
    ErrorText.tryAgainLater: 'Vui lòng thử lại sau',
  };

  @override
  Map<String, String> get en => {
    // Common errors
    ErrorText.generalError: 'An error occurred',
    ErrorText.networkError: 'Network error',
    ErrorText.unknownError: 'Unknown error',
    ErrorText.operationFailed: 'Operation failed',
    ErrorText.invalidData: 'Invalid data',

    // Authentication errors
    ErrorText.pinTooShort: 'PIN must be at least 6 characters',
    ErrorText.pinIncorrect: 'Incorrect PIN',
    ErrorText.authenticationFailed: 'Authentication failed',
    ErrorText.deviceKeyMissing: 'Device key not created',
    ErrorText.keyVerificationFailed: 'Key verification failed',

    // Account errors
    ErrorText.accountEmpty: 'Account cannot be empty',
    ErrorText.accountNotFound: 'Account not found',
    ErrorText.accountNameRequired: 'Account name is required',
    ErrorText.cannotDeleteAccount: 'Cannot delete account',
    ErrorText.cannotDeleteSomeAccounts: 'Cannot delete some accounts',

    // Category errors
    ErrorText.categoryNameEmpty: 'Category name cannot be empty',
    ErrorText.categoryExists: 'This category already exists',
    ErrorText.cannotDeleteCategory: 'Cannot delete category',
    ErrorText.categoryNotFound: 'Category not found',

    // File operation errors
    ErrorText.fileNotSelected: 'No file selected',
    ErrorText.fileNotFound: 'File not found',
    ErrorText.cannotReadFile: 'Cannot read file',
    ErrorText.invalidFileFormat: 'Invalid file format',
    ErrorText.emptyCsvFile: 'CSV file is empty',
    ErrorText.invalidCsvFormat:
        'CSV file format is invalid. It must have columns: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'Invalid backup file',
    ErrorText.corruptedBackupFile: 'Backup file is corrupted or invalid',
    ErrorText.missingBackupField: 'Missing field in backup file',
    ErrorText.backupTooLarge: 'Backup size is too large',
    ErrorText.restoreFailed: 'Restore failed',

    // Encryption errors
    ErrorText.encryptionFailed: 'Encryption failed',
    ErrorText.decryptionFailed: 'Decryption failed',
    ErrorText.dataEncryptionMismatch: 'Data mismatch after re-encryption',
    ErrorText.encryptionVerificationFailed: 'Encryption verification failed',
    ErrorText.migrationFailed: 'Data migration failed',

    // TOTP errors
    ErrorText.emptySecretKey: 'Secret key is empty',
    ErrorText.invalidSecretKey: 'Invalid secret key',
    ErrorText.invalidOtpUri: 'Invalid OTP URI',
    ErrorText.missingOtpIssuer: 'Missing OTP issuer',
    ErrorText.missingOtpSecret: 'Missing OTP secret',
    ErrorText.invalidUriScheme: 'Invalid URI scheme',
    ErrorText.missingIssuer: 'Missing issuer',
    ErrorText.missingSecret: 'Missing secret',
    ErrorText.invalidAlgorithm: 'Invalid algorithm',

    // Operation limits
    ErrorText.tooManyRetries: 'Too many retries',
    ErrorText.tryAgainLater: 'Please try again later',
  };

  @override
  Map<String, String> get pt => {
    // Common errors
    ErrorText.generalError: 'Ocorreu um erro',
    ErrorText.networkError: 'Erro de rede',
    ErrorText.unknownError: 'Erro desconhecido',
    ErrorText.operationFailed: 'Operação falhou',
    ErrorText.invalidData: 'Dados inválidos',

    // Authentication errors
    ErrorText.pinTooShort: 'O PIN deve ter pelo menos 6 caracteres',
    ErrorText.pinIncorrect: 'PIN incorreto',
    ErrorText.authenticationFailed: 'Falha na autenticação',
    ErrorText.deviceKeyMissing: 'Chave do dispositivo não criada',
    ErrorText.keyVerificationFailed: 'Falha na verificação da chave',

    // Account errors
    ErrorText.accountEmpty: 'A conta não pode estar vazia',
    ErrorText.accountNotFound: 'Conta não encontrada',
    ErrorText.accountNameRequired: 'Nome da conta é obrigatório',
    ErrorText.cannotDeleteAccount: 'Não é possível excluir a conta',
    ErrorText.cannotDeleteSomeAccounts: 'Não é possível excluir algumas contas',

    // Category errors
    ErrorText.categoryNameEmpty: 'O nome da categoria não pode estar vazio',
    ErrorText.categoryExists: 'Esta categoria já existe',
    ErrorText.cannotDeleteCategory: 'Não é possível excluir a categoria',
    ErrorText.categoryNotFound: 'Categoria não encontrada',

    // File operation errors
    ErrorText.fileNotSelected: 'Nenhum arquivo selecionado',
    ErrorText.fileNotFound: 'Arquivo não encontrado',
    ErrorText.cannotReadFile: 'Não é possível ler o arquivo',
    ErrorText.invalidFileFormat: 'Formato de arquivo inválido',
    ErrorText.emptyCsvFile: 'Arquivo CSV vazio',
    ErrorText.invalidCsvFormat:
        'Formato do arquivo CSV inválido. Deve ter colunas: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'Arquivo de backup inválido',
    ErrorText.corruptedBackupFile: 'Arquivo de backup corrompido ou inválido',
    ErrorText.missingBackupField: 'Campo ausente no arquivo de backup',
    ErrorText.backupTooLarge: 'Tamanho do backup é muito grande',
    ErrorText.restoreFailed: 'Falha na restauração',

    // Encryption errors
    ErrorText.encryptionFailed: 'Falha na criptografia',
    ErrorText.decryptionFailed: 'Falha na descriptografia',
    ErrorText.dataEncryptionMismatch: 'Incompatibilidade de dados após recriptografia',
    ErrorText.encryptionVerificationFailed: 'Falha na verificação de criptografia',
    ErrorText.migrationFailed: 'Falha na migração de dados',

    // TOTP errors
    ErrorText.emptySecretKey: 'Chave secreta vazia',
    ErrorText.invalidSecretKey: 'Chave secreta inválida',
    ErrorText.invalidOtpUri: 'URI OTP inválido',
    ErrorText.missingOtpIssuer: 'Emissor OTP ausente',
    ErrorText.missingOtpSecret: 'Segredo OTP ausente',

    // Operation limits
    ErrorText.tooManyRetries: 'Muitas tentativas',
    ErrorText.tryAgainLater: 'Por favor, tente novamente mais tarde',

    ErrorText.invalidUriScheme: 'Esquema de URI inválido',
    ErrorText.missingIssuer: 'Emissor ausente',
    ErrorText.missingSecret: 'Segredo ausente',
    ErrorText.invalidAlgorithm: 'Algoritmo inválido',
  };

  @override
  Map<String, String> get hi => {
    // Common errors
    ErrorText.generalError: 'एक त्रुटि हुई',
    ErrorText.networkError: 'नेटवर्क त्रुटि',
    ErrorText.unknownError: 'अज्ञात त्रुटि',
    ErrorText.operationFailed: 'ऑपरेशन विफल',
    ErrorText.invalidData: 'अमान्य डेटा',

    // Authentication errors
    ErrorText.pinTooShort: 'पिन कम से कम 6 अक्षरों का होना चाहिए',
    ErrorText.pinIncorrect: 'गलत पिन',
    ErrorText.authenticationFailed: 'प्रमाणीकरण विफल',
    ErrorText.deviceKeyMissing: 'डिवाइस कुंजी नहीं बनाई गई',
    ErrorText.keyVerificationFailed: 'कुंजी सत्यापन विफल',

    // Account errors
    ErrorText.accountEmpty: 'खाता खाली नहीं हो सकता',
    ErrorText.accountNotFound: 'खाता नहीं मिला',
    ErrorText.accountNameRequired: 'खाता नाम आवश्यक है',
    ErrorText.cannotDeleteAccount: 'खाता हटाया नहीं जा सकता',
    ErrorText.cannotDeleteSomeAccounts: 'कुछ खाते हटाए नहीं जा सकते',

    // Category errors
    ErrorText.categoryNameEmpty: 'श्रेणी का नाम खाली नहीं हो सकता',
    ErrorText.categoryExists: 'यह श्रेणी पहले से मौजूद है',
    ErrorText.cannotDeleteCategory: 'श्रेणी हटाई नहीं जा सकती',
    ErrorText.categoryNotFound: 'श्रेणी नहीं मिली',

    // File operation errors
    ErrorText.fileNotSelected: 'कोई फ़ाइल चयनित नहीं',
    ErrorText.fileNotFound: 'फ़ाइल नहीं मिली',
    ErrorText.cannotReadFile: 'फ़ाइल पढ़ नहीं सकते',
    ErrorText.invalidFileFormat: 'अमान्य फ़ाइल प्रारूप',
    ErrorText.emptyCsvFile: 'CSV फ़ाइल खाली है',
    ErrorText.invalidCsvFormat:
        'CSV फ़ाइल प्रारूप अमान्य है। इसमें कॉलम होने चाहिए: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'अमान्य बैकअप फ़ाइल',
    ErrorText.corruptedBackupFile: 'बैकअप फ़ाइल दूषित या अमान्य है',
    ErrorText.missingBackupField: 'बैकअप फ़ाइल में फ़ील्ड गायब है',
    ErrorText.backupTooLarge: 'बैकअप आकार बहुत बड़ा है',
    ErrorText.restoreFailed: 'पुनर्स्थापना विफल',

    // Encryption errors
    ErrorText.encryptionFailed: 'एन्क्रिप्शन विफल',
    ErrorText.decryptionFailed: 'डिक्रिप्शन विफल',
    ErrorText.dataEncryptionMismatch: 'पुन: एन्क्रिप्शन के बाद डेटा मेल नहीं खाता',
    ErrorText.encryptionVerificationFailed: 'एन्क्रिप्शन सत्यापन विफल',
    ErrorText.migrationFailed: 'डेटा माइग्रेशन विफल',

    // TOTP errors
    ErrorText.emptySecretKey: 'गुप्त कुंजी खाली है',
    ErrorText.invalidSecretKey: 'अमान्य गुप्त कुंजी',
    ErrorText.invalidOtpUri: 'अमान्य OTP URI',
    ErrorText.missingOtpIssuer: 'OTP जारीकर्ता गायब है',
    ErrorText.missingOtpSecret: 'OTP गुप्त गायब है',

    // Operation limits
    ErrorText.tooManyRetries: 'बहुत अधिक प्रयास',
    ErrorText.tryAgainLater: 'कृपया बाद में पुन: प्रयास करें',

    ErrorText.invalidUriScheme: 'अमान्य URI स्कीम',
    ErrorText.missingIssuer: 'जारीकर्ता गायब है',
    ErrorText.missingSecret: 'गुप्त गायब है',
    ErrorText.invalidAlgorithm: 'अमान्य एल्गोरिदम',
  };

  @override
  Map<String, String> get ja => {
    // Common errors
    ErrorText.generalError: 'エラーが発生しました',
    ErrorText.networkError: 'ネットワークエラー',
    ErrorText.unknownError: '不明なエラー',
    ErrorText.operationFailed: '操作に失敗しました',
    ErrorText.invalidData: '無効なデータ',

    // Authentication errors
    ErrorText.pinTooShort: 'PINは6文字以上である必要があります',
    ErrorText.pinIncorrect: '不正なPIN',
    ErrorText.authenticationFailed: '認証に失敗しました',
    ErrorText.deviceKeyMissing: 'デバイスキーが作成されていません',
    ErrorText.keyVerificationFailed: 'キー検証に失敗しました',

    // Account errors
    ErrorText.accountEmpty: 'アカウントを空にすることはできません',
    ErrorText.accountNotFound: 'アカウントが見つかりません',
    ErrorText.accountNameRequired: 'アカウント名が必要です',
    ErrorText.cannotDeleteAccount: 'アカウントを削除できません',
    ErrorText.cannotDeleteSomeAccounts: '一部のアカウントを削除できません',

    // Category errors
    ErrorText.categoryNameEmpty: 'カテゴリ名を空にすることはできません',
    ErrorText.categoryExists: 'このカテゴリはすでに存在します',
    ErrorText.cannotDeleteCategory: 'カテゴリを削除できません',
    ErrorText.categoryNotFound: 'カテゴリが見つかりません',

    // File operation errors
    ErrorText.fileNotSelected: 'ファイルが選択されていません',
    ErrorText.fileNotFound: 'ファイルが見つかりません',
    ErrorText.cannotReadFile: 'ファイルを読み取れません',
    ErrorText.invalidFileFormat: '無効なファイル形式',
    ErrorText.emptyCsvFile: 'CSVファイルが空です',
    ErrorText.invalidCsvFormat: 'CSVファイル形式が無効です。列が必要です：name, url, username, password, note',
    ErrorText.invalidBackupFile: '無効なバックアップファイル',
    ErrorText.corruptedBackupFile: 'バックアップファイルが破損しているか無効です',
    ErrorText.missingBackupField: 'バックアップファイルにフィールドがありません',
    ErrorText.backupTooLarge: 'バックアップサイズが大きすぎます',
    ErrorText.restoreFailed: '復元に失敗しました',

    // Encryption errors
    ErrorText.encryptionFailed: '暗号化に失敗しました',
    ErrorText.decryptionFailed: '復号化に失敗しました',
    ErrorText.dataEncryptionMismatch: '再暗号化後のデータが一致しません',
    ErrorText.encryptionVerificationFailed: '暗号化の検証に失敗しました',
    ErrorText.migrationFailed: 'データ移行に失敗しました',

    // TOTP errors
    ErrorText.emptySecretKey: '秘密鍵が空です',
    ErrorText.invalidSecretKey: '無効な秘密鍵',
    ErrorText.invalidOtpUri: '無効なOTP URI',
    ErrorText.missingOtpIssuer: 'OTP発行者がありません',
    ErrorText.missingOtpSecret: 'OTP秘密がありません',

    // Operation limits
    ErrorText.tooManyRetries: '再試行回数が多すぎます',
    ErrorText.tryAgainLater: '後でもう一度お試しください',

    ErrorText.invalidUriScheme: '無効なURIスキーム',
    ErrorText.missingIssuer: '発行者が不足しています',
    ErrorText.missingSecret: '秘密が不足しています',
    ErrorText.invalidAlgorithm: '無効なアルゴリズム',
  };

  @override
  Map<String, String> get ru => {
    // Common errors
    ErrorText.generalError: 'Произошла ошибка',
    ErrorText.networkError: 'Ошибка сети',
    ErrorText.unknownError: 'Неизвестная ошибка',
    ErrorText.operationFailed: 'Операция не удалась',
    ErrorText.invalidData: 'Недопустимые данные',

    // Authentication errors
    ErrorText.pinTooShort: 'PIN-код должен содержать не менее 6 символов',
    ErrorText.pinIncorrect: 'Неверный PIN-код',
    ErrorText.authenticationFailed: 'Ошибка аутентификации',
    ErrorText.deviceKeyMissing: 'Ключ устройства не создан',
    ErrorText.keyVerificationFailed: 'Ошибка проверки ключа',

    // Account errors
    ErrorText.accountEmpty: 'Учетная запись не может быть пустой',
    ErrorText.accountNotFound: 'Учетная запись не найдена',
    ErrorText.accountNameRequired: 'Требуется имя учетной записи',
    ErrorText.cannotDeleteAccount: 'Невозможно удалить учетную запись',
    ErrorText.cannotDeleteSomeAccounts: 'Невозможно удалить некоторые учетные записи',

    // Category errors
    ErrorText.categoryNameEmpty: 'Имя категории не может быть пустым',
    ErrorText.categoryExists: 'Эта категория уже существует',
    ErrorText.cannotDeleteCategory: 'Невозможно удалить категорию',
    ErrorText.categoryNotFound: 'Категория не найдена',

    // File operation errors
    ErrorText.fileNotSelected: 'Файл не выбран',
    ErrorText.fileNotFound: 'Файл не найден',
    ErrorText.cannotReadFile: 'Невозможно прочитать файл',
    ErrorText.invalidFileFormat: 'Неверный формат файла',
    ErrorText.emptyCsvFile: 'CSV файл пуст',
    ErrorText.invalidCsvFormat:
        'Неверный формат CSV файла. Должны быть столбцы: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'Недействительный файл резервной копии',
    ErrorText.corruptedBackupFile: 'Файл резервной копии поврежден или недействителен',
    ErrorText.missingBackupField: 'Отсутствует поле в файле резервной копии',
    ErrorText.backupTooLarge: 'Размер резервной копии слишком большой',
    ErrorText.restoreFailed: 'Восстановление не удалось',

    // Encryption errors
    ErrorText.encryptionFailed: 'Ошибка шифрования',
    ErrorText.decryptionFailed: 'Ошибка дешифрования',
    ErrorText.dataEncryptionMismatch: 'Несоответствие данных после повторного шифрования',
    ErrorText.encryptionVerificationFailed: 'Ошибка проверки шифрования',
    ErrorText.migrationFailed: 'Ошибка миграции данных',

    // TOTP errors
    ErrorText.emptySecretKey: 'Секретный ключ пуст',
    ErrorText.invalidSecretKey: 'Недействительный секретный ключ',
    ErrorText.invalidOtpUri: 'Недействительный OTP URI',
    ErrorText.missingOtpIssuer: 'Отсутствует издатель OTP',
    ErrorText.missingOtpSecret: 'Отсутствует секрет OTP',

    // Operation limits
    ErrorText.tooManyRetries: 'Слишком много попыток',
    ErrorText.tryAgainLater: 'Повторите попытку позже',

    ErrorText.invalidUriScheme: 'Недействительный URI-схема',
    ErrorText.missingIssuer: 'Отсутствует издатель',
    ErrorText.missingSecret: 'Отсутствует секрет',
    ErrorText.invalidAlgorithm: 'Недействительный алгоритм',
  };

  @override
  Map<String, String> get id => {
    // Common errors
    ErrorText.generalError: 'Terjadi kesalahan',
    ErrorText.networkError: 'Kesalahan jaringan',
    ErrorText.unknownError: 'Kesalahan tidak diketahui',
    ErrorText.operationFailed: 'Operasi gagal',
    ErrorText.invalidData: 'Data tidak valid',

    // Authentication errors
    ErrorText.pinTooShort: 'PIN harus minimal 6 karakter',
    ErrorText.pinIncorrect: 'PIN salah',
    ErrorText.authenticationFailed: 'Autentikasi gagal',
    ErrorText.deviceKeyMissing: 'Kunci perangkat belum dibuat',
    ErrorText.keyVerificationFailed: 'Verifikasi kunci gagal',

    // Account errors
    ErrorText.accountEmpty: 'Akun tidak boleh kosong',
    ErrorText.accountNotFound: 'Akun tidak ditemukan',
    ErrorText.accountNameRequired: 'Nama akun diperlukan',
    ErrorText.cannotDeleteAccount: 'Tidak dapat menghapus akun',
    ErrorText.cannotDeleteSomeAccounts: 'Tidak dapat menghapus beberapa akun',

    // Category errors
    ErrorText.categoryNameEmpty: 'Nama kategori tidak boleh kosong',
    ErrorText.categoryExists: 'Kategori ini sudah ada',
    ErrorText.cannotDeleteCategory: 'Tidak dapat menghapus kategori',
    ErrorText.categoryNotFound: 'Kategori tidak ditemukan',

    // File operation errors
    ErrorText.fileNotSelected: 'Tidak ada file yang dipilih',
    ErrorText.fileNotFound: 'File tidak ditemukan',
    ErrorText.cannotReadFile: 'Tidak dapat membaca file',
    ErrorText.invalidFileFormat: 'Format file tidak valid',
    ErrorText.emptyCsvFile: 'File CSV kosong',
    ErrorText.invalidCsvFormat:
        'Format file CSV tidak valid. Harus memiliki kolom: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'File cadangan tidak valid',
    ErrorText.corruptedBackupFile: 'File cadangan rusak atau tidak valid',
    ErrorText.missingBackupField: 'Bidang hilang dalam file cadangan',
    ErrorText.backupTooLarge: 'Ukuran cadangan terlalu besar',
    ErrorText.restoreFailed: 'Pemulihan gagal',

    // Encryption errors
    ErrorText.encryptionFailed: 'Enkripsi gagal',
    ErrorText.decryptionFailed: 'Dekripsi gagal',
    ErrorText.dataEncryptionMismatch: 'Data tidak cocok setelah re-enkripsi',
    ErrorText.encryptionVerificationFailed: 'Verifikasi enkripsi gagal',
    ErrorText.migrationFailed: 'Migrasi data gagal',

    // TOTP errors
    ErrorText.emptySecretKey: 'Kunci rahasia kosong',
    ErrorText.invalidSecretKey: 'Kunci rahasia tidak valid',
    ErrorText.invalidOtpUri: 'URI OTP tidak valid',
    ErrorText.missingOtpIssuer: 'Penerbit OTP hilang',
    ErrorText.missingOtpSecret: 'Rahasia OTP hilang',

    // Operation limits
    ErrorText.tooManyRetries: 'Terlalu banyak percobaan ulang',
    ErrorText.tryAgainLater: 'Silakan coba lagi nanti',

    ErrorText.invalidUriScheme: 'URI scheme tidak valid',
    ErrorText.missingIssuer: 'Penerbit hilang',
    ErrorText.missingSecret: 'Rahasia hilang',
    ErrorText.invalidAlgorithm: 'Algoritma tidak valid',
  };

  @override
  Map<String, String> get tr => {
    // Common errors
    ErrorText.generalError: 'Hata oluştu',
    ErrorText.networkError: 'Ağ hatası',
    ErrorText.unknownError: 'Bilinmeyen hata',
    ErrorText.operationFailed: 'İşlem başarısız',
    ErrorText.invalidData: 'Geçersiz veri',

    // Authentication errors
    ErrorText.pinTooShort: 'PIN en az 6 karakter olmalıdır',
    ErrorText.pinIncorrect: 'Yanlış PIN',
    ErrorText.authenticationFailed: 'Kimlik doğrulama başarısız',
    ErrorText.deviceKeyMissing: 'Cihaz anahtarı oluşturulmamış',

    // Account errors
    ErrorText.accountEmpty: 'Hesap boş olamaz',
    ErrorText.accountNotFound: 'Hesap bulunamadı',
    ErrorText.accountNameRequired: 'Hesap adı gereklidir',
    ErrorText.cannotDeleteAccount: 'Hesap silinemez',
    ErrorText.cannotDeleteSomeAccounts: 'Bazı hesaplar silinemez',

    // Category errors
    ErrorText.categoryNameEmpty: 'Kategori adı boş olamaz',
    ErrorText.categoryExists: 'Bu kategori zaten mevcut',
    ErrorText.cannotDeleteCategory: 'Kategori silinemez',
    ErrorText.categoryNotFound: 'Kategori bulunamadı',

    // File operation errors
    ErrorText.fileNotSelected: 'Dosya seçilmedi',
    ErrorText.fileNotFound: 'Dosya bulunamadı',
    ErrorText.cannotReadFile: 'Dosya okunamadı',
    ErrorText.invalidFileFormat: 'Geçersiz dosya formatı',
    ErrorText.emptyCsvFile: 'CSV dosyası boş',
    ErrorText.invalidCsvFormat:
        'Geçersiz CSV formatı. Gerekli sütunlar: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'Geçersiz yedekleme dosyası',
    ErrorText.corruptedBackupFile: 'Yedekleme dosyası bozuk veya geçersiz',
    ErrorText.missingBackupField: 'Yedekleme dosyasında eksik alan',
    ErrorText.backupTooLarge: 'Yedekleme boyutu çok büyük',
    ErrorText.restoreFailed: 'Geri yükleme başarısız',

    // Encryption errors
    ErrorText.encryptionFailed: 'Şifreleme başarısız',
    ErrorText.decryptionFailed: 'Şifre çözme başarısız',
    ErrorText.dataEncryptionMismatch: 'Yeniden şifreleme sonrası veri eşleşmiyor',
    ErrorText.encryptionVerificationFailed: 'Şifreleme doğrulama başarısız',
    ErrorText.migrationFailed: 'Veri geçişi başarısız',

    // TOTP errors
    ErrorText.emptySecretKey: 'Gizli anahtar boş',
    ErrorText.invalidSecretKey: 'Geçersiz gizli anahtar',
    ErrorText.invalidOtpUri: 'Geçersiz OTP URI',
    ErrorText.missingOtpIssuer: 'OTP yayıncısı eksik',
    ErrorText.missingOtpSecret: 'OTP gizli anahtarı eksik',

    // Operation limits
    ErrorText.tooManyRetries: 'Çok fazla deneme',
    ErrorText.tryAgainLater: 'Lütfen daha sonra tekrar deneyin',

    ErrorText.invalidUriScheme: 'Geçersiz URI şeması',
    ErrorText.missingIssuer: 'Yayıncı eksik',
    ErrorText.missingSecret: 'Gizli anahtar eksik',
  };

  @override
  Map<String, String> get es => {
    ErrorText.generalError: 'Ocurrió un error',
    ErrorText.networkError: 'Error de red',
    ErrorText.unknownError: 'Error desconocido',
    ErrorText.operationFailed: 'La operación falló',
    ErrorText.invalidData: 'Datos inválidos',

    // Errores de autenticación
    ErrorText.pinTooShort: 'El PIN debe tener al menos 6 caracteres',
    ErrorText.pinIncorrect: 'PIN incorrecto',
    ErrorText.authenticationFailed: 'Falló la autenticación',
    ErrorText.deviceKeyMissing: 'Clave del dispositivo no creada',
    ErrorText.keyVerificationFailed: 'Falló la verificación de clave',

    // Errores de cuenta
    ErrorText.accountEmpty: 'La cuenta no puede estar vacía',
    ErrorText.accountNotFound: 'Cuenta no encontrada',
    ErrorText.accountNameRequired: 'Se requiere el nombre de la cuenta',
    ErrorText.cannotDeleteAccount: 'No se puede eliminar la cuenta',
    ErrorText.cannotDeleteSomeAccounts: 'No se pueden eliminar algunas cuentas',

    // Errores de categoría
    ErrorText.categoryNameEmpty: 'El nombre de la categoría no puede estar vacío',
    ErrorText.categoryExists: 'Esta categoría ya existe',
    ErrorText.cannotDeleteCategory: 'No se puede eliminar la categoría',
    ErrorText.categoryNotFound: 'Categoría no encontrada',

    // Errores de archivo
    ErrorText.fileNotSelected: 'No se ha seleccionado ningún archivo',
    ErrorText.fileNotFound: 'Archivo no encontrado',
    ErrorText.cannotReadFile: 'No se puede leer el archivo',
    ErrorText.invalidFileFormat: 'Formato de archivo inválido',
    ErrorText.emptyCsvFile: 'El archivo CSV está vacío',
    ErrorText.invalidCsvFormat:
        'Formato de archivo CSV inválido. Debe tener las columnas: nombre, url, usuario, contraseña, nota',
    ErrorText.invalidBackupFile: 'Archivo de respaldo inválido',
    ErrorText.corruptedBackupFile: 'El archivo de respaldo está dañado o es inválido',
    ErrorText.missingBackupField: 'Falta un campo en el archivo de respaldo',
    ErrorText.backupTooLarge: 'El tamaño del respaldo es demasiado grande',
    ErrorText.restoreFailed: 'Error al restaurar',

    // Errores de encriptación
    ErrorText.encryptionFailed: 'Error al encriptar',
    ErrorText.decryptionFailed: 'Error al desencriptar',
    ErrorText.dataEncryptionMismatch: 'Los datos no coinciden después de la reencriptación',
    ErrorText.encryptionVerificationFailed: 'Falló la verificación de encriptación',
    ErrorText.migrationFailed: 'Falló la migración de datos',

    // Errores TOTP
    ErrorText.emptySecretKey: 'La clave secreta está vacía',
    ErrorText.invalidSecretKey: 'Clave secreta inválida',
    ErrorText.invalidOtpUri: 'URI de OTP inválido',
    ErrorText.missingOtpIssuer: 'Falta el emisor del OTP',
    ErrorText.missingOtpSecret: 'Falta la clave secreta del OTP',
    ErrorText.invalidUriScheme: 'Esquema de URI inválido',
    ErrorText.missingIssuer: 'Falta el emisor',
    ErrorText.missingSecret: 'Falta la clave secreta',
    ErrorText.invalidAlgorithm: 'Algoritmo inválido',

    // Límites de operación
    ErrorText.tooManyRetries: 'Demasiados intentos',
    ErrorText.tryAgainLater: 'Por favor, inténtalo más tarde',
  };
  @override
  Map<String, String> get it => {
    ErrorText.generalError: 'Si è verificato un errore',
    ErrorText.networkError: 'Errore di rete',
    ErrorText.unknownError: 'Errore sconosciuto',
    ErrorText.operationFailed: 'Operazione fallita',
    ErrorText.invalidData: 'Dati non validi',

    // Authentication errors
    ErrorText.pinTooShort: 'Il PIN deve essere almeno 6 caratteri',
    ErrorText.pinIncorrect: 'PIN errato',
    ErrorText.authenticationFailed: 'Autenticazione fallita',
    ErrorText.deviceKeyMissing: 'Chiave del dispositivo non creata',
    ErrorText.keyVerificationFailed: 'Verifica della chiave fallita',

    // Account errors
    ErrorText.accountEmpty: 'L\'account non può essere vuoto',
    ErrorText.accountNotFound: 'Account non trovato',
    ErrorText.accountNameRequired: 'Il nome dell\'account è obbligatorio',
    ErrorText.cannotDeleteAccount: 'Non è possibile eliminare l\'account',
    ErrorText.cannotDeleteSomeAccounts: 'Non è possibile eliminare alcuni account',

    // Category errors
    ErrorText.categoryNameEmpty: 'Il nome della categoria non può essere vuoto',
    ErrorText.categoryExists: 'Questa categoria già esiste',
    ErrorText.cannotDeleteCategory: 'Non è possibile eliminare la categoria',
    ErrorText.categoryNotFound: 'Categoria non trovata',

    // File operation errors
    ErrorText.fileNotSelected: 'Nessun file selezionato',
    ErrorText.fileNotFound: 'File non trovato',
    ErrorText.cannotReadFile: 'Non è possibile leggere il file',
    ErrorText.invalidFileFormat: 'Formato file non valido',
    ErrorText.emptyCsvFile: 'Il file CSV è vuoto',
    ErrorText.invalidCsvFormat:
        'Formato file CSV non valido. Deve avere le colonne: name, url, username, password, note',
    ErrorText.invalidBackupFile: 'File di backup non valido',
    ErrorText.corruptedBackupFile: 'Il file di backup è danneggiato o non valido',
    ErrorText.missingBackupField: 'Campo mancante nel file di backup',
    ErrorText.backupTooLarge: 'Il file di backup è troppo grande',
    ErrorText.restoreFailed: 'Ripristino fallito',

    // Encryption errors
    ErrorText.encryptionFailed: 'Crittografia fallita',
    ErrorText.decryptionFailed: 'Decrittazione fallita',
    ErrorText.dataEncryptionMismatch: 'I dati non corrispondono dopo la ricrittografia',
    ErrorText.encryptionVerificationFailed: 'Verifica della crittografia fallita',
    ErrorText.migrationFailed: 'Migrazione dei dati fallita',

    // TOTP errors
    ErrorText.emptySecretKey: 'Chiave segreta vuota',
    ErrorText.invalidSecretKey: 'Chiave segreta non valida',
    ErrorText.invalidOtpUri: 'URI OTP non valido',
    ErrorText.missingOtpIssuer: 'Mancante il fornitore OTP',
    ErrorText.missingOtpSecret: 'Mancante la chiave segreta OTP',
    ErrorText.invalidUriScheme: 'Schema URI non valido',
    ErrorText.missingIssuer: 'Mancante il fornitore',
  };
}
