/*
* writer Jiwon Jung
* date: 7/29
* description: adding the bottom line writing
* */

/*
writer:정지원
date: 7/26
description: Creating the LoginPage
next Page=>Policy()
*
* */

import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/launch/access_authority.dart';
import 'policy.dart';

import '../theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
        Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.topCenter,
          color: AppTheme.startBackground,
          padding: EdgeInsets.fromLTRB(0,0,0,20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                '시작하기를 누르면 ',
                style: AppTheme.start_caption,
              ),

              TextButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Policy()));
                },
                child: Text(
                  '이용약관 및 정책 ',
                  style: AppTheme.start_caption_button,
                ),
              ),

              Text(
                '동의로 간주합니다',
                style: AppTheme.start_caption,
              ),

            ],
          ),
        ),
        body: Container(
      color: AppTheme.startBackground,
      child: Center(child: _start_view(context)),
    ));
  }

  Widget _bottom_bar() {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.topCenter,
      color: AppTheme.startBackground,
      padding: EdgeInsets.fromLTRB(0,0,0,20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

            Text(
              '시작하기를 누르면 ',
              style: AppTheme.start_caption,
            ),

           TextButton(
              onPressed: (){
               // Navigator.push(LoginPage.context,
                 //   MaterialPageRoute(builder: (context) => Policy()));
              },
              child: Text(
                '이용약관 및 정책 ',
                style: AppTheme.start_caption_button,
              ),
          ),

          Text(
              '동의로 간주합니다',
              style: AppTheme.start_caption,
            ),

        ],
      ),
    );
  }

  Widget _start_view(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: <Widget>[
            expanded_sizedBox(),
            Expanded(
              /*
                        * 해야할 일: 스타일이 수정되어야 됨
                        * */
              child: Column(children: <Widget>[

                Container(
                  width: 300,
                  height:25,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '나와 내 이웃을 지키는',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height:80,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '피싱캣S',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]),
              flex: 2,
            ),
            expanded_sizedBox()
          ]),

          SizedBox(
            height: 10,
          ), // 간격 맞추기

          //시작하기 버튼이 있고, 이 시작하기 버튼은 policy 화면으로 옮겨감
          Row(
            children: [
              expanded_sizedBox(),
              Expanded(
                // 간격 맞추기
                flex: 2,
                child: TextButton(
                    style: AppTheme.buttonStyle_white,
                    onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccessAuthority()));
                    },
                    child: Text("시작하기", style: AppTheme.button_blue)),
              ),
              expanded_sizedBox(),
            ],
          )
        ]);
  }

  /*
    * 구현 맞추기 위한 sizedbox
    *
    * */
  Widget expanded_sizedBox() {
    return Expanded(
        child: // 간격 맞추기
            SizedBox(),
        flex: 1);
  }
}
