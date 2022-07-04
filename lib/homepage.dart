import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar.dart';
import 'package:phishing_kat_pluss/theme.dart';
import 'kat_widget/kat_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KaTAppBar(),
      drawer: KaTDrawer(),
    );
  }
}

