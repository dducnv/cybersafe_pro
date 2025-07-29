import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity(uid: 1076262210416939821)
class TOTPOjbModel {
  @Id()
  int id;

  @Property(uid: 8564762779212685146)
  String secretKey;

  @Property(uid: 5582173328156468147)
  bool isShowToHome;

  @Property(uid: 2563563088476085377, type: PropertyType.date)
  DateTime createdAt;

  @Property(uid: 1140319654760595252, type: PropertyType.date)
  DateTime updatedAt;

  // Relation to Account
  final account = ToOne<AccountOjbModel>();

  TOTPOjbModel({this.id = 0, required this.secretKey, this.isShowToHome = false, DateTime? createdAt, DateTime? updatedAt})
    : createdAt = createdAt ?? DateTime.now(),
      updatedAt = updatedAt ?? DateTime.now() {
    if (secretKey.isEmpty) throw ArgumentError('Secret key cannot be empty');
  }

  //from json
  factory TOTPOjbModel.fromJson(Map<String, dynamic> json) {
    final secretKey = json['secretKey']?.toString() ?? '';
    if (secretKey.isEmpty) throw ArgumentError('Secret key cannot be empty');

    return TOTPOjbModel(
      id: json['id'] ?? 0,
      secretKey: secretKey,
      isShowToHome: json['isShowToHome'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Future<Map<String, dynamic>> toDecryptedJson() async {
    return {'secretKey': await DataSecureService.decryptTOTPKey(secretKey), 'isShowToHome': isShowToHome, 'createdAt': createdAt.toIso8601String(), 'updatedAt': updatedAt.toIso8601String()};
  }

  //to json
  Map<String, dynamic> toJson() {
    return {'id': id, 'secretKey': secretKey, 'isShowToHome': isShowToHome, 'createdAt': createdAt.toIso8601String(), 'updatedAt': updatedAt.toIso8601String()};
  }

  String get createdAtFormat => DateFormat('dd/MM/yy HH:mm:ss').format(createdAt);

  String get updatedAtFormat => DateFormat('dd/MM/yy HH:mm:ss').format(updatedAt);

  bool setShowToHome() {
    isShowToHome = !isShowToHome;
    return isShowToHome;
  }

  // Kiểm tra xem TOTP có hợp lệ không
  bool get isValid => secretKey.isNotEmpty;

  // Copy with method để tạo bản sao với các giá trị mới
  TOTPOjbModel copyWith({String? secretKey, String? algorithm, int? digits, int? period, bool? isShowToHome}) {
    return TOTPOjbModel(id: id, secretKey: secretKey ?? this.secretKey, isShowToHome: isShowToHome ?? this.isShowToHome, createdAt: createdAt, updatedAt: DateTime.now());
  }

  @override
  String toString() => 'TOTPOjbModel(id: $id, secretKey: $secretKey)';
}
