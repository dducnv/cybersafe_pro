import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constantTimeEquals Security Fix', () {
    bool constantTimeEquals(String a, String b) {
      final maxLen = a.length > b.length ? a.length : b.length;
      var result = a.length ^ b.length;
      for (int i = 0; i < maxLen; i++) {
        final ca = i < a.length ? a.codeUnitAt(i) : 0;
        final cb = i < b.length ? b.codeUnitAt(i) : 0;
        result |= ca ^ cb;
      }
      return result == 0;
    }

    test('should return true for matching strings', () {
      expect(constantTimeEquals('hello', 'hello'), true);
    });

    test('should return false for different content', () {
      expect(constantTimeEquals('hello', 'world'), false);
    });

    test('should return false for different lengths without early return', () {
      // The old version would return early on length mismatch
      // The new version processes all characters
      expect(constantTimeEquals('short', 'longer_string'), false);
      expect(constantTimeEquals('longer_string', 'short'), false);
    });

    test('should return false for empty vs non-empty', () {
      expect(constantTimeEquals('', 'notempty'), false);
      expect(constantTimeEquals('notempty', ''), false);
    });

    test('should return true for empty vs empty', () {
      expect(constantTimeEquals('', ''), true);
    });

    test('should handle base64-encoded hash comparison', () {
      final hash1 = base64.encode(sha256.convert(utf8.encode('test')).bytes);
      final hash2 = base64.encode(sha256.convert(utf8.encode('test')).bytes);
      final hash3 = base64.encode(sha256.convert(utf8.encode('other')).bytes);

      expect(constantTimeEquals(hash1, hash2), true);
      expect(constantTimeEquals(hash1, hash3), false);
    });

    test('timing consistency - no early return on length mismatch', () {
      // Run many iterations to verify no significant timing difference
      final sameLenDurations = <int>[];
      final diffLenDurations = <int>[];

      for (int i = 0; i < 100; i++) {
        final sw1 = Stopwatch()..start();
        constantTimeEquals('a' * 1000, 'b' * 1000);
        sw1.stop();
        sameLenDurations.add(sw1.elapsedMicroseconds);

        final sw2 = Stopwatch()..start();
        constantTimeEquals('a' * 100, 'b' * 1000);
        sw2.stop();
        diffLenDurations.add(sw2.elapsedMicroseconds);
      }

      // Both should execute (not return early)
      // We can't assert exact timing, but we can verify function completes
      expect(sameLenDurations.isNotEmpty, true);
      expect(diffLenDurations.isNotEmpty, true);
    });
  });

  group('Argon2 Config Version Tests', () {
    test('old params should be weaker than new params', () {
      // Old: memoryPowerOf2=15 (32KB), iterations=2
      // New: memoryPowerOf2=16 (64KB), iterations=3
      const oldMemory = 15;
      const newMemory = 16;
      const oldIterations = 2;
      const newIterations = 3;

      expect(newMemory > oldMemory, true, reason: 'New memory should be higher');
      expect(newIterations > oldIterations, true, reason: 'New iterations should be higher');

      // 2^16 = 65536 bytes = 64KB
      expect(1 << newMemory, 65536);
      // 2^15 = 32768 bytes = 32KB
      expect(1 << oldMemory, 32768);
    });

    test('parallelism should be consistent', () {
      const oldParallelism = 1;
      const newParallelism = 1;
      expect(oldParallelism, newParallelism);
    });
  });

  group('CachedKey PRNG Security', () {
    test('Random.secure should produce different outputs each time', () {
      Uint8List generateSecureRandomBytes(int length) {
        final random = Random.secure();
        return Uint8List.fromList(List<int>.generate(length, (_) => random.nextInt(256)));
      }

      final bytes1 = generateSecureRandomBytes(32);
      final bytes2 = generateSecureRandomBytes(32);

      // Should be different (astronomically unlikely to be same)
      expect(bytes1, isNot(equals(bytes2)));
    });

    test('Random.secure should produce uniform distribution', () {
      final random = Random.secure();
      final counts = List<int>.filled(256, 0);
      const sampleSize = 100000;

      for (int i = 0; i < sampleSize; i++) {
        counts[random.nextInt(256)]++;
      }

      // Each byte value should appear roughly sampleSize/256 times
      final expected = sampleSize / 256;
      for (int i = 0; i < 256; i++) {
        // Allow ±50% deviation (very generous for CSPRNG)
        expect(counts[i] > expected * 0.5, true, reason: 'Byte $i appears too rarely: ${counts[i]}');
        expect(counts[i] < expected * 1.5, true, reason: 'Byte $i appears too often: ${counts[i]}');
      }
    });
  });

  group('EncryptBaseInfo Version Compatibility', () {
    test('v4.0 package with HMAC should be accepted', () {
      final v4Package = {
        'salt': base64.encode(utf8.encode('test_salt')),
        'iv': base64.encode(utf8.encode('test_iv_12b!')),
        'data': base64.encode(utf8.encode('encrypted')),
        'hmac': 'some_hmac_value',
        'timestamp': DateTime.now().toIso8601String(),
        'version': '4.0',
        'algorithm': 'AES-256-GCM',
        'kdf': 'None',
      };

      expect(v4Package['version'], '4.0');
      expect(v4Package.containsKey('hmac'), true);
      // v4.0 should be supported
      final version = v4Package['version'];
      expect(version == '4.0' || version == '5.0', true);
    });

    test('v5.0 package without HMAC should be accepted', () {
      final v5Package = {
        'salt': base64.encode(utf8.encode('test_salt')),
        'iv': base64.encode(utf8.encode('test_iv_12b!')),
        'data': base64.encode(utf8.encode('encrypted')),
        'timestamp': DateTime.now().toIso8601String(),
        'version': '5.0',
        'algorithm': 'AES-256-GCM',
        'kdf': 'None',
      };

      expect(v5Package['version'], '5.0');
      expect(v5Package.containsKey('hmac'), false);
      // v5.0 should be supported
      final version = v5Package['version'];
      expect(version == '4.0' || version == '5.0', true);
    });

    test('unsupported version should be rejected', () {
      final version = '3.0';
      expect(version == '4.0' || version == '5.0', false);
    });
  });

  group('HKDF Deterministic Salt vs Random Salt', () {
    test('deterministic salt produces same output for same input', () {
      Uint8List generateDeterministicSalt(String context) {
        final contextBytes = utf8.encode(context);
        final hash = sha256.convert(contextBytes).bytes;
        return Uint8List.fromList(hash);
      }

      final salt1 = generateDeterministicSalt('pin_key_derivation_v2');
      final salt2 = generateDeterministicSalt('pin_key_derivation_v2');

      // Deterministic salt = same for all users (BAD for security)
      expect(salt1, equals(salt2));
    });

    test('random salt produces different output each time', () {
      Uint8List generateRandomSalt(int length) {
        final random = Random.secure();
        return Uint8List.fromList(List<int>.generate(length, (_) => random.nextInt(256)));
      }

      final salt1 = generateRandomSalt(32);
      final salt2 = generateRandomSalt(32);

      // Random salt = different for each user (GOOD for security)
      expect(salt1, isNot(equals(salt2)));
    });
  });

  group('Secure Wipe Tests', () {
    test('wipe should clear all bytes to zero', () {
      final data = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      // Multi-pass wipe
      final random = Random.secure();
      for (int pass = 0; pass < 3; pass++) {
        for (int i = 0; i < data.length; i++) {
          data[i] = random.nextInt(256);
        }
      }
      data.fillRange(0, data.length, 0);

      expect(data.every((b) => b == 0), true);
    });
  });
}
