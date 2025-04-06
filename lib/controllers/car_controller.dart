import 'dart:convert';

import 'package:api/models/car_model.dart';

import 'package:http/http.dart' as http;

class CarController {
  final String _baseUrl =
      "https://jaxascars-default-rtdb.asia-southeast1.firebasedatabase.app/";
  List<CarModel> cars = [];

  Future<List<CarModel>> getCar() async {
    final url = Uri.parse("$_baseUrl/cars.json");

    final response = await http.get(url);

    final decodedData = jsonDecode(response.body) as Map;

    final List<CarModel> allCars = [];

    decodedData.forEach((key, value) {
      final data = value;
      data["id"] = key;

      allCars.add(CarModel.fromJson(data));
    });

    cars = allCars;

    return cars;
  }

  Future<void> addCar(String title) async {
    final url = Uri.parse("$_baseUrl/cars.json");

    final newCar = {"name": title};
    final response = await http.post(url, body: jsonEncode(newCar));

    final decodeData = jsonDecode(response.body);
    newCar["id"] = decodeData["name"];

    cars.add(CarModel.fromJson(newCar));
  }

  Future<void> editCar({required String id, required String name}) async {
    final url = Uri.parse("$_baseUrl/cars/$id.json");

    final updateingCar = {"name": name};
    final response = await http.patch(url, body: jsonEncode(updateingCar));
  }

  Future<void> deleteCar({required String id}) async {
    final url = Uri.parse("$_baseUrl/cars/$id.json");

    final response = await http.delete(url);
  }
}
