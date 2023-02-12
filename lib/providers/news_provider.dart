import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';

import '../db_conn.dart';

class NewsProvider extends ChangeNotifier {
  List<String> _news = [" "];

  List<String> getNewsContent() => _news;

  NewsProvider(){
    _getNews();
  }

  Future<void> _getNews() async{
    await MySqlConnection.connect(Database.getConnection()).then((conn) async {
      await conn.query(
          "SELECT * FROM tb_news ORDER BY NEWS_DATE DESC LIMIT 3").then((results) {
        if (results.isNotEmpty) {
          _news.clear();
          List temp = results.toList();
          for(int i =0 ; i < 3 ; i++){
            print(temp[i]["NEWS_TITLE"].toString());
            _news.add(temp[i]["NEWS_TITLE"].toString().replaceFirst("[관련기사] ", ""));
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