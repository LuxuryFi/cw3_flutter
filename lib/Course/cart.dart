import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'welcome.dart'; // Import the WelcomeView page

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  TextEditingController emailController = TextEditingController();
  String emailError = ''; // Track email error message

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Fetch cart items from the API
  Future<void> fetchCartItems() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://103.107.182.247:3000/cart'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        cartItems = data.map((item) => item as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load cart items');
    }
  }

  // Validate the Gmail format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email);
  }

  // Place the order and send the Gmail address
  Future<void> placeOrder(String email) async {
    if (isValidEmail(email)) {
      final response = await http.post(
        Uri.parse('http://103.107.182.247:3000/order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Order placed successfully!'),
        ));

        // Navigate back to the Welcome view after successful order
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Welcome()),
        );
      } else {
        throw Exception('Failed to place order');
      }
    } else {
      setState(() {
        emailError = 'Please enter a valid Gmail address';
      });
    }
  }

  // Display the cart items in a table
  Widget _buildCartItemsTable() {
  return DataTable(
    columnSpacing: 20.0,
    columns: const [
      DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Day of Week', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Position', style: TextStyle(fontWeight: FontWeight.bold))),  // New column for Position
      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
    ],
    rows: cartItems.map((cartItem) {
      return DataRow(cells: [
        DataCell(Text(cartItem['_id'])),
        DataCell(Text(cartItem['dayOfWeek'])),
        DataCell(Text(cartItem['time'])),
        DataCell(Text(cartItem['capacity'].toString())),
        DataCell(Text(cartItem['position'] ?? 'Not Set')), // Display the position
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteCartItem(cartItem['_id']),
          ),
        ),
      ]);
    }).toList(),
  );
}

  // Delete a cart item by id
  Future<void> deleteCartItem(String id) async {
    final response = await http.delete(Uri.parse('http://103.107.182.247:3000/$id'));

    if (response.statusCode == 200) {
      setState(() {
        cartItems.removeWhere((item) => item['_id'] == id);
      });
    } else {
      throw Exception('Failed to delete cart item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart View'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
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
                              'Your Cart',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildCartItemsTable(),
                            const SizedBox(height: 16),
                            // Email Input
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Enter your Gmail',
                                prefixIcon: const Icon(Icons.email),
                                border: const OutlineInputBorder(),
                                errorText: emailError.isNotEmpty ? emailError : null,
                              ),
                              onChanged: (email) {
                                setState(() {
                                  emailError = ''; // Clear error when user types
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Order Button
                            ElevatedButton(
                              onPressed: emailController.text.isNotEmpty && isValidEmail(emailController.text)
                                  ? () {
                                      placeOrder(emailController.text);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: emailController.text.isNotEmpty && isValidEmail(emailController.text)
                                    ? Colors.deepPurpleAccent
                                    : Colors.grey,
                              ),
                              child: const Text('Place Order'),
                            ),
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
