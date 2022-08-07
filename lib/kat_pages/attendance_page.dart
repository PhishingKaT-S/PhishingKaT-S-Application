/// update: 2022-07-21
/// AttendanceCheckPage
/// 최종 작성자: 김진일

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../theme.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _AttendancePage() ;
}

class _AttendancePage extends State<AttendancePage> {

  Widget _oneday_onecheck_notice() {
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
        child: Text('* 하루에 한 번 출석 가능합니다.', style: TextStyle(color: AppTheme.greyText),),
      ),
    ) ;
  }

  Widget _dividing_line() {
    return Container(
      height: 15,
      color: AppTheme.whiteGrey,
    );
  }

  Widget _calendar_title() {
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
            width: MediaQuery.of(context).size.width * 0.3,
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08),
            child: Row(
              children: const [
                Text('7', style: AppTheme.display1),
                Text('월', style: AppTheme.title),
              ],
            )
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text('이번달 출석일수 '),
                Text('1', style: TextStyle(color: AppTheme.blueText)),
                Text('일'),
              ],
            )
          ),
        ],
      )
    );
  }

  Widget _calendar_content() {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];
    const double CALENDAR_HEIGHT = 400.0;

    /**
     * _calendar_content
     * 캘린더 내용
     * [수정해야할 사항]
     * 1. Database에서 사용자의 출석 현황 값을 들고와 표시
     */
    return Container(
      height: CALENDAR_HEIGHT,
      color: AppTheme.blueBackground,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TableCalendar(
        firstDay: DateTime(2022, 8, 1),
        lastDay: DateTime(2022, 8, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        daysOfWeekHeight: 30,
        headerVisible: false,
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            return Center(child: Text(days[day.weekday])) ;
          },
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
              _focusedDay = focusedDay;
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
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _oneday_onecheck_additional_notice() {
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("출석체크", style: TextStyle(color: AppTheme.blueText),),
        backgroundColor: AppTheme.blueBackground,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _oneday_onecheck_notice(),
            _dividing_line(),
            _calendar_title(),
            _calendar_content(),
            _oneday_onecheck_additional_notice(),
          ],
        ),
      )
    );
  }
}