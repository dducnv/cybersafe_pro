import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryOjbModel {
  @Id()
  int id;
  
  String categoryName;
  String? icon;
  int? color;
  int indexPos;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;

  CategoryOjbModel({
    this.id = 0,
    required this.categoryName,
    this.icon,
    this.color,
    this.indexPos = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  //from json
  factory CategoryOjbModel.fromJson(Map<String, dynamic> json) {
    return CategoryOjbModel(
      id: json['id'],
      categoryName: json['categoryName'],
      icon: json['icon'],
      color: json['color'],
      indexPos: json['indexPos'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'icon': icon,
      'color': color,
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
