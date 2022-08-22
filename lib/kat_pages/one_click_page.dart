/**
 * update: 2022-08-18
 * OneClickPage
 * 최종 작성자: 김진일
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

import '../kat_widget/kat_appbar_back.dart';
import '../kat_widget/kat_webview.dart';
import '../theme.dart';

class OneClickPage extends StatefulWidget {
  const OneClickPage({Key? key}) : super(key: key);

  @override
  _OneClickPageState createState() => _OneClickPageState();
}


class _OneClickPageState extends State<OneClickPage> {
  TextEditingController search_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    search_controller.addListener(() { });
  }

  @override
  void dispose() {
    search_controller.dispose();
    super.dispose() ;
  }

  Widget _search_widget() {

    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: AppTheme.blueText,),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.57,
            child: TextField(
              controller: search_controller,
              decoration: const InputDecoration(
                hintText: '은행명 입력',
                border: InputBorder.none,
              ),
              onChanged: (text) {},
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: IconButton(icon: Icon(Icons.close), color: AppTheme.grey, onPressed: () { search_controller.clear(); },),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: IconButton(icon: Icon(Icons.search), color: AppTheme.blueText ,onPressed: () {  },),
          )
        ],
      )
    );
  }


  /*

  Widget _search_list() {
    return SingleChildScrollView(
      child: Container(
        height: 40,
        child: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            if ( data.hasError ) {
              return Center(child: Text("${data.error}"),) ;
            } else if ( data.hasData ) {
              var items = data.data as List<Banks> ;
              return ListView.builder(
                itemCount: items == null ? 0 : items.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Text(items[index].name),
                  )
                }
              );
            }
          }
        ),
      ),
    );
  }

  */

  Widget _bank_search() {
    const double PADDING_TOP = 30.0;
    return Container(
      padding: EdgeInsets.only(top: PADDING_TOP),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('지급 정지 신청·계좌에 1원 입금 시', style: AppTheme.title_blue),
          const Text('해당 은행 고객센터로 연결됩니다.', style: AppTheme.caption),
          Padding(padding: EdgeInsets.only(top: 20),),
          _search_widget(),
          // _search_list(),
        ],
      ),
    );
  }

  Widget _declaration() {

    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 40)),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset('assets/images/6045.png'),
                  ),
                  onTap: () {},
                ),

                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset('assets/images/6046.png'),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _other_functions() {
    const double HEIGHT = 100;
    const double LABEL_HEIGHT = 40;
    List<String> imgList = ['deposit_loan_credit_card_lookup', 'general_certificate_revocation',
                            'check_my_phone_number', 'check_the_authenticity_of_official_documents'];
    const List<String> urlList = ['https://www.payinfo.or.kr/payinfo.html', 'https://login.kt.com/wamui/NewKTFindIdPhoneCertifiedFront.do', '', 'https://www.gov.kr/mw/EgovPageLink.do?link=confirm/AA040_confirm_id'] ;
    const List<String> titleList = ['예금/대출/신용카드 조회', '내 명의 핸드폰 찾기', '', '공문서 진위 확인'] ;

    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(imgList.length, (index) {
          return InkWell(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Card(
                    shadowColor: AppTheme.grey,
                    elevation: 10,
                    child: Image.asset('assets/images/' + imgList[index] + '.png', fit: BoxFit.fill, height: MediaQuery.of(context).size.height * 0.15,),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: LABEL_HEIGHT,
                  margin: const EdgeInsets.only(top: HEIGHT - LABEL_HEIGHT - 10),
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                  alignment: FractionalOffset.bottomCenter,
                  child: Image.asset('assets/images/' + imgList[index] + '_label.png', fit: BoxFit.fill),
                ),
              ],
            ),
            onTap: () {
              if (index != 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => KaTWebView(title: titleList[index], url: urlList[index],))) ;
              } else {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const )) ;
              }
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
          title: "원클릭 신고"
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width * 0.1,
                right: MediaQuery
                    .of(context)
                    .size
                    .width * 0.1),
            child: Column(
              children: [
                _bank_search(),
                _declaration(),
                _other_functions(),
              ],
            ),
          )
      ),
    );
  }
}
