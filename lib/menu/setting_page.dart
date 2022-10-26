/**
 * update: 2022-08-18
 * Detect noticePage
 * 최종 작성자: 김진일
 *
 * 해야할 일
 * 1. Insert Trigger 작성
 * 2. 알림 페이지로 넘길 때 user_id 값 파라미터로 넘기기
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../Theme.dart';
import '../db_conn.dart';
import '../kat_widget/kat_appbar_back.dart';
import '../providers/launch_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<int> _status = [0, 0, 0, 0] ;
  List<int> _settingStatus = [0, 0, 0, 0] ;
  List<String> settingNames = ['피싱관련 뉴스 알림', '이벤트 알림', '알림 미리보기', '푸시알림'] ;
  late int user_id ;

  @override
  void initState() {
    super.initState() ;

    () async {
      user_id = Provider.of<LaunchProvider>(context, listen: false).getUserInfo().userId ;
      await _getSettingStatus(user_id) ;
      setState(() {
        for (int i = 0 ; i < _status.length ;i++) {
          _status[i] = _settingStatus[i] ;
        }
      });
    } () ;
  }

  @override
  void dispose() {
    super.dispose() ;
    _saveStatus(user_id) ;
  }

  Future<bool> _getSettingStatus(int user_id) async {
    const List<String> alarm_cols = ['news_alarm', 'events_alarm', 'preview_alarm', 'push_alarm'] ;

    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async {
      await conn.query("SELECT * FROM alarm_setting WHERE user_id = ?", [user_id])
          .then((results) {
        if ( results.isNotEmpty ) {
          for (var res in results )  {
            for (int i = 0 ; i < _settingStatus.length; i++) {
              _settingStatus[i] = ( res[alarm_cols[i]] == 1 ) ? 1 : 0 ;
              print(_settingStatus[i].toString()) ;
            }
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

    return true ;
  }

  Future _saveStatus(int user_id) async {
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async {
      await conn.query("UPDATE alarm_setting SET news_alarm = ?, events_alarm = ?, preview_alarm = ?, push_alarm = ? WHERE user_id = ?",
          [_status[0], _status[1], _status[2], _status[3], user_id])
          .then((results) {
      }).onError((error, stackTrace) {
        /// 쿼리 에러 처리
      });
      conn.close();
    }).onError((error, stackTrace) {
      /// 네트워크 에러 처리
    });
  }

  Widget _title() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 10),
      width: MediaQuery.of(context).size.width ,
      child: const Text('알림 설정', style: AppTheme.subtitle),
      decoration: const BoxDecoration(
        color: AppTheme.whiteGreyBackground,
      ),
    ) ;
  }

  Widget _flutterSwitch(int index) {
    List<String> buttonNames = ['무음', '소리', '진동', '소리+진동'] ;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 5),
        width: MediaQuery.of(context).size.width ,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(settingNames[index], textAlign: TextAlign.center,),

              (index < 3) ? (
                Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.006 ),
                      child: FlutterSwitch(
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.height * 0.028,
                        showOnOff: true,
                        activeTextColor: AppTheme.white,
                        inactiveTextColor: AppTheme.white,
                        value: (_status[index] == 1) ? true : false,
                        valueFontSize: MediaQuery.of(context).size.height * 0.015,
                        toggleSize: MediaQuery.of(context).size.height * 0.026,
                        padding: 1,
                        onToggle: (val) {
                          setState(() {
                            _status[index] = (val) ? 1 : 0;
                          });
                        },
                      )
                  )
                )
              )
                  :
              (
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _status[3] = (_status[3] + 1) % 4 ;
                        });
                      } ,

                      child: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.014),
                          padding: const EdgeInsets.only(top: 1, bottom: 3),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.03,
                          decoration: const BoxDecoration(
                            color: AppTheme.blueLineChart, // (_status[3] == 1) ? AppTheme.blueLineChart : AppTheme.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(buttonNames[_status[3]],
                                        style: TextStyle(color: AppTheme.white, fontSize: 12), textAlign: TextAlign.center,)// TextStyle(color: (_status[3] == 1) ? AppTheme.white : AppTheme.blueLineChart), textAlign: TextAlign.center,),
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
          children: List.generate(_settingStatus.length, (index) {
            return _flutterSwitch(index);
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