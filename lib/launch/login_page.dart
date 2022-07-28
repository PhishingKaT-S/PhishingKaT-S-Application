/*
* writer Jiwon Jung
* date: 7/25
* description: writing 0.1
* */

/*
writer:정지원
date: 7/26
description: Creating the LoginPage
*
* */


import 'package:flutter/material.dart';
import 'policy.dart';

import '../theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body:
            Container(
              color:Colors.blue,
              child: Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Row(children:<Widget>[
                        expanded_sizedBox(),
                        Expanded(
                          /*
                          * 해야할 일: 스타일이 수정되어야 됨
                          * */
                            child:  Center(child: Text('나와 내 이웃을 지키는', style: AppTheme.title)),
                            flex: 2,
                        ),
                        expanded_sizedBox()
                      ]),

                    Row(
                        children: [
                          expanded_sizedBox(),
                          Expanded( // 간격 맞추기
                            flex: 2,
                            child:
                            Center(
                              child: Text('피싱캣S', style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                          ),
                          expanded_sizedBox(),
                        ],
                      ),

                    SizedBox(height: 10,), // 간격 맞추기

                    //시작하기 버튼이 있고, 이 시작하기 버튼은 policy 화면으로 옮겨감
                    Row(
                        children: [
                          expanded_sizedBox(),

                          Expanded( // 간격 맞추기
                            flex: 2,
                            child: TextButton(

                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Policy()));
                              },
                              child:Text("시작하기",style:AppTheme.title)
                            ),
                          ),
                          expanded_sizedBox(),
                        ],
                      )
                  ]

          )
        ),
            )
      );
    }




    /*
    * 구현 맞추기 위한 sizedbox
    *
    * */
  Widget expanded_sizedBox() {
    return Expanded(child: // 간격 맞추기
                        SizedBox(
                        ),
                            flex:1
                        );
  }
}
