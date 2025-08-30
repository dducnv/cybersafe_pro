// ignore_for_file: constant_identifier_names

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class EncryptionConfig {
  static const int KEY_SIZE_BYTES = 32; // 256-bit keys
  static const int SALT_SIZE_BYTES = 32; // 256-bit salt (increased from 16)
  static const int MIN_PIN_LENGTH = 6;
  static const int MAX_BACKUP_SIZE_MB = 50;
  static const Duration RETRY_DELAY = Duration(seconds: 1);
  static const int MAX_RETRY_ATTEMPTS = 3;

  static const Duration KEY_CACHE_DURATION = Duration(minutes: 15); // Reduced from 30

  // IV length standardization
  static const int IV_LENGTH_GCM = 12; // 96 bits for GCM mode
  static const int HMAC_KEY_LENGTH = 32; // 256-bit HMAC keys

  // Performance thresholds (microseconds)
  static const int PERFORMANCE_THRESHOLD_HIGH = 5000;
  static const int PERFORMANCE_THRESHOLD_MOBILE = 15000;

  // Security constants
  static const int SECURE_RANDOM_SEED_LENGTH = 32;
  static const int MEMORY_WIPE_PASSES = 3;
  static const int MAX_FAILED_ATTEMPTS = 5;
  static const Duration LOCKOUT_DURATION = Duration(minutes: 5);

  static const int biometricKeyLength = 32;

  // Cache configuration
  static DevicePerformance? _cachedPerformance;
  static DateTime? _performanceTestTime;

  static DevicePerformance get devicePerformance {
    if (_cachedPerformance != null &&
        _performanceTestTime != null &&
        DateTime.now().difference(_performanceTestTime!).inHours < 1) {
      return _cachedPerformance!;
    }
    _cachedPerformance = _detectDevicePerformance();
    _performanceTestTime = DateTime.now();
    return _cachedPerformance!;
  }

  static DevicePerformance _detectDevicePerformance() {
    if (kIsWeb) return DevicePerformance.mobile;
    final stopwatch = Stopwatch()..start();
    _performCryptoPerformanceTest();
    stopwatch.stop();

    final microseconds = stopwatch.elapsedMicroseconds;
    if (microseconds < PERFORMANCE_THRESHOLD_HIGH) {
      return DevicePerformance.high;
    } else if (microseconds < PERFORMANCE_THRESHOLD_MOBILE) {
      return DevicePerformance.mobile;
    } else {
      return DevicePerformance.lowEnd;
    }
  }

  static int memoryPowerOf2 = 15;
  static int iterations = 2;
  static int parallelism = 1;

  static const int saltLength = 32;
  static const int rmkLength = 32;
  static const int pinHashLength = 32;

  static void _performCryptoPerformanceTest() {
    try {
      final data = Uint8List.fromList(List.generate(1024, (i) => i % 256));
      for (int i = 0; i < 100; i++) {
        sha256.convert(data);
      }

      // Test AES-like operations
      var accumulator = 0;
      for (int i = 0; i < 10000; i++) {
        accumulator ^= (i * 0x9e3779b9) >> 16;
      }

      if (accumulator < 0) throw Exception('Impossible condition');
    } catch (e) {
      var sum = 0;
      for (int i = 0; i < 10000; i++) {
        sum += i * i * i;
      }
      if (sum < 0) throw Exception('Impossible');
    }
  }

  static const Map<String, String> KEY_PURPOSES = {
    'authentication': 'auth',
    'encryption': 'enc',
    'signing': 'sign',
    'backup': 'backup',
    'hmac': 'hmac',
    'kdf': 'kdf',
    'aes': 'aes',
    'integrity': 'integrity',
  };
}

enum DevicePerformance {
  high, // Desktop/high-end mobile
  mobile, // Standard mobile
  lowEnd, // Low-end mobile
}
