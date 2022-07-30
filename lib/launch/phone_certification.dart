/*
* write:Jiwon Jung
* date: 7/29
* content: 0.4, phone number certication
* 7/29: style change
* */

import 'package:flutter/material.dart';

import '../Theme.dart';
import '../kat_widget/launch_appbar.dart';
import '../kat_widget/launch_bottombar.dart';
import 'detailed_info.dart';

class PhoneCRT extends StatefulWidget {
  const PhoneCRT({Key? key}) : super(key: key);

  @override
  State<PhoneCRT> createState() => _Phone_CRTState();
}
/*
* 휴대폰 번호를 인증하는 UI이고 다음을 누르면 detailed_info.dart로 넘어간다.
* detailed_info는 DetailInfo가 들어있다.
*
* 해야할 일, 휴대폰 버튼 입력에 아이콘에 문자보내는 기능
* text옆에 시간을 5분 초 세는 기능,
* ?버튼에 인증번호 확인 하는 기능
* 다음버튼에 인증번호가 맞으면 DetailInfo로 넘어가는 기능
* 인증번호 다시받기 버튼 기능능
 */

class _Phone_CRTState extends State<PhoneCRT> {
  String banner = "피싱 피해를 막기 위해\n휴대폰 본인 인증이 필요해요";
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(title: '다음', onPress: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>(DetailInfo())));
        }),
        // button '확인'
        appBar: certification_appbar(Colors.blue, Colors.grey), // 위쪽 점 두개 구현
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0), //padding(20, 10, 20, 0)
              child: Column(
                children: <Widget>[

                  Text(
                      banner,   //위의 안내글을 입력받아서 state를 변화시킴
                      style: AppTheme.title,  //스타일
                    ), //피싱 피해를 막기 위해 ~

                  SizedBox(height: 50,),  //크기 조절

                  //휴대폰 번호 입력하는 container
                  /*
                  * 해야할 일 아이콘 버튼
                  * */
                  Container(                  //입력창을 담는 컨테이너 height 70임
                    decoration: BoxDecoration(  //박스 데코:블루, width:3 circular10
                      border:Border.all(
                        color:Colors.blue,
                        width:3
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width:60,
                        child: Center(
                          child:
                          Text('+082 ', style: AppTheme.body1))),


                        Flexible(
                          flex: 8,
                            child: TextField(
                          controller:_textEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: '휴대폰 번호 입력',
                              labelStyle: AppTheme.caption,
                              ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                            child: IconButton(onPressed: (){}, icon:Icon( Icons.check), color: Colors.green,))
                      ],
                    ), //국가 번호, 휴대폰번호, 아이콘이 flexible 1, 8, 1 비율로 있음
                  ), //border

                  SizedBox(height: 20,),

                  Container(
                    decoration: BoxDecoration(
                      border:Border.all(
                          color:Colors.blue,
                          width:3
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width:60,
                            child: Center(child: Text('4:46', style: AppTheme.body1))),
                        Flexible(
                          flex: 9,
                          child: TextField(
                            controller:_textEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '인증번호 입력',
                              labelStyle: AppTheme.caption,
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: IconButton(onPressed: (){}, icon:Icon( Icons.question_mark, color: Colors.red,), color: Colors.green,))
                      ],
                    ),
                  ),//남은 시간, 인증번호 아이콘이 flexible 1, 9, 1비율로 있음

                  Align(  //인증번호 다시 받기
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text('인증번호 다시받기', style: AppTheme.caption),
                      onPressed: (){},
                    ),
                  )//인증번호 받기 받기

                ],
              )),
        ));
  }

}
