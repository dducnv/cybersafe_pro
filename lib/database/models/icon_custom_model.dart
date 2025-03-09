import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';
import 'account_ojb_model.dart';

@Entity()
class IconCustomModel {
  @Id()
  int id;
  
  String path;
  String? name;
  int? color;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;

  // Relation to Account
  @Backlink('iconCustom')
  final accounts = ToMany<AccountOjbModel>();

  IconCustomModel({
    this.id = 0,
    required this.path,
    this.name,
    this.color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  //from json
  factory IconCustomModel.fromJson(Map<String, dynamic> json) {
    return IconCustomModel(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      color: json['color'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get createdAtFormat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(createdAt);

  String get updatedAtFormat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(updatedAt);
}
