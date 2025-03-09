import 'package:cybersafe_pro/my_app.dart';
import 'package:cybersafe_pro/providers/provider.dart';
import 'package:cybersafe_pro/services/enscrypt_app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/objectbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo ObjectBox
  await ObjectBox.create();
  final encryptService = EncryptAppData.instance;
  await encryptService.initialize();
  runApp(MultiProvider(providers: ListProvider.providers, child: MyApp(),),);
}


