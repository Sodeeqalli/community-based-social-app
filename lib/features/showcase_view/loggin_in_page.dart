import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/home/screens/home_screen_new.dart';
import 'package:bu_connect/features/user_profile/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';

import '../home/screens/home_screen.dart';

class LoggingInPage extends ConsumerStatefulWidget {
  const LoggingInPage({super.key});

  @override
  ConsumerState<LoggingInPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoggingInPage> {
  void updateUserStatus() {
    ref.read(userProfileControllerProvider.notifier).updateUserStatus();
  }

  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 1), () {
      final currentUser = ref.read(userProvider)!;

      // Determine if the user is new or not
      final isNewUser = currentUser
          .isNew; // Ensure your user model has a property to indicate if the user is new or not

      // Based on the user's status, navigate to the appropriate screen
      Widget destinationScreen = isNewUser
          ? ShowCaseWidget(
              builder: Builder(builder: (ctx) => const HomeScreenNew()))
          : const HomeScreen();

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => destinationScreen));
      if (isNewUser) {
        updateUserStatus();
      }
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
