import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For API requests

class NewCourse extends StatefulWidget {
  const NewCourse({Key? key}) : super(key: key);

  @override
  State<NewCourse> createState() => _NewCourseState();
}

class _NewCourseState extends State<NewCourse> {
  String result = "Detail";
  final TextEditingController txtCourseName = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final TextEditingController txtCapacity = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtTeacher = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtImage = TextEditingController();

  final String apiUrl = "http://103.107.182.247:3000/upload";

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Course'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  buildTextField("Course Name", txtCourseName),
                  buildTextField("Date", txtDate),
                  buildTextField("Duration", txtDuration, isNumeric: true),
                  buildTextField("Capacity", txtCapacity, isNumeric: true),
                  buildTextField("Price", txtPrice, isNumeric: true),
                  buildTextField("Teacher", txtTeacher),
                  buildTextField("Description", txtDescription),
                  buildTextField("Image URL", txtImage),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: saveCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Save', style: TextStyle(fontSize: fontSize)),
                    ),
                  ),
                  Text(result, style: TextStyle(fontSize: fontSize)),
                ],
              ),
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
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Send data to API
  Future<void> saveCourse() async {
    // Close the keyboard
    FocusScope.of(context).unfocus();

    final payload = {
      "nameValuePairs": {
        "userId": "gw001249268", // Replace with actual userId if needed
        "courseName": txtCourseName.text,
        "date": txtDate.text,
        "capacity": int.tryParse(txtCapacity.text) ?? 0,
        "duration": int.tryParse(txtDuration.text) ?? 0,
        "price": int.tryParse(txtPrice.text) ?? 0,
        "teacher": txtTeacher.text,
        "description": txtDescription.text,
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
          result = "Course saved successfully!";
        });
        clearFields();
        Navigator.pushNamed(context, '/welcome'); // Navigate to a different page on success
      } else {
        setState(() {
          result = "Failed to save course. Status Code: ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        result = "An error occurred: $e";
      });
    }
  }

  void clearFields() {
    txtCourseName.clear();
    txtDate.clear();
    txtDuration.clear();
    txtCapacity.clear();
    txtPrice.clear();
    txtTeacher.clear();
    txtDescription.clear();
    txtImage.clear();
  }

  @override
  void dispose() {
    txtCourseName.dispose();
    txtDate.dispose();
    txtDuration.dispose();
    txtCapacity.dispose();
    txtPrice.dispose();
    txtTeacher.dispose();
    txtDescription.dispose();
    txtImage.dispose();
    super.dispose();
  }
}
