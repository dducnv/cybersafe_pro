import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'PIN_CODE_ENCRYPT_KEY', obfuscate: true)
  static final String pinCodeKeyEncrypt = _Env.pinCodeKeyEncrypt;

  @EnviedField(varName: 'INFO_ENCRYPT_KEY', obfuscate: true)
  static final String infoEncryptKey = _Env.infoEncryptKey;

  @EnviedField(varName: 'PASSWORD_ENCRYPT_KEY', obfuscate: true)
  static final String passwordEncryptKey = _Env.passwordEncryptKey;

  @EnviedField(varName: 'FILE_ENCRYPT_KEY', obfuscate: true)
  static final String fileEncryptKey = _Env.fileEncryptKey;

  @EnviedField(varName: 'TOTP_ENCRYPT_KEY', obfuscate: true)
  static final String totpEncryptKey = _Env.totpEncryptKey;

  //old_key
  @EnviedField(varName: 'OLD_PIN_CODE_ENCRYPT_KEY', obfuscate: true)
  static final String oldPinCodeKeyEncrypt = _Env.oldPinCodeKeyEncrypt;

  @EnviedField(varName: 'OLD_INFO_ENCRYPT_KEY', obfuscate: true)
  static final String oldInfoEncryptKey = _Env.oldInfoEncryptKey;

  @EnviedField(varName: 'OLD_PASSWORD_ENCRYPT_KEY', obfuscate: true)
  static final String oldPasswordEncryptKey = _Env.oldPasswordEncryptKey;

  @EnviedField(varName: 'OLD_FILE_ENCRYPT_KEY', obfuscate: true)
  static final String oldFileEncryptKey = _Env.oldFileEncryptKey;

  @EnviedField(varName: 'OLD_TOTP_ENCRYPT_KEY', obfuscate: true)
  static final String oldTotpEncryptKey = _Env.oldTotpEncryptKey;

  @EnviedField(varName: 'VERSION_KEY', obfuscate: true)
  static final String versionKey = _Env.versionKey;

  @EnviedField(varName: 'BACKUP_FILE_ENCRYPT_KEY', obfuscate: true)
  static final String backupFileEncryptKey = _Env.backupFileEncryptKey;

  @EnviedField(varName: 'TRANSFER_FILE_ENCRYPT_KEY', obfuscate: true)
  static final String transferFileEncryptKey = _Env.transferFileEncryptKey;

  @EnviedField(varName: 'APP_SIGNATURE_KEY', obfuscate: true)
  static final String appSignatureKey = _Env.appSignatureKey;

  @EnviedField(varName: 'ORCHESTRATION_ENCRYPTION_KEY', obfuscate: true)
  static final String orchestrationEncryptionKey = _Env.orchestrationEncryptionKey;
}
