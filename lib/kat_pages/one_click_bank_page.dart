/**
 * update: 2022-08-23
 * OneClickPage
 * 최종 작성자: 김진일
 *
 * 해야할 작업:
 *  1. 은행 별 이미지 (Done)
 *  2. 전화로 바로 넘어가도록 (다시)
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Theme.dart';
import '../kat_widget/kat_appbar_back.dart';

class OneClickBank extends StatelessWidget {
  const OneClickBank({Key? key, required this.bank_name, required this.phone_list, required this.image}) : super(key: key);
  final String bank_name ;
  final List<String> phone_list ;
  final String image ;

  _launchCaller(String phone_number) async {
    var url = Uri(scheme: 'tel', path: phone_number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _one_click_call(BuildContext context) {
    return Container(
      // color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.2,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 눌러서 통화하기
          Container(
            height: 20,
            child: Image.asset('assets/images/bank_call.png', width: MediaQuery.of(context).size.width * 0.4,)
          ),

          /// 은행 이미지
          InkWell(
            onTap: () {
              _launchCaller(phone_list[0]);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 5),
              height: 60,
              child: Image.asset('assets/bank_logo/' + image),
            ),
          ),

          /// hint_text
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset('assets/images/call_connect_text.png', width: MediaQuery.of(context).size.width * 0.4,)
          ),
        ],
      )
    );
  }

  Widget _phone_numbers(BuildContext context) {
    List<String> internal_phone_numbers = phone_list;
    List<String> external_phone_numbers = ['82 - 2 - 2006 - 5000'] ;

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05,
                              left:  MediaQuery.of(context).size.width * 0.3,
                              right: MediaQuery.of(context).size.width * 0.3),
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
    return Container (
      padding: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/launch_end.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const AppBarBack(title: '원클릭 신고'),
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _one_click_call(context),
                _phone_numbers(context),
                _logo(context),
              ],
            )
        ),
      ),
    );
  }
}
