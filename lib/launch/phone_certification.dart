/*
* write:Jiwon Jung
* date: 7/29
* content: 0.4, phone number certication
* 7/29: style change
* 8/6: time flow, certification number, flag
* */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Theme.dart';
import '../kat_widget/launch_appbar.dart';
import '../kat_widget/launch_bottombar.dart';
import 'controller/PhoneVericationController.dart';
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

  //textfield가 포커스 아웃되면 인증번호 맞는지 아닌지 확인
  FocusNode textFocus = FocusNode();
  bool initialPicture_phone= false; // 느낌표 때문
  bool initialPicture_certification= false; // 느낌표 때문
  //
  String tokenbanner = "접속한 지 오래되어 휴대폰 재인증이 필요해요";
  String banner = "피싱 피해를 막기 위해\n휴대폰 본인 인증이 필요해요";
  int original = 300;

  //cellphone is correct?
  bool _correctCellphone=false; //휴대폰 형식 전화번호
  final cellphoneREG = RegExp(r'^(010)?(\d{4})(\d{4})$');
  
  //button pushed?
  bool _pushedBtn=false;
  
  //시간
  bool flag = false; // flag of certification.
  bool timeover = false; // end of the 5 minute.
  //int time = 5; //300 seconds
  Timer? _timer;
  int time = 300;
  final TextEditingController _textEditingController = TextEditingController(); // phonenumber textfield
  final TextEditingController _certificationController = TextEditingController();

  //verification
  var verification;
  String _phoneNumber = '';
  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time--;
        if (time == 0) {
          _timer?.cancel();
          timeover = true;
        }
      });
    });
  } //시간 시작

  void _clickPlayButton() {
    _timer?.cancel();
    _start();
  }//시간 시작

  void _clickResend() {
    _timer?.cancel();
    _start();
  }//다시 보내기

  @override
  void dispose() {
    super.dispose() ;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        textFocus.unfocus();

        setState((){
          _correctCellphone = cellphoneREG.hasMatch(_textEditingController.text);
          if (_certificationController.text ==
              verification) {
            _timer?.cancel();
            flag = true;
          } else {
            if(flag == true)
              {
                _start();
              }
            flag = false;

          }
        });
      },
      child: Scaffold(
          bottomNavigationBar: bottomBar(
              title: '다음',
              onPress: () {
                flag = (_certificationController.text==verification? true : false);
                /*각 경우에 따라서 알림을 날릴꺼임*/
                if(_certificationController.text.length == 0){
                  flag=false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        height: 45,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[Text('비밀번호 미입력', style:AppTheme.smsPhone), Text('인증번호를 입력해주세요', style:AppTheme.checksmsContent),]),
                      ))
                  );
                }else if(_certificationController.text != verification){
                  flag=false;
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Container(
                            height: 45,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[Text('비밀번호 불일치', style:AppTheme.smsPhone), Text('인증번호 6자리를 다시 입력해주세요', style:AppTheme.checksmsContent),]),
                          ))
                  );
                }
                if (flag &&  !timeover && ( _phoneNumber.compareTo(_textEditingController.text)==0 )) { //  옳고, 타임오버 아니고, 현재 text가 맞으면
                  _timer?.cancel();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (DetailInfo(phoneNumber: _phoneNumber))));
                }else if(timeover){ //시간초과
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Container(
                            height: 45,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[Text('시간 초과 입니다. \n인증 번호를 다시 받아주세요.', style:AppTheme.smsPhone)]),
                          ))
                  );
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Container(
                            height: 45,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[Text('번호 및 인증번호를 다시 확인해주세요', style:AppTheme.smsPhone)]),
                          ))
                  );
                }
              }),
          // button '확인'
          appBar: certification_appbar(Colors.blue, Colors.grey), // 위쪽 점 두개 구현
          body: WillPopScope( // 뒤로가기 버튼 막음
            onWillPop: () {
              return Future(() => false);
             // return Future(()=>false);
            },
            child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 20, 0),
                  //padding(20, 10, 20, 0)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(banner, style: AppTheme.serviceAuth), //피싱 피해를 막기 위해 ~

                      const SizedBox(
                        height: 40,
                      ), //크기 조절

                      //휴대폰 번호 입력하는 container
                      /*
                      * 해야할 일 아이콘 버튼
                      * */
                      Container(
                        //입력창을 담는 컨테이너 height 70임
                        decoration: BoxDecoration(
                          //박스 데코:블루, width:3 circular10
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: MediaQuery.of(context).size.height * 0.075,
                        child: Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.04),
                                child: const Center(
                                    child: Text('+82 ', style: TextStyle(
                                      // 0.4 국가번호
                                      fontFamily: 'applegothicRegular',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.lightdark2,
                                    )))),
                            Expanded(
                              child: TextField(
                                onSubmitted: (value) async { // 확인 눌렀을 때
                                  initialPicture_phone=true; //느낌표 생성
                                  _correctCellphone = cellphoneREG.hasMatch(_textEditingController.text);
                                  if (_correctCellphone) {
                                    _phoneNumber = _textEditingController.text;
                                    _pushedBtn=true;
                                    verification = await PhoneVerificationController()
                                        .sendSMS(_textEditingController.text);
                                    time = original;
                                    _timer?.cancel();
                                    _clickPlayButton();
                                  }
                                },
                                controller: _textEditingController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '휴대폰 번호 입력(-제외)',
                                  hintStyle: const TextStyle(fontFamily: 'applegothicMedium', fontSize: 17, color: AppTheme.lightGrey),
                                  contentPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.002),
                                ),
                              ),
                            ),

                            Container(
                                width: 50,
                                height: MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        scale: initialPicture_phone ? 8 : 0,
                                        image:_correctCellphone ? AssetImage('assets/images/joinFeedback2.png') : AssetImage('assets/images/joinFeedback1.png') // 휴대폰 번호 형식이 맞으면 넘어감
                                    )
                                ),
                              ),
                          ],
                        ), //국가 번호, 휴대폰번호, 아이콘이 flexible 1, 8, 1 비율로 있음
                      ), //border

                      const SizedBox(
                        height: 30,
                      ),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: MediaQuery.of(context).size.height * 0.075,
                        child: Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03),
                                child: Center(
                                    child: Text("0${(time ~/ 60)}:"+"${(time % 60).toString().length==2?(time % 60).toString():"0"+(time % 60).toString()}",
                                        style: TextStyle(fontFamily: 'applegothicRegular', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.blueText,)))),
                            Expanded(
                              child: TextField(
                                  onSubmitted: ((value) {
                                    if (value == verification) {
                                      setState(() {
                                        _timer?.cancel();
                                        flag = true;
                                      });
                                    }
                                  }
                                ),
                                focusNode: textFocus,
                                controller: _certificationController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '인증번호 입력',
                                  hintStyle: const TextStyle(fontFamily: 'applegothicMedium', fontSize: 17, color: AppTheme.lightGrey),
                                  contentPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.003),
                                ),
                              ),
                            ),
                            InkWell(
                                  onTap: () {
                                    initialPicture_certification=true;
                                    if (_certificationController.text ==
                                        verification) {
                                      _timer?.cancel();
                                      flag = true;
                                    } else {
                                      flag = false;
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          scale: initialPicture_certification ? 8 : 0,
                                        image:flag ?  AssetImage('assets/images/joinFeedback2.png',): AssetImage('assets/images/joinFeedback1.png')
                                      )
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ), //남은 시간, 인증번호 아이콘이 flexible 1, 9, 1비율로 있음

                      Align(
                        //인증번호 다시 받기
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: _pushedBtn ? Text('인증번호 다시받기', style: AppTheme.certicationResend) : Text('인증번호 받기', style: AppTheme.certicationResend),
                          onPressed: () async {
                            _correctCellphone = cellphoneREG.hasMatch(_textEditingController.text);
                            timeover=false;

                            if(_correctCellphone){
                              if(_pushedBtn){ // 한번 눌릴 상태
                                _phoneNumber = _textEditingController.text;
                            verification = await PhoneVerificationController()
                                .sendSMS(_textEditingController.text);
                            _timer?.cancel();
                            setState((){
                              _pushedBtn = true; //버튼 눌렀으므로 인증번호 다시받기로 바꿈
                              flag= false;    //certification 초기화
                            });
                            time = original;
                            _clickResend();}
                              else{ //처음 눌릴 상태
                                _phoneNumber = _textEditingController.text;
                                print("지금은" + _phoneNumber);
                                verification =
                                await PhoneVerificationController()
                                    .sendSMS(_textEditingController.text);
                                time = original;
                                _timer?.cancel();
                                _clickPlayButton();
                                setState((){
                                  _pushedBtn = true;
                                  flag=false;
                                });
                              }
                            }

                          },
                        ),
                      ) //인증번호 받기 받기
                    ],
                  )),
            ),
          )),
    );
  }
}
