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

  Future<bool> getTodayAttendance(int userId) async{
    await getRecentAttendance(userId);
    return _todayAttendance;
  }

  void setTodayAttendance(){
    _attendanceCheck();
    _todayAttendance = true;
  }

  Future getRecentAttendance(int userId) async {
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT attendance FROM attendance WHERE user_id = ? AND attendance >= ?",
          [
            userId,
            DateFormat('yy-MM-dd').format(DateTime.now())
          ]).then((results) {
        if (results.isNotEmpty) {
          _todayAttendance = true;
        } else if (results.isEmpty) {
          _todayAttendance = false;
        }
      }).onError((error, stackTrace) {
        print("error: $error");
      });
      conn.close();
    }).onError((error, stackTrace) {
      print("error2: $error");
    });

  }

  void _attendanceCheck() async{
    if (!_todayAttendance) {
      await MySqlConnection.connect(Database.getConnection()).then((conn) async {
        await conn.query(
            "INSERT INTO attendance VALUE(?, ?)",
            [
              LaunchProvider().getUserInfo().userId,DateFormat('yy-MM-dd').format(DateTime.now())
            ]).then((results) {
          if (results.isNotEmpty) {
          } else if (results.isEmpty) {
          }
        }).onError((error, stackTrace) {
          print("error: $error");
        });
        conn.close();
      }).onError((error, stackTrace) {
        print("error2: $error");
      });
    }
  }
}
