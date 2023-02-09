import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:mysql1/mysql1.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../db_conn.dart';

class LaunchProvider extends ChangeNotifier {
  int _signUp = 0;
  UserInfo _userInfo = UserInfo();
  final platform = const MethodChannel("phishingkat.flutter.android");
  final platform2 = const MethodChannel("onestore");
  LaunchProvider(){
    //Init();
  }

  Future<String> getSdkVersion() async{
    return await DeviceInformation.platformVersion;
  }

  Future<int> Init() async {
    _signUp = 0;
    // await Future.delayed(const Duration(milliseconds: 500));

    await request_permission();
    //getMessage();
    //getContacts();
    String sdkVersion = await getSdkVersion();
    int androidSdkVersion = int.parse(sdkVersion.split(' ')[1]);
    if(androidSdkVersion > 11){
      _userInfo.imei = await getSSAID();
    }
    else{
      _userInfo.imei = await getIMEI() as String;
    }
    _userInfo.phoneNumber = await getPhoneNumber() as String;
    String _error_msg = "";

    print("imei: ${_userInfo.imei}");
    print("phonenumber: ${_userInfo.phoneNumber}");
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT * FROM users WHERE IMEI = ? AND phone_number = ?",
          [_userInfo.imei, _userInfo.phoneNumber]).then((results) {
        if (results.isNotEmpty) {
          if (results.length == 1) {
            _signUp = 1;
            _error_msg = "success";
            _userInfo.userId = results.first["id"];
            //_userInfo.analysisDate = results.first["analysis_date"];
            _userInfo.gender = (results.first["gender"] == "1") ? true : false;
            _userInfo.profession = results.first["profession"];
            _userInfo.year = results.first["year"];
            _userInfo.nickname = results.first["nickname"];
            //_userInfo.updateDate = results.first["update_date"];
            _userInfo.score = results.first["score"];

            notifyListeners();
          }
          else{
            _error_msg = "not success";
          }
        } else if (results.isEmpty) {
          _signUp = 0;
          notifyListeners();
        }
      }).onError((error, stackTrace) {
        _signUp = -1;
        _error_msg = error.toString();
        print("error: $error");
      });
      conn.close();
    }).onError((error, stackTrace) {
      _error_msg = error.toString();
      _signUp = -1;
      print("error2: $error");
    });
    notifyListeners();
    return _signUp ;
  }

  UserInfo getUserInfo(){
    return _userInfo;
  }

  int getSignUp() {
    return _signUp;
  }

  void setSignUp(int signUp) {

    _signUp = signUp;
    // notifyListeners();


  }

  bool _load_flag = false;
  bool get_load_flag() => _load_flag;
  void set_load_flag(bool new_value){
    _load_flag = new_value;
    notifyListeners();
  }

  Future<String> getSSAID() async{
    String ssaid = "";
    try{
      ssaid = await platform2.invokeMethod('getSSAID');
      print("launch_provider: SSAID: $ssaid");
    } on PlatformException catch (e){
      log("ERROR $e");
    }
    return ssaid;
  }

  void setScore(int score){
    _userInfo.score = score;
    notifyListeners();
    MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "UPDATE users SET score = ? WHERE id = ?;",
          [
            score,
            _userInfo.userId
          ]).then((results) {
        if (results.isNotEmpty) {

        } else if (results.isEmpty) {
        }
      }).onError((error, stackTrace) {
        _signUp = -1;
        print("error: $error");
      });
      conn.close();
    }).onError((error, stackTrace) {
      print("error2: $error");
    });
    // _userInfo.score = score;
    // notifyListeners();
  }

  void setUpdate(){
    MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "INSERT INTO users (update_date) SELECT ? where id = ?",
          [
            DateFormat('yyyy-MM-dd').format(
                DateTime.now()),
            _userInfo.userId
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
    //_userInfo.updateDate = DateTime.now();
    notifyListeners();
  }

  Future getMessage() async {
    var sms_permission = await Permission.sms.status;
    if (sms_permission.isGranted) {
      SmsQuery _query = SmsQuery();
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
        // address: '+254712345789',
        count: 100,
      );
      for (int i = 0; i < messages.length; i++) {
        print('$i :sms inbox messages: ${messages[i].body}');
      }
    } else {
      await Permission.sms.request();
    }
  }

  Future getIMEI() async {
    var phone_permission = await Permission.phone.status;
    if (phone_permission.isGranted) {
      String? identifier = await DeviceInformation.deviceIMEINumber;
      return identifier;
    } else {
      await Permission.phone.request();
      phone_permission = await Permission.phone.status;
      if (phone_permission.isGranted) {
        String? identifier = await DeviceInformation.deviceIMEINumber;
        return identifier;
      } else {
        await Permission.phone.request();
        String? identifier = await DeviceInformation.deviceIMEINumber;
        return identifier;
      }
    }
  }

  Future getContacts() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      var contacts = await ContactsService.getContacts();
      for (int i = 0; i < contacts.length; i++) {
        print("phone number: ");
        print(contacts[i].phones!.first.value);
      }
    } else if (status.isDenied) {
      Permission.contacts.request();
    }
  }

  Future request_permission() async {
    await [
      Permission.contacts,
      Permission.phone,
      Permission.sms,
    ].request();
    _showActivity();
  }
  @override
  Future<void> _showActivity() async{
    try{
      await platform.invokeMethod('showActivity');
    } on PlatformException catch (e){
      log("ERROR $e");
    }
  }

  Future getPhoneNumber() async {
    var status = await Permission.contacts.status;
    String number = '';
    if (status.isGranted) {
      number = (await MobileNumber.mobileNumber) as String;
      RegExp re = RegExp(r'[82\+82|\+82|82]+0?') ;
      final match = re.firstMatch(number)?.group(0);
      number = number.replaceFirst(match!, '0') ;

    } else if (status.isDenied) {
      await Permission.contacts.request();
      status = await Permission.contacts.status;
      if (status.isGranted) {
        number = (await MobileNumber.mobileNumber) as String;
        RegExp re = RegExp(r'[82\+82|\+82|82]+0?') ;
        final match = re.firstMatch(number)?.group(0);
        number = number.replaceFirst(match!, '0') ;

      } else if (status.isDenied) {
        await Permission.contacts.request();
        number = (await MobileNumber.mobileNumber) as String;
        RegExp re = RegExp(r'[82\+82|\+82|82]+0?') ;
        final match = re.firstMatch(number)?.group(0);
        number = number.replaceFirst(match!, '0') ;
      }
    }
    return number;
  }

  Future _getDateInfo() async {
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async => {
      await conn
          .query("SELECT * FROM attendance WHERE user_id = ?",
          [_userInfo.userId])
          .then((results) =>
      {if (results.isNotEmpty) {} else if (results.isEmpty) {}})
          .onError((error, stackTrace) => {}),
      conn.close(),
    })
        .onError((error, stackTrace) => {});
  }

  void set_userinfo(String nickname, String year, bool gender, String profession){
    _userInfo.nickname = nickname;
    _userInfo.year = year;
    _userInfo.gender = gender;
    _userInfo.profession = profession;
  }

  Future updateAnalysisDate(int userId) async {
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "UPDATE users SET analysis_date=now() WHERE users.id=?", [
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
}


class UserInfo {
  // UserInfo({this.imei = "", this.phoneNumber = ""});

  String imei = "";
  String phoneNumber = "";
  int userId = 0;
  String nickname = "";
  String year = "";
  bool gender = true;
  String profession = "";
  DateTime analysisDate = DateTime.now();
  DateTime updateDate = DateTime.now();
  int score = -1;
}