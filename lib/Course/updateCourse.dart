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
        'nameValuePairs':{
        'dayOfWeek': _dayOfWeekController.text,
        'time': _timeController.text,
        'capacity': int.parse(_capacityController.text),
        'duration': int.parse(_durationController.text),
        'price': int.parse(_priceController.text),
        'description': _descriptionController.text,
        'teacher': _teacherController.text,
        'image': widget.classDetail['image'], // If you don't want to change the image, keep it the same
      }}),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _dayOfWeekController,
                decoration: const InputDecoration(labelText: 'Day of Week'),
              ),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Capacity'),
              ),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration'),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _teacherController,
                decoration: const InputDecoration(labelText: 'Teacher'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateClassDetails,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
