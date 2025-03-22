import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:objectbox/objectbox.dart';
@Entity(uid: 965409409935003527)
class IconCustomModel {
  @Id()
  int id;

  @Property(uid: 3048476553136400367)
  final String name;

  @Property(uid: 3062578946622634533)
  final String imageBase64;

  @Property(uid: 5132215409006114972)
  final String? imageBase64DarkModel;

  IconCustomModel(
      {this.id = 0,
      required this.name,
      required this.imageBase64,
      this.imageBase64DarkModel});

  //from json
  factory IconCustomModel.fromJson(Map<String, dynamic> json) {
    return IconCustomModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageBase64: json['imageBase64'] ?? '',
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
