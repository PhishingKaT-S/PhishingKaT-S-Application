import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../db_conn.dart';
import 'launch_provider.dart';

class SmsProvider with ChangeNotifier {
  late List<SmsInfo> _smsList;
  List<String> _user_contact = [];
  int _unknown_number = 0;
  int _danger_sms = 0;

  SmsProvider() {
    _smsList = [];
    getContacts();
  }

  void setSmsToSmsProvider(List smsList) {
    _smsList = [];
    if (smsList[0] == "Error") {
      return;
    }
    _smsList.clear();

    for (int i = 0; i < smsList.length; i++) {
      List temp = smsList[i].toString().split("[sms_text]");
      _smsList.add(
          SmsInfo(name: temp[0], phone: temp[1], date: temp[2], body: temp[3]));
      if(_user_contact.contains(temp[1])){
        _unknown_number++;
      }
    }
    notifyListeners();
    //_makeScore();
  }

  Future<void> insertScore(int userId) async {
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "INSERT INTO analysis_reports VALUES (null, ?, ?, ?, ?, ?, ?)", [
        userId,
        80,
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
        _smsList.length,
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

  // Future<int> _makeScore() async{
  //   if(await getContacts()){
  //     for(int i = 0; i < _smsList.length ; i++){
  //       if()
  //     }
  //   }
  //
  // }

  int getSmsLength() {
    return _smsList.length;
  }

  Future<bool> getContacts() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      List<Contact> temp = await ContactsService.getContacts();
      for (int i = 0; i < temp.length; i++) {
        if(temp[i].phones!.isNotEmpty){
          _user_contact.add(temp[i].phones!.first.value.toString());
        }
      }
      return true;
    } else if (status.isDenied) {
      Permission.contacts.request();
      return false;
    }
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

          int results_length = results.length - 1;
          DateTime date_temp;
          for (int i = 0; i < 6; i++) {
            if (results_length >= 0) {
              date_temp = DateTime.parse(
                  temp[results_length]["date"].toString().split(" ").first);
              dayList.add("${date_temp.month}/${date_temp.day}");
              data.add(LineChartModel(
                  amount:
                  double.parse(temp[results_length]["score"].toString()),
                  date: DateTime(
                      date_temp.year, date_temp.month, date_temp.day)));
              results_length--;
              continue;
            }
            dayList.add("--/--");
            data.add(LineChartModel(amount: 0, date: DateTime(2000, 1, 1)));
            results_length--;
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
        required this.body});

  String name;
  String phone;
  String date;
  String body;
}
