import 'package:cybersafe_pro/models/account_ojb_model.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryOjbModel {
  @Id()
  int id;
  String categoryName;
  int indexPos;

  @Property(type: PropertyType.date)
  DateTime? createdAt;
  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  CategoryOjbModel(
      {this.id = 0,
      required this.categoryName,
      this.indexPos = 0,
      DateTime? createdAt,
      this.updatedAt}) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  //from json
  factory CategoryOjbModel.fromJson(Map<String, dynamic> json) {
    return CategoryOjbModel(
      id: json['id'],
      categoryName: json['categoryName'],
      indexPos: json['indexPos'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'indexPos': indexPos,
    };
  }

  String get createdAtFromat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(createdAt!);

  String get updatedAtFromat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(updatedAt!);

  @Backlink("category")
  final accounts = ToMany<AccountOjbModel>();
}
