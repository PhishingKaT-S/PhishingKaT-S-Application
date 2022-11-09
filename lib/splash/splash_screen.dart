/**
 * writer: 유이새
 * Update: 2022.10.26
 * Description: SplashScreen for initial data loding.
 */

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Theme.dart';
import '../kat_pages/home_page.dart';
import '../providers/launch_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0473e1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '나와 내 이웃을 지키는',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'shineforU',
                  height: 1
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            child: const Align(
              alignment: Alignment.topCenter,
              child: Text(
                '피싱캣S',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'shineforU',
                height: 1.1),
              ),
            ),
          ),
          Container(
            height: 115,
          ),
          Text(Provider.of<LaunchProvider>(context, listen: true).getUserInfo().imei.toString() ),
          Text(Provider.of<LaunchProvider>(context, listen: true).getUserInfo().phoneNumber.toString() )
        ],
      ),
    );
  }
}
