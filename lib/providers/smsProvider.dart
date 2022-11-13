import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../db_conn.dart';
import 'launch_provider.dart';
import 'dart:math';

class SmsProvider with ChangeNotifier {
  late List<SmsInfo> _smsList;
  List<String> _user_contact = [];
  int _total_sms = 0;
  int _unknown_number = 0;
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
  int getUnknownSms() => _unknown_number;
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
          _unknown_number = results.first["unknown_phone_sms"];
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
    _unknown_number = 0;
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
        if(_user_contact[j].compareTo(temp[1]) == 0){
          UnknownNumbers = false;
          break;
        }
        else{
          continue;
        }
      }
      if(UnknownNumbers){
        _unknown_number++;
        _smsList.add(
            SmsInfo(name: temp[0], phone: temp[1], date: temp[2], body: temp[3], score: 0));
      }
    }
    notifyListeners();
    //_makeScore();
  }

  List<SmsInfo> getUnknownSmsList() => _smsList;

  Future<void> insertSMSList(List<SmsInfo> _unknownSmsList) async {
    if ( _unknownSmsList.isEmpty ) {
      return ;
    } else {
      await MySqlConnection.connect(Database.getConnection()).then((conn) async {
        for (int i = 0 ; i < _unknownSmsList.length; i++) {
          SmsInfo _smsInfo = _unknownSmsList[i];
          await conn.query(
              "INSERT INTO smsData VALUES (NULL, ?)", [
            _smsInfo.body
          ]).then((results) {
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

  Future<void> insertScore(int userId) async {
    Random random_num = Random.secure();

    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "INSERT INTO analysis_reports VALUES (null, ?, ?, ?, ?, ?, ?)", [
        userId,
        random_num.nextInt(100),
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
        _total_sms,
        _unknown_number,
        _danger_sms
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

  Future<void> updateScore(int userId) async {
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "UPDATE users SET score = ? WHERE id = ?", [
        80,
        userId,
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

  Future<bool> getContacts() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      List<Contact> temp = await ContactsService.getContacts();
      for (int i = 0; i < temp.length; i++) {
        if(temp[i].phones!.isNotEmpty){
          _user_contact.add(temp[i].phones!.first.value.toString().replaceAll("-", ""));
        }
      }
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
              notifyListeners();
              continue;
            }
            dayList.add("--/--");
            data.add(LineChartModel(amount: 0, date: DateTime(2000, 1, 1)));
            resultsLength--;
            notifyListeners();
          }
          notifyListeners();
        } else if (results.isEmpty) {}
      }).onError((error, stackTrace) {});
      conn.close();
    }).onError((error, stackTrace) {});
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
