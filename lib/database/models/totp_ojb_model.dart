import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TOTPOjbModel {
  @Id()
  int id;

  @Index()
  String secretKey;

  @Index()
  String? algorithm;

  int digits;

  int period;

  bool isShowToHome;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;

  // Relation to Account
  final account = ToOne<AccountOjbModel>();
  
  TOTPOjbModel({
    this.id = 0,
    required this.secretKey,
    this.algorithm = 'SHA1',
    this.digits = 6,
    this.period = 30,
    this.isShowToHome = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now() {
    if (secretKey.isEmpty) throw ArgumentError('Secret key cannot be empty');
    if (digits <= 0 || digits > 8) throw ArgumentError('Digits must be between 1 and 8');
    if (period <= 0 || period > 60) throw ArgumentError('Period must be between 1 and 60 seconds');
  }

  //from json
  factory TOTPOjbModel.fromJson(Map<String, dynamic> json) {
    final secretKey = json['secretKey']?.toString() ?? '';
    if (secretKey.isEmpty) throw ArgumentError('Secret key cannot be empty');
    
    return TOTPOjbModel(
      id: json['id'] ?? 0,
      secretKey: secretKey,
      algorithm: json['algorithm']?.toString().toUpperCase() ?? 'SHA1',
      digits: (json['digits'] ?? 6).clamp(6, 8),
      period: (json['period'] ?? 30).clamp(30, 60),
      isShowToHome: json['isShowToHome'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'secretKey': secretKey,
      'algorithm': algorithm?.toUpperCase() ?? 'SHA1',
      'digits': digits,
      'period': period,
      'isShowToHome': isShowToHome,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get createdAtFormat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(createdAt);

  String get updatedAtFormat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(updatedAt);

  bool setShowToHome() {
    isShowToHome = !isShowToHome;
    return isShowToHome;
  }

  // Kiểm tra xem TOTP có hợp lệ không
  bool get isValid => 
    secretKey.isNotEmpty && 
    (algorithm?.toUpperCase() == 'SHA1' || 
     algorithm?.toUpperCase() == 'SHA256' || 
     algorithm?.toUpperCase() == 'SHA512') &&
    digits >= 6 && digits <= 8 &&
    period >= 30 && period <= 60;

  // Copy with method để tạo bản sao với các giá trị mới
  TOTPOjbModel copyWith({
    String? secretKey,
    String? algorithm,
    int? digits,
    int? period,
    bool? isShowToHome,
  }) {
    return TOTPOjbModel(
      id: id,
      secretKey: secretKey ?? this.secretKey,
      algorithm: algorithm ?? this.algorithm,
      digits: digits ?? this.digits,
      period: period ?? this.period,
      isShowToHome: isShowToHome ?? this.isShowToHome,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'TOTPOjbModel(id: $id, secretKey: $secretKey, algorithm: $algorithm, digits: $digits, period: $period)';
}
