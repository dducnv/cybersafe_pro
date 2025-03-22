import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity(uid: 1129773840658876529)
class CategoryOjbModel {
  @Id()
  int id;
  
  @Property(uid: 8872622909213525147)
  String categoryName;

  @Property(uid: 5509757696427258474)
  int indexPos;
  
  @Property(uid: 3844861102953137554, type: PropertyType.date)
  DateTime createdAt;
  
  @Property(uid: 16479445437159146, type: PropertyType.date)
  DateTime updatedAt;

  CategoryOjbModel({
    this.id = 0,
    required this.categoryName,
    this.indexPos = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  //from json
  factory CategoryOjbModel.fromJson(Map<String, dynamic> json) {
    return CategoryOjbModel(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? '',

      indexPos: json['indexPos'] ?? 0,
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt']) 
        : DateTime.now(),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'indexPos': indexPos,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get createdAtFromat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(createdAt);

  String get updatedAtFromat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(updatedAt);

  @Backlink("category")
  final accounts = ToMany<AccountOjbModel>();
}
