/**
 * update: 2022-08-18
 * Detect phishngNoticePage
 * 최종 작성자: 김진일
 *
 * 해야할 일:
 *  폰트 수정, 알림 확인 (디테일)
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../Theme.dart';
import '../db_conn.dart';
import '../kat_widget/kat_appbar_back.dart';
import '../providers/launch_provider.dart';

class PhishingAlarmPage extends StatefulWidget {
  const PhishingAlarmPage({Key? key}) : super(key: key);

  @override
  _PhishingAlarmPageState createState() => _PhishingAlarmPageState();
}

class _PhishingAlarmPageState extends State<PhishingAlarmPage> {
  List<int> _id = [] ;
  List<String> _dateList = [] ;
  List<String> _contents = [] ;
  List<bool> _isReadList = [] ;

  Future<bool> _getPhishingAlarmData(int user_id) async {

    if ( _id.isEmpty && _dateList.isEmpty && _contents.isEmpty && _isReadList.isEmpty ) {
      await MySqlConnection.connect(Database.getConnection())
          .then((conn) async {
        await conn.query("SELECT * FROM phishing_alarm WHERE user_id = ?", [user_id])
            .then((results) {
          if ( results.isNotEmpty ) {
            for (var res in results )  {
              print(res['alarm_date']);
              DateTime _date = res['alarm_date'] as DateTime ;

              String _month = (_date.month < 10) ? '0${_date.month}' : '${_date.month}';
              String _day = (_date.day < 10) ? '0${_date.day}' : '${_date.day}';

              _id.add(res['id']) ;
              print(res['id']);
              _dateList.add('$_month월 $_day일') ;
              _contents.add(res['content']) ;
              _isReadList.add((res['confirm'] == 1) ? true : false );
            }
          } else {
            return false;
          }
        }).onError((error, stackTrace) {
          /// 쿼리 에러 처리
        });
        conn.close();
      }).onError((error, stackTrace) {
        /// 네트워크 에러 처리
      });
    }
    return true ;
  }

  Future _deleteAlarmData(int idx) async {
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async {
      await conn.query(
          "DELETE FROM phishing_alarm WHERE id = ?", [_id[idx]])
          .then((results) {
        _id = List.from(_id)..removeAt(idx) ;
      }).onError((error, stackTrace) {
        /// 쿼리 에러 처리
      });
      conn.close();
    }).onError((error, stackTrace) {
      /// 네트워크 에러 처리
    });
  }

  Widget _vertical_divider (){
    return Container(
      margin: const EdgeInsets.only(left: 3),
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
                    color: (_isReadList[index]) ? AppTheme.blueLineChart : Color(0xFFB1AEAE),
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
                      Text(_dateList[index], style: TextStyle(fontSize: 16)),
                      InkWell(
                        child: const Icon(Icons.close, color: AppTheme.greyText,),
                        onTap: () async {
                          if ( _id.isNotEmpty && _dateList.isNotEmpty && _isReadList.isNotEmpty && _contents.isNotEmpty ) {
                            setState(() {
                              _dateList = List.from(_dateList)..removeAt(index);
                              _isReadList = List.from(_isReadList)..removeAt(index) ;
                              _contents = List.from(_contents)..removeAt(index);
                              // await _deleteAlarmData(_id[index]) ;
                            });

                            await _deleteAlarmData(index) ;
                          }
                        },
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
                  child: (_isReadList[index]) ? Text(_contents[index], style: const TextStyle(color: Color(0xFF0473E1), overflow: TextOverflow.ellipsis,)) :
                  Text(_contents[index], style: const TextStyle(color: Color(0xFFB1AEAE)), overflow: TextOverflow.ellipsis,),
                  decoration: BoxDecoration(
                    color: (_isReadList[index]) ? const Color(0xFFEAF5FF) : AppTheme.white,
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
      appBar: AppBar(
        leading: IconButton(
        icon: Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('피싱알림', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.blueText),),
        backgroundColor: AppTheme.blueBackground,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset('assets/images/setting.png', width: MediaQuery.of(context).size.width * 0.055,),
            onPressed: () {
              Navigator.pushNamed(context, '/menu/alarm/setting');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        /// dateList.length != 0

        child: FutureBuilder(
          future: _getPhishingAlarmData(context.watch<LaunchProvider>().getUserInfo().userId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if ( snapshot.hasError ) {
              return const Text('데이터를 불러 올 수 없습니다.') ;
            } else if ( snapshot.hasData ) {
              print(_dateList.length);
              return Container(
                  padding: EdgeInsets.only(top: 30, left: MediaQuery.of(context).size.width * 0.1,
                                                    right: MediaQuery.of(context).size.width * 0.1),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
                        height: MediaQuery.of(context).size.height * 0.1 *  ((_dateList.isNotEmpty) ? _dateList.length - 1 : 0),
                        child: _vertical_divider(),
                      ),
                      Container(
                          child: Column(
                            children: List.generate(_contents.length, (index) {
                              return _notice(index) ;
                            }),
                          )
                      )
                    ],
                  )
              );
            } else {
              return Container() ;
            }
          },
        ),
      ),
    );
  }
}
