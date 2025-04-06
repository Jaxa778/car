import 'package:api/controllers/car_controller.dart';
import 'package:api/models/car_model.dart';
import 'package:flutter/material.dart';

class EditShowDialog extends StatefulWidget {
  final CarController carController;
  final CarModel carModel;
  const EditShowDialog({
    super.key,
    required this.carController,
    required this.carModel,
  });

  @override
  State<EditShowDialog> createState() => _EditShowDialogState();
}

class _EditShowDialogState extends State<EditShowDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.carModel.name;
    priceController.text = widget.carModel.price;
    speedController.text = widget.carModel.speed.toString();
    imageController.text = widget.carModel.image;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    speedController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        FilledButton(
          onPressed: () async {
            final title = nameController.text;
            final price = priceController.text;
            final speed = speedController.text;
            final imageCar = imageController.text;

            if (title.isNotEmpty) {
              setState(() {
                isLoading = true;
              });
              await widget.carController.editCar(
                id: widget.carModel.id,
                name: title,
                image: imageCar,
                price: price,
                speed: speed,
              );
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context, true);
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
