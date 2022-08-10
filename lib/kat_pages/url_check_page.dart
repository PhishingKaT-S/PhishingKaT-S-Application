import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar_back.dart';

class UrlCheckPage extends StatelessWidget {
  const UrlCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(title: "Url 검사"),
      body: Container(),
    );
  }
}
