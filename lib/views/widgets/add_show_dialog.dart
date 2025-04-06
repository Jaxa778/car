import 'package:api/controllers/car_controller.dart';
import 'package:flutter/material.dart';

class ShowDialogForCar extends StatefulWidget {
  final CarController carController;
  const ShowDialogForCar({super.key, required this.carController});

  @override
  State<ShowDialogForCar> createState() => _ShowDialogForCarState();
}

class _ShowDialogForCarState extends State<ShowDialogForCar> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    speedController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Name",
            ),
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Price",
            ),
          ),
          TextField(
            controller: speedController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Speed",
            ),
          ),
          TextField(
            controller: imageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Image",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            final name = nameController.text;
            final price = priceController.text;
            final speed = speedController.text;
            final image = imageController.text;

            if (name.isNotEmpty) {
              setState(() {
                isLoading = true;
              });

              await widget.carController.addCar(
                name: name,
                image: image,
                price: price,
                speed: speed,
              );

              setState(() {
                isLoading = false;
              });
              Navigator.pop(ctx, true);
            }
          },
          child:
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Save"),
        ),
      ],
    );
  }
}
