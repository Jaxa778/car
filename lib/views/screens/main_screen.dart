import 'package:api/controllers/car_controller.dart';
import 'package:api/models/car_model.dart';
import 'package:api/views/widgets/add_show_dialog.dart';
import 'package:api/views/widgets/edit_show_dialog.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CarController carController = CarController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cars"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) {
                  return ShowDialogForCar(carController: carController);
                },
              );
              if (result == true) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<CarModel>>(
        future: carController.getCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Xatolik yuz berdi: ${snapshot.error}"));
          }

          final cars = snapshot.data;
          if (cars == null || cars.isEmpty) {
            return const Center(child: Text("Mashinalar mavjud emas."));
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading:
                      car.image.isNotEmpty
                          ? CircleAvatar(
                            backgroundImage: NetworkImage(car.image),
                            onBackgroundImageError:
                                (exception, stackTrace) =>
                                    const Icon(Icons.error),
                          )
                          : const CircleAvatar(
                            child: Icon(Icons.directions_car),
                          ),
                  title: Text(car.name),
                  subtitle: Text("Narxi: ${car.price} | Tezligi: ${car.speed}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return EditShowDialog(
                                carController: carController,
                                carModel: car,
                              );
                            },
                          );
                          if (result == true) {
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text("Mashinani o'chirish"),
                                  content: Text(
                                    "${car.name} mashinasini o'chirishni xohlaysizmi?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text("Yo'q"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text("Ha"),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await carController.deleteCar(id: car.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${car.name} muvaffaqiyatli o'chirildi",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Xatolik: $e")),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {}); // Ma'lumotlarni yangilash uchun
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
