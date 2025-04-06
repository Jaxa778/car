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
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
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

            if (name.isNotEmpty) {
              setState(() {
                isLoading = true;
              });

              await widget.carController.addCar(name);

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
