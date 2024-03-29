import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'Sms.dart';

const String tableName = 'SmsData';

class DBHelper {

  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  late Database _database ;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'sms.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            sender TEXT,
            text TEXT,
            date TEXT, 
            type INTEGER, 
            prediction INTEGER, 
            smishing INTEGER
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  insertSMS(List<Sms> smsList) async {
    final db = await database;
    // var res = await db.rawInsert('INSERT INTO $tableName(id, sender, text, date, type, prediction, smishing) VALUES(?, ?, ?, ?, ?, ?, ?)',
    //     [sms.id, sms.sender, sms.text, sms.date, sms.type, sms.prediction, sms.smishing]);
    bool result = false;
    List<Object> query_data_list = [];
    for (int i = 0 ; i < smsList.length; i+=100) {
      String query_string = "INSERT INTO $tableName(id, sender, text, date, type, prediction, smishing) VALUES ";
      query_data_list.clear();
      for(int j = i ; j < i+100 ; j++){
        if(j == smsList.length){
          break;
        }
        query_data_list.add(smsList[j].id);
        query_data_list.add(smsList[j].sender);
        query_data_list.add(smsList[j].text);
        query_data_list.add(smsList[j].date);
        query_data_list.add(smsList[j].type);
        query_data_list.add(smsList[j].prediction);
        query_data_list.add(smsList[j].smishing);
        // query_data_list.add(DateFormat('yyyy-MM-dd HH:mm:ss').parse(smsList[i].date, true));

        if(j == 99 + i || j == smsList.length - 1){
          query_string += "(?, ?, ?, ?, ?, ?, ?)";
        }
        else{
          query_string += "(?, ?, ?, ?, ?, ?, ?),";
        }

      }
      print("LENGTH: " + query_data_list.length.toString()) ;
      var res = await db.rawInsert(query_string, query_data_list) ;
      if ( res == 0 ) {
        print("sms.db 데이터 삽입 문제");
        result = true ;
      } else {
        print("sms.db 데이터 삽입 성공");
      }
      // await conn.query(
      //   //     "INSERT INTO smsData VALUES (NULL, ?, ?)", [
      //   //   _smsInfo.body, DateFormat('yyyy-MM-dd HH:mm:ss').format(
      //   //       DateTime.now()),
      //   // ]
      //     query_string, query_data_list
      // ).then((results) {
      //   if (results.isNotEmpty) {} else if (results.isEmpty) {}
      // }).onError((error, stackTrace) {
      //   print("error: $error");
      // });
    }

    return result;
  }

  //Read
  getSMS(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    Map<String, Object?> s = res.first ;
    return res.isNotEmpty ? Sms(id: int.parse(s['id'].toString()), sender: s['sender'].toString(), text: s['text'].toString(), date: s['date'].toString(),
                                type: int.parse(s['type'].toString()), prediction: int.parse(s['prediction'].toString()), smishing: int.parse(s['smishing'].toString())) : null;
  }

  //Read All
  Future<List<Sms>> getAllSMS() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName');
    List<Sms> list = res.isNotEmpty ? res.map((c) => Sms(id:int.parse(c['id'].toString()), sender: c['sender'].toString(), text:c['text'].toString(), date: c['date'].toString(),
                                                        type: int.parse(c['type'].toString()), prediction: int.parse(c['prediction'].toString()),
                                                        smishing: int.parse(c['smishing'].toString()))).toList() : [];

    return list;
  }

  Future<List<Sms>> getAllSMSFreq() async { // 지원 추가
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName as c, (select sender, count(*) as cnt from $tableName group by sender order by cnt desc) as b where c.sender = b.sender order by cnt desc');
    List<Sms> list = res.isNotEmpty ? res.map((c) => Sms(id:int.parse(c['id'].toString()), sender: c['sender'].toString(), text:c['text'].toString(), date: c['date'].toString(),
        type: int.parse(c['type'].toString()), prediction: int.parse(c['prediction'].toString()),
        smishing: int.parse(c['smishing'].toString()))).toList() : [];

    return list;
  }

  //Delete
  deleteSMS(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllSMS() async {
    final db = await database;
    db.rawDelete('DELETE FROM $tableName');
  }

  updateSMS(int _id, int _type) async{ //지원 추가
    final db = await database;
    db.rawUpdate('UPDATE $tableName SET type = ? where id= ?', [_type, _id]);
  }

  checkTable() async{
    final db = await database;
    db.rawQuery('select count(*) from sqlite_master Where Name = $tableName');
  }
}