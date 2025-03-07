import 'package:cybersafe_pro/models/account_ojb_model.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TOTPOjbModel {
  @Id()
  int id;
  String secretKey;
  bool isShowToHome;
  @Property(type: PropertyType.date)
  DateTime? createdAt;
  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  TOTPOjbModel(
      {this.id = 0,
      required this.secretKey,
      this.isShowToHome = false,
      DateTime? createdAt,
      this.updatedAt}) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  //from json
  factory TOTPOjbModel.fromJson(Map<String, dynamic> json) {
    return TOTPOjbModel(
      id: json['id'],
      secretKey: json['secretKey'],
      isShowToHome: json['isShowToHome'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  //to json

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'secretKey': secretKey,
      'isShowToHome': isShowToHome,
    };
  }

  String get createdAtFromat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(createdAt!);

  String get updatedAtFromat =>
      DateFormat('dd/MM/yy HH:mm:ss').format(updatedAt!);
      
  final account = ToOne<AccountOjbModel>();

  bool setShowToHome() {
    isShowToHome = !isShowToHome;
    return isShowToHome;
  }
}
