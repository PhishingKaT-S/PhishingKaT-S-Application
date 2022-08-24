/**
 * update: 2022-08-23
 * PrepaidPhonePage
 * 최종 작성자: 김진일
 *
 * 해야할 작업 : 명의 도용 API 연결
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class PrepaidPhonePage extends StatefulWidget {
  const PrepaidPhonePage({Key? key}) : super(key: key);

  @override
  _PrepaidPhonePageState createState() => _PrepaidPhonePageState();
}

class _PrepaidPhonePageState extends State<PrepaidPhonePage> {
  TextEditingController name_controller = TextEditingController() ;
  TextEditingController year_controller = TextEditingController() ;

  Widget _title() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: const Text('내 명의로 된 선불폰 확인하기', style: AppTheme.title_blue),
    ) ;
  }

  Widget _user_input_field() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.greyText, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: name_controller,
                decoration: const InputDecoration(
                  hintText: '이름',
                  border: InputBorder.none,
                ),
              ),
            )
          ),
          const Padding(padding: EdgeInsets.only(top: 10),),
          Container(
            decoration: BoxDecoration(
            border: Border.all(color: AppTheme.greyText, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                controller: year_controller,
                decoration: const InputDecoration(
                  hintText: '생년월일 8자리(YYYYMMDD)',
                  border: InputBorder.none,
                ),
              ),
            )
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          const Text('* KT 통신사 이용고객만 가능합니다.', style: AppTheme.caption,),
        ],
      )
    );
  }

  Widget _check_button() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(AppTheme.blueText),
        ),
        child: const Text('확인', style: AppTheme.whitetitle),
        onPressed: () { },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(title: '내 명의 핸드폰 개통확인'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          children: [
            _title(),
            _user_input_field(),
            _check_button(),
          ],
        ),
      ),
    );
  }
}
