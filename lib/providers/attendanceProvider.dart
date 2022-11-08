import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import 'package:phishing_kat_pluss/providers/launch_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../db_conn.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceProvider() {
    // _init();
  }

  // void _init() {
  //   getRecentAttendance();
  // }

  bool _todayAttendance = false;
  int _monthAttendance = 0;
  List _week_attendance_date = [];
  List<bool> _week_attendance = [false, false, false, false, false, false, false];

  int getMonthAttendance(){
    return _monthAttendance;
  }

  List<bool> getWeekAttendance(){
    return _week_attendance;
  }

  Future<bool> getTodayAttendance(int userId) async {
    await getRecentAttendance(userId);
    // await getMonthAttendance(userId);
    return _todayAttendance;
  }

  void setTodayAttendance(int userId) {
    _attendanceCheck(userId);
    _todayAttendance = true;
  }

  Future getRecentAttendance(int userId) async {
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT attendance FROM attendance WHERE user_id = ? AND attendance >= ? ORDER BY attendance",
          [
            userId,
            DateFormat('yy-MM-dd').format(
                DateTime.now().subtract(Duration(days: DateTime.now().day - 1)))
          ]).then((results) {
        if (results.isNotEmpty) {
          if (results.last["attendance"].toString().split(" ").first ==
              DateFormat('yyyy-MM-dd').format(DateTime.now())){
            _todayAttendance = true;
            _monthAttendance = results.length;
          }
          else{
            _monthAttendance = results.length + 1;
            _todayAttendance = false;
          }
        } else if (results.isEmpty) {
          _todayAttendance = false;
          _monthAttendance = 1;
        }
      }).onError((error, stackTrace) {
        print("error: $error");
      });
      conn.close();
    }).onError((error, stackTrace) {
      print("error2: $error");
    });
    getWeekAttendance_fromDB(userId);
  }

  Future getWeekAttendance_fromDB(int userId) async {
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT attendance FROM attendance WHERE user_id = ? AND attendance >= ? ORDER BY attendance",
          [
            userId,
            DateFormat('yy-MM-dd').format(
                DateTime.now().subtract(const Duration(days: 7)))
          ]).then((results) {
        if (results.isNotEmpty) {
          List temp = results.toList();
          for(int i = 0 ; i < results.length ; i++){
            _week_attendance_date.add(temp[i]["attendance"].toString().split(" ").first);
          }

          DateTime _nowDay = DateTime.now();
          int _now_week = _nowDay.weekday;
          DateTime _firstDay = DateTime.now().subtract(Duration(days: _now_week-1));
          for(int i = 0 ; i < _now_week ; i++){
            if(_week_attendance_date.contains(_firstDay.add(Duration(days: i)).toString().split(" ").first)){
              _week_attendance[i] = true;
              notifyListeners();
            }
          }
        }
      }).onError((error, stackTrace) {
        print("error: $error");
      });
      conn.close();
    }).onError((error, stackTrace) {
      print("error2: $error");
    });
  }

  void _attendanceCheck(int userId) async {
    print("user ID: $userId");
    if (!_todayAttendance) {
      await MySqlConnection.connect(Database.getConnection())
          .then((conn) async {
        await conn.query("INSERT INTO attendance VALUES(?, ?)", [
          userId,
          DateFormat('yyyy-MM-dd').format(DateTime.now())

        ]).then((results) {
          if (results.isNotEmpty) {
          } else if (results.isEmpty) {}
        }).onError((error, stackTrace) {
          print("error: $error");
        });
        conn.close();
      }).onError((error, stackTrace) {
        print("error2: $error");
      });

      getRecentAttendance(userId);
    }
  }
}
