import 'dart:io';

import 'package:cybersafe_pro/database/models/account_custom_field.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/database/models/password_history_model.dart';
import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
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

  // Relationships với ObjectBox
  final category = ToOne<CategoryOjbModel>();
  final iconCustom = ToOne<IconCustomModel>();
  final totp = ToOne<TOTPOjbModel>();
  @Backlink("account")
  final customFields = ToMany<AccountCustomFieldOjbModel>();
  @Backlink("account")
  final passwordHistories = ToMany<PasswordHistory>();

  // Getters và Setters cho relationships
  CategoryOjbModel? get getCategory => category.target;
  set setCategory(CategoryOjbModel? value) => category.target = value;

  IconCustomModel? get getIconCustom => iconCustom.target;
  set setIconCustom(IconCustomModel? value) => iconCustom.target = value;

  TOTPOjbModel? get getTotp => totp.target;
  set setTotp(TOTPOjbModel? value) => totp.target = value;

  List<AccountCustomFieldOjbModel> get getCustomFields => customFields;
  List<PasswordHistory> get getPasswordHistories => passwordHistories;



  AccountOjbModel({
    this.id = 0,
    required this.title,
    this.email,
    this.password,
    this.notes,
    this.icon,
    DateTime? passwordUpdatedAt,
    DateTime? createdAt,
    this.updatedAt,
    CategoryOjbModel? categoryOjbModel,
    List<AccountCustomFieldOjbModel>? customFieldOjbModel,
    List<PasswordHistory>? passwordHistoriesList,
    TOTPOjbModel? totpOjbModel,
    IconCustomModel? iconCustomModel,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.passwordUpdatedAt = passwordUpdatedAt ?? DateTime.now();
    updatedAt = updatedAt ?? DateTime.now();

    // Set relationships
    if (categoryOjbModel != null) setCategory = categoryOjbModel;
    if (totpOjbModel != null) setTotp = totpOjbModel;
    if (iconCustomModel != null) setIconCustom = iconCustomModel;
    if (customFieldOjbModel != null) customFields.addAll(customFieldOjbModel);
    if (passwordHistoriesList != null) passwordHistories.addAll(passwordHistoriesList);
  }

  // Factory constructor để tạo object mới từ object cũ
  factory AccountOjbModel.fromModel(AccountOjbModel account) {
    final newAccount = AccountOjbModel(
      id: account.id,
      title: account.title,
      email: account.email,
      password: account.password,
      notes: account.notes,
      icon: account.icon,
      passwordUpdatedAt: account.passwordUpdatedAt,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );

    // Copy relationships
    newAccount.setCategory = account.getCategory;
    newAccount.setTotp = account.getTotp;
    newAccount.setIconCustom = account.getIconCustom;
    
    if (account.getCustomFields.isNotEmpty) {
      newAccount.customFields.addAll(account.getCustomFields);
    }
    
    if (account.getPasswordHistories.isNotEmpty) {
      newAccount.passwordHistories.addAll(account.getPasswordHistories);
    }

    return newAccount;
  }

  // Getters cho format date
  String get createdAtFormat => _formatDateTime(createdAt);
  String get updatedAtFormat => _formatDateTime(updatedAt);
  String get passwordUpdatedAtFormat => _formatDateTime(passwordUpdatedAt);

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return "${DateFormat.yMMMd(Platform.localeName).format(dateTime)} ${DateFormat.Hm(Platform.localeName).format(dateTime)}";
  }

  factory AccountOjbModel.fromJson(Map<String, dynamic> json) {
    return AccountOjbModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      email: json['email'],
      password: json['password'],
      notes: json['notes'],
      icon: json['icon'],
      passwordUpdatedAt: json['passwordUpdatedAt'] != null 
        ? DateTime.parse(json['passwordUpdatedAt']) 
        : null,
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : null,
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt']) 
        : null,
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
      totpOjbModel: json['totp'] != null 
        ? TOTPOjbModel.fromJson(json['totp']) 
        : null,
      iconCustomModel: json['iconCustom'] != null 
        ? IconCustomModel.fromJson(json['iconCustom']) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'password': password,
      'notes': notes,
      'icon': icon,
      'customFields': getCustomFields.map((e) => e.toJson()).toList(),
      'totp': getTotp?.toJson(),
      'category': getCategory?.toJson(),
      'passwordUpdatedAt': passwordUpdatedAt?.toIso8601String(),
      'passwordHistories': getPasswordHistories.map((e) => e.toJson()).toList(),
      'iconCustom': getIconCustom?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}