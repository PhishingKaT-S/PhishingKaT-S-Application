/*
* write:Jiwon Jung
* date: 7/29
* content: 0.5, birthday and nickname
*   7/30: modifying the category of the jobs and outline was changed
* */

import 'package:flutter/material.dart';
import '../kat_widget/launch_appbar.dart';
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

class privateInfo{
  
}


class DetailInfo extends StatefulWidget {
  const DetailInfo({Key? key}) : super(key: key);

  @override
  State<DetailInfo> createState() => _detailed_infoState();
}

class _detailed_infoState extends State<DetailInfo> {
  String year = ' ';
  List<String> itemTypes = ['남', '여'];
  GlobalKey<FormState> _fkey = GlobalKey<FormState>();
  List<bool> _isSelected = [false, false]; // gender toggle button

  List<bool> _categorySelected=[false, false, false, false];
  List<String> _job_Category=['일반', '직장인','실버','주부'];

  DateTime selectedDate = DateTime.now();
  TextEditingController yController = TextEditingController();
  bool autovalidate = false;
  TextEditingController nicknameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //할일 onPress에 DB로 저장할 수 있게 해야됨
        bottomNavigationBar: bottomBar(title:'확인', onPress: (){
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CeleBration()));
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

                SizedBox(height:30),

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
                height:52,
                child: TextFormField(
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
                height: 52,
                child: Row(
                  children: <Widget>[
                      Flexible( // 이어 피커
                          flex: 4,
                          child:
                          GestureDetector(
                        onTap: yearPicker,
                        child: AbsorbPointer(
                          child:TextFormField(
                            controller: yController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:Colors.blue,
                                  width:2.0
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
                              print('123123');
                              print(yController.text);
                              },
                            validator: (val){
                              print('123123');
                              if(val == null || val.isEmpty)
                                {
                                  return 'Year is necessary';
                                }
                              return null;
                            },
                          )
                        ),
                      )
                      ),
                      SizedBox(width: 10,),// 이어피커
                      Flexible(
                          flex: 3,
                          child: ToggleButtons(
                            selectedColor: Colors.white,
                            fillColor: Colors.white,
                            renderBorder: false,
                            onPressed: (int val) {
                              setState((){
                                    for(int index =0; index<_isSelected.length; index++) {
                                      if(index == val) {
                                        _isSelected[index] = true;

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
                                    padding: EdgeInsets.only(left: 20, right:20,),
                                    height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: _isSelected[index] ? AppTheme.startBackground: Colors.white,
                                    border: Border.all(color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(5) ),
                                    alignment: Alignment.center,
                                  child:Text(
                                      (itemTypes[index]), style: _isSelected[index] ? AppTheme.selected:AppTheme.unseleted
                                  )
                                  ),
                              ),
                              ))
                          )
                      ), // 남자 버튼
                  ],
                ),
              );
  }

  Align _guide_text() {
    return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '보다 정확한 스미싱 예방을 위해 \n정보를 입력해주세요',   //위의 안내글을 입력받아서 state를 변화시킴
                  style: AppTheme.title,  //스타일
                ),
              );
  }

}
