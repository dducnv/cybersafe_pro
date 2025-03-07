import 'dart:io';

import 'package:cybersafe_pro/models/account_custom_field.dart';
import 'package:cybersafe_pro/models/category_ojb_model.dart';
import 'package:cybersafe_pro/models/icon_custom_model.dart';
import 'package:cybersafe_pro/models/password_history_model.dart';
import 'package:cybersafe_pro/models/totp_ojb_model.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AccountOjbModel {
  @Id()
  int id;
  String title;
  String? email;
  String? password;
  String? notes;
  String? icon;
  @Property(type: PropertyType.date)
  DateTime? passwordUpdatedAt;
  @Property(type: PropertyType.date)
  DateTime? createdAt;
  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  CategoryOjbModel? categoryOjbModel;
  List<AccountCustomFieldOjbModel>? customFieldOjbModel;
  TOTPOjbModel? totpOjbModel;
  List<PasswordHistory>? passwordHistoriesList;
  IconCustomModel? iconCustomModel;

  AccountOjbModel(
      {this.id = 0,
      required this.title,
      this.email,
      this.password,
      this.notes,
      this.icon,
      DateTime? passwordUpdatedAt,
      DateTime? createdAt,
      this.updatedAt,
      this.categoryOjbModel,
      this.customFieldOjbModel,
      this.passwordHistoriesList,
      this.totpOjbModel,
      this.iconCustomModel}) {
    this.createdAt = createdAt ?? DateTime.now();
    this.passwordUpdatedAt = passwordUpdatedAt ?? DateTime.now();
    updatedAt = updatedAt ?? DateTime.now();
  }
  final String defaultLocale = Platform.localeName;
  String get createdAtFromat =>
      "${DateFormat.yMMMd(defaultLocale).format(createdAt!)} ${DateFormat.Hm(defaultLocale).format(createdAt!)}";

  String get updatedAtFromat =>
      "${DateFormat.yMMMd(defaultLocale).format(updatedAt!)} ${DateFormat.Hm(defaultLocale).format(updatedAt!)}";

  String get passwordUpdatedAtFromat =>
      "${DateFormat.yMMMd(defaultLocale).format(passwordUpdatedAt!)} ${DateFormat.Hm(defaultLocale).format(passwordUpdatedAt!)}";

  //from json
  factory AccountOjbModel.fromJson(Map<String, dynamic> json) {
    return AccountOjbModel(
      id: json['id'],
      title: json['title'],
      email: json['email'],
      password: json['password'],
      notes: json['notes'],
      icon: json['icon'],
      passwordUpdatedAt: DateTime.parse(
          json['passwordUpdatedAt'] ?? DateTime.now().toIso8601String()),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      categoryOjbModel: json['category'] != null
          ? CategoryOjbModel.fromJson(json['category'])
          : null,
      customFieldOjbModel: json['customFields'] != null
          ? (json['customFields'] as List)
              .map((e) => AccountCustomFieldOjbModel.fromJson(e))
              .toList()
          : null,
      passwordHistoriesList: json['passwordHistories'] != null
          ? (json['passwordHistories'] as List)
              .map((e) => PasswordHistory.fromJson(e))
              .toList()
          : null,
      totpOjbModel:
          json['totp'] != null ? TOTPOjbModel.fromJson(json['totp']) : null,
      iconCustomModel: json['iconCustom'] != null
          ? IconCustomModel.fromJson(json['iconCustom'])
          : null,
    );
  }

//to json

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'password': password,
      'notes': notes,
      'icon': icon,
      "customFields": customFieldOjbModel?.map((e) => e.toJson()).toList(),
      "totp": totpOjbModel?.toJson(),
      'category': categoryOjbModel?.toJson(),
      'passwordUpdatedAt': passwordUpdatedAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'passwordHistories':
          passwordHistoriesList?.map((e) => e.toJson()).toList(),
      'iconCustom': iconCustomModel?.toJson(),
      'createdAt':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  final category = ToOne<CategoryOjbModel>();
  final iconCustom = ToOne<IconCustomModel>();
  final totp = ToOne<TOTPOjbModel>();

  //one to many
  @Backlink("account")
  var customFields = ToMany<AccountCustomFieldOjbModel>();
  @Backlink("account")
  final passwordHistories = ToMany<PasswordHistory>();
}
