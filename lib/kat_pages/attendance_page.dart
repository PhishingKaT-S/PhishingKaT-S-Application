/**
 * update: 2022-08-16
 * AttendancePage
 * 최종 작성자: 김진일
 *
 * 해야할 일:
 *  1. user_id (객체에서 꼽아주기)
 *  2. 네트워크 에러 페이지로 넘기기 (연동)
 *  3. 이번달 출석일수 Provider 작성
 */

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:phishing_kat_pluss/db_conn.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../kat_widget/kat_appbar_back.dart';
import '../providers/attendanceProvider.dart';
import '../providers/launch_provider.dart';
import '../theme.dart';

class Event {
  final DateTime date ;
  Event({required this.date});
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _AttendancePage() ;
}

bool _test() {
  return false;
}

class _AttendancePage extends State<AttendancePage> {
  var _now = DateTime.now() ;
  var user_id = 0 ;
  var total_attendance = 0 ;

  @override
  void initState() {
    super.initState();
    user_id = Provider.of<LaunchProvider>(context, listen: false).getUserInfo().userId ;
  }

  final _events = LinkedHashMap(
    equals: isSameDay,
  ) ;

  Future _getDateInfo() async {
    DateTime _date ;
    Map<DateTime, dynamic> dates = {} ;
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async {
          await conn.query("SELECT * FROM attendance WHERE user_id = ?", [user_id])
          .then((results) {
            if ( results.isNotEmpty ) {
              for (var res in results )  {
                _date = res['attendance'] as DateTime;
                dates[_date] = _date;
              }
              _events.addAll(dates);
            } else {

            }
          }).onError((error, stackTrace) {
            /// 쿼리 에러 처리
          });
          conn.close();
        }).onError((error, stackTrace) {
          /// 네트워크 에러 처리
        });
    //print(_events) ;

    setState(() {
      total_attendance = _events.length;
    });

    return _events ;
  }

  Widget _onedayOnecheckNotice() {
    const double NOTICE_HEIGHT = 60.0;
    /**
     * _oneday_onecheck_notice
     * 맨 위에 공지 글
     * */
    return Container(
      height: NOTICE_HEIGHT,
      color: AppTheme.white,
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: const Center(
        child: Text('* 하루에 한 번 출석 가능합니다.', style: TextStyle(color: AppTheme.greyText, fontSize: 16),),
      ),
    ) ;
  }

  Widget _dividingLine() {
    return Container(
      height: 15,
      color: AppTheme.whiteGrey,
    );
  }

  Widget _calendarTitle() {
    const double TITLE_HEIGHT = 90.0;

    /**
     * _calendar_title
     * 캘린더 제목
     * [수정해야할 사항]
     * 1. 현재 월(달) 출력, 고정 값 X
     */
    return Container(
      height: TITLE_HEIGHT,
      color: AppTheme.white,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08),
            child: Row(
              children: [
                Text(_now.month.toString(), style: AppTheme.display1),
                const Text('월', style: AppTheme.title),
              ],
            )
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('이번달 출석일수 '),
                Text(context.read<AttendanceProvider>().getMonthAttendance().toString(), style: const TextStyle(color: AppTheme.blueText, fontSize: 16, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
                const Text('일'),
              ],
            )
          ),
        ],
      )
    );
  }

  Widget _calendarContent() {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime? _selectedDay;
    List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];

    /**
     * _calendar_content
     * 캘린더 내용
     * [수정해야할 사항]
     * 1. Database에서 사용자의 출석 현황 값을 들고와 표시
     */
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      color: AppTheme.blueBackground,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: FutureBuilder(
        future: _getDateInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print(snapshot) ;
          if ( snapshot.hasError ) {
            return Text('${snapshot.error}') ;
          } else if ( snapshot.hasData ) {
            return TableCalendar(
              firstDay: DateTime(_now.year, _now.month, 1),
              lastDay: DateTime(_now.year, _now.month + 1, 0),
              focusedDay: _now,
              calendarFormat: _calendarFormat,
              daysOfWeekHeight: 30,
              headerVisible: false,
              calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  )
              ),
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _now = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _now = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(child: Text(days[day.weekday])) ;
                },
                markerBuilder: (context, date, events) {
                  if ( isSameDay(date, _events[date] )) {
                    return Container(
                        width: MediaQuery.of(context).size.width * 0.11,
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Image.asset('assets/images/attendance.png',));
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        },
      )
    );
  }

  Widget _onedayOnecheckAdditionalNotice() {
    const double NOTICE_HEIGHT = 100.0;

    /**
     * _oneday_onecheck_additional_notice
     * 맨 아래에 공지 글
     * */
    return Container(
      height: NOTICE_HEIGHT,
      color: AppTheme.white,
      padding: EdgeInsets.only(top: 15, bottom: 15, left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1),
      child: const Text('* 오늘 날짜를 선택해주세요. 지난 날짜는 응모할 수 없습니다.', style: TextStyle(color: AppTheme.greyText),),
    ) ;
  }

  @override
  Widget build(BuildContext context) {

    /**
     * 이것 또한 AppBar를 따로 빼서 구현할 것 인지 정해야함.
     * */
    return Scaffold(
      appBar: AppBarBack(title: "출석체크"),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _onedayOnecheckNotice(),
            _dividingLine(),
            _calendarTitle(),
            _calendarContent(),
            _onedayOnecheckAdditionalNotice(),
          ],
        ),
      )
    );
  }
}