import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import '../db_conn.dart';
import 'launch_provider.dart';

class SmsProvider with ChangeNotifier{
  late List<SmsInfo> _smsList;

  SmsProvider(){
    _smsList = [];
  }

  void setSmsToSmsProvider(List smsList){
    _smsList = [];
    if(smsList[0] == "Error"){
      return ;
    }
    for(int i = 0 ; i < smsList.length ; i++){
      List temp = smsList[i].toString().split("[sms_text]");
      _smsList.add(SmsInfo(name: temp[0], phone: temp[1], date: temp[2], body: temp[3]));
    }
    notifyListeners();
  }

  int getSmsLength(){
    return _smsList.length;
  }
}

class SmsInfo{
  SmsInfo({required this.name, required this.phone, required this.date, required this.body});
  String name;
  String phone;
  String date;
  String body;
}