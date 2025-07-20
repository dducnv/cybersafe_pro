class SecureStorageKey {
  static const String themMode = 'themMode';
  static const String themeMode = 'themeMode';
  static const String themeColor = 'themeColor';
  static const String surfaceColor = 'surfaceColor';
  static const String isDefaultTheme = 'isDefaultTheme';
  static const String appLang = 'appLang';
  static const String pinCode = 'pinCode';
  static const String isEnableLocalAuth = 'isEnableLocalAuth';
  static const String firstOpenApp = 'firstOpenApp';
  static const String fistOpenAppOld = 'fistOpenApp';
  static const String isRequiredPinCodeForFileBackup = 'isRequiredPinCodeForFileBackup';
  static const String isAutoLock = 'isAutoLock';
  static const String timeAutoLock = 'timeAutoLock';
  static const String versionEncryptKey = 'versionEncryptKey';
  static const String numberLogin = 'numberLogin';
  static const String lockOnBackground = 'lockOnBackground';

  static const String encryptionKeyCreationTime = "encryption_key_creation_time";
  
  //old_key
  static const String deviceKeyStorageKey = 'device_encryption_key';
  static const String infoKeyStorageKey = 'info_encryption_key';
  static const String passwordKeyStorageKey = 'password_encryption_key';
  static const String totpKeyStorageKey = 'totp_encryption_key';
  static const String pinCodeKeyStorageKey = 'pinCode_encryption_key';
  // static const String keyCreationTimeStorageKey = 'encryption_key_creation_time';
  static const String appVersionStorageKey = 'app_version';

  // Khóa cho tính năng khóa tài khoản
  static const String lockUntil = 'account_lock_until';
  static const String loginFailCount = 'login_fail_count';
  static const String lockDurationMultiplier = 'lock_duration_multiplier';

  //new_encript_key
  static const String secureDeviceKey = '@device_encryption_key';
  static const String secureInfoKey = '@info_encryption_key';
  static const String securePasswordKey = '@password_encryption_key';
  static const String secureTotpKey = '@totp_encryption_key';
  static const String securePinCodeKey = '@pinCode_encryption_key';
  static const String secureDatabaseKey = '@database_encryption_key';
  static const String secureNoteKey = '@note_encryption_key';
  
  // Key rotation support - thời gian tạo key
  static const String secureDeviceKeyCreationTime = '@device_encryption_key_creation_time';
  static const String secureInfoKeyCreationTime = '@info_encryption_key_creation_time';
  static const String securePasswordKeyCreationTime = '@password_encryption_key_creation_time';
  static const String secureTotpKeyCreationTime = '@totp_encryption_key_creation_time';
  static const String securePinCodeKeyCreationTime = '@pinCode_encryption_key_creation_time';
  
  // Performance và security tracking
  static const String devicePerformanceCache = '@device_performance_cache';
  static const String devicePerformanceTestTime = '@device_performance_test_time';
  static const String securityViolationCount = '@security_violation_count';
  static const String lastSecurityViolationTime = '@last_security_violation_time';
}
