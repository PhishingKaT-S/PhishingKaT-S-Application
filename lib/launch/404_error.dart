import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Error404 extends StatelessWidget {
  const Error404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/lotties/error404.json')
      )
    );
  }
}
