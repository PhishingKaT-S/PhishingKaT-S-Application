/**
 * writer: 유이새
 * Date: 2022.08.31
 * Description: webview
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../Theme.dart';
import '../db_conn.dart';
import '../kat_widget/kat_appbar_back.dart';

class NewsWebView extends StatefulWidget {
  const NewsWebView({Key? key}) : super(key: key);

  @override
  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  late List<News> _newsList = [];

  List<bool> _isSelected = [true, false, false] ;

  @override
  void initState() {
    super.initState();
    () async {
      List<News> data = await _getNewsData() ;
      if ( data == null ) {
        print("Cannot get the data") ;
      }

      setState(() {
        _newsList = data ;
      });
    } ();
  }

  Future<List<News>> _getNewsData() async {
    List<News> _newsInfoList = [] ;
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async {
      await conn.query("SELECT * FROM news ORDER BY news_date DESC LIMIT 3")
          .then((results) {
        if ( results.isNotEmpty ) {
          for ( var res in results )  {
            DateTime _date = res['news_date'] as DateTime ;
            News _news = News(title: res['title'], content: res['content'],
                              news_date: '${_date.year}.${_date.month}.${_date.day}',
                              num_of_chat: res['num_of_chat'] as int,
                              url: res['url']) ;

            _newsInfoList.add(_news) ;
          }
        } else {
          print("No data") ;
          return null;
        }
      }).onError((error, stackTrace) {
        return null ;
      });
      conn.close();
    }).onError((error, stackTrace) {
      /// 네트워크 에러 처리

    });
    return _newsInfoList ;
  }

  Widget _headerView() {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          /// BACKGROUND
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Image.asset('assets/images/phishing_news_background.png', fit: BoxFit.fill,),
          ),

          /// TITLE
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text((_newsList.isNotEmpty) ? _newsList[0].title : '', style: const TextStyle(fontSize: 17, color: AppTheme.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                InkWell(
                  onTap: () { },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xCC000000),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) => KaTWebView(title: '피싱 뉴스', url: _newsList[0].url))) ;
                        },
                        child: const Text('바로 가기', style: TextStyle(color: AppTheme.white, fontSize: 12), textAlign: TextAlign.center,),
                      ),
                    )
                  )
                )
              ],
            )
          ),

          /// Bottom (DAY, WEEK, MONTH)
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
            child: Opacity(
              opacity: 0.3,
              child: Container(
                color: Color(0xCC000000),
              )
            )
          ),

          Container(
              height: MediaQuery.of(context).size.height * 0.07,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          _isSelected[0] = true ; _isSelected[1] = false; _isSelected[2] = false;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 3, // space between underline and text
                          ),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: (_isSelected[0]) ? Colors.white : AppTheme.greyText,  // Text colour here
                                width: 1.0, // Underline width
                              ))
                          ),
                          child: Text('DAY', style: TextStyle(fontSize: 17, color: (_isSelected[0]) ? AppTheme.white : AppTheme.greyText, fontWeight: FontWeight.bold))
                      )
                  ),
                ],
              )
          ),
        ],
      )
    );
  }

  Widget _newsInfoList() {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: List.generate(_newsList.length, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => KaTWebView(title: '피싱 뉴스', url: _newsList[index].url))) ;
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(_newsList[index].title, style: AppTheme.subtitle, overflow: TextOverflow.clip,),
                      ),

                      Container(
                        height: 50,
                        child: Text(_newsList[index].content, overflow: TextOverflow.clip,),
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        height: 20,
                        child: Text(_newsList[index].news_date, style: AppTheme.caption, overflow: TextOverflow.ellipsis,),
                      ),

                      Container(
                        height: 20,
                        child: Row(
                          children: [
                            Icon(Icons.chat, size: 15,),
                            Padding(padding: EdgeInsets.only(left: 5),),
                            Text(_newsList[index].num_of_chat.toString(), style: AppTheme.caption,),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        color: AppTheme.whiteGrey,
                      )
                    ]
                )
            )
          );
        })
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('피싱 뉴스', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.blueText),),
          backgroundColor: AppTheme.blueBackground,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerView(),
              _newsInfoList(),
            ],
          ),
        )
    );
  }
}

class News {
  String title = "" ;
  String content = "" ;
  String news_date = "" ;
  int num_of_chat = 0 ;
  String url ;

  News({required this.title, required this.content, required this.news_date, required this.num_of_chat, required this.url}) ;
}