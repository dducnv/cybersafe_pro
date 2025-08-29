import 'dart:developer';
import 'dart:io';

import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/constants/secure_storage_key.dart';
import 'package:cybersafe_pro/database/boxes/account_box.dart';
import 'package:cybersafe_pro/database/boxes/account_custom_field_box.dart';
import 'package:cybersafe_pro/database/boxes/category_box.dart';
import 'package:cybersafe_pro/database/boxes/icon_custom_box.dart';
import 'package:cybersafe_pro/database/boxes/password_history_box.dart';
import 'package:cybersafe_pro/database/boxes/totp_box.dart';
import 'package:cybersafe_pro/database/objectbox.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/migrate_data/old_data_decrypt.dart';
import 'package:cybersafe_pro/repositories/driff_db/models/account_aggregate.dart';
import 'package:cybersafe_pro/secure/secure_app_manager.dart';
import 'package:cybersafe_pro/services/account/account_services.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';
import 'package:cybersafe_pro/utils/logger.dart';
import 'package:cybersafe_pro/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MigrateFromOldData {
  static Future<bool> startMigrate(BuildContext context) async {
    try {
      if (await SecureStorage.instance.read(key: SecureStorageKey.isMigrateOldData) == "true") {
        return false;
      }
      if (!context.mounted) return false;
      showLoadingDialog(
        loadingText: ValueNotifier<String>(context.trSafe(HomeLocale.migrationData)),
      );
      final stopwatch = Stopwatch()..start();
      final docsDir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(docsDir.path, "cyber_safe");
      logInfo("dbPath: $dbPath");
      logInfo("dbPath exists: ${await Directory(dbPath).exists()}");
      if (!await Directory(dbPath).exists()) {
        await SecureStorage.instance.save(key: SecureStorageKey.isMigrateOldData, value: "true");
        return false;
      }
      await _migratePinCode();
      await ObjectBox.create();
      logInfo("Start migrate data from old data: ${stopwatch.elapsed}ms");
      final oldData = await OldDataDecrypt().decryptOldData();
      logInfo("Decrypt old data: ${stopwatch.elapsed}ms");
      log(oldData.map((e) => e.toString()).toString());
      final accountAggregates = oldData.map((e) => AccountAggregate.fromOldDataJson(e)).toList();
      logInfo("Convert old data to account aggregates: ${stopwatch.elapsed}ms");
      log(accountAggregates.map((e) => e.toString()).toString());
      await AccountServices.instance.saveAccountsFromAccountAggregates(accountAggregates);
      deleteData();
      EncryptAppDataService.instance.clearAllKey();
      await SecureStorage.instance.save(key: SecureStorageKey.isMigrateOldData, value: "true");
      return true;
    } catch (e) {
      logError('Error migrating data: $e');
      return false;
    } finally {
      hideLoadingDialog();
    }
  }

  static Future<void> migratePinCodeV2() async {
    final pinCode = await SecureStorage.instance.read(key: SecureStorageKey.pinCode);
    final isEnableLocalAuth = await SecureStorage.instance.readBool(
      SecureStorageKey.isEnableLocalAuth,
    );

    if (pinCode != null) {
      String pinCodeEncrypted = await DataSecureService.decryptPinCode(pinCode);
      await SecureAppManager.initializeNewUser(pinCodeEncrypted);
      await SecureStorage.instance.delete(key: SecureStorageKey.pinCode);
      if (isEnableLocalAuth == true) {
        await SecureAppManager.enableBiometric();
      }
    }
  }

  //delete data
  static Future<bool> deleteData() async {
    try {
      try {
        await CategoryBox.deleteAll();
      } catch (e) {
        logError('Lỗi xóa CategoryBox: $e');
      }
      try {
        await AccountBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa AccountBox: $e');
      }
      try {
        await AccountCustomFieldBox.deleteAll();
      } catch (e) {
        logError('Lỗi xóa AccountCustomFieldBox: $e');
      }
      try {
        await IconCustomBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa IconCustomBox: $e');
      }
      try {
        await PasswordHistoryBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa PasswordHistoryBox: $e');
      }
      try {
        await TOTPBox.deleteAllAsync();
      } catch (e) {
        logError('Lỗi xóa TOTPBox: $e');
      }

      return true;
    } catch (e) {
      logError('Lỗi xóa tất cả dữ liệu: $e');
      return false;
    }
  }

  static Future<void> _migratePinCode() async {
    final pinCode = await SecureStorage.instance.read(key: SecureStorageKey.pinCode);
    if (pinCode == null) {
      return;
    }
    final decryptOldPinCode = await EncryptAppDataService.instance.decryptPinCode(pinCode);
    String pinCodeEncrypted = await DataSecureService.encryptPinCode(decryptOldPinCode);
    await SecureStorage.instance.save(key: SecureStorageKey.pinCode, value: pinCodeEncrypted);
  }
}
