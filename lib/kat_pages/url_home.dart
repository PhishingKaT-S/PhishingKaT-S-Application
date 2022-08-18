/*
* write: jiwon
* date: 8/10
* scene 1.7.1~ 1.8.1
*
*
* 8/17 below popup implementation
* */

import 'package:flutter/material.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class InspectFeedback extends StatefulWidget {
  const InspectFeedback({Key? key}) : super(key: key);

  @override
  State<InspectFeedback> createState() => _InspectFeedbackState();
}

enum SingingCharacter { smishingURL, remoteControll, privateInfo, scam, teleMarketing, insurance, others}// radio button category

class _InspectFeedbackState extends State<InspectFeedback> with SingleTickerProviderStateMixin {

  final _isVisible = List<bool>.filled(100, false);
  int _idx =0; // 몇 번째 문자를 보고 있는지에 대한 변수
  int flag = 0; //
  late TabController _tabController; // tab bar를 위한 변수
  int _isSelected =0;       //
  bool _changeCategory=false; // 분류수정이 눌렸는지에 대한 변수
  List<bool> toggleSelected=[false, false];
  SingingCharacter? _character = SingingCharacter.smishingURL;
  void buttonInit(int num){
      _isSelected =0;
      toggleSelected  = [false, false]; // 토글 버튼에 대한 index
      _changeCategory = false;   //분류 수정을 눌렀는지 아닌지
      _character = SingingCharacter.smishingURL;  //라디오 버튼 값 변수
      _isVisible.fillRange(0, num, false);
      _isVisible.fillRange(num+1, _isVisible.length, false);

  }

  void _settingModalBottomSheet(context)
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
             height: MediaQuery.of(context).size.height!*0.55,
              width: MediaQuery.of(context).size.width,
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
                    SizedBox(height: MediaQuery.of(context).size.height!*0.04,),
                    Container(

                      height: MediaQuery.of(context).size.height!*0.08,
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
                          Container(width: MediaQuery.of(context).size.width*0.496,  color: Colors.grey[300],
                            child:
                            Center(child: Text('취소', style: AppTheme.whitetitle)),
                          ),
                          Container(width: MediaQuery.of(context).size.width*0.496, color: AppTheme.startBackground,
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


  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _last_list(int type) {
    List<String> msgList = ['텔레마케팅으로 분류된 문자입니다.','지인사칭으로 분류된 문자입니다.', '위험 URL 포함으로 분류된 문자입니다.'];
    List<int> scoreList = [90, 70, 60, 70, 30, 10, 30, 90];

    if(type==2)
        scoreList.sort((b,a) => a.compareTo(b));


      return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: List.generate(scoreList.length, (index) {
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
                        child: (scoreList[index] > 80 ) ? const Image(image: AssetImage('assets/images/smsManage1.png')) : (scoreList[index] > 60) ? const Image(image: AssetImage('assets/images/smsManage2.png')) : const Image(image: AssetImage('assets/images/smsManage3.png')),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[

                                    Container(

                                        margin: EdgeInsets.fromLTRB(8, 0, MediaQuery.of(context).size.width*0.02, 0),
                                        child: Text('010-1234-1234', style: _isVisible[index]?  AppTheme.smsPhone: AppTheme.subtitle)),
                                    Row(
                                      children:<Widget> [
                                        Container(
                                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0,0, 0),
                                            child: Text('2021-10-26 11:40', style: _isVisible[index]?  AppTheme.selectDate:AppTheme.unseletDate),),

                                        IconButton(
                                            icon: Icon(
                                                Icons.arrow_drop_down,
                                                size: 10),
                                            onPressed: (){
                                              setState((){
                                                buttonInit(index);
                                                _isSelected = index;
                                                _isVisible[index] = !_isVisible[index];
                                                if(_isVisible[index]==true) flag++;
                                                else {flag--; _isSelected=0;}
                                              });
                                            },
                                          ),



                                      ],
                                    ),
                                  ]
                              ),
                            ),

                            Container(
                              height: 30,
                                margin: EdgeInsets.fromLTRB(8, 0, 2, 0),
                                child: Text(msgList[index%3], style: _isVisible[index]?  AppTheme.checksmsContent: AppTheme.unchecksmsContent)),
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
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.749,
                                height: MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.blueText)

                                ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('고객님의 택배가 반송 처리되었습니다. 자세한 사항은 아래 링크를 통해 확인할 수 있습니다.'),
                                  )
                          )), // 문자 내용 메시지 보여지는 text

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
                                    onPressed: (){},
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
  }

  BottomAppBar BottomAppbar(BuildContext context) {
    return BottomAppBar(
      child:
      Container(
        decoration: BoxDecoration(

            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)
            ),
            border: Border.all(
                width: 0.1,
                style:BorderStyle.solid
            )
        ),
        height: _changeCategory? MediaQuery.of(context).size.height!*0.55 : 0,
        width: _changeCategory ? MediaQuery.of(context).size.width: 0,
        child: Visibility(
          visible: _changeCategory,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  height: _changeCategory? (MediaQuery.of(context).size.height)!*0.46 : 0,
                  child: Column(children: <Widget>[
                    Container(
                      height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      child: Center(
                        child: RadioListTile<SingingCharacter>(

                          title: const Text('스미싱 의심 URL'),
                          value: SingingCharacter.smishingURL,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState((){
                              _character = value;
                            });
                          },
                        ),
                      ),


                    ),
                    Container(
                      height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      child: RadioListTile<SingingCharacter>(
                        title: const Text('원격제어 설치 유도'),
                        value: SingingCharacter.remoteControll,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value){
                          setState((){
                            _character = value;
                          });
                        },
                      ),

                    ),
                    Container(
                      height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      child: RadioListTile<SingingCharacter>(
                        title: const Text('개인정보유출'),
                        value: SingingCharacter.privateInfo,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value){
                          setState((){
                            _character = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      child:
                      RadioListTile<SingingCharacter>(
                        title: const Text('지인 및 기관 사칭'),
                        value: SingingCharacter.scam,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value){
                          setState((){
                            _character = value;
                          });
                        },
                      ),

                    ),
                    Container(
                      height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      child:
                      RadioListTile<SingingCharacter>(
                        title: const Text('텔레마케팅'),
                        value: SingingCharacter.teleMarketing,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value){
                          setState((){
                            _character = value;
                          });
                        },
                      ),

                    ),
                    Container(
                      height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      child:
                      RadioListTile<SingingCharacter>(
                        title: const Text('보험 및 대출 안내'),
                        value: SingingCharacter.insurance,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value){
                          setState((){
                            _character = value;
                          });
                        },
                      ),

                    ),
                    Container(
                      height: ((MediaQuery.of(context).size.height-20)*0.44)/7,
                      child:
                      RadioListTile<SingingCharacter>(
                        title: const Text('기타(해당사항 없음)'),
                        value: SingingCharacter.others,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value){
                          setState((){
                            _character = value;
                          });
                        },
                      ),

                    ),
                  ],)
              ),
              Container(

                height: MediaQuery.of(context).size.height!*0.08,
                child: ToggleButtons(
                  isSelected: toggleSelected,
                  onPressed: (int index){
                    setState(() {
                      toggleSelected[index] = !toggleSelected[index];
                      if(toggleSelected[0] == true){
                        toggleSelected[0] = false;
                        _changeCategory=false;
                      }
                      if(toggleSelected[1] == true)
                      {
                        print(_character);
                        _changeCategory=false;
                        toggleSelected[1] = false;
                      }
                    });
                  },
                  children: <Widget>[
                    Container(width: MediaQuery.of(context).size.width*0.496,  color: Colors.grey[300],
                      child:
                      Center(child: Text('취소', style: AppTheme.whitetitle)),
                    ),
                    Container(width: MediaQuery.of(context).size.width*0.496, color: AppTheme.startBackground,
                      child:
                      Center(child: Text('변경하기', style: AppTheme.whitetitle)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      ),



    );
  } //bottom show up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (flag == 0) ? AppBarBack( title: '메세지 관리',) : AppBarBack( title: 'Url 검사결과',),


      body:Column(
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
                    child: Text('최신순', style: (_idx==0)? AppTheme.selected:AppTheme.unseletedURL),
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
                  _last_list(1),
                  _last_list(2),
                  _last_list(3),
                ],

          ))
        ],
      )
    );
  }


}

