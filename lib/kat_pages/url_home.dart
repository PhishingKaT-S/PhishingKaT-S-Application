/*
* write: jiwon
* date: 8/10
* scene 1.7.1~ 1.8.1
*
*
* 8/17 below popup implementation
* 9/1 end by connect db and load, left delete element and future build
* */

import 'dart:io';
import 'dart:math';

import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phishing_kat_pluss/providers/launch_provider.dart';
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../Theme.dart';
import '../db_conn.dart';
import '../kat_widget/kat_appbar_back.dart';
import '../kat_widget/no_smishing.dart';
import '../local_database/DBHelper.dart';
import '../local_database/Sms.dart';
import '../providers/smsProvider.dart';

//문자 최신순으로 정렬하기
/*
class smsInBox{
  int length=0;
  List<smsContent> messagess =[]; // 두 번째 화면
  List<smsContent> freqmessagess=[]; //첫 번째 화면을 위한 변수
  List<smsContent> recentmessage=[]; //세 번째 화면


  void addsms(smsContent s)
  {
    freqmessagess.add(s);
    length+=1;
  }
  void sortingdate() //for 전체 뷰
  {
    recentmessage.sort((b,a)=> a.received_date.compareTo(b.received_date));
  }

  void sortingscore(){
    messagess.sort((b,a)=> a.score.compareTo(b.score));
  }

  Future<void> _getdeleteInfo(int id) async {
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async  {
      await conn.query("Delete FROM sms WHERE id = ?", [id])
          .then((results)  {
      }).onError((error, stackTrace) {
      });
      conn.close();
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  void removesms(int id)
  {
    /*
    * db 연결해서 delete 해야됨
    * */
    _getdeleteInfo(id);

    freqmessagess.removeWhere((element)=>   element.id == id);
    messagess.removeWhere((element) => element.id == id);
    recentmessage.removeWhere((element) => element.id == id);
    length-=1;
  }

  Future<void> _getupdateInfo(int id, int type) async { //update 테이블
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async  {
      await conn.query("update sms set type = ? WHERE id = ?", [type, id])
          .then((results)  {
      }).onError((error, stackTrace) {
      });
      conn.close();
    }).onError((error, stackTrace) {
      print(error);
    });
  }
  
  void update(int scene, int id, int _type)
  {
      for (int j = 0; j < length; j++) {
        if (scene == 0 && messagess[j].id == id){
          messagess[j].type = _type;
        }
        if (scene == 1 && freqmessagess[j].id == id) freqmessagess[j].type = _type;
        if (scene==2 && recentmessage[j].id == id) recentmessage[j].type = _type;
      }
  }

  void copysms(){
    messagess = List.from(freqmessagess);
    recentmessage = List.from(freqmessagess);
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
*/
class InspectFeedback extends StatefulWidget {

  @override
  State<InspectFeedback> createState() => _InspectFeedbackState();
}

enum SingingCharacter { parcel,  corp, acquaint, pay, ad, others}// radio button category


class _InspectFeedbackState extends State<InspectFeedback> with SingleTickerProviderStateMixin {
  final _isVisible = List<bool>.filled(100, false);
  int _idx =0; // 몇 번째 문자를 보고 있는지에 대한 변수
  late TabController _tabController; // tab bar를 위한 변수
  int _isSelected =0;       // 리스트에서 몇번째가 선택되었는지에 대한 변수(인덱스를 가리킴)
  bool _changeCategory=false; // 분류수정이 눌렸는지에 대한 변수
  List<bool> toggleSelected=[false, false]; //토글 버튼 파랑색 회식
  SingingCharacter? _character = SingingCharacter.parcel;
  List<String> msgList = ['수시 기관 사칭으로 분류된 문자입니다.','정부기관 사칭으로 분류된 문자입니다.','지인/가족 사칭 분류된 문자입니다.', '택배사 사칭으로 분류된 문자입니다.', '금융기관 사칭으로 분류된 문자입니다.', '기업 사칭으로 분류된 문자입니다.'];
  int _type =0; // 나중에 type 수정을 위함, 카테고리 분류 변수
  List<Sms> _smsinbox_freq = [];// sms 관리
  List<Sms> _smsinbox_danger = [];// sms 관리
  List<Sms> _smsinbox_recent = [];// sms 관리
  String? identifier;
  var myFuture;

  void buttonInit(int num){
    _type = _tabController.index==0? _smsinbox_freq[_isSelected].type :(_tabController.index==1 ? _smsinbox_danger[_isSelected].type: _smsinbox_recent[_isSelected].type); //잠시 에러로 인해
    _isSelected =0;
    toggleSelected  = [false, false]; // 토글 버튼에 대한 index
    _changeCategory = false;   //분류 수정을 눌렀는지 아닌지
    _character = SingingCharacter.values[_type];  //라디오 버튼 값 변수
    _isVisible.fillRange(0, num, false);
    _isVisible.fillRange(num+1, _isVisible.length, false);

  } // 버튼들 init


  void _settingModalBottomSheet(context) // 분류수정
  {
    List<bool> buttonCheck = List<bool>.filled(6, false);
   // _type = _tabController.index==0? _smsinbox.freqmessagess[_isSelected].type :(_tabController.index==1 ? _smsinbox.messagess[_isSelected].type: _smsinbox.recentmessage[_isSelected].type); 잠시 에러로 인해
    buttonCheck[_type]=true;
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
                  height: MediaQuery.of(context).size.height * 0.49,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                        child: RadioListTile<SingingCharacter>(
                          title: Text('수사 기관 사칭', style: buttonCheck[0] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                          value: SingingCharacter.parcel,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState((){
                              _character = value;
                              for(int i=0; i<buttonCheck.length; i++)
                                if(_character == SingingCharacter.values[i]) {
                                  _type = i;
                                  buttonCheck[i] = true;
                                }
                                else buttonCheck[i] = false;
                            });
                          },
                        ),
                      ), //스미싱 타일
                      Container(
                        height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                        child: RadioListTile<SingingCharacter>(
                          title: Text('정부기관 사칭', style: buttonCheck[1] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                          value: SingingCharacter.corp,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState((){
                              _character = value;
                              for(int i=0; i<buttonCheck.length; i++)
                                if(_character == SingingCharacter.values[i]) {
                                  _type = i;
                                  buttonCheck[i] = true;
                                }
                                else buttonCheck[i] = false;
                            });
                          },
                        ),
                      ), // 원격제어 타일
                      Container(
                        height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                        child: RadioListTile<SingingCharacter>(
                          title: Text('지인/가족 사칭', style: buttonCheck[2] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                          value: SingingCharacter.acquaint,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState((){
                              _character = value;
                              for(int i=0; i<buttonCheck.length; i++)
                                if(_character == SingingCharacter.values[i]) {
                                  _type = i;
                                  buttonCheck[i] = true;
                                }else buttonCheck[i] = false;
                            });
                          },
                        ),
                      ), //개인정보 유출 타일
                      Container(
                        height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                        child:
                        RadioListTile<SingingCharacter>(
                          title: Text('택배사 사칭', style: buttonCheck[3] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                          value: SingingCharacter.pay,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState((){
                              _character = value;
                              for(int i=0; i<buttonCheck.length; i++)
                                if(_character == SingingCharacter.values[i]) {
                                  _type = i;
                                  buttonCheck[i] = true;
                                }else buttonCheck[i] = false;
                            });
                          },
                        ),

                      ), //결제 사칭 타일
                      Container(
                        height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                        child:
                        RadioListTile<SingingCharacter>(
                          title:  Text('금융기관 사칭', style: buttonCheck[4] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                          value: SingingCharacter.ad,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState((){
                              _character = value;
                              for(int i=0; i<buttonCheck.length; i++)
                                if(_character == SingingCharacter.values[i]) {
                                  _type = i;
                                  buttonCheck[i] = true;
                                }else buttonCheck[i] = false;
                            });
                          },
                        ),

                      ), //광고 사칭 타일
                      Container(
                        height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                        child:
                        RadioListTile<SingingCharacter>(
                          title: Text('기업 사칭', style: buttonCheck[5] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                          value: SingingCharacter.others,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState((){
                              _character = value;
                              for(int i=0; i<buttonCheck.length; i++)
                                if(_character == SingingCharacter.values[i]) {
                                  _type = i;
                                  buttonCheck[i] = true;
                                }else buttonCheck[i] = false;
                            });
                          },
                        ),

                      ), //기타 해당 사항 없음 타일
                      // Container(
                      //   height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      //   child:
                      //   RadioListTile<SingingCharacter>(
                      //     title: Text('기타(해당사항 없음)', style: buttonCheck[5] ? AppTheme.check_messageManage: AppTheme.uncheck_messageManage),
                      //     value: SingingCharacter.ad,
                      //     groupValue: _character,
                      //     onChanged: (SingingCharacter? value){
                      //       setState((){
                      //         _character = value;
                      //         for(int i=0; i<buttonCheck.length; i++)
                      //           if(_character == SingingCharacter.values[i]) {
                      //             _type = i;
                      //             buttonCheck[i] = true;
                      //           }else buttonCheck[i] = false;
                      //       });
                      //     },
                      //   ),

                     // ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                      Container(

                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ToggleButtons(
                          isSelected: toggleSelected,
                          onPressed: (int index){
                          //  int _private = (_tabController.index==0?_smsinbox.freqmessagess[_isSelected].id : (_tabController.index==1?_smsinbox.messagess[_isSelected].id : _smsinbox.recentmessage[_isSelected].id)); 잠시 에러로 인해

                            setState(() {
                              toggleSelected[index] = !toggleSelected[index];
                              if(toggleSelected[0] == true){
                                Navigator.pop(bc);
                                toggleSelected[0] = false;
                              }
                              if(toggleSelected[1] == true)
                              {
                                //print( _tabController.index.toString() + ' ' + _isSelected.toString() + ' ' + _type.toString()); 테스트용
                                //print(_type);
                                _smsinbox_freq[_isSelected].type = _type;
                                _smsinbox_danger[_isSelected].type = _type;
                                _smsinbox_recent[_isSelected].type = _type;
                                DBHelper().updateSMS(_smsinbox_freq[_isSelected].id, _smsinbox_freq[_isSelected].type);
                                //    _smsinbox.update(_tabController.index, _private, _type); 잠시 에러로 인해
                               //   _smsinbox._getupdateInfo(_private, _type);잠시 에러로 인해

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
    var _id =  _tabController.index==0?  _smsinbox_freq[_isSelected].id :(_tabController.index==1 ? _smsinbox_danger[_isSelected].id: _smsinbox_recent[_isSelected].id); //잠시 에러로 인해 주석
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
                          var id = _smsinbox_recent[_isSelected].id;
                           setState((){
                             _smsinbox_freq.removeAt(_isSelected);
                             _smsinbox_danger.removeAt(_isSelected);
                             _smsinbox_recent.removeAt(_isSelected);
                           }
                           ); // remove 해야됨
                          setState((){
                            DBHelper().deleteSMS(id);
                          //  _smsinbox.removesms(_id); 잠시 에러로 인해
                          });
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

  Future<String> get _localpath async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return documentsDirectory.path;
  }

  Future<File> get _localFile async{
    final path = await _localpath;
    return File('$path/sms.db');
}

  Future<int> existFile() async {
    try{
      final file= await _localFile;
      if(await file.exists() ) {
        print(file);
        return 1;
      } else {
        return 0;
      }
    }catch(e){
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3 );
    myFuture = getSmsList();
    }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _last_list(int type) {
    return
      SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 10, left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
            child: Column(
                children: List.generate( _smsinbox_danger.length, (index) {
                  return
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.symmetric(vertical: 10),

                    child:
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child:
                              (type==0)?
                              showScoreFreqMessage(index):
                                  type==1?
                              showScoreMessage(index):
                                      showRecentFreqMessage(index)
                              ,

                            ),  // 노란, 빨강, 오렌지 등의 사진 문자 아이콘
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
                                          children:[
                                            Container(
                                              width:115,
                                                margin: EdgeInsets.fromLTRB(8, 0, MediaQuery.of(context).size.width*0.02, 0),
                                                child: Text((type==0)? (_smsinbox_freq[index].sender.contains("#"))?"알 수 없음":_smsinbox_freq[index].sender.padRight(2):(type==1?  ((_smsinbox_danger[index].sender.contains('#CMAS')?"알 수 없음":_smsinbox_danger[index].sender)).padRight(11): (_smsinbox_recent[index].sender.contains("#CMAS")?"알 수 없음":_smsinbox_recent[index].sender)), style: _isVisible[index]?  AppTheme.smsPhone: AppTheme.subtitle)), // 휴대폰 번호
                                            Container(
                                              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0,0, 0),
                                              child: Text((type==0)?( _smsinbox_freq[index].date ) :
                                                                    (type==1? _smsinbox_danger[index].date : _smsinbox_recent[index].date),
                                                                    style: _isVisible[index] ? AppTheme.selectDate:AppTheme.unseletDate),), //받은 날짜
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.topCenter,
                                                height:40,
                                                child:
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      size: 15),
                                                  onPressed: (){
                                                    setState((){
                                                      buttonInit(index);
                                                      _isSelected = index;
                                                      _isVisible[index] = !_isVisible[index];
                                                      if(_isVisible[index]==false) {_isSelected=0;}
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),  //밑으로 내리는 버튼
                                        ]
                                      ),
                                    ),
                                    Container(
                                        height: 30,
                                        margin: EdgeInsets.fromLTRB(8, 0, 2, 0),
                                        child: Text(type==0? msgList[_smsinbox_freq[index].type] : (type==1?  msgList[_smsinbox_danger[index].type] :  msgList[_smsinbox_recent[index].type]) , style: _isVisible[index]?  AppTheme.checksmsContent: AppTheme.unchecksmsContent)), //문자 타입별 보여주는 글 // type 대신 점수 가져옴
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
                                        child: Text((type==0)? _smsinbox_freq[index].text:((type==1)? _smsinbox_danger[index].text: _smsinbox_recent[index].text)),
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
                                          },
                                          child: Text('차단해제', style: AppTheme.caption)
                                      ),
                                    )
                                  ],
                                )
                            ) // 분류수정, 차단해제 버튼
                          ],
                        ),   //문자 내용 보여주는 위젯
                      ],
                    ),
                  );
                })
            )
        ),
      );

  } //카드 보여주는 위젯

  Widget showScoreMessage(int index) =>(   _smsinbox_danger[index].prediction  > 80 ) ? const Image(image: AssetImage('assets/images/smsManage1.png')) : (_smsinbox_danger[index].prediction > 60) ? const Image(image: AssetImage('assets/images/smsManage2.png')) : const Image(image: AssetImage('assets/images/smsManage3.png')); // 점수에 따라 문자 보여줌
  Widget showScoreFreqMessage(int index) => (  _smsinbox_freq[index].prediction  > 80 ) ? const Image(image: AssetImage('assets/images/smsManage1.png')) : ( _smsinbox_freq[index].prediction > 60) ? const Image(image: AssetImage('assets/images/smsManage2.png')) : const Image(image: AssetImage('assets/images/smsManage3.png')); // 점수에 따라 Message의 문자 보여줌 // 메인 UI
  Widget showRecentFreqMessage(int index) => ( _smsinbox_recent[index].prediction  > 80 ) ? const Image(image: AssetImage('assets/images/smsManage1.png')) : (_smsinbox_recent[index].prediction > 60) ? const Image(image: AssetImage('assets/images/smsManage2.png')) : const Image(image: AssetImage('assets/images/smsManage3.png')); // 점수에 따라 Message의 문자 보여줌 // 메인 UI
  //bottom show up */

  Future<List<Sms>> getSmsList()   async {
  if(await existFile() ==1) {
      _smsinbox_danger = await DBHelper().getAllSMS();
      _smsinbox_freq = await DBHelper().getAllSMSFreq();
      _smsinbox_recent = await DBHelper().getAllSMS();

      _smsinbox_recent.sort((b, a) => a.date.compareTo(b.date));
      _smsinbox_danger.sort((b, a) => a.prediction.compareTo(b.prediction));

      return _smsinbox_recent;
    }
    else {
      _smsinbox_danger = [];
      _smsinbox_freq = [];
      _smsinbox_recent = [];
      return [];
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ((ModalRoute.of(context))!.settings.arguments) == 1? AppBarBack( title: '메시지 관리',) : AppBarBack( title: 'Url 검사결과',),


        body:
        Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 60,
                color: Color(0xfff0f0f0),
                child: TabBar(
                  onTap: (index){
                    if(_tabController.indexIsChanging){
                      _idx = _tabController.index;
                    }
                    setState(() {
                      _idx =index;
                      print(_idx);
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
                          color: (_idx==0) ? Colors.transparent:Colors.white,
                          border:Border.all(color: (_idx==0) ? Colors.transparent : AppTheme.greyText),

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
                          Border.all(color: (_idx==1) ? Colors.transparent : AppTheme.greyText),
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
                          border:Border.all(color: (_idx==2) ? Colors.transparent : AppTheme.greyText),
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

            FutureBuilder(
              future:myFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if( !snapshot.hasData){
                    return Container();
                  }
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }
                  else{
                  return

                    TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                  (_smsinbox_danger.length>0) ?  _last_list(0):noSmishing(),
                    ( _smsinbox_danger.length>0) ? _last_list(1):noSmishing(),
                    ( _smsinbox_danger.length>0) ?_last_list(2): noSmishing(),
                  ],

                )
                 ;}
              }

            )
            )
          ],
        )
    );
  }


}
/*
//문자 번호의 빈도에 따라 정렬하기 위한 클래스
class Freqmessage{
  List<SmsInfo> smslist;
  Map <String, dynamic> dic={};
  List<SmsInfo> retsmsList =[];
  Freqmessage({required this.smslist});

  List<SmsInfo> retFreqList(){
    int idx=0;
    for(int i=0; i<smslist.length ; i++) {
      if(dic.containsKey(smslist[i].phone) ){
        dic[smslist[i].phone] = dic[smslist[i].phone] + 1;
      }
      else {
        dic.addAll({smslist[i].phone: 0});
      }
    }
    var sortedByValueMap = Map.fromEntries(dic.entries.toList()..sort((b,a) => a.value.compareTo(b.value)));

    sortedByValueMap.forEach((key, value) {
      for(int i=0; i<smslist.length; i++){
        if( key.contains(smslist[i].phone)) {
          retsmsList.add(smslist[i]);
        }
      }
    });

    return retsmsList;
  }
}
*/
