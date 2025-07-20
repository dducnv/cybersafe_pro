// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

class EncryptionConfig {
  // PBKDF2 Configuration (OWASP 2023 recommendations)
  static const int PBKDF2_ITERATIONS = 250000; //For 
  static const int PBKDF2_ITERATIONS_MOBILE = 100000; // For mobile optimization
  static const int PBKDF2_ITERATIONS_LOW_END = 50000; // For low-end devices
  
  static const int KEY_SIZE_BYTES = 32; // 256-bit keys
  static const int SALT_SIZE_BYTES = 32; // 256-bit salt (increased from 16)
  static const int MIN_PIN_LENGTH = 6;
  static const int MAX_BACKUP_SIZE_MB = 50;
  static const Duration RETRY_DELAY = Duration(seconds: 1);
  static const int MAX_RETRY_ATTEMPTS = 3;

  static const Duration KEY_CACHE_DURATION = Duration(minutes: 15); // Reduced from 30
  
  // Argon2 Configuration (adjusted for mobile)
  static const int ARGON2_ITERATIONS = 3;
  static const int ARGON2_MEMORY_POWER = 17; // 128MB for high-end
  static const int ARGON2_LANES = 4;
  
  // Argon2 mobile optimized
  static const int ARGON2_ITERATIONS_MOBILE = 2;
  static const int ARGON2_MEMORY_POWER_MOBILE = 15; // 32MB for mobile
  static const int ARGON2_LANES_MOBILE = 2;
  
  // Argon2 low-end optimized
  static const int ARGON2_ITERATIONS_LOW_END = 1;
  static const int ARGON2_MEMORY_POWER_LOW_END = 13; // 8MB for low-end
  static const int ARGON2_LANES_LOW_END = 1;
  
  // HKDF Configuration
  static const int HKDF_SALT_LENGTH = 32;
  static const int HKDF_INFO_MAX_LENGTH = 255;
  
  // Key Rotation Configuration
  static const Duration MAX_KEY_AGE = Duration(days: 90);
  static const Duration KEY_ROTATION_WARNING = Duration(days: 75);
  
  // IV length standardization
  static const int IV_LENGTH_GCM = 12; // 96 bits for GCM mode
  static const int IV_LENGTH_CBC = 16; // 128 bits for CBC mode
  
  // Integrity Configuration
  static const int INTEGRITY_HASH_LENGTH = 32; // SHA-256 hash length
  static const int HMAC_KEY_LENGTH = 32; // 256-bit HMAC keys
  
  // Performance thresholds (microseconds)
  static const int PERFORMANCE_THRESHOLD_HIGH = 5000;
  static const int PERFORMANCE_THRESHOLD_MOBILE = 15000;
  static const int PERFORMANCE_THRESHOLD_LOW_END = 50000;
  
  // Security constants
  static const int SECURE_RANDOM_SEED_LENGTH = 32;
  static const int MEMORY_WIPE_PASSES = 3;
  static const int MAX_FAILED_ATTEMPTS = 5;
  static const Duration LOCKOUT_DURATION = Duration(minutes: 5);
  
  // Cache configuration
  static DevicePerformance? _cachedPerformance;
  static DateTime? _performanceTestTime;
  static int? _cachedPbkdf2Iterations;
  static int? _cachedArgon2Iterations;
  static int? _cachedArgon2MemoryPower;
  static int? _cachedArgon2Lanes;
  
  static DevicePerformance get devicePerformance {
    // Cache performance test results for 1 hour
    if (_cachedPerformance != null && 
        _performanceTestTime != null && 
        DateTime.now().difference(_performanceTestTime!).inHours < 1) {
      return _cachedPerformance!;
    }
    
    _cachedPerformance = _detectDevicePerformance();
    _performanceTestTime = DateTime.now();
    _updateCachedValues();
    return _cachedPerformance!;
  }
  
  static DevicePerformance _detectDevicePerformance() {
    if (kIsWeb) return DevicePerformance.mobile;
    
    // Improved performance test with crypto operations
    final stopwatch = Stopwatch()..start();
    _performCryptoPerformanceTest();
    stopwatch.stop();
    
    final microseconds = stopwatch.elapsedMicroseconds;
    
    // More accurate performance classification
    if (microseconds < PERFORMANCE_THRESHOLD_HIGH) {
      return DevicePerformance.high;
    } else if (microseconds < PERFORMANCE_THRESHOLD_MOBILE) {
      return DevicePerformance.mobile;
    } else {
      return DevicePerformance.lowEnd;
    }
  }
  
  static void _performCryptoPerformanceTest() {
    try {
      // Test SHA-256 performance
      final data = Uint8List.fromList(List.generate(1024, (i) => i % 256));
      for (int i = 0; i < 100; i++) {
        sha256.convert(data);
      }
      
      // Test AES-like operations
      var accumulator = 0;
      for (int i = 0; i < 10000; i++) {
        accumulator ^= (i * 0x9e3779b9) >> 16;
      }
      
      // Prevent compiler optimization
      if (accumulator < 0) throw Exception('Impossible condition');
    } catch (e) {
      // Fallback to simple arithmetic test
      var sum = 0;
      for (int i = 0; i < 10000; i++) {
        sum += i * i * i;
      }
      if (sum < 0) throw Exception('Impossible');
    }
  }
  
  static void _updateCachedValues() {
    switch (_cachedPerformance!) {
      case DevicePerformance.high:
        _cachedPbkdf2Iterations = PBKDF2_ITERATIONS;
        _cachedArgon2Iterations = ARGON2_ITERATIONS;
        _cachedArgon2MemoryPower = ARGON2_MEMORY_POWER;
        _cachedArgon2Lanes = ARGON2_LANES;
        break;
      case DevicePerformance.mobile:
        _cachedPbkdf2Iterations = PBKDF2_ITERATIONS_MOBILE;
        _cachedArgon2Iterations = ARGON2_ITERATIONS_MOBILE;
        _cachedArgon2MemoryPower = ARGON2_MEMORY_POWER_MOBILE;
        _cachedArgon2Lanes = ARGON2_LANES_MOBILE;
        break;
      case DevicePerformance.lowEnd:
        _cachedPbkdf2Iterations = PBKDF2_ITERATIONS_LOW_END;
        _cachedArgon2Iterations = ARGON2_ITERATIONS_LOW_END;
        _cachedArgon2MemoryPower = ARGON2_MEMORY_POWER_LOW_END;
        _cachedArgon2Lanes = ARGON2_LANES_LOW_END;
        break;
    }
  }
  
  // Optimized getters with caching
  static int get pbkdf2Iterations {
    if (_cachedPbkdf2Iterations == null) {
      devicePerformance; // Trigger cache update
    }
    return _cachedPbkdf2Iterations!;
  }
  
  static int get argon2Iterations {
    if (_cachedArgon2Iterations == null) {
      devicePerformance; // Trigger cache update
    }
    return _cachedArgon2Iterations!;
  }
  
  static int get argon2MemoryPower {
    if (_cachedArgon2MemoryPower == null) {
      devicePerformance; // Trigger cache update
    }
    return _cachedArgon2MemoryPower!;
  }
  
  static int get argon2Lanes {
    if (_cachedArgon2Lanes == null) {
      devicePerformance; // Trigger cache update
    }
    return _cachedArgon2Lanes!;
  }
  
  // Security validation methods
  static bool isValidKeyLength(int length) {
    return length >= 16 && length <= 64; // 128-bit to 512-bit
  }
  
  static bool isValidSaltLength(int length) {
    return length >= 16 && length <= 64; // 128-bit to 512-bit
  }
  
  static bool isValidIterations(int iterations) {
    return iterations >= 10000 && iterations <= 1000000;
  }
  
  // Performance cache refresh
  static void refreshPerformanceCache() {
    _cachedPerformance = null;
    _performanceTestTime = null;
    _cachedPbkdf2Iterations = null;
    _cachedArgon2Iterations = null;
    _cachedArgon2MemoryPower = null;
    _cachedArgon2Lanes = null;
  }
  
  // Security constants for different key purposes
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
  
  // Context-specific key derivation purposes
  static const Map<String, String> ENCRYPTION_CONTEXTS = {
    'basic_encryption': 'basic',
    'critical_encryption': 'critical',
    'backup_encryption': 'backup',
    'otp_encryption': 'otp',
    'pin_encryption': 'pin',
    'database_encryption': 'database',
  };
  
  // Derived key cache configuration
  static const Duration DERIVED_KEY_CACHE_DURATION = Duration(minutes: 5);
  static const int MAX_DERIVED_KEYS_PER_CONTEXT = 10;
  
  // HKDF specific configuration
  static const int HKDF_MAX_OUTPUT_LENGTH = 255 * 32; // SHA-256 limitation
  static const String HKDF_DEFAULT_INFO_PREFIX = 'cybersafe_pro_v2';
  
  // Key derivation validation
  static bool isValidKeyPurpose(String purpose) {
    return KEY_PURPOSES.containsKey(purpose) || 
           KEY_PURPOSES.containsValue(purpose);
  }
  
  static bool isValidEncryptionContext(String context) {
    return ENCRYPTION_CONTEXTS.containsKey(context) || 
           ENCRYPTION_CONTEXTS.containsValue(context);
  }
  
  // Get standardized context name
  static String getStandardizedContext(String context) {
    return ENCRYPTION_CONTEXTS[context] ?? context;
  }
  
  // Get standardized purpose name
  static String getStandardizedPurpose(String purpose) {
    return KEY_PURPOSES[purpose] ?? purpose;
  }
}

enum DevicePerformance {
  high,     // Desktop/high-end mobile
  mobile,   // Standard mobile
  lowEnd,   // Low-end mobile
}
