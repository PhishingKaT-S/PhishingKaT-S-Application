/**
 * writer: 유이새
 * Date: 2022.07.04
 * Description: SplashScreen for initial data loding.
 */

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../homepage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('PhishingKaT+S',
                    textStyle: GoogleFonts.allura(textStyle: const TextStyle(fontSize: 32.0)),
                    speed: const Duration(milliseconds: 100)),
              ],
              totalRepeatCount: 2,
              pause: const Duration(milliseconds: 100),
            )
          ],
        ),
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future<Widget?> initialize(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 5000));

    // . . .
    // 초기 로딩 작성
    // . . .

    return const HomePage(); // 초기 로딩 완료 시 띄울 앱 첫 화면
  }
}