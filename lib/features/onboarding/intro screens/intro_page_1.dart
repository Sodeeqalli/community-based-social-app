// ignore_for_file: deprecated_member_use

import 'package:bu_connect/core/constants/constants.dart';
import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  final ThemeData themeData;
  const IntroPage1({super.key, required this.themeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeData.backgroundColor,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 90),
          child: Image.asset(
            Constants.communityPath,
            height: 320,
            width: 600,
            fit: BoxFit.fill,
          ),
        ),
        const Text(
          'CONNECT TODAY',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
          child: Text(
            'Welcome to BU Connect, your gateway to joining the vibrant groups of Babcock University. Discover communities that spark your interest.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        )
      ]),
    );
  }
}
