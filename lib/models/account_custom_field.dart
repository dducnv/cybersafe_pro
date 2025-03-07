import 'package:cybersafe_pro/models/account_ojb_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AccountCustomFieldOjbModel {
  @Id()
  int id;
  String name;
  String value;
  String hintText;
  String typeField;

  AccountCustomFieldOjbModel(
      {this.id = 0,
      required this.name,
      required this.value,
      required this.hintText,
      required this.typeField});

  final account = ToOne<AccountOjbModel>();

  //from json
  factory AccountCustomFieldOjbModel.fromJson(Map<String, dynamic> json) {
    return AccountCustomFieldOjbModel(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      hintText: json['hintText'],
      typeField: json['typeField'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'hintText': hintText,
      'typeField': typeField,
    };
  }
}
