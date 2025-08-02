import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/logger.dart';

class OldDataDecrypt {
  
  Future<List<Map<String, dynamic>>> decryptOldData() async {
    final stopwatch = Stopwatch()..start();
    final accounts = await AccountBox.getAll();
    logInfo("Get all accounts: ${stopwatch.elapsed}");
    
    if (accounts.isEmpty) {
      return [];
    }

    try {
      // Khởi tạo EncryptAppDataService nếu chưa
      await EncryptAppDataService.instance.initialize();
      logInfo("EncryptAppDataService initialized: ${stopwatch.elapsed}");

      // Sử dụng batch decrypt với compute() - tối ưu nhất
      const batchSize = 50; // Tăng batch size vì compute() hiệu quả hơn
      final results = <Map<String, dynamic>>[];
      
      for (int i = 0; i < accounts.length; i += batchSize) {
        final end = (i + batchSize < accounts.length) ? i + batchSize : accounts.length;
        final batch = accounts.sublist(i, end);
        
        logInfo("Processing batch ${(i ~/ batchSize) + 1}/${(accounts.length / batchSize).ceil()} with compute()");
        
        try {
          // Sử dụng batch decrypt trong isolate
          final batchResults = await EncryptAppDataService.instance.batchDecryptAccounts(batch);
          results.addAll(batchResults);
        } catch (e) {
          logError('Error batch decrypting, fallback to individual decrypt: $e');
          
          // Fallback: decrypt từng account riêng lẻ
          final fallbackResults = await Future.wait(
            batch.map((acc) => acc.toDecryptedJson().catchError((error) {
              logError('Error decrypting account ${acc.id}: $error');
              return _createFallbackData(acc);
            }))
          );
          results.addAll(fallbackResults);
        }
        
        // Delay nhỏ giữa các batch
        if (i + batchSize < accounts.length) {
          await Future.delayed(const Duration(milliseconds: 5));
        }
      }
      
      logInfo("Decrypt completed: ${stopwatch.elapsed}, total: ${results.length} accounts");
      return results;
    } catch (e) {
      logError('Error in batch decrypt, using fallback method: $e');
      
      // Fallback method: decrypt tuần tự
      return await _fallbackDecryptMethod(accounts, stopwatch);
    }
  }

  // Phương thức fallback nếu batch decrypt thất bại
  Future<List<Map<String, dynamic>>> _fallbackDecryptMethod(List<AccountOjbModel> accounts, Stopwatch stopwatch) async {
    const batchSize = 10;
    final results = <Map<String, dynamic>>[];
    
    for (int i = 0; i < accounts.length; i += batchSize) {
      final end = (i + batchSize < accounts.length) ? i + batchSize : accounts.length;
      final batch = accounts.sublist(i, end);
      
      logInfo("Fallback processing batch ${(i ~/ batchSize) + 1}/${(accounts.length / batchSize).ceil()}");
      
      final batchResults = await Future.wait(
        batch.map((acc) => acc.toDecryptedJson().catchError((error) {
          logError('Error decrypting account ${acc.id}: $error');
          return _createFallbackData(acc);
        }))
      );
      
      results.addAll(batchResults);
      
      if (i + batchSize < accounts.length) {
        await Future.delayed(const Duration(milliseconds: 20));
      }
    }
    
    logInfo("Fallback decrypt completed: ${stopwatch.elapsed}, total: ${results.length} accounts");
    return results;
  }

  Map<String, dynamic> _createFallbackData(AccountOjbModel account) {
    return {
      'id': account.id,
      'title': account.title,
      'email': account.email ?? '',
      'password': account.password ?? '',
      'notes': account.notes ?? '',
      'icon': account.icon ?? 'account_circle',
      'customFields': [],
      'totp': null,
      'category': account.getCategory?.toJson(),
      'passwordUpdatedAt': account.passwordUpdatedAt?.toIso8601String(),
      'passwordHistories': [],
      'iconCustom': account.getIconCustom?.toJson(),
      'createdAt': account.createdAt?.toIso8601String(),
      'updatedAt': account.updatedAt?.toIso8601String(),
    };
  }
}
