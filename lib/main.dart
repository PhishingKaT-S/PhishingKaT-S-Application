import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/kat_pages/attendance_page.dart';
import 'package:phishing_kat_pluss/kat_pages/detect_load_page.dart';
import 'package:phishing_kat_pluss/kat_pages/home_page.dart';
import 'package:phishing_kat_pluss/kat_pages/score_page.dart';
import 'package:phishing_kat_pluss/providers/testProvider.dart';
import 'package:phishing_kat_pluss/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'kat_pages/info_check_page.dart';
import 'kat_pages/one_click_page.dart';
import 'kat_pages/url_check_page.dart';
import 'kat_pages/detect_load_page.dart';
import 'launch/login_page.dart';
import 'splash/test.dart';

void main() {
  runApp(
    /**
     * Provider initialization
     * TestProvider: Test를 위한 Provider
     */
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (BuildContext context) => TestProvider(),),
      ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /**
     * FutureBuilder
     * 앱의 초기 데이터를 불러오는 시간을 벌기위한 Splash Screen 화면은 FutureBuilder로 구현.
     */
    return FutureBuilder(
      ///future: 앱의 초기 설정및 데이터를 불러오는 곳
        future: Init.instance.initialize(context),
        /// future의 상태에 따라 보여주는 화면이 다르다.
        /// future를 기다리는 중이면 Splash화면을 보여준다.
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(home: SplashScreen()); // 초기 로딩 시 Splash Screen
          }
          ///future에서 데이터를 불러오는 중에 에러가 발생하면 에러 메시지를 띄워준다.
          // else if (snapshot.hasError) {
          //   return MaterialApp(home: ErrorScreen()); // 초기 로딩 에러 시 Error Screen
          // }
          ///future에서 데이터를 불러온 다음 home page로 이동
          else {
            return MaterialApp(
              title: 'PhishingKaT+s', // 앱 이름
              ///전체앱의 theme 설정
              theme: ThemeData(
                primarySwatch: Colors.blue,
                // fontFamily: 'Noto_Serif_KR',
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: Colors.blueGrey,
                scaffoldBackgroundColor: Colors.white,
              ),
              home: snapshot.data,
              ///앱에서 이동할 페이지의 이름 설정
              routes: {
                //'/login': (BuildContext context) => const LoginPage(),
                '/splash_screen': (BuildContext context) => const SplashScreen(),
                '/kat_pages/attendance' : (BuildContext context) => const AttendancePage(),
                '/kat_pages/score': (BuildContext context) => const ScorePage(),
                '/kat_pages/one_click' : (BuildContext context) => const OneClickPage(),
                '/kat_pages/info_check' : (BuildContext context) => const InfoCheckPage(),
                '/kat_pages/url_check' : (BuildContext context) => const UrlCheckPage(),
                '/kat_pages/detect_load' : (BuildContext context) => const DetectLoadPage(),
                '/launch/login' : (BuildContext context) => const LoginPage(),
                '/splash/test' : (BuildContext context) => const TestPage(),
              },
            );
          }
        });
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future<Widget?> initialize(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2000));

    // . . .
    // 초기 로딩 작성
    // . . .

    return const HomePage(); // 초기 로딩 완료 시 띄울 앱 첫 화면
  }
}
