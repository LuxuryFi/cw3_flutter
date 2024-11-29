import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_course_cw/Course/updateCourse.dart';
import 'package:http/http.dart' as http;

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  List<Map<String, dynamic>> classDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClassDetails();
  }

  // Fetch data from the API
  Future<void> fetchClassDetails() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://103.107.182.247:3000'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        classDetails = data.map((item) => item as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load class details');
    }
  }

  // Delete function to remove class detail by id from both the UI and API
  Future<void> deleteClassDetail(String id) async {
    final response = await http.delete(Uri.parse('http://103.107.182.247:3000/$id'));

    if (response.statusCode == 200) {
      setState(() {
        classDetails.removeWhere((classDetail) => classDetail['_id'] == id);
      });
    } else {
      // Handle error
      throw Exception('Failed to delete class');
    }
  }

  // Display the class details in a table
  Widget _buildClassDetailsTable() {
    return DataTable(
      columnSpacing: 20.0,
      columns: const [
        DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Day of Week', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Duration', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Teacher', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: classDetails.map((classDetail) {
        return DataRow(cells: [
          DataCell(Text(classDetail['_id'])),
          DataCell(Text(classDetail['dayOfWeek'])),
          DataCell(Text(classDetail['time'])),
          DataCell(Text(classDetail['capacity'].toString())),
          DataCell(Text(classDetail['duration'].toString())),
          DataCell(Text(classDetail['price'].toString())),
          DataCell(Text(classDetail['description'])),
          DataCell(Text(classDetail['teacher'])),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Update Button
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateCourse(classDetail), // Pass classDetail to the update page
                      ),
                    ).then((shouldReload) {
                      // Check if the data needs to be refreshed after update
                      if (shouldReload == true) {
                        fetchClassDetails(); // Refresh data after update
                      }
                    });
                  },
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteClassDetail(classDetail['_id']),
                ),
              ],
            ),
          ),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newCourse');
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: const Text('Course CW'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images.jfif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator() // Show loading indicator while data is being fetched
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildClassDetailsTable(),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
