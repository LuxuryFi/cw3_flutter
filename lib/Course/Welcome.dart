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
  List<Map<String, dynamic>> filteredClassDetails = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClassDetails();
    searchController.addListener(_filterClassDetails);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterClassDetails);
    searchController.dispose();
    super.dispose();
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
        filteredClassDetails = List.from(classDetails);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load class details');
    }
  }

  // Search filter function
  void _filterClassDetails() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredClassDetails = classDetails.where((classDetail) {
        return classDetail['dayOfWeek'].toLowerCase().contains(query) ||
            classDetail['teacher'].toLowerCase().contains(query) ||
            classDetail['_id'].toLowerCase().contains(query);
      }).toList();
    });
  }

  // Add to cart function
  Future<void> addToCart(Map<String, dynamic> classDetail) async {
    final response = await http.post(
      Uri.parse('http://103.107.182.247:3000/cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(classDetail),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Class added to cart!'),
      ));
    } else {
      throw Exception('Failed to add to cart');
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
        DataColumn(label: Text('Position', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: filteredClassDetails.map((classDetail) {
        return DataRow(cells: [
          DataCell(Text(classDetail['_id'])),
          DataCell(Text(classDetail['dayOfWeek'])),
          DataCell(Text(classDetail['time'])),
          DataCell(Text(classDetail['capacity'].toString())),
          DataCell(Text(classDetail['duration'].toString())),
          DataCell(Text(classDetail['price'].toString())),
          DataCell(Text(classDetail['description'])),
          DataCell(Text(classDetail['teacher'])),
          DataCell(Text(classDetail['position'])),
          DataCell(Text(classDetail['image'])),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                  onPressed: () => addToCart(classDetail),
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
      appBar: AppBar(
        title: const Text('Course CW'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newCourse');
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
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
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Yoga Course List',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    labelText: 'Search',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildClassDetailsTable(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // New prominent buttons for Cart and Order
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/cart');
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text(
                                'Cart',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150, 50),
                                backgroundColor: Colors.deepPurpleAccent,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/order');
                              },
                              icon: const Icon(Icons.list_alt),
                              label: const Text(
                                'Order',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150, 50),
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
