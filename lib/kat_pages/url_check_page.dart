import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class UrlCheckPage extends StatelessWidget {
  const UrlCheckPage({Key? key}) : super(key: key);
  Widget belowImage() {
    return
      Container(child:
      Image.asset('assets/images/launch_end.png', fit: BoxFit.fitWidth),
        width: double.infinity,

      );
  }

  Widget inspectButton(BuildContext context) {
    return Center(
          child: InkWell(
            onTap: (){
                Navigator.pushNamed(context, '/kat_pages/url_home', arguments: 0 );

            },
            child: Container(
                height: MediaQuery.of(context).size.height * 0.053,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/url_inspect.png'),
                  ),
                ),
                child: const Center(
                  child: Text(
                      '지금 바로 URL 검사하기',
                      style:
                      TextStyle( // 로그인 버튼의 파란색 버튼
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        letterSpacing: 0.2,
                        color:Color(0xff5153ff),
                      )
                  ),
                )
            ),
          ),

        );
  }

  Widget guideText() {
    return Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 37, 10),
            child:
            Text('문자 내에 위험 요소를 검사하여 스미싱 피해를 방지합니다.(최대 100개)',
                style: TextStyle(
                // 문자 내에 위험요소, 1.7 url 검사
                fontFamily: 'WorkSans',
                fontSize: 16,
                letterSpacing: 0.2,
                color: Color(0xFF9b9b9b), // was lightText
              ),
            )
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBarBack(title: 'Url 검사'),
          body:
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                guideText(), //문자 내에~~
                SizedBox(height: 80), // 간격 유지
               inspectButton(context),
                SizedBox(height:30),
                belowImage()
              ],

            ),
          )
      );
  }
}