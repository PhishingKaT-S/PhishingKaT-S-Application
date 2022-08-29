/*
* write:Jiwon Jung
* date: 7/29
* content: 0.5, birthday and nickname
*   7/30: modifying the category of the jobs and outline was changed
* */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';
import '../db_conn.dart';
import '../kat_widget/launch_appbar.dart';
import '../providers/launch_provider.dart';
import 'celebration.dart';

import '../Theme.dart';
import '../kat_widget/launch_bottombar.dart';

/*
* 해야할 일 출생년도에서 선택하면 년도를 바꿔줘야됨
* 성별을 한개만 선택할 수 있게 해야됨,
* 나의 유형을 한 개만 선택할 수 있게 해야됨
* 확인을 누르면 내가 선택한 정보들이 DB로 들어가야됨 그리고
* celebration화면으로 넘어감
* */

class Users{
  late String? IMEI="";
  late String nickname='';
  late int type;
  late bool gender;
  late String year;
  late String phone;

  Users(String name, int type, bool gender, String year, String phone, String? IMEI)
  {
    nickname = name;
    this.type = type;
    this.gender = gender;
    this.year= year;
    this.phone = phone;
    this.IMEI = IMEI;
  }
}

class DetailInfo extends StatefulWidget {
  String _phoneNumber='';
  DetailInfo({required String phoneNumber}){
    _phoneNumber = phoneNumber;
  }
  @override
  State<DetailInfo> createState() => _detailed_infoState(_phoneNumber);
}

class _detailed_infoState extends State<DetailInfo> {
  String _phone = '';
  _detailed_infoState(String phone) : super(){
     _phone = phone;
  }
  late Users users;
  String year = ' ';
  List<String> itemTypes = ['남', '여'];
  List<bool> _isSelected = [true, false]; // gender toggle button

  List<bool> _categorySelected=[true, false, false, false];
  List<String> _job_Category=['일반', '직장인','실버','주부'];

  DateTime selectedDate = DateTime.now();
  TextEditingController yController = TextEditingController();
  bool autovalidate = false;
  TextEditingController nicknameController = TextEditingController();

  /* Users data */
  int type = 0;
  bool gender = false;

  String? _identifier = 'Unknown'; // IMEI

  @override
  void initState() {
    super.initState();
    initUniqueIdentifierState();
  }

  Future<void> initUniqueIdentifierState() async {
    String? identifier ;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;
    setState(() {
      _identifier = identifier;
    });
  }


  yearPicker() { //year Picker? 함수
    final year = DateTime.now().year;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '출생년도를 입력하세요',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 4.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[200],
            child: YearPicker(
              selectedDate: DateTime(year),
              firstDate: DateTime(year - 100),
              lastDate: DateTime(year),
              onChanged: (value) {
                yController.text = value.toString().substring(0, 4);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _category_button() {
    return Container(
      child: ToggleButtons(
          selectedColor: Colors.white,
          fillColor: Colors.white,
          renderBorder: false,
          onPressed: (int val) {
            setState((){
              for(int index =0; index<_categorySelected.length; index++) {
                if(index == val) {
                  type = index;
                  _categorySelected[index] = true;
                }else{
                  _categorySelected[index] = false;
                }

              }
            });
          },
          isSelected: _categorySelected,
          children:List<Widget>.generate(4, (index)=>
              Padding(padding: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.06, right:MediaQuery.of(context).size.width*0.06),
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: _categorySelected[index] ? Colors.blue: Colors.grey[200],
                          borderRadius: BorderRadius.circular(35) ),
                      alignment: Alignment.center,
                      child:Text(
                          (_job_Category[index] ), style: _categorySelected[index] ? AppTheme.selected : AppTheme.unseleted),
                  ),
                ),
              ))
      )
    );
  }

  Container _nickname() {
    return Container(
                padding: EdgeInsets.only(right: 5),
                height: 48,
                child: TextFormField(
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(6)
                  ],
                  controller: nicknameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    labelText: '별명 (최대 6자)',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.blue, width:0.0),
                    ),
                    filled: true,
                  ),
                ),
              );
  }

  Align _over_fourteen() {
    return Align(
                alignment: Alignment.centerLeft,
                  child:
                      Text('만 14세 이상만 회원으로 가입할 수 있습니다.', style: AppTheme.caption,));
  }

  Widget _birth_gender() {
    return Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: <Widget>[
                      Expanded( // 이어 피커
                          child:
                          GestureDetector(
                        onTap: yearPicker,
                        child: AbsorbPointer(
                          child:
                          Container(
                            padding: EdgeInsets.only(bottom:2, top:2),
                            child: TextFormField(
                              controller: yController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:Colors.blue,
                                    width:2
                                  )
                                ), //border 아웃라인
                                labelText: '출생년도',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color:Colors.blue, width:0.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onSaved: (val){
                                year = yController.text;
                                print(yController.text);
                                },
                              validator: (val){
                                if(val == null || val.isEmpty)
                                  {
                                    return 'Year is necessary';
                                  }
                                return null;
                              },
                            ),
                          )
                        ),
                      )
                      ),
                      SizedBox(width: 10,),// 이어피커
                      ToggleButtons(
                            selectedColor: Colors.white,
                            fillColor: Colors.white,
                            renderBorder: false,
                            onPressed: (int val) {
                              setState((){
                                    for(int index =0; index<_isSelected.length; index++) {
                                      if(index == val) {
                                        _isSelected[index] = true;
                                        index==0 ? gender = false : gender= true ;
                                      }else{
                                        _isSelected[index] = false;
                                      }

                                    }
                              });
                            },
                            isSelected: _isSelected,
                            children:List<Widget>.generate(2, (index)=>
                              Padding(padding: EdgeInsets.all(0),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                    padding: EdgeInsets.only(left: 20, right:20),
                                    height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: _isSelected[index] ? AppTheme.startBackground: Colors.white,
                                    border: Border.all(color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(5) ),
                                    alignment: Alignment.center,
                                  child:Text(
                                      (itemTypes[index]), style: _isSelected[index] ? AppTheme.selecttoggleGender :AppTheme.unselecttoggleGender
                                  )
                                  ),
                              ),
                              ))
                          ),
                      // 남자 버튼
                  ],
                ),
              );
  }

  Align _guide_text() {
    return Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  '보다 정확한 스미싱 예방을 위해 \n정보를 입력해주세요',   //위의 안내글을 입력받아서 state를 변화시킴
                  style: AppTheme.serviceAuth,  //스타일
                ),
              );
  }

  //DB
  Future main(Users user) async{
    final conn = await MySqlConnection.connect(Database.getConnection());

    var register = await conn.query(
        'insert into users (phone_number, IMEI, nickname, year, gender, profession) select ?, ?, ?,?, ?, ? where not exists (select * from users where phone_number like (?))', [user.phone, user.IMEI, user.nickname, user.year, user.gender, user.type, user.phone]);

    conn.close();

    if(register.isNotEmpty){
      print('회원 추가 완료');
      context.watch<LaunchProvider>().set_userinfo(user.nickname, user.year, user.gender, user.type);
      return register.first[0];
    }
    else return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //할일 onPress에 DB로 저장할 수 있게 해야됨
        bottomNavigationBar: bottomBar(title:'확인', onPress: () async {
          if((yController.text != '') && (nicknameController.text!='')) {
            users = Users(nicknameController.text, type, gender, yController.text,_phone, _identifier); // String name, int type, bool gender, String year, String phone
              print(users.nickname + " " +   users.gender.toString() + " " + users.phone + " " + users.type.toString() + " " + users.year);
                var ret = await main(users);
                print(ret);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => CeleBration()));
          }
        }),
        appBar: certification_appbar(Colors.blue, Colors.blue),
        body: SingleChildScrollView(
          child:
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              children: <Widget>[
                _guide_text(),//위의 안내글

                SizedBox(height: 30,),//위 위젯과 거리 조절

                //출생년도, 남녀 버튼이 있음

                /*
                * 출생년도 출력과 남 여 버튼 하나만 선택할 수 있게 해야됨
                * */

                _birth_gender(),


                SizedBox(height: 10,),

                _over_fourteen(), //14세 이상 안내글

                SizedBox(height: 10,),

                //별명
                _nickname(),

                SizedBox(height:20),

                Align(alignment: Alignment.bottomLeft,child: Text('나의 유형', style: AppTheme.title,),),

                SizedBox(height: 10,),

                //유형 중 하나만 선택할 수 있게 해야됨
                _category_button()

              ],
            ),
          ),
        )
    );
  }
}
