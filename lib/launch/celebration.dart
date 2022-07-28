/*
   write: jiwon
   date: 7 26
   discription 0.6 celebration for joinning
 */


import 'package:flutter/material.dart';

import '../Theme.dart';
import '../kat_widget/launch_appbar.dart';


/*
* 이 화면이 보이면 3초후 꺼지고 진짜 home으로 돌아감
*
* */

class CeleBration extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _height = (MediaQuery.of(context).size.height~/5);
    return Scaffold(
      bottomNavigationBar: Container(child:
          Image.asset('assets/images/launch_end.png', fit: BoxFit.fill),
          width: double.infinity,
          height: 3*_height.toDouble(),
      ),//이미지 불러오기
      appBar: certification_appbar(Colors.white, Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child:
          Container(
            child: Column(
              children: <Widget>[
                Align(
              alignment: Alignment.centerLeft,
                      child: Text(
                      '당신과,\n당신의 소중한 이웃들이\n피싱으로부터 안전할 수 있게', style: AppTheme.title,
                  ),
                    ),
                SizedBox(height: 20,),
                    Align(alignment: Alignment.centerLeft,
                        child: Text('피싱캣S는 모두가 안심하고\n소통할 수 있는 세상을 만듭니다', style: AppTheme.body1,), ),
                
              ],
            ),
          ),//당신과 당신의

      )

    );
  }
}
