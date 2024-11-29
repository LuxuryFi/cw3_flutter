import 'dart:convert';
import 'package:flutter/material.dart';
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
    final response = await http.get(Uri.parse('http://103.107.182.247:3000'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        classDetails = data.map((item) => item as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } else {
      // If the request fails, handle error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load class details');
    }
  }

  // Display the class details in a table
  Widget _buildClassDetailsTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Day of Week')),
        DataColumn(label: Text('Time')),
        DataColumn(label: Text('Capacity')),
        DataColumn(label: Text('Duration')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Teacher')),
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
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newTrip');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Trip CW'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator() // Show loading indicator while data is being fetched
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.blue.shade100.withOpacity(0.8),
                      ),
                      child: _buildClassDetailsTable(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
