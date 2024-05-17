import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/core/common/sign_in_button.dart';
import 'package:bu_connect/core/constants/constants.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogInScreen extends ConsumerWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 60,
        ),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Start Connecting...',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Constants.introPath,
                      height: 400,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SignInButton(onTap: () {}),
                ],
              ),
            ),
    );
  }
}
