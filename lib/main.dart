// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_course_cw/Course/Welcome.dart';
import 'package:flutter_course_cw/Course/newCourse.dart';
import 'package:flutter_course_cw/Course/route_name.dart';

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
        RouterNames.NewTrip: (context) => const NewCourse()
      },
      initialRoute: RouterNames.Welcome,
      //home: Welcome());
    );
  }
}
