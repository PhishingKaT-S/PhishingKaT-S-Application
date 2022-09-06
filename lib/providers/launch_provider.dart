
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
  bool _signUp = false;
  LaunchProvider(){
    Init();
  }

  Future Init() async {
    _signUp = false;

    await request_permission();
    //getMessage();
    //getContacts();
    _userInfo.imei = await getIMEI() as String;
    _userInfo.phoneNumber = await getPhoneNumber() as String;

    print("imei: ${_userInfo.imei}");
    print("phonenumber: ${_userInfo.phoneNumber}");
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT * FROM users WHERE IMEI = ? AND phone_number = ?",
          [_userInfo.imei, _userInfo.phoneNumber]).then((results) {
            print("results: $results") ;
        if (results.isNotEmpty) {
          if (results.length > 1) {
            //  동일한 IMEI와 핸드폰 번호가 있으면 2개 이상이 나오는데 그 때는 우짜나?
            _signUp = false;
          } else {
            _userInfo.userId = results.first["id"];
            _userInfo.analysisDate = results.first["analysis_date"];
            _userInfo.gender = (results.first["gender"] == "1") ? true : false;
            _userInfo.profession = results.first["profession"];
            _userInfo.year = results.first["year"];
            _userInfo.nickname = results.first["nickname"];
            _userInfo.updateDate = results.first["update_date"];
            _signUp = true;
            notifyListeners();
          }
        } else if (results.isEmpty) {
          _signUp = false;
          notifyListeners();
        }
      }).onError((error, stackTrace) {
        print("error: $error");
      });
      conn.close();
    }).onError((error, stackTrace) {
      print("error2: $error");
    });
    notifyListeners();
    return _signUp ;
  }

  UserInfo _userInfo = UserInfo();
  UserInfo getUserInfo(){
    return _userInfo;
  }

  bool getSignUp() {
    return _signUp;
  }

  void setSignUp(bool signUp) {

    _signUp = signUp;
    // notifyListeners();
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
      String? identifier = await UniqueIdentifier.serial;
      return identifier;
    } else {
      await Permission.phone.request();
      return 0;
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

  Future getPhoneInfo() async {
    var status_permission = await Permission.phone.status;
    if (status_permission.isGranted) {
      try {
        final platformVersion = await DeviceInformation.platformVersion;
        final imeiNo = await DeviceInformation.deviceIMEINumber;
        final modelName = await DeviceInformation.deviceModel;
        final manufacturer = await DeviceInformation.deviceManufacturer;
        final apiLevel = await DeviceInformation.apiLevel;
        final deviceName = await DeviceInformation.deviceName;
        final productName = await DeviceInformation.productName;
        final cpuType = await DeviceInformation.cpuName;
        final hardware = await DeviceInformation.hardware;

        print("platformVersion: " + platformVersion);
        print("IMEI: " + imeiNo);
        print("modelName: " + modelName);
        print("manufacturer: " + manufacturer);
        //print("apiLevel: "+apiLevel);
        print("deviceName: " + deviceName);
        print("productName: " + productName);
        print("cpuType: " + cpuType);
        print("hardware: " + hardware);
      } on PlatformException {
        final platformVersion = "Failed to get platform version";
        print(platformVersion);
      }
    }
  }

  Future request_permission() async {
    await [
      Permission.contacts,
      Permission.phone,
      Permission.sms,
    ].request();
  }

  // Future getUserInfo() async {
  //   var conn = await MySqlConnection.connect(Database.getConnection());
  //   var results = await conn.query(
  //       'SELECT * FROM users WHERE IMEI == ? AND phone_number = ?',
  //       [userInfo?.imei, userInfo?.phoneNumber]);
  //   conn.close();
  //   return results;
  // }

  Future getPhoneNumber() async {
    var status = await Permission.contacts.status;
    String number = '';
    if (status.isGranted) {
      number = (await MobileNumber.mobileNumber) as String;
      number = number.substring(number.length-11);
      if(number[0] == '2'){
        number.replaceRange(0, 0, "0");
      }
    } else if (status.isDenied) {
      Permission.contacts.request();
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
}

class SmsData {
  SmsData({required this.sms});

  String sms;
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
}
