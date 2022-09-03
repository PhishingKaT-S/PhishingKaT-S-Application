/*
* write: jiwon
* date: 8/10
* scene 1.7.1~ 1.8.1
*
*
* 8/17 below popup implementation
* 9/1 end by connect db and load, left delete element and future build
* */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../Theme.dart';
import '../db_conn.dart';
import '../kat_widget/kat_appbar_back.dart';
import '../kat_widget/no_smishing.dart';

//문자 최신순으로 정렬하기
class smsInBox{
  int length=0;
  List<smsContent> messagess =[];
  List<smsContent> freqmessagess=[];
  void addsms(smsContent s)
  {
    freqmessagess.add(s);
    length+=1;
  }
  void sortingdate() //for 전체 뷰
  {
    messagess.sort((b,a)=> a.received_date.compareTo(b.received_date));
  }

  void sortingscore(){
    messagess.sort((b,a)=> a.score.compareTo(b.score));
  }

  void removesms(int num)
  {
    freqmessagess.removeWhere((element) => element.id == num);
    length-=1;
  }
  void copysms(){
    messagess = List.from(freqmessagess);
  }
  void printsms() // for debug
  {
    for(int i =0; i< length; i++)
      {
        print(freqmessagess[i].text);
      }
  }

} //sms 저장하는 클레스

class smsContent{
  int id; // for delete
  String text;
  String sender_ph;
  int type;
  String received_date;
  int score;

  smsContent(this.id, this.sender_ph, this.text, this.type, this.received_date, this.score);
} //sms 클래스

class InspectFeedback extends StatefulWidget {

  @override
  State<InspectFeedback> createState() => _InspectFeedbackState();
}

enum SingingCharacter { smishingURL, remoteControll, privateInfo, scam, teleMarketing, insurance, others}// radio button category


class _InspectFeedbackState extends State<InspectFeedback> with SingleTickerProviderStateMixin {
  final _isVisible = List<bool>.filled(100, false);
  int _idx =0; // 몇 번째 문자를 보고 있는지에 대한 변수
  late TabController _tabController; // tab bar를 위한 변수
  int _isSelected =0;       // 리스트에서 몇번째가 선택되었는지에 대한 변수(인덱스를 가리킴)
  bool _changeCategory=false; // 분류수정이 눌렸는지에 대한 변수
  List<bool> toggleSelected=[false, false]; //토글 버튼 파랑색 회식
  SingingCharacter? _character = SingingCharacter.smishingURL;
  List<String> msgList = ['위험 URL으로 분류된문자입니다.','텔레마케팅으로 분류된 문자입니다.','지인사칭으로 분류된 문자입니다.', '위험 URL 포함으로 분류된 문자입니다.', '기타로 분류된 문자입니다.'];


  smsInBox _smsinbox = smsInBox() ; // sms 관리

  void buttonInit(int num){
      _isSelected =0;
      toggleSelected  = [false, false]; // 토글 버튼에 대한 index
      _changeCategory = false;   //분류 수정을 눌렀는지 아닌지
      _character = SingingCharacter.smishingURL;  //라디오 버튼 값 변수
      _isVisible.fillRange(0, num, false);
      _isVisible.fillRange(num+1, _isVisible.length, false);

  } // 버튼들 init


  void _settingModalBottomSheet(context) // 분류수정
  {
    List<bool> buttonCheck = List<bool>.filled(7, false);
    buttonCheck[0]=true;
    _character = SingingCharacter.smishingURL;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc){
          return StatefulBuilder(
            builder:(BuildContext bc, setState)=>
             Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)
                  ),

              ),
             height: MediaQuery.of(context).size.height * 0.55,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                          Container(
                            height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                            child: RadioListTile<SingingCharacter>(
                              title: Text('스미싱 의심 URL', style: buttonCheck[0] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                              value: SingingCharacter.smishingURL,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value){
                                setState((){
                                  _character = value;
                                  for(int i=0; i<buttonCheck.length; i++)
                                    if(_character == SingingCharacter.values[i]) {
                                      buttonCheck[i] = true;
                                      print(buttonCheck[i]);
                                    }
                                  else buttonCheck[i] = false;
                                });
                              },
                            ),
                          ),

                          Container(
                            height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                            child: RadioListTile<SingingCharacter>(
                              title: Text('원격제어 설치 유도', style: buttonCheck[1] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                              value: SingingCharacter.remoteControll,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value){
                                setState((){
                                  _character = value;
                                  for(int i=0; i<buttonCheck.length; i++)
                                    if(_character == SingingCharacter.values[i]) {
                                      buttonCheck[i] = true;
                                    }
                                  else buttonCheck[i] = false;
                                });
                              },
                            ),
                          ),
                          Container(
                            height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                            child: RadioListTile<SingingCharacter>(
                              title: Text('개인정보유출', style: buttonCheck[2] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                              value: SingingCharacter.privateInfo,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value){
                                setState((){
                                  _character = value;
                                  for(int i=0; i<buttonCheck.length; i++)
                                    if(_character == SingingCharacter.values[i]) {
                                      buttonCheck[i] = true;
                                    }else buttonCheck[i] = false;
                                });
                              },
                            ),
                          ),
                          Container(
                            height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                            child:
                            RadioListTile<SingingCharacter>(
                              title: Text('지인 및 기관 사칭', style: buttonCheck[3] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                              value: SingingCharacter.scam,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value){
                                setState((){
                                  _character = value;
                                  for(int i=0; i<buttonCheck.length; i++)
                                    if(_character == SingingCharacter.values[i]) {
                                      buttonCheck[i] = true;
                                    }else buttonCheck[i] = false;
                                });
                              },
                            ),

                          ),
                          Container(
                            height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                            child:
                            RadioListTile<SingingCharacter>(
                              title:  Text('텔레마케팅', style: buttonCheck[4] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                              value: SingingCharacter.teleMarketing,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value){
                                setState((){
                                  _character = value;
                                  for(int i=0; i<buttonCheck.length; i++)
                                    if(_character == SingingCharacter.values[i]) {
                                      buttonCheck[i] = true;
                                    }else buttonCheck[i] = false;
                                });
                              },
                            ),

                          ),
                          Container(
                            height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                            child:
                            RadioListTile<SingingCharacter>(
                              title: Text('보험 및 대출 안내', style: buttonCheck[5] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                              value: SingingCharacter.insurance,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value){
                                setState((){
                                  _character = value;
                                  for(int i=0; i<buttonCheck.length; i++)
                                    if(_character == SingingCharacter.values[i]) {
                                      buttonCheck[i] = true;
                                    }else buttonCheck[i] = false;
                                });
                              },
                            ),

                          ),
                          Container(
                            height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                            child:
                            RadioListTile<SingingCharacter>(
                              title: Text('기타(해당사항 없음)', style: buttonCheck[6] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                              value: SingingCharacter.others,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value){
                                setState((){
                                  _character = value;
                                  for(int i=0; i<buttonCheck.length; i++)
                                    if(_character == SingingCharacter.values[i]) {
                                      buttonCheck[i] = true;
                                    }else buttonCheck[i] = false;
                                });
                              },
                            ),

                          ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                    Container(

                      height: MediaQuery.of(context).size.height * 0.08,
                      child: ToggleButtons(
                        isSelected: toggleSelected,
                        onPressed: (int index){
                          setState(() {
                            toggleSelected[index] = !toggleSelected[index];
                            if(toggleSelected[0] == true){
                              Navigator.pop(bc);
                              toggleSelected[0] = false;
                            }
                            if(toggleSelected[1] == true)
                            {
                              print(_character);
                              Navigator.pop(bc);
                              _changeCategory=false;
                              toggleSelected[1] = false;
                            }
                          });
                        },
                        children: <Widget>[
                          Container(width: MediaQuery.of(context).size.width*0.495,  color: Colors.grey[300],
                            child:
                            Center(child: Text('취소', style: AppTheme.whitetitle)),
                          ),
                          Container(width: MediaQuery.of(context).size.width*0.495, color: AppTheme.startBackground,
                            child:
                            Center(child: Text('변경하기', style: AppTheme.whitetitle)),
                          ),
                        ],
                      ),
                    )


                        ],),




            ),
          );
        });
  }

  void _alertModalBottomSheet(context){
    showModalBottomSheet(backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)
            ),

          ),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Container(
                padding: EdgeInsets.fromLTRB(40, MediaQuery.of(context).size.height * 0.05, 40, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text('차단 해제 시', style: AppTheme.menu_news2),
                        Text(' 보안에 취약해지고 스미싱 위험에', style: AppTheme.subtitle),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('노출', style: AppTheme.subtitle),
                        Text(' 될 수 있습니다.', style: AppTheme.service_center),
                      ],
                    ),
                    Text('그래도 해제하시겠어요?', style: AppTheme.service_center)
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ToggleButtons(
                  isSelected: toggleSelected,
                  onPressed: (int index){
                    setState(() {
                      toggleSelected[index] = !toggleSelected[index];
                      if(toggleSelected[0] == true){
                        Navigator.pop(context);
                        toggleSelected[0] = false;
                      }
                      if(toggleSelected[1] == true)
                      {
                       // setState((){scoreList.removeAt(_isSelected);}); // remove 해야됨

                        Navigator.pop(context);
                        _changeCategory=false;
                        toggleSelected[1] = false;
                      }
                    });
                  },
                  children: <Widget>[
                    Container(width: MediaQuery.of(context).size.width*0.49,  color: Colors.grey[300],
                      child:
                      Center(child: Text('취소', style: AppTheme.whitetitle)),
                    ),
                    Container(width: MediaQuery.of(context).size.width*0.49, color: AppTheme.startBackground,
                      child:
                      Center(child: Text('해체하기', style: AppTheme.whitetitle)),
                    ),
                  ],
                ),
              )
            ],
          ),

        );
      });
  } // 차단해제


  Future _getSmsInfo() async {
    var a = await UniqueIdentifier.serial;
    print(a);
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async  {
      await conn.query("select id, sms.user_ph, sms.text, sms.sender_ph, sms.type, sms.received_sms_date from sms ,"
        "(select user_ph, sender_ph, count(*) as cnt from sms group by sender_ph order by cnt DESC)"
      "as b where sms.sender_ph = b.sender_ph and user_id = 2 order by b.cnt DESC") // 수정해야됨
          .then((results)  {

            for(int i =0 ; i < results.length.ceil(); i++)
              {
                  var _temp = results.elementAt(i);
                  smsContent s = smsContent(_temp['id'], _temp['sender_ph'], _temp['text'], _temp['type'], _temp['received_sms_date'].toString(), Random().nextInt(100)+1);
                  _smsinbox.addsms(s);
              }

      }).onError((error, stackTrace)  {
          print(error);
      });
      conn.close();
    }).onError((error, stackTrace)  {
    });
  } //_getSmsInfo, db에서부터 list로 가져오기


  @override
  void initState() {

    _getSmsInfo();
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
    // for(int i=0; i<content.length; i++) {
    //   if (content[i] == "\n") {
    //     cnt += 1;
    //   }
    // }
    // cnt = (cnt>=content.length ~/13 ? cnt : content.length~/13);
    // print("cnt: " + cnt.toString() + content.length.toString()); // 글자수 계산해서 container 만들거임
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _last_list(int type) {
    _smsinbox.copysms();
    if(type==2) {
      setState((){
        _smsinbox.sortingscore();
      });
    }
    if(type==3) {
      setState((){
        _smsinbox.sortingdate();
      });

    }
      return 
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 10, left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              children: List.generate(_smsinbox.length, (index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(vertical: 10),

                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.1,

                            child: (type==1)?
                            showScoreFreqMessage(index):
                            showScoreMessage(index)
                            ,

                          ), // 노란, 빨강, 오렌지 등의 사진 문자 아이콘
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 60,
                            color: _isVisible[index]? AppTheme.blueText:AppTheme.whiteGrey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(

                                  height: 30,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children:[
                                        Container(
                                            width: 120,
                                            margin: EdgeInsets.fromLTRB(8, 0, MediaQuery.of(context).size.width*0.02, 0),
                                            child: Text((type==1)?_smsinbox.freqmessagess[index].sender_ph.padRight(11):_smsinbox.messagess[index].sender_ph.padRight(20), style: _isVisible[index]?  AppTheme.smsPhone: AppTheme.subtitle)), // 휴대폰 번호
                                        Container(
                                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0,0, 0),
                                                child: Text((type==1)?(_smsinbox.freqmessagess[index].received_date.substring(0, 19)) : (_smsinbox.messagess[index].received_date.substring(0, 19)), style: _isVisible[index]?  AppTheme.selectDate:AppTheme.unseletDate),), //받은 날짜
                                        Container(
                                              width: 15,
                                              height:20,
                                              child: IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      size: 10),
                                                  onPressed: (){
                                                    setState((){
                                                      buttonInit(index);
                                                      _isSelected = index;
                                                      _isVisible[index] = !_isVisible[index];
                                                      if(_isVisible[index]==false) {_isSelected=0;}
                                                    });
                                                  },
                                                ),
                                            ), //밑으로 내리는 버튼

                                      ]
                                  ),
                                ),
                                Container(
                                  height: 30,
                                    margin: EdgeInsets.fromLTRB(8, 0, 2, 0),
                                    child: Text(msgList[_smsinbox.freqmessagess[index].type-1], style: _isVisible[index]?  AppTheme.checksmsContent: AppTheme.unchecksmsContent)), //문자 타입별 보여주는 글
                              ],
                            )
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: <Widget>[
                          Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                              Visibility(
                                      visible: _isVisible[index],
                                      child:

                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.749,
                                            //height: MediaQuery.of(context).size.height*0.02 >=  (cnt ) * MediaQuery.of(context).size.height*0.03 ?MediaQuery.of(context).size.height*0.2:(cnt) * MediaQuery.of(context).size.height*0.02, //컨테이너 높이는 글자수에 비례하게 만듬
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppTheme.blueText)

                                            ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Text((type==1)?_smsinbox.freqmessagess[index].text:_smsinbox.messagess[index].text),
                                              )

                                      ),
                                      )

                               // 문자 내용 메시지 보여지는 text

                            ],
                          ), // 문자 내용 보여주는 로우
                          SizedBox(height: 10),
                          Visibility(
                              visible: _isVisible[index],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[

                                  Container(
                                    //color: Colors.blue,
                                    width: 80,
                                    height: 35,
                                    child: TextButton(
                                      style: AppTheme.buttonStyle_whitewithbolder,
                                      onPressed: (){
                                        setState((){
                                        //  _changeCategory= !(_changeCategory);
                                          _settingModalBottomSheet(context);
                                        });
                                        },
                                      child: Text('분류수정', style: AppTheme.caption)
                                    ),
                                  ),
                                  SizedBox(width:30),
                                  Container(
                                     // color: Colors.blue,
                                      width: 80,
                                      height: 35,
                                      child: TextButton(
                                        style: AppTheme.buttonStyle_whitewithbolder,
                                        onPressed: (){_alertModalBottomSheet(context);
                                          print(index);},
                                        child: Text('차단해제', style: AppTheme.caption)
                                    ),
                                     )
                                ],
                              )
                          ) // 분류수정, 차단해제 버튼
                        ],
                      ), //문자 내용 보여주는 위젯
                    ],
                  ),
                );
              })
            )
          ),
        );

  } //카드 보여주는 위젯

  Widget showScoreMessage(int index) => ( _smsinbox.messagess[index].score  > 80 ) ? const Image(image: AssetImage('assets/images/smsManage1.png')) : (_smsinbox.messagess[index].score > 60) ? const Image(image: AssetImage('assets/images/smsManage2.png')) : const Image(image: AssetImage('assets/images/smsManage3.png')); // 점수에 따라 문자 보여줌
  Widget showScoreFreqMessage(int index) => ( _smsinbox.freqmessagess[index].score  > 80 ) ? const Image(image: AssetImage('assets/images/smsManage1.png')) : (_smsinbox.freqmessagess[index].score > 60) ? const Image(image: AssetImage('assets/images/smsManage2.png')) : const Image(image: AssetImage('assets/images/smsManage3.png')); // 점수에 따라 Message의 문자 보여줌 // 메인 UI
  //bottom show up */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ((ModalRoute.of(context))!.settings.arguments) == 1? AppBarBack( title: '메세지 관리',) : AppBarBack( title: 'Url 검사결과',),


      body:
      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 60,
            color: Color(0xfff0f0f0),
            child: TabBar(
              onTap: (index){
                  setState(() {
                    _idx =index;
                  });
              },
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  border: Border.all(color:AppTheme.startBackground),
                  borderRadius: BorderRadius.circular(50),
                  color: AppTheme.startBackground),
              controller: _tabController,

              tabs: [
                Container(
                  height: 40,
                  width: 250,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (_idx==0)?  Colors.transparent:Colors.white,
                      border:Border.all(color: (_idx==0) ? Colors.transparent : AppTheme.nearlyBlack),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text('빈도순', style: (_idx==0)? AppTheme.selected:AppTheme.unseletedURL),
                  ),
                ),
                Container(
                  height: 40,
                  width: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: (_idx==1) ? Colors.transparent : AppTheme.nearlyBlack),
                      borderRadius: BorderRadius.circular(50),
                       color: (_idx==1)?  Colors.transparent:Colors.white,

                       // border:Border.all(color:  AppTheme.startBackground)
                      ),
                    alignment: Alignment.center,
                    child: Text('위험도순', style: (_idx==1)? AppTheme.selected:AppTheme.unseletedURL),
                  ),
                ),
                Container(
                  height: 40,
                  width: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      color: (_idx==2)?  Colors.transparent:Colors.white,
                      border:Border.all(color: (_idx==2) ? Colors.transparent : AppTheme.nearlyBlack),
                        borderRadius: BorderRadius.circular(50),
                       // border:Border.all(color:  AppTheme.startBackground)
                      ),
                    alignment: Alignment.center,
                    child: Text('전체', style: (_idx==2)? AppTheme.selected:AppTheme.unseletedURL),
                  ),
                )
              ],
            )
          ),
          Expanded(child:
              TabBarView(
                controller: _tabController,
                children: [
                  _smsinbox.length==0 ? noSmishing() : _last_list(1),
                  (_smsinbox.length==0) ?noSmishing() :_last_list(2),
                  (_smsinbox.length==0) ?noSmishing() :_last_list(3),
                ],

          ))
        ],
      )
    );
  }


}

