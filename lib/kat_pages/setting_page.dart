import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class settingPage extends StatefulWidget {
  const settingPage({Key? key}) : super(key: key);

  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {

  Widget _title() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: const Text('알림 설정', style: AppTheme.subtitle),
      decoration: const BoxDecoration(
        color: AppTheme.whiteGreyBackground,
      ),
    ) ;
  }

  Widget _buttons() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(title: '설정'),
      body: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          children: [
            _title(),
            _buttons(),
          ]
        ),
      ),
    );
  }
}
