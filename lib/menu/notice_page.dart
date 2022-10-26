/**
 * update: 2022-08-18
 * Detect noticePage
 * 최종 작성자: 김진일
 *
 * 완료
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../db_conn.dart';
import '../kat_widget/kat_appbar_back.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<String> _title = [] ;
  List<String> _written_date = [] ;
  List<String> _content = [];
  List<bool> _notice_tap = [false];

  bool update_flag = false;

  Future<bool> _getNoticeData() async {
    if(!update_flag) {
      await MySqlConnection.connect(Database.getConnection())
          .then((conn) async {
        await conn.query("SELECT * FROM notice WHERE view = 1")
            .then((results) {
          if (results.isNotEmpty) {
            for (var res in results) {
              _title.add(res['title']);

              DateTime _datetime = res['day'] as DateTime;
              int _year = _datetime.year;
              int _month = _datetime.month;
              int _day = _datetime.day;

              _written_date.add('$_year. $_month. $_day');

              _content.add(res['content']);

              _notice_tap.add(false);

              update_flag = true;
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

    return true;
  }

  Widget _expansionTile(int index) {


    return ExpansionTile(
      trailing: _notice_tap[index]
        ? Icon(Icons.keyboard_arrow_down_outlined)
        : Icon(Icons.keyboard_arrow_up_outlined),
      onExpansionChanged: (val) {
        setState(() {
          _notice_tap[index] = !_notice_tap[index] ;
        });

      },
      title: Text(_title[index]),
      subtitle: Text(_written_date[index]),
      children: <Widget>[
        ListTile(
          title: Text(_content[index]), tileColor: const Color(0xFFF6F6F6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(title: '공지사항'),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getNoticeData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if ( snapshot.hasError ) {
              return const Text('데이터를 불러 올 수 없습니다.') ;
            } else if ( snapshot.hasData ) {
              return Column(
                children: List.generate(_title.length, (index) {
                  return _expansionTile(index) ;
                }),
              );
            } else {
              return Container();
            }
          },
        ),
      )
    );
  }
}
