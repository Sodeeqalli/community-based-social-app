import 'package:bu_connect/features/onboarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';

class LoggingOutPage extends StatefulWidget {
  const LoggingOutPage({super.key});

  @override
  State<LoggingOutPage> createState() => _LoggingOutPageState();
}

class _LoggingOutPageState extends State<LoggingOutPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 1), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const OnBoardingScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
