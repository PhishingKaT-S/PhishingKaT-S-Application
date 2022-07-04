import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/providers/testProvider.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';

void main() {
  runApp(
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
    return MaterialApp(
      title: 'PhishingKaT+s', // 앱 이름
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        //'/login': (BuildContext context) => const LoginPage(),
      },
    );
  }
}
