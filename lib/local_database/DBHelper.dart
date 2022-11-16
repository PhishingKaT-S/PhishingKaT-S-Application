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
    if ( _database.isOpen ) return _database ;
    _database = await initDB();
    return _database;
  }

  initDB() async {
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

  insertSMS(Sms sms) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $tableName(id, sender, text, date, type, prediction, smishing) VALUES(?, ?, ?, ?, ?, ?, ?)',
                                [sms.id, sms.sender, sms.text, sms.date, sms.type, sms.prediction, sms.smishing]);
    return res;
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
}