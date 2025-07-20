import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';
import 'package:objectbox/objectbox.dart';

@Entity(uid: 7720765967536005100)
class AccountCustomFieldOjbModel {
  @Id()
  int id;

  @Property(uid: 6810372553496786412)
  String name;

  @Property(uid: 6756111045446270073)
  String value;

  @Property(uid: 4112533644947478733)
  String hintText;

  @Property(uid: 4951341637174002499)
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

  final EncryptAppDataService _encryptAppDataService = EncryptAppDataService.instance;
  Future<Map<String,dynamic>> toDecryptedJson() async {
    return {
      'id': id,
      'name': name,
      'value': typeField == 'password' ? await _encryptAppDataService.decryptPassword(value) : await _encryptAppDataService.decryptInfo(value),
      'hintText': hintText,
      'typeField': typeField,
    };
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
