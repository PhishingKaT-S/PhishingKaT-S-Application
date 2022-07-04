/*
* Provider 예시를 위한 페이지
* 2022-06-29
* 유이새
*/

import 'package:flutter/material.dart';
/*
* ChangeNotifier를 extends하여 사용
* 사용법: _testProvider = Provider.of<TestProvider>(context); => 이 state를 사용해야 하는 곳에서 사용하는 방법.
*/
class TestProvider extends ChangeNotifier{
  TestProvider(){
    //여기에 입력하는건 이제 이 함수를 생성하자마자 실행 하는 것들
  }

  int? My_state;

  void sample(){
    //이거는 함수를 불렀을 때 실행해야 하는 내용
    notifyListeners(); //이거를 써줘야 해당 내용에 대해서 페이지를 다시 그려준다.
  }
}