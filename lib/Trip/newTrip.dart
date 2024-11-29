import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For API requests

class NewTrip extends StatefulWidget {
  const NewTrip({Key? key}) : super(key: key);

  @override
  State<NewTrip> createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  String result = "Detail";
  final TextEditingController txtTripName = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtDestination = TextEditingController();
  final TextEditingController txtRickAssessment = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtCapacity = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtClassType = TextEditingController();
  final TextEditingController txtTeacher = TextEditingController();
  final TextEditingController txtImage = TextEditingController();

  final String apiUrl = "http://103.107.182.247:3000/upload";

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Trip'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildTextField("Trip Name", txtTripName),
                buildTextField("Date", txtDate),
                buildTextField("Destination", txtDestination),
                buildTextField("Risk Assessment", txtRickAssessment),
                buildTextField("Description", txtDescription),
                buildTextField("Capacity", txtCapacity, isNumeric: true),
                buildTextField("Duration", txtDuration, isNumeric: true),
                buildTextField("Price", txtPrice, isNumeric: true),
                buildTextField("Class Type", txtClassType),
                buildTextField("Teacher", txtTeacher),
                buildTextField("Image URL", txtImage),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: saveTrip,
                    child: Text('Save', style: TextStyle(fontSize: fontSize)),
                  ),
                ),
                Text(result, style: TextStyle(fontSize: fontSize)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to create input fields
  Widget buildTextField(String hintText, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(hintText: hintText),
      ),
    );
  }

  // Send data to API
  Future<void> saveTrip() async {
    // Close the keyboard
    FocusScope.of(context).unfocus();

    final payload = {
      "nameValuePairs": {
        "userId": "gw001249268",
        "dayOfWeek": txtTripName.text,
        "time": txtDate.text,
        "capacity": int.tryParse(txtCapacity.text) ?? 0,
        "duration": int.tryParse(txtDuration.text) ?? 0,
        "price": int.tryParse(txtPrice.text) ?? 0,
        "classType": txtClassType.text,
        "description": txtDescription.text,
        "teacher": txtTeacher.text,
        "image": txtImage.text,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          result = "Trip saved successfully!";
        });
        clearFields();
      } else {
        setState(() {
          result =
              "Failed to save trip. Status Code: ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        result = "An error occurred: $e";
      });
    }
  }

  void clearFields() {
    txtTripName.clear();
    txtDate.clear();
    txtDestination.clear();
    txtRickAssessment.clear();
    txtDescription.clear();
    txtCapacity.clear();
    txtDuration.clear();
    txtPrice.clear();
    txtClassType.clear();
    txtTeacher.clear();
    txtImage.clear();
  }

  @override
  void dispose() {
    txtTripName.dispose();
    txtDate.dispose();
    txtDestination.dispose();
    txtRickAssessment.dispose();
    txtDescription.dispose();
    txtCapacity.dispose();
    txtDuration.dispose();
    txtPrice.dispose();
    txtClassType.dispose();
    txtTeacher.dispose();
    txtImage.dispose();
    super.dispose();
  }
}
