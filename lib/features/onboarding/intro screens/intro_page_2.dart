// ignore_for_file: deprecated_member_use

import 'package:bu_connect/core/constants/constants.dart';
import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  final ThemeData themeData;
  const IntroPage2({super.key, required this.themeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeData.backgroundColor,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 90),
          child: Image.asset(
            Constants.connectPath,
            height: 300,
            width: 600,
            fit: BoxFit.fill,
          ),
        ),
        const Text(
          'DISCOVER AND ENGAGE',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Text(
            'Dive into a world of opportunities! Explore upcoming events, join clubs that match your interests',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        )
      ]),
    );
  }
}
