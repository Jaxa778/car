import 'dart:convert';
import 'package:api/models/car_model.dart';
import 'package:http/http.dart' as http;

class CarController {
  final String _baseUrl =
      "https://jaxascars-default-rtdb.asia-southeast1.firebasedatabase.app/";
  List<CarModel> cars = [];

  Future<List<CarModel>> getCars() async {
    final url = Uri.parse("$_baseUrl/cars.json");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Mashinalarni yuklashda xatolik: ${response.statusCode}');
    }

    if (response.body == "null") {
      return [];
    }

    final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
    final List<CarModel> allCars = [];

    decodedData.forEach((key, value) {
      final data = Map<String, dynamic>.from(value);
      data["id"] = key;
      allCars.add(CarModel.fromJson(data));
    });

    cars = allCars;
    return cars;
  }

  Future<CarModel> addCar({
    required String name,
    required String image,
    required String price,
    required String speed,
  }) async {
    final url = Uri.parse("$_baseUrl/cars.json");
    final newCar = {
      "name": name,
      "image": image,
      "price": price,
      "speed": speed,
    };

    final response = await http.post(url, body: jsonEncode(newCar));

    if (response.statusCode != 200) {
      throw Exception('Mashina qo\'shishda xatolik: ${response.statusCode}');
    }

    final decodedData = jsonDecode(response.body);
    newCar["id"] = decodedData["name"];

    final carModel = CarModel.fromJson(newCar);
    cars.add(carModel);

    return carModel;
  }

  Future<void> editCar({
    required String id,
    String? name,
    String? image,
    String? price,
    String? speed,
  }) async {
    final url = Uri.parse("$_baseUrl/cars/$id.json");

    final updatingCar = <String, dynamic>{};
    if (name != null) updatingCar["name"] = name;
    if (image != null) updatingCar["image"] = image;
    if (price != null) updatingCar["price"] = price;
    if (speed != null) updatingCar["speed"] = speed;

    final response = await http.patch(url, body: jsonEncode(updatingCar));

    if (response.statusCode != 200) {
      throw Exception('Mashinani yangilashda xatolik: ${response.statusCode}');
    }

    // Mahalliy ro'yxatni yangilash
    final index = cars.indexWhere((car) => car.id == id);
    if (index != -1) {
      final updatedCar = await getCarById(id);
      if (updatedCar != null) {
        cars[index] = updatedCar;
      }
    }
  }

  Future<void> deleteCar({required String id}) async {
    final url = Uri.parse("$_baseUrl/cars/$id.json");
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Mashinani o\'chirishda xatolik: ${response.statusCode}');
    }

    // Mahalliy ro'yxatdan olib tashlash
    cars.removeWhere((car) => car.id == id);
  }

  Future<CarModel?> getCarById(String id) async {
    final url = Uri.parse("$_baseUrl/cars/$id.json");
    final response = await http.get(url);

    if (response.statusCode != 200 || response.body == "null") {
      return null;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    data["id"] = id;
    return CarModel.fromJson(data);
  }
}
