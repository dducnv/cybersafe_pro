import 'dart:developer';

import 'package:cybersafe_pro/encrypt/argon2/secure_argon2.dart';
import 'package:cybersafe_pro/encrypt/ase_256/secure_ase256.dart';
import 'package:cybersafe_pro/encrypt/key_manager.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:flutter/material.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Developer Tools')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final derivedKeyStopwatch = Stopwatch()..start();
                  await KeyManager.instance.getDerivedKeys(KeyType.totp, 'critical_encryption', purposes: ['aes', 'hmac']);
                  derivedKeyStopwatch.stop();
                  logInfo("Thời gian lấy derived keys: ${derivedKeyStopwatch.elapsedMilliseconds}ms");

                  final encryptStopwatch = Stopwatch()..start();
                  final encrypted = await SecureArgon2.encrypt(
                    plainText: "rửyrwetryewtryewtrytewyrewtryew fihsdfisdfuisdfuisd fdshfjsdhfjdshf  fsjdfhsjfshfjs",
                    keyType: KeyType.password,
                    associatedData: "data_liên_quan",
                  );
                  encryptStopwatch.stop();
                  logInfo("Thời gian mã hoá: ${encryptStopwatch.elapsedMilliseconds}ms");

                  final decryptStopwatch = Stopwatch()..start();
                  final decrypted = await SecureArgon2.decrypt(value: encrypted, keyType: KeyType.password, associatedData: "data_liên_quan");
                  decryptStopwatch.stop();
                  logInfo("Thời gian giải mã: ${decryptStopwatch.elapsedMilliseconds}ms");

                  final cachedKeyStopwatch = Stopwatch()..start();
                  await KeyManager.instance.getDerivedKeys(KeyType.password, 'critical_encryption', purposes: ['aes', 'hmac']);
                  cachedKeyStopwatch.stop();
                  logInfo("Thời gian lấy derived keys (từ cache): ${cachedKeyStopwatch.elapsedMilliseconds}ms");

                  final key = await KeyManager.getKey(KeyType.info);
                  final ase256Stopwatch = Stopwatch()..start();
                  SecureAse256.encrypt(value: "duudududududu25005", key: key, associatedData: "data_liên_quan");
                  ase256Stopwatch.stop();
                  logInfo("Thời gian mã hoá SecureAse256: ${ase256Stopwatch.elapsedMilliseconds}ms");

                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Kết quả đo hiệu năng'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lấy derived keys: ${derivedKeyStopwatch.elapsedMilliseconds}ms'),
                                Text('Mã hoá SecureArgon2: ${encryptStopwatch.elapsedMilliseconds}ms'),
                                Text('Giải mã SecureArgon2: ${decryptStopwatch.elapsedMilliseconds}ms'),
                                Text('Lấy derived keys (cache): ${cachedKeyStopwatch.elapsedMilliseconds}ms'),
                                Text('Mã hoá SecureAse256: ${ase256Stopwatch.elapsedMilliseconds}ms'),
                                const Divider(),
                                Text('Dữ liệu mã hoá: ${encrypted.length} ký tự'),
                                Text('Dữ liệu giải mã: $decrypted'),
                              ],
                            ),
                          ),
                          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Đóng'))],
                        ),
                  );
                },
                child: const Text("Kiểm tra hiệu năng mã hoá"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
