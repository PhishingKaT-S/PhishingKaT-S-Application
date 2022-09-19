import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';

import '../db_conn.dart';

class NewsProvider extends ChangeNotifier {
  List<String> _news = [];

  List<String> getNewsContent() => _news;

  NewsProvider(){
    getNews();
  }

  Future<void> getNews() async{
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT * FROM news ORDER BY news_date DESC LIMIT 3").then((results) {
        if (results.isNotEmpty) {
          _news.clear();
          List temp = results.toList();
          for(int i =0 ; i < 3 ; i++){
            _news.add(temp[i]["content"]);
          }
          notifyListeners();
        }
        else if (results.isEmpty) {
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