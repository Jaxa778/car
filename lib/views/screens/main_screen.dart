import 'package:api/controllers/car_controller.dart';
import 'package:api/views/widgets/add_show_dialog.dart';
import 'package:api/views/widgets/edit_show_dialog.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CarController carController = CarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cars"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = showDialog(
                context: context,
                builder: (context) {
                  return ShowDialogForCar(carController: carController);
                },
              );
              if (result == true) {
                setState(() {});
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: carController.getCar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final cars = snapshot.data;

          if (cars == null || cars.isEmpty) {
            return Center(child: Text("Mashinalar mavjud emas."));
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                leading: Text(car.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditShowDialog(
                              carController: carController,
                              carModel: car,
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        await carController.deleteCar(id: car.id);
                        setState(() {});
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
