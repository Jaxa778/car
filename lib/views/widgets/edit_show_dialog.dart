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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.carModel.name;
  }

  @override
  void dispose() {
    nameController.dispose();
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

            if (title.isNotEmpty) {
              /// rejani qo'shamiz
              ///
              setState(() {
                isLoading = true;
              });
              await widget.carController.editCar(
                id: widget.carModel.id,
                name: title,
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
