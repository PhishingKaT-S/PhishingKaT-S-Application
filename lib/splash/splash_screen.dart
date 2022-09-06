/**
 * writer: 유이새
 * Date: 2022.07.04
 * Description: SplashScreen for initial data loding.
 */

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../kat_pages/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0473e1),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                '나와 내 이웃을 지키는',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.1
                ),
              ),
              Text(
                '피싱캣S+',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  height: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
