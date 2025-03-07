import 'dart:io';

import 'package:cybersafe_pro/models/account_ojb_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class PasswordHistory {
  @Id()
  int id;
  String password;
  @Property(type: PropertyType.date)
  DateTime? createdAt;

  PasswordHistory({this.id = 0, required this.password, DateTime? createdAt}) {
    this.createdAt = createdAt ?? DateTime.now();
  }
  final String defaultLocale = Platform.localeName;
  String get createdAtFromat =>
      "${DateFormat.yMMMd(defaultLocale).format(createdAt ?? DateTime.now())} ${DateFormat.Hm(defaultLocale).format(createdAt ?? DateTime.now())}";

  //from json
  factory PasswordHistory.fromJson(Map<String, dynamic> json) {
    return PasswordHistory(
      id: json['id'],
      password: json['password'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  final account = ToOne<AccountOjbModel>();
}
