/**
 * update: 2022-08-18
 * Detect phishngNoticePage
 * 최종 작성자: 김진일
 *
 * 해야할 일: 폰트 수정, 알림 확인 (디테일)
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class phishingNoticePage extends StatefulWidget {
  const phishingNoticePage({Key? key}) : super(key: key);

  @override
  _phishingNoticePageState createState() => _phishingNoticePageState();
}

class _phishingNoticePageState extends State<phishingNoticePage> {

  List<String> dateList = ['03월 03일', '03월 03일', '03월 03일'] ;
  List<String> contents = ['보이스피싱이었다면 말할 것도 없고...', '보이스피싱이었다면 말할 것도 없고...', '보이스피싱이었다면 말할 것도 없고...'] ;
  List<bool> isReadList = [true, false, true] ;

  Widget _vertical_divider (){
    return Container(
      margin: const EdgeInsets.only(left: 3.25),
      width: 1,
      decoration: const BoxDecoration(
        color: Color(0xFFB1AEAE),
      ),
    );
  }

  Widget _notice(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.04,
            child: Row(
              children: [
                /// 제목 앞 동그라미 표시
                Container(
                  width: MediaQuery.of(context).size.height * 0.01,
                  height: MediaQuery.of(context).size.height * 0.01,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isReadList[index]) ? AppTheme.blueLineChart : Color(0xFFB1AEAE),
                  ),
                ),

                /// 제목 (알림 날짜)
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// 날짜
                      Text(dateList[index], style: TextStyle(fontSize: 16)),
                      InkWell(
                        child: const Icon(Icons.close),
                        onTap: () { },
                      )
                    ]
                  ),
                )
              ],
            ),
          ),

          /// 알림 내용
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04)),
              InkWell(
                /// 알림 확인하는 부분
                onTap: () { },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.74,
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: (isReadList[index]) ? Text(contents[index], style: TextStyle(color: Color(0xFF0473E1))) :
                  Text(contents[index], style: TextStyle(color: Color(0xFFB1AEAE))),
                  decoration: BoxDecoration(
                    color: (isReadList[index]) ? Color(0xFFEAF5FF) : AppTheme.white,
                  ),
                )
              )
            ],
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(title: '피싱알림'),
      body: SingleChildScrollView(
        /// dateList.length != 0
        child: (dateList.isNotEmpty) ? (
          Container(
          padding: EdgeInsets.only(top: 30, left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
                height: MediaQuery.of(context).size.height * 0.1 * (dateList.length - 1),
                child: _vertical_divider(),
              ),
              Container(
                child: Column(
                  children: List.generate(contents.length, (index) {
                    return _notice(index) ;
                  }),
                )
              )
            ],
          )
        )) :
        /// dataList.length == 0
        Container(),
      ),
    );
  }
}
