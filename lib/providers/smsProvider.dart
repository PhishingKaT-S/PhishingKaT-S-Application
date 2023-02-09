import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../db_conn.dart';
import '../local_database/Sms.dart';
import 'launch_provider.dart';
import 'dart:math';

class SmsProvider with ChangeNotifier {
  late List<SmsInfo> _smsList;
  List<String> _user_contact = [];
  int _total_sms = 0;
  int _num_of_sms_unknown_number = 0;
  int _num_of_unknown_number = 0 ;
  var _unknown_phone_numbers = Set() ;
  int _danger_sms = 0;

  SmsProvider() {
    _smsList = [];
    getContacts();
  }

  void setDangerSms(int number){
    _danger_sms = number;
    notifyListeners();
  }
  int getDangerSms() => _danger_sms;
  int getUnknownSms() => _num_of_sms_unknown_number;
  int getSmsLength() {
    return _smsList.length;
  }
  int getTotalSms() => _total_sms;

  Future<void> getInitialInfo(int userId) async{
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT * FROM analysis_reports WHERE user_id = ? ORDER BY date DESC LIMIT 1;", [
        userId,
      ]).then((results) {
        if (results.isNotEmpty) {
          _total_sms = results.first["received_sms"];
          _danger_sms = results.first["phishing_suspected_sms"];
          _num_of_sms_unknown_number = results.first["unknown_phone_sms"];
        } else if (results.isEmpty) {}
      }).onError((error, stackTrace) {
        print("error: $error");
      });
      conn.close();
    }).onError((error, stackTrace) {
      print("error2: $error");
    });
    notifyListeners();
  }

  Future setSmsToSmsProvider(List smsList) async{
    _smsList = [];
    _num_of_sms_unknown_number = 0;
    _num_of_unknown_number = 0 ;

    if (smsList[0] == "Error") {
      return;
    }
    _smsList.clear();
    _total_sms = smsList.length;

    bool UnknownNumbers = true;

    for (int i = 0; i < smsList.length; i++) {
      UnknownNumbers = true;
      List temp = smsList[i].toString().split("[sms_text]");
      for(int j = 0 ; j < _user_contact.length ; j++){
        // print("sms provider - setSmsToSmsProvider - date format: ${DateFormat('yyyy-MM-dd HH:mm:ss').parse(temp[2])}");
        if(_user_contact[j].compareTo(temp[1]) == 0){
          UnknownNumbers = false;
          break;
        }
        else{
          continue;
        }
      }
      if(UnknownNumbers){
        _unknown_phone_numbers.add(temp[1]); // 저장되지 않은 번호들
        _num_of_sms_unknown_number++;
        _smsList.add(
            SmsInfo(name: temp[0], phone: temp[1], date: temp[2], body: temp[3], score: 0));
      }
    }

    _num_of_unknown_number = _unknown_phone_numbers.length ;

    notifyListeners();
    //_makeScore();
  }

  List<SmsInfo> getUnknownSmsList() => _smsList;

  Future<void> insertSMSList(List<SmsInfo> _unknownSmsList) async {

    if ( _unknownSmsList.isEmpty ) {
      return ;
    } else {
      await MySqlConnection.connect(Database.getConnection()).then((conn) async {
        // for (int i = 0 ; i < _unknownSmsList.length; i++) {
        //   SmsInfo _smsInfo = _unknownSmsList[i];
        List<Object> query_data_list = [];
        for (int i = 0 ; i < _unknownSmsList.length; i+=100) {
          String query_string = "INSERT INTO smsdata VALUES ";
          query_data_list.clear();
          for(int j = i ; j < i+100 ; j++){
            if(j == _unknownSmsList.length){
              break;
            }
            query_data_list.add(_unknownSmsList[j].body);
            query_data_list.add(DateFormat('yyyy-MM-dd HH:mm:ss').parse(_unknownSmsList[i].date, true));

            if(j == 99 + i || j == _unknownSmsList.length - 1){
              query_string += "(NULL, ?, ?)";
            }
            else{
              query_string += "(NULL, ?, ?),";
            }

          }
          await conn.query(
          //     "INSERT INTO smsData VALUES (NULL, ?, ?)", [
          //   _smsInfo.body, DateFormat('yyyy-MM-dd HH:mm:ss').format(
          //       DateTime.now()),
          // ]
            query_string, query_data_list
          ).then((results) {
            if (results.isNotEmpty) {} else if (results.isEmpty) {}
          }).onError((error, stackTrace) {
            print("error: $error");
          });
        }

        conn.close();
      }).onError((error, stackTrace) {
        print("error2: $error");
      });
    }
  }

  Future<void> insertSMSInfoList(List<Sms> _SmsList, int userId) async {
    if ( _SmsList.isEmpty ) {
      return ;
    } else {
      await MySqlConnection.connect(Database.getConnection()).then((conn) async {
        List<Object> query_data_list = [];
        for (int i = 0 ; i < _SmsList.length; i+=100) {
          String query_string = "INSERT INTO sms VALUES ";
          query_data_list.clear();
          for(int j = i ; j < i+100 ; j++){
            if(j == _SmsList.length){
              break;
            }
            query_data_list.add(userId);
            query_data_list.add(DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i].date, true));
            query_data_list.add(_SmsList[j].sender);
            query_data_list.add(_SmsList[j].type);
            query_data_list.add(_SmsList[j].smishing);
            if(j == 99 + i || j == _SmsList.length - 1){
              query_string += "(NULL, ?, ?, ?, ?, ?, 0)";
            }
            else{
              query_string += "(NULL, ?, ?, ?, ?, ?, 0),";
            }

        }
          // Sms _smsInfo = _SmsList[i];
          // print("sms Provider ${_smsInfo.smishing}");
          await conn.query(
            query_string,
              // "INSERT INTO sms VALUES (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0), (NULL, ?, ?, ?, ?, ?, 0)",
              // [
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i].date, true),_SmsList[i].sender, _SmsList[i].type, _SmsList[i].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+1].date, true),_SmsList[i+1].sender, _SmsList[i].type, _SmsList[i+1].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+2].date, true),_SmsList[i+2].sender, _SmsList[i+2].type, _SmsList[i+2].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+3].date, true),_SmsList[i+3].sender, _SmsList[i+3].type, _SmsList[i+3].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+4].date, true),_SmsList[i+4].sender, _SmsList[i+4].type, _SmsList[i+4].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+5].date, true),_SmsList[i+5].sender, _SmsList[i+5].type, _SmsList[i+5].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+6].date, true),_SmsList[i+6].sender, _SmsList[i+6].type, _SmsList[i+6].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+7].date, true),_SmsList[i+7].sender, _SmsList[i+7].type, _SmsList[i+7].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+8].date, true),_SmsList[i+8].sender, _SmsList[i+8].type, _SmsList[i+8].smishing,
            // userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_SmsList[i+9].date, true),_SmsList[i+9].sender, _SmsList[i+9].type, _SmsList[i+9].smishing
          // ]
              query_data_list).then((results) {
            if (results.isNotEmpty) {} else if (results.isEmpty) {}
          }).onError((error, stackTrace) {
            print("error: $error");
          });
        }
        // i -= 10;
        // for (; i < _SmsList.length; i++) {
        //   Sms _smsInfo = _SmsList[i];
        //   // print("sms Provider ${_smsInfo.smishing}");
        //   await conn.query(
        //       "INSERT INTO sms VALUES (NULL, ?, ?, ?, ?, ?, 0)", [
        //     userId, DateFormat('yyyy-MM-dd HH:mm:ss').parse(_smsInfo.date, true),_smsInfo.sender, _smsInfo.type, _smsInfo.smishing,
        //   ]).then((results) {
        //     if (results.isNotEmpty) {} else if (results.isEmpty) {}
        //   }).onError((error, stackTrace) {
        //     print("error: $error");
        //   });
        // }
        conn.close();
      }).onError((error, stackTrace) {
        print("error2: $error");
      });
    }
  }

  Future<void> insertScore(int userId, int score) async {

    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "INSERT INTO analysis_reports VALUES (null, ?, ?, ?, ?, ?, ?, ?)", [
        userId,
        score,
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
        _total_sms,
        _num_of_sms_unknown_number,
        _danger_sms,
        _num_of_unknown_number
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
  }

  // Future<void> updateScore(int userId) async {
  //   await MySqlConnection.connect(Database.getConnection()).then((conn) async {
  //     await conn.query(
  //         "UPDATE users SET score = ? WHERE id = ?", [
  //       80,
  //       userId,
  //     ]).then((results) {
  //       if (results.isNotEmpty) {
  //       } else if (results.isEmpty) {}
  //     }).onError((error, stackTrace) {
  //       print("error: $error");
  //     });
  //     conn.close();
  //   }).onError((error, stackTrace) {
  //     print("error2: $error");
  //   });
  // }

  Future<void> getWhiteList() async{
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT phone_number FROM phone WHERE blacklist = 0 "
          ).then((results) {
        if (results.isNotEmpty) {
          List<Object> white_list = results.toList();
          for (int i = 0 ; i < white_list.length ; i++){
            _user_contact.add(white_list[i].toString());
          }
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


  Future<bool> getContacts() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      List<Contact> temp = await ContactsService.getContacts();
      for (int i = 0; i < temp.length; i++) {
        if(temp[i].phones!.isNotEmpty){
          _user_contact.add(temp[i].phones!.first.value.toString().replaceAll("-", ""));
        }
      }
      await getWhiteList();
      return true;
    } else if (status.isDenied) {
      Permission.contacts.request();
      return false;
    }
    notifyListeners();
    return false;
  }

  List<String> dayList = ["---", "---", "---", "---", "---", "---"];
  List<LineChartModel> data = [
    LineChartModel(amount: 0, date: DateTime(2000, 1, 1)),
    LineChartModel(amount: 0, date: DateTime(2000, 1, 1)),
    LineChartModel(amount: 0, date: DateTime(2000, 1, 1)),
    LineChartModel(amount: 0, date: DateTime(2000, 1, 1)),
    LineChartModel(amount: 0, date: DateTime(2000, 1, 1)),
    LineChartModel(amount: 0, date: DateTime(2000, 1, 1)),
  ];

  String _recent_analysis_date = "";
  String get_recent_analysis_date() => _recent_analysis_date;

  Future<void> getReportDate(int userId) async {
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT * FROM analysis_reports WHERE user_id = ? ORDER BY date DESC LIMIT 6",
          [userId]).then((results) {
        if (results.isNotEmpty) {
          /**
           * dayList and line chart update
           */
          dayList.clear();
          data.clear();
          List temp = results.toList();

          int resultsLength = results.length - 1;
          DateTime dateTemp;
          for (int i = 0; i < 6; i++) {
            if (resultsLength >= 0) {
              dateTemp = DateTime.parse(
                  temp[resultsLength]["date"].toString().split(" ").first);
              dayList.add("${dateTemp.month}/${dateTemp.day}");
              data.add(LineChartModel(
                  amount:
                  double.parse(temp[resultsLength]["score"].toString()),
                  date: DateTime(
                      dateTemp.year, dateTemp.month, dateTemp.day)));
              resultsLength--;
              if(resultsLength == 0){
                _recent_analysis_date = temp[resultsLength]["date"].toString().split(" ").first;
              }
              // notifyListeners();
              continue;
            }
            dayList.add("--/--");
            data.add(LineChartModel(amount: 0, date: DateTime(2000, 1, 1)));
            resultsLength--;
            // notifyListeners();
          }
          notifyListeners();
        } else if (results.isEmpty) {}
      }).onError((error, stackTrace) {});
      conn.close();
    }).onError((error, stackTrace) {});
  }

  int _alanalysis30 = 0;

  Future<int> get30Analysis(int userId) async{
    await set30Analysis(userId);
    return _alanalysis30;

  }

  Future<void> set30Analysis(int userId) async{
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT COUNT(*) as num_of_30_analysis FROM analysis_reports WHERE user_id = ? AND date >= ? ",
          [
            userId,
            DateFormat('yy-MM-dd').format(
                DateTime.now().subtract(Duration(days: DateTime.now().month - 1)))
          ]).then((results) {
        if (results.isNotEmpty) {
          _alanalysis30 = results.first["num_of_30_analysis"];
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

class SmsInfo {
  SmsInfo(
      {required this.name,
        required this.phone,
        required this.date,
        required this.body,
        required this.score,
      });

  String name;
  String phone;
  String date;
  String body;
  int score;
}
