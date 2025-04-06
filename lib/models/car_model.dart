// ignore_for_file: public_member_api_docs, sort_constructors_first
class CarModel {
  final String name;
  final String id;
  CarModel({required this.name, required this.id});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(name: json["name"], id: json["id"]);
  }
}
