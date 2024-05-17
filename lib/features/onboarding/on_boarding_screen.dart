import 'package:bu_connect/features/auth/screen/login_screen.dart';
import 'package:bu_connect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bu_connect/features/onboarding/intro screens/intro_page_1.dart';
import 'package:bu_connect/features/onboarding/intro screens/intro_page_2.dart';
import 'package:bu_connect/features/onboarding/intro screens/intro_page_3.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final PageController _controller = PageController(initialPage: 0);
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 2;
              });
            },
            controller: _controller,
            children: [
              IntroPage1(
                themeData: themeData,
              ),
              IntroPage2(
                themeData: themeData,
              ),
              IntroPage3(
                themeData: themeData,
              ),
            ],
          ),
          Positioned(
              bottom: 300,
              left: 350,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    _controller.jumpToPage(2);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 1, 94, 250),
                  ))),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  effect: const SwapEffect(
                    activeDotColor: Color.fromARGB(255, 1, 94, 250),
                    dotColor: Colors.grey,
                    dotHeight: 8,
                    dotWidth: 18,
                  ),
                  count: 3,
                ),
                const SizedBox(height: 20),
                if (onLastPage)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const LogInScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 1, 94, 250),
                        padding: const EdgeInsets.symmetric(horizontal: 40)),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else
                  const SizedBox(
                    height: 48,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
