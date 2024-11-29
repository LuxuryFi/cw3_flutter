// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_course_cw/Course/Welcome.dart';
import 'package:flutter_course_cw/Course/newCourse.dart';
import 'package:flutter_course_cw/Course/order.dart';
import 'package:flutter_course_cw/Course/route_name.dart';
import 'package:flutter_course_cw/Course/cart.dart';

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
        RouterNames.NewTrip: (context) => const NewCourse(),
        RouterNames.Cart: (context) => const CartView(),
        RouterNames.order: (context) => const OrderView()
      },
      initialRoute: RouterNames.Welcome,
      //home: Welcome());
    );
  }
}
