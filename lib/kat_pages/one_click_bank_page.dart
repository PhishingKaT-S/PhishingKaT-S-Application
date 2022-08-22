
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class OneClickBank extends StatelessWidget {
  const OneClickBank({Key? key}) : super(key: key);

  Widget _one_click_call(BuildContext context) {
    return Container(
      // color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.2,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// 눌러서 통화하기
          Container(
            height: 30,
            child: Text(">> 눌러서 통화하기 <<"),
          ),

          /// 은행 이미지
          Container(
            padding: const EdgeInsets.only(top: 25 ),
            height: 60,
            color: Colors.lightBlueAccent,
          ),

          /// hint_text
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset('assets/images/call_connect_text.png', width: MediaQuery.of(context).size.width * 0.5,)
          ),
        ],
      )
    );
  }

  Widget _phone_numbers(BuildContext context) {
    List<String> internal_phone_numbers = ['1588-5000 - # - 1', '1599-5000', '1533-5000'];
    List<String> external_phone_numbers = ['82 - 2 - 2006 - 5000'] ;

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, left:  MediaQuery.of(context).size.width * 0.25, right: MediaQuery.of(context).size.width * 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(internal_phone_numbers.length, (index) {
              return Text(internal_phone_numbers[index], style: const TextStyle(fontSize: 17, color: AppTheme.blueText)) ;
            }),
          ),
          const Padding(padding: EdgeInsets.only(top: 10),),
          Container(height: 2, color: AppTheme.whiteGreyBackground),
          const Padding(padding: EdgeInsets.only(top: 7),),
          const Text('해외', style: TextStyle(fontSize: 16, color: AppTheme.greyText)),
          Column(
            children: List.generate(external_phone_numbers.length, (index) {
              return Text(external_phone_numbers[index], style: const TextStyle(fontSize: 17, color: AppTheme.blueText)) ;
            }),
          )
        ]
      )
    );
  }

  Widget _logo(BuildContext context) {
    return Flexible(
        fit: FlexFit.loose,
        child: Container (
            padding: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/launch_end.png', width: MediaQuery.of(context).size.width,fit: BoxFit.fitWidth)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const AppBarBack(title: '원클릭 신고'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _one_click_call(context),
            _phone_numbers(context),
            _logo(context),
          ],
        )
      ),
    );
  }
}
