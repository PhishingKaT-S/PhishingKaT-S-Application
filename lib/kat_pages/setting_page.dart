import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class settingPage extends StatefulWidget {
  const settingPage({Key? key}) : super(key: key);

  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  List<bool> status = [false, true, false, true] ;
  List<String> setting_names = ['피싱관련 뉴스 알림', '이벤트 알림', '알림 미리보기', '푸시알림'] ;

  Widget _title() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 5),
      width: MediaQuery.of(context).size.width ,
      child: const Text('알림 설정', style: AppTheme.subtitle),
      decoration: const BoxDecoration(
        color: AppTheme.whiteGreyBackground,
      ),
    ) ;
  }

  Widget _flutter_switch(int index) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 5),
      width: MediaQuery.of(context).size.width ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(setting_names[index]),

          (index < 3) ? (
            FlutterSwitch(
              height: 30,
              showOnOff: true,
              activeTextColor: AppTheme.white,
              inactiveTextColor: AppTheme.white,
              value: status[index],
              onToggle: (val) {
                setState(() {
                  status[index] = val;
                });
              },
            )
          ) :
          (
            InkWell(
              onTap: () {} ,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppTheme.blueLineChart,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Text('소리+진동', style: TextStyle(color: AppTheme.white), textAlign: TextAlign.center,)
                )
              )
            )
          )
        ]
      )
    );
  }

  Widget _buttons() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        children: List.generate(setting_names.length, (index) {
          return _flutter_switch(index);
        })
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(title: '설정'),
      body: Container(
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
