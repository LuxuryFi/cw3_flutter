// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_trip_cw/Trip/Welcome.dart';
import 'package:flutter_trip_cw/Trip/newTrip.dart';
import 'package:flutter_trip_cw/Trip/route_name.dart';

void main() {
  runApp(const TripWorm());
}
//widget
class TripWorm extends StatelessWidget {
  const TripWorm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouterNames.Welcome: (context) => const Welcome(),
        RouterNames.NewTrip: (context) => const NewTrip()
      },
      initialRoute: RouterNames.Welcome,
      //home: Welcome());
    );
  }
}
