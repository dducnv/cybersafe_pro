import 'dart:io';

import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class PasswordHistory {
  @Id()
  int id;
  String password;
  @Property(type: PropertyType.date)
  DateTime createdAt;
  @Property(type: PropertyType.date)
  DateTime updatedAt;

  // Relation to Account
  final account = ToOne<AccountOjbModel>();

  PasswordHistory({
    this.id = 0,
    required this.password,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final String defaultLocale = Platform.localeName;
  String get createdAtFormat =>
      "${DateFormat.yMMMd(defaultLocale).format(createdAt)} ${DateFormat.Hm(defaultLocale).format(createdAt)}";
  String get updatedAtFormat =>
      "${DateFormat.yMMMd(defaultLocale).format(updatedAt)} ${DateFormat.Hm(defaultLocale).format(updatedAt)}";

  //from json
  factory PasswordHistory.fromJson(Map<String, dynamic> json) {
    return PasswordHistory(
      id: json['id'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
