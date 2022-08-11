import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class UrlCheckPage extends StatelessWidget {
  const UrlCheckPage({Key? key}) : super(key: key);
  Widget belowImage() {
    return Expanded(flex:4,
              child:
              Container(child:
              Image.asset('assets/images/launch_end.png', fit: BoxFit.fill),
                width: double.infinity,
              ),
           );
  }

  Widget inspectButton(BuildContext context) {
    return Expanded(
              flex: 1,
              child: Center(
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/kat_pages/url_home');
                },
                  child: Container(
                    width:230,
                    height:40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/url_inspect.png'),
                        fit: BoxFit.cover
                      ),
                    ),
                    child: Center(
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

          ));
  }

  Widget guideText() {
    return Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 37, 10),
                child:
                  Text('문자 내에 위험 요소를 검사하여 스미싱 피해를 방지합니다.(최대 100개)', style: AppTheme.urlInspect)
              )
          );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("URI 검사", style: TextStyle(color: AppTheme.blueText),),
          backgroundColor: AppTheme.blueBackground,
          elevation: 0,
          centerTitle: true,
        ),
        body:
        Column(
          children: <Widget>[
            guideText(), //문자 내에~~
            Expanded(flex:1,child: SizedBox(height: 1,)), // 간격 유지
            inspectButton(context),
            belowImage()
          ],

        )
    );
  }
}
