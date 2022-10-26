import "package:flutter/material.dart";
import 'package:phishing_kat_pluss/splash/splash_screen.dart';
import 'package:phishing_kat_pluss/splash/update_page.dart';

import '../launch/login_page.dart';
import '404_error.dart';
import 'network_error.dart';

class SplashTest extends StatelessWidget {
  const SplashTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
              Navigator.pushNamed(context, '/splash_screen');
            }, child: Text("splash_screen")),
            TextButton(onPressed: (){
              Navigator.pushNamed(context, '/launch/login');
            }, child: Text("login page")),
            TextButton(onPressed: (){
              Navigator.pushNamed(context, '/launch/network_error');
            }, child: Text("network_error")),
            TextButton(onPressed: (){
              Navigator.pushNamed(context, '/launch/update_page');
            }, child: Text("update_page")),
            TextButton(onPressed: (){
              Navigator.pushNamed(context, '/launch/404_error');
            }, child: Text("404_error")),
          ],
        ),
    );
  }
}
