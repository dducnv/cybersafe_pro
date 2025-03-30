class ErrorText {
  // Common errors
  static const String generalError = 'general_error';
  static const String networkError = 'network_error';
  static const String unknownError = 'unknown_error';
  static const String operationFailed = 'operation_failed';
  static const String invalidData = 'invalid_data';

  // Authentication errors
  static const String pinTooShort = 'pin_too_short';
  static const String pinIncorrect = 'pin_incorrect';
  static const String authenticationFailed = 'authentication_failed';
  static const String deviceKeyMissing = 'device_key_missing';
  static const String keyVerificationFailed = 'key_verification_failed';

  // Account errors
  static const String accountEmpty = 'account_empty';
  static const String accountNotFound = 'account_not_found';
  static const String accountNameRequired = 'account_name_required';
  static const String cannotDeleteAccount = 'cannot_delete_account';
  static const String cannotDeleteSomeAccounts = 'cannot_delete_some_accounts';

  // Category errors
  static const String categoryNameEmpty = 'category_name_empty';
  static const String categoryExists = 'category_exists';
  static const String cannotDeleteCategory = 'cannot_delete_category';
  static const String categoryNotFound = 'category_not_found';

  // File operation errors
  static const String fileNotSelected = 'file_not_selected';
  static const String fileNotFound = 'file_not_found';
  static const String cannotReadFile = 'cannot_read_file';
  static const String invalidFileFormat = 'invalid_file_format';
  static const String emptyCsvFile = 'empty_csv_file';
  static const String invalidCsvFormat = 'invalid_csv_format';
  static const String invalidBackupFile = 'invalid_backup_file';
  static const String corruptedBackupFile = 'corrupted_backup_file';
  static const String missingBackupField = 'missing_backup_field';
  static const String backupTooLarge = 'backup_too_large';
  static const String restoreFailed = 'restore_failed';

  // Encryption errors
  static const String encryptionFailed = 'encryption_failed';
  static const String decryptionFailed = 'decryption_failed';
  static const String dataEncryptionMismatch = 'data_encryption_mismatch';
  static const String encryptionVerificationFailed = 'encryption_verification_failed';
  static const String migrationFailed = 'migration_failed';
  
  // TOTP errors
  static const String emptySecretKey = 'empty_secret_key';
  static const String invalidSecretKey = 'invalid_secret_key';
  static const String invalidOtpUri = 'invalid_otp_uri';
  static const String missingOtpIssuer = 'missing_otp_issuer';
  static const String missingOtpSecret = 'missing_otp_secret';
  static const String invalidUriScheme = 'invalid_uri_scheme';
  static const String missingIssuer = 'missing_issuer';
  static const String missingSecret = 'missing_secret';
  static const String invalidAlgorithm = 'invalid_algorithm';
  
  // Operation limits
  static const String tooManyRetries = 'too_many_retries';
  static const String tryAgainLater = 'try_again_later';
} 