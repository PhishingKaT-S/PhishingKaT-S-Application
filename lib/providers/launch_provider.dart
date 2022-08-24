import 'dart:ffi';

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
  Future<bool> Init() async {
    bool signUp = true;
    await request_permission();
    //getMessage();
    //getContacts();
    userInfo = UserInfo(
        imei: await getIMEI() as String,
        phoneNumber: await getPhoneNumber() as String);
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async => {
              await conn
                  .query(
                      "SELECT nickname FROM users WHERE IMEI = ? AND phone_number = ?",
                      [userInfo.imei, userInfo.phoneNumber])
                  .then((results) => {
                        if (results.isNotEmpty)
                          {
                            if (results.length > 1)
                              {
                                //  동일한 IMEI와 핸드폰 번호가 있으면 2개 이상이 나오는데 그 때는 우짜나?
                              }
                            else
                              {
                                userInfo.uerId = results.first["id"],
                                userInfo.analysisDate =
                                    results.first["analysis_date"],
                                userInfo.gender = results.first["gender"],
                                userInfo.profession =
                                    results.first["profession"],
                                userInfo.year = results.first["year"],
                                userInfo.nickname = results.first["nickname"],
                                userInfo.updateDate =
                                    results.first["update_date"]
                              }
                          }
                        else if (results.isEmpty)
                          {signUp = false}
                      })
                  .onError((error, stackTrace) => {}
                  ),
              conn.close(),
            })
        .onError((error, stackTrace) => {
    });
    //print("imei: " + userInfo.imei + "\nnumber: " + userInfo.number);

    return signUp;
  }

  late UserInfo userInfo;

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

  Future getUserInfo() async {
    var conn = await MySqlConnection.connect(Database.getConnection());
    var results = await conn.query(
        'SELECT * FROM users WHERE IMEI == ? AND phone_number = ?',
        [userInfo.imei, userInfo.phoneNumber]);
    conn.close();
    return results;
  }

  Future getPhoneNumber() async {
    var status = await Permission.contacts.status;
    String number = '';
    if (status.isGranted) {
      number = (await MobileNumber.mobileNumber) as String;
      number = number.replaceFirst('82', '');
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
                      [userInfo.uerId])
                  .then((results) =>
                      {if (results.isNotEmpty) {} else if (results.isEmpty) {}})
                  .onError((error, stackTrace) => {}),
              conn.close(),
            })
        .onError((error, stackTrace) => {});
  }
}

class SmsData {
  SmsData({required this.sms});

  String sms;
}

class UserInfo {
  UserInfo({required this.imei, required this.phoneNumber});

  String imei;
  String phoneNumber;
  String? uerId;
  String? nickname;
  String? year;
  String? gender;
  String? profession;
  DateTime? analysisDate;
  DateTime? updateDate;
}
