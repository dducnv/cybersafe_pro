import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class IconCustomModel {
  @Id()
  int id;
  final String name;
  final String imageBase64;
  final String? imageBase64DarkModel;
  IconCustomModel(
      {this.id = 0,
      required this.name,
      required this.imageBase64,
      this.imageBase64DarkModel});

  //from json
  factory IconCustomModel.fromJson(Map<String, dynamic> json) {
    return IconCustomModel(
      id: json['id'],
      name: json['name'],
      imageBase64: json['imageBase64'],
      imageBase64DarkModel: json['imageBase64DarkModel'],
    );
  }
  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageBase64': imageBase64,
      'imageBase64DarkModel': imageBase64DarkModel,
    };
  }

  @Backlink("iconCustom")
  final accounts = ToMany<AccountOjbModel>();
}
