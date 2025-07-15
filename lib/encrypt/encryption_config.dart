// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

class EncryptionConfig {
  static const int PBKDF2_ITERATIONS = 15000;
  static const int KEY_SIZE_BYTES = 32;
  static const int MIN_PIN_LENGTH = 6;
  static const int MAX_BACKUP_SIZE_MB = 50;
  static const Duration RETRY_DELAY = Duration(seconds: 1);
  static const int MAX_RETRY_ATTEMPTS = 3;

  static const Duration KEY_CACHE_DURATION = Duration(minutes: 30);
  
  static const int ARGON2_ITERATIONS = 3;
  static const int ARGON2_MEMORY_POWER = 18; // 256MB
  static const int ARGON2_LANES = 4;
  
  // Cấu hình Argon2 adaptive cho mobile devices (hiệu suất tốt hơn)
  static const int ARGON2_ITERATIONS_MOBILE = 2;
  static const int ARGON2_MEMORY_POWER_MOBILE = 16; // 64MB
  static const int ARGON2_LANES_MOBILE = 2;
  
  // Cấu hình Argon2 cho low-end devices
  static const int ARGON2_ITERATIONS_LOW_END = 1;
  static const int ARGON2_MEMORY_POWER_LOW_END = 14; // 16MB
  static const int ARGON2_LANES_LOW_END = 1;
  
  // Cấu hình AES KDF
  static const int AES_KDF_ITERATIONS = 10000;
  
  // Cấu hình Key Rotation
  static const Duration MAX_KEY_AGE = Duration(days: 90);
  
  // Cấu hình IV length chuẩn hóa
  static const int IV_LENGTH_GCM = 12; // 96 bits cho GCM mode
  static const int IV_LENGTH_CBC = 16; // 128 bits cho CBC mode
  
  // Cấu hình Integrity
  static const int INTEGRITY_HASH_LENGTH = 64; // Full SHA-256 hash
  
  // Cache cho device performance và config values
  static DevicePerformance? _cachedPerformance;
  static DateTime? _performanceTestTime;
  static int? _cachedArgon2Iterations;
  static int? _cachedArgon2MemoryPower;
  static int? _cachedArgon2Lanes;
  
  static DevicePerformance get devicePerformance {
    // Cache performance test kết quả trong 1 giờ
    if (_cachedPerformance != null && 
        _performanceTestTime != null && 
        DateTime.now().difference(_performanceTestTime!).inHours < 1) {
      return _cachedPerformance!;
    }
    
    _cachedPerformance = _detectDevicePerformance();
    _performanceTestTime = DateTime.now();
    _updateCachedValues(); // Cập nhật cache values khi performance thay đổi
    return _cachedPerformance!;
  }
  
  static DevicePerformance _detectDevicePerformance() {
    // Kiểm tra platform
    if (kIsWeb) return DevicePerformance.mobile;
    
    // Thực hiện performance test đơn giản
    final stopwatch = Stopwatch()..start();
    _performanceTest();
    stopwatch.stop();
    
    final microseconds = stopwatch.elapsedMicroseconds;
    
    // Phân loại performance dựa trên test time
    if (microseconds < 1000) {
      return DevicePerformance.high;
    } else if (microseconds < 5000) {
      return DevicePerformance.mobile;
    } else {
      return DevicePerformance.lowEnd;
    }
  }
  
  static void _performanceTest() {
    // Test crypto performance
    var sum = 0;
    for (int i = 0; i < 10000; i++) {
      sum += i * i * i;
    }
    
    // Prevent optimization
    if (sum < 0) throw Exception('Impossible');
  }
  
  // Cập nhật cached values khi performance thay đổi
  static void _updateCachedValues() {
    switch (_cachedPerformance!) {
      case DevicePerformance.high:
        _cachedArgon2Iterations = ARGON2_ITERATIONS;
        _cachedArgon2MemoryPower = ARGON2_MEMORY_POWER;
        _cachedArgon2Lanes = ARGON2_LANES;
        break;
      case DevicePerformance.mobile:
        _cachedArgon2Iterations = ARGON2_ITERATIONS_MOBILE;
        _cachedArgon2MemoryPower = ARGON2_MEMORY_POWER_MOBILE;
        _cachedArgon2Lanes = ARGON2_LANES_MOBILE;
        break;
      case DevicePerformance.lowEnd:
        _cachedArgon2Iterations = ARGON2_ITERATIONS_LOW_END;
        _cachedArgon2MemoryPower = ARGON2_MEMORY_POWER_LOW_END;
        _cachedArgon2Lanes = ARGON2_LANES_LOW_END;
        break;
    }
  }
  
  // Getters tối ưu hóa - chỉ return cached values
  static int get argon2Iterations {
    if (_cachedArgon2Iterations == null) {
      // Trigger performance detection và cache update
      devicePerformance;
    }
    return _cachedArgon2Iterations!;
  }
  
  static int get argon2MemoryPower {
    if (_cachedArgon2MemoryPower == null) {
      // Trigger performance detection và cache update
      devicePerformance;
    }
    return _cachedArgon2MemoryPower!;
  }
  
  static int get argon2Lanes {
    if (_cachedArgon2Lanes == null) {
      // Trigger performance detection và cache update
      devicePerformance;
    }
    return _cachedArgon2Lanes!;
  }
  
  // Method để force refresh cache (dùng khi cần test lại performance)
  static void refreshPerformanceCache() {
    _cachedPerformance = null;
    _performanceTestTime = null;
    _cachedArgon2Iterations = null;
    _cachedArgon2MemoryPower = null;
    _cachedArgon2Lanes = null;
  }
}

enum DevicePerformance {
  high,     // Desktop/high-end mobile
  mobile,   // Standard mobile
  lowEnd,   // Low-end mobile
}
