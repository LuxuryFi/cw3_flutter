import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOrders();
    searchController.addListener(_filterOrders);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterOrders);
    searchController.dispose();
    super.dispose();
  }

  // Fetch orders from the API
  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://103.107.182.247:3000/orders'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        orders = data.map((item) => item as Map<String, dynamic>).toList();
        filteredOrders = List.from(orders);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load orders');
    }
  }

  // Filter orders based on Gmail
  void _filterOrders() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredOrders = orders.where((order) {
        return order['email'].toLowerCase().contains(query);
      }).toList();
    });
  }

  // Display the orders in a table
  Widget _buildOrdersTable() {
    return DataTable(
      columnSpacing: 15.0,
      columns: const [
        DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Day of Week', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Duration', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Teacher', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Position', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: filteredOrders.map((order) {
        return DataRow(cells: [
          DataCell(Text(order['_id'] ?? '')),
          DataCell(Text(order['email'] ?? '')),
          DataCell(Text(order['dayOfWeek'] ?? '')),
          DataCell(Text(order['time'] ?? '')),
          DataCell(Text(order['capacity']?.toString() ?? '')),
          DataCell(Text(order['duration']?.toString() ?? '')),
          DataCell(Text(order['price']?.toString() ?? '')),
          DataCell(Text(order['description'] ?? '')),
          DataCell(Text(order['teacher'] ?? '')),
          DataCell(Text(order['position'] ?? '')),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order View'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/welcome');
            },
          ),
        ],
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
                    child: Card(
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
                              'Order List',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Search Bar
                            TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                labelText: 'Search by Gmail',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildOrdersTable(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
