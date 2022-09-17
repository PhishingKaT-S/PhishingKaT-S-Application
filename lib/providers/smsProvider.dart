import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db_conn.dart';
import 'launch_provider.dart';

class SmsProvider with ChangeNotifier{
  late List<SmsInfo> _smsList;
  List<String> _user_contact = [];


  SmsProvider(){
    _smsList = [];
  }

  void setSmsToSmsProvider(List smsList){
    _smsList = [];
    if(smsList[0] == "Error"){
      return ;
    }
    _smsList.clear();

    for(int i = 0 ; i < smsList.length ; i++){
      List temp = smsList[i].toString().split("[sms_text]");
      _smsList.add(SmsInfo(name: temp[0], phone: temp[1], date: temp[2], body: temp[3]));
    }
    notifyListeners();
    //_makeScore();
  }

  // Future<int> _makeScore() async{
  //   if(await getContacts()){
  //     for(int i = 0; i < _smsList.length ; i++){
  //       if()
  //     }
  //   }
  //
  // }


  int getSmsLength(){
    return _smsList.length;
  }

  Future<bool> getContacts() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      var temp = await ContactsService.getContacts();
      for (int i = 0; i < temp.length; i++) {
        print("phone number: ");
        _user_contact.add(temp[i].phones!.first.value.toString());
      }
      return true;
    } else if (status.isDenied) {
      Permission.contacts.request();
      return false;
    }
    return false;

  }
}

class SmsInfo{
  SmsInfo({required this.name, required this.phone, required this.date, required this.body});
  String name;
  String phone;
  String date;
  String body;
}