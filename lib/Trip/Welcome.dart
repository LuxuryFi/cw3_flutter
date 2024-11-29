import 'package:flutter/material.dart';
import 'package:flutter_trip_cw/Trip/route_name.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, RouterNames.NewTrip);
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),//icon dau +
      ),
      appBar: AppBar(
        title: const Text("Trip CW"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.blue.shade100.withOpacity(0.8),
            ),
            child: const Text(
              'Welcome to the Trip good',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    ));
  }
}
