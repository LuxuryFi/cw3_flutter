import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateCourse extends StatefulWidget {
  final Map<String, dynamic> classDetail;

  const UpdateCourse(this.classDetail, {Key? key}) : super(key: key);

  @override
  _UpdateCourseState createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {
  final TextEditingController _dayOfWeekController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dayOfWeekController.text = widget.classDetail['dayOfWeek'];
    _timeController.text = widget.classDetail['time'];
    _capacityController.text = widget.classDetail['capacity'].toString();
    _durationController.text = widget.classDetail['duration'].toString();
    _priceController.text = widget.classDetail['price'].toString();
    _descriptionController.text = widget.classDetail['description'];
    _teacherController.text = widget.classDetail['teacher'];
  }

  // Update class details in the database
  Future<void> updateClassDetails() async {
    final response = await http.put(
      Uri.parse('http://103.107.182.247:3000/${widget.classDetail['_id']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'dayOfWeek': _dayOfWeekController.text,
        'time': _timeController.text,
        'capacity': int.parse(_capacityController.text),
        'duration': int.parse(_durationController.text),
        'price': int.parse(_priceController.text),
        'description': _descriptionController.text,
        'teacher': _teacherController.text,
        'image': widget.classDetail['image'], // If you don't want to change the image, keep it the same
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      throw Exception('Failed to update class');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Class Details'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 6,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_dayOfWeekController, 'Day of Week'),
                _buildTextField(_timeController, 'Time'),
                _buildNumberField(_capacityController, 'Capacity'),
                _buildNumberField(_durationController, 'Duration'),
                _buildNumberField(_priceController, 'Price'),
                _buildTextField(_descriptionController, 'Description'),
                _buildTextField(_teacherController, 'Teacher'),
                const SizedBox(height: 20),
                _buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
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

  Widget _buildNumberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
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

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: updateClassDetails,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Update',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
