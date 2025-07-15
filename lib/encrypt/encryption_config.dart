class EncryptionConfig {
  static const int PBKDF2_ITERATIONS = 20000;
  static const int KEY_SIZE_BYTES = 32;
  static const int MIN_PIN_LENGTH = 6;
  static const int MAX_BACKUP_SIZE_MB = 50;
  static const Duration RETRY_DELAY = Duration(seconds: 1);
  static const int MAX_RETRY_ATTEMPTS = 3;
  static const Duration KEY_CACHE_DURATION = Duration(minutes: 15);
}
