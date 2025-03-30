import 'dart:io';

import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity(uid: 3018443929711597194)
class PasswordHistory {
  @Id()
  int id;

  @Property(uid: 2667871814024352714)
  String password;

  @Property(uid: 5165880507350807871, type: PropertyType.date)
  DateTime createdAt;

  // Relation to Account
  final account = ToOne<AccountOjbModel>();

  PasswordHistory({this.id = 0, required this.password, DateTime? createdAt, DateTime? updatedAt}) : createdAt = createdAt ?? DateTime.now();

  final String defaultLocale = Platform.localeName;
  String get createdAtFormat => "${DateFormat.yMMMd(defaultLocale).format(createdAt)} ${DateFormat.Hm(defaultLocale).format(createdAt)}";

  final EncryptAppDataService _encryptAppDataService = EncryptAppDataService.instance;
  Future<Map<String, dynamic>> toDecryptedJson() async {
    return {'password': await _encryptAppDataService.decryptPassword(password), 'createdAt': createdAt.toIso8601String()};
  }

  //from json
  factory PasswordHistory.fromJson(Map<String, dynamic> json) {
    return PasswordHistory(
      id: json['id'] ?? 0,
      password: json['password'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {'id': id, 'password': password, 'createdAt': createdAt.toIso8601String()};
  }
}
