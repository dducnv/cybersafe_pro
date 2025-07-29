
// Enhanced cached key with memory encryption
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cybersafe_pro/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';

class CachedKey {
  final String _encryptedValue;
  final DateTime expiresAt;
  static const int _keySize = 32; // 256 bits

  CachedKey(String value, {Duration? customDuration}) 
    : expiresAt = DateTime.now().add(customDuration ?? KeyManager.MAX_CACHE_DURATION),
      _encryptedValue = _encryptValue(value);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  String get value {
    try {
      return _decryptValue(_encryptedValue);
    } catch (e) {
      logError('Failed to decrypt cached key: $e');
      throw Exception('Failed to decrypt cached key');
    }
  }

  // Encrypt value in memory using simple XOR with random key
  static String _encryptValue(String value) {
    try {
      // Generate a temporary key for memory encryption using secure Random
      final tempKey = Uint8List(_keySize);
      final random = Random.secure();
      for (int i = 0; i < tempKey.length; i++) {
        tempKey[i] = random.nextInt(256);
      }

      // Convert value to bytes
      final valueBytes = utf8.encode(value);
      final encrypted = Uint8List(valueBytes.length);

      // Simple XOR encryption (for memory protection only)
      for (int i = 0; i < valueBytes.length; i++) {
        encrypted[i] = valueBytes[i] ^ tempKey[i % tempKey.length];
      }

      // Combine encrypted data with temp key
      final combined = Uint8List(tempKey.length + encrypted.length);
      for (int i = 0; i < tempKey.length; i++) {
        combined[i] = tempKey[i];
      }
      for (int i = 0; i < encrypted.length; i++) {
        combined[tempKey.length + i] = encrypted[i];
      }

      // Securely wipe temp key
      _secureWipe(tempKey);

      return base64.encode(combined);
    } catch (e) {
      logError('Failed to encrypt cached key: $e');
      throw Exception('Failed to encrypt cached key');
    }
  }

  // Decrypt value from memory
  static String _decryptValue(String encryptedValue) {
    try {
      // Decode from base64
      final combined = base64.decode(encryptedValue);
      
      // Extract temp key and encrypted value
      final tempKey = Uint8List(_keySize);
      final encrypted = Uint8List(combined.length - tempKey.length);
      
      for (int i = 0; i < tempKey.length; i++) {
        tempKey[i] = combined[i];
      }
      for (int i = 0; i < encrypted.length; i++) {
        encrypted[i] = combined[tempKey.length + i];
      }

      // Decrypt using XOR
      final decrypted = Uint8List(encrypted.length);
      for (int i = 0; i < encrypted.length; i++) {
        decrypted[i] = encrypted[i] ^ tempKey[i % tempKey.length];
      }

      final result = utf8.decode(decrypted);

      // Securely wipe temp key
      _secureWipe(tempKey);

      return result;
    } catch (e) {
      logError('Failed to decrypt cached key: $e');
      throw Exception('Failed to decrypt cached key');
    }
  }

  // Securely wipe sensitive data
  static void _secureWipe(Uint8List data) {
    if (data.isNotEmpty) {
      data.fillRange(0, data.length, 0);
    }
  }
}
