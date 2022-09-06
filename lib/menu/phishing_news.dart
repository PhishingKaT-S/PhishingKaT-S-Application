/**
 * writer: 유이새
 * Date: 2022.08.31
 * Description: webview
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class NewsWebView extends StatefulWidget {
  const NewsWebView({Key? key}) : super(key: key);

  @override
  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  String _headerTitle = "야간근무 전 은행 들렸다 보이스피싱범 잡은 경찰관" ;
  List<String> _newsList = ['[관련기사] 야간근무 전 은행 들렀다 보이스피싱범 잡은 경찰관', '[관련기사] 신한은행, 금융권 최초 \'AI 이상행동탐지 ATM\' 도입', '[관련기사] 정부 지원 \'미끼\' 소상공인 노리는 문자'] ;
  List<String> _contentList = ['A씨가 취업했다는 법률사무소 측은 사무실의 위치조차 알려주지 않았고, 메신저를 통해서만 업무 지시를 했으며, 하는 일이라고는 소송 의뢰인으로부터 사건 수임료를 받아오는 것이 전부였다고 한다. 근무 형태와 담당 업무 등에 의문을 품은 박씨는 인터넷 검색을 통해 해당 법률사무소가 통신판매업체로 등록된 사실을 알아채고 A씨에게 "뭔가 이상하다. 보이스피싱이 의심된다"고 말했다.',
    'A씨가 취업했다는 법률사무소 측은 사무실의 위치조차 알려주지 않았고, 메신저를 통해서만 업무 지시를 했으며, 하는 일이라고는 소송 의뢰인으로부터 사건 수임료를 받아오는 것이 전부였다고 한다. 근무 형태와 담당 업무 등에 의문을 품은 박씨는 인터넷 검색을 통해 해당 법률사무소가 통신판매업체로 등록된 사실을 알아채고 A씨에게 "뭔가 이상하다. 보이스피싱이 의심된다"고 말했다.',
    'A씨가 취업했다는 법률사무소 측은 사무실의 위치조차 알려주지 않았고, 메신저를 통해서만 업무 지시를 했으며, 하는 일이라고는 소송 의뢰인으로부터 사건 수임료를 받아오는 것이 전부였다고 한다. 근무 형태와 담당 업무 등에 의문을 품은 박씨는 인터넷 검색을 통해 해당 법률사무소가 통신판매업체로 등록된 사실을 알아채고 A씨에게 "뭔가 이상하다. 보이스피싱이 의심된다"고 말했다.'] ;
  List<String> _dateList = ['2022.3.6', '2022.3.6', '2022.3.6'] ;
  List<String> _numOfChatList = ['0', '1', '1'] ;

  List<bool> _isSelected = [true, false, false] ;

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
            color: Colors.grey, // child: Image.asset('assets/images/voicephishing.jpeg', fit: BoxFit.fill,),
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
                  child: Text(_headerTitle, style: const TextStyle(fontSize: 17, color: AppTheme.white, fontWeight: FontWeight.bold)),
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
                    child: const Center(
                      child: Text('바로 가기', style: TextStyle(color: AppTheme.white), textAlign: TextAlign.center,)
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

                  const Padding(padding: EdgeInsets.only(left: 20),),

                  InkWell(
                      onTap: () {
                        setState(() {
                          _isSelected[0] = false ; _isSelected[1] = true; _isSelected[2] = false;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 3, // space between underline and text
                          ),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: (_isSelected[1]) ? Colors.white : AppTheme.greyText,  // Text colour here
                                width: 1.0, // Underline width
                              ))
                          ),
                          child: Text('WEEK', style: TextStyle(fontSize: 17, color: (_isSelected[1]) ? AppTheme.white : AppTheme.greyText, fontWeight: FontWeight.bold))
                      )
                  ),

                  const Padding(padding: EdgeInsets.only(left: 20),),

                  InkWell(
                      onTap: () {
                        setState(() {
                          _isSelected[0] = false ; _isSelected[1] = false; _isSelected[2] = true;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 3, // space between underline and text
                          ),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: (_isSelected[2]) ? Colors.white : AppTheme.greyText,  // Text colour here
                                width: 1.0, // Underline width
                              ))
                          ),
                          child: Text('MONTH', style: TextStyle(fontSize: 17, color: (_isSelected[2]) ? AppTheme.white : AppTheme.greyText, fontWeight: FontWeight.bold))
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
      padding: EdgeInsets.only(top: 5),
      child: Column(
        children: List.generate(_newsList.length, (index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  child: Text(_newsList[index], style: AppTheme.subtitle, overflow: TextOverflow.clip,),
                ),

                Container(
                  height: 50,
                  child: Text(_contentList[index], overflow: TextOverflow.clip,),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 5),
                  height: 20,
                  child: Text(_dateList[index], style: AppTheme.caption, overflow: TextOverflow.ellipsis,),
                ),

                Container(
                  height: 20,
                  child: Row(
                    children: [
                      Icon(Icons.chat, size: 15,),
                      Padding(padding: EdgeInsets.only(left: 5),),
                      Text(_numOfChatList[index], style: AppTheme.caption,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: AppTheme.whiteGrey,
                )
              ]
            )
          );
        })
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(title: '피싱 뉴스'),
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
