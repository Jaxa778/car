// ignore_for_file: public_member_api_docs, sort_constructors_first
class CarModel {
  final String id;
  final String name;
  final int speed;
  final String price;
  final String image;
  CarModel({
    required this.name,
    required this.id,
    required this.image,
    required this.price,
    required this.speed,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      name: json["name"],
      id: json["id"],
      image: json["image"],
      speed:  int.tryParse(json["speed"].toString()) ?? 0,
      price: json["price"],
    );
  }
}
