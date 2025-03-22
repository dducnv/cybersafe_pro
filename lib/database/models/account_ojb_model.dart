import 'dart:io';

import 'package:cybersafe_pro/database/models/account_custom_field.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/database/models/icon_custom_model.dart';
import 'package:cybersafe_pro/database/models/password_history_model.dart';
import 'package:cybersafe_pro/database/models/totp_ojb_model.dart';
import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity(uid: 808721809346376920)
class AccountOjbModel {
  @Id()
  int id;

  @Property(uid: 2625426417278383013)
  String title;

  @Property(uid: 615286758753448621)
  String? email;

  @Property(uid: 5424898965257979061)
  String? password;

  @Property(uid: 9173965011134390942)
  String? notes;

  @Property(uid: 603238089867337940)
  String? icon;

  @Property(uid: 6270388988144688518, type: PropertyType.date)
  DateTime? passwordUpdatedAt;

  @Property(uid: 9156602806049161939, type: PropertyType.date)
  DateTime? createdAt;

  @Property(uid: 3899775664941408825, type: PropertyType.date)
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

    // Set relationships một cách an toàn
    try {
      if (categoryOjbModel != null) {
        category.target = categoryOjbModel;
      }
      if (totpOjbModel != null) {
        totp.target = totpOjbModel;
      }
      if (iconCustomModel != null) {
        iconCustom.target = iconCustomModel;
      }
      if (passwordHistoriesList != null) {
        passwordHistories.clear(); // Clear trước khi thêm mới
        for (var history in passwordHistoriesList) {
          history.account.target = this;
          passwordHistories.add(history);
        }
      }
      if (customFieldOjbModel != null) {
        customFields.clear();
        for (var field in customFieldOjbModel) {
          field.account.target = this;
          customFields.add(field);
        }
      }
    } catch (e) {
      print('Error setting relationships: $e');
    }
  }

  // Factory constructor để tạo object mới từ object cũ
  factory AccountOjbModel.fromModel(AccountOjbModel account) {
    try {
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

      // Copy relationships một cách an toàn
      if (account.getCategory != null) {
        newAccount.category.target = account.getCategory;
      }
      if (account.getTotp != null) {
        newAccount.totp.target = account.getTotp;
      }
      if (account.getIconCustom != null) {
        newAccount.iconCustom.target = account.getIconCustom;
      }
      
      if (account.getCustomFields.isNotEmpty) {
        for (var field in account.getCustomFields) {
          field.account.target = newAccount;
          newAccount.customFields.add(field);
        }
      }
      
      if (account.getPasswordHistories.isNotEmpty) {
        for (var history in account.getPasswordHistories) {
          history.account.target = newAccount;
          newAccount.passwordHistories.add(history);
        }
      }

      return newAccount;
    } catch (e) {
      print('Error creating account from model: $e');
      rethrow;
    }
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
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      notes: json['notes'] ?? '',
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

  final EncryptAppDataService _encryptAppDataService = EncryptAppDataService.instance;

  Future<Map<String, dynamic>> toDecryptedJson() async {
    return {
      'id': id,
      'title': await _encryptAppDataService.decryptInfo(title),
      'email': await _encryptAppDataService.decryptInfo(email ?? ''),
      'password': await _encryptAppDataService.decryptPassword(password ?? ''),
      'notes': await _encryptAppDataService.decryptInfo(notes ?? ''),
      'icon': icon,
      'customFields': getCustomFields.map((e) => e.toDecryptedJson()).toList(),
      'totp': getTotp?.toDecryptedJson(),
      'category': getCategory?.toJson(),
      'passwordUpdatedAt': passwordUpdatedAt?.toIso8601String(),
      'passwordHistories': getPasswordHistories.map((e) => e.toDecryptedJson()).toList(),
      'iconCustom': getIconCustom?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
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