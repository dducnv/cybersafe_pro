import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class OldEncryptUtils {
  static final instance = OldEncryptUtils._internal();

  OldEncryptUtils._internal();

  String encryptFernet({
    required String value,
    required String key,
  }) {
    try {
      if (key.isEmpty || value.isEmpty) {
        return "";
      }
      var keyFromUtf8 = Key.fromUtf8(key);
      final b64key =
          Key.fromUtf8(base64Url.encode(keyFromUtf8.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      final encrypted = encrypter.encrypt(value);
      return encrypted.base64;
    } catch (e) {
      throw Exception("Error encrypting data $e");
    }
  }

  String decryptFernet({required String value, required String key}) {
    try {
      var keyFromUtf8 = Key.fromUtf8(key);
      final b64key =
          Key.fromUtf8(base64Url.encode(keyFromUtf8.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      final decrypted = encrypter.decrypt(Encrypted.fromBase64(value));
      return decrypted;
    } catch (e) {
      throw Exception("Error decryptFernet data $e");
    }
  }

  List<int> encryptFernetBytes({required List<int> data, required String key}) {
    try {
      var keyFromUtf8 = Key.fromUtf8(key);
      final b64key =
          Key.fromUtf8(base64Url.encode(keyFromUtf8.bytes).substring(0, 32));

      Encrypter encrypter = Encrypter(Fernet(b64key));
      Encrypted encryptedData = encrypter.encryptBytes(data);

      return encryptedData.bytes;
    } catch (e) {
      throw Exception("Error encryptFernetBytes data $e");
    }
  }

  List<int> decryptFernetBytes(
      {required List<int> encryptedData, required String key}) {
    try {
      var keyFromUtf8 = Key.fromUtf8(key);
      final b64key =
          Key.fromUtf8(base64Url.encode(keyFromUtf8.bytes).substring(0, 32));

      Encrypter encrypter = Encrypter(Fernet(b64key));
      final uint8List = Uint8List.fromList(encryptedData);
      List<int> decryptedData = encrypter.decryptBytes(Encrypted(uint8List));
      return decryptedData;
    } catch (e) {
      throw Exception("Error decryptFernetBytes: $e");
    }
  }
}
