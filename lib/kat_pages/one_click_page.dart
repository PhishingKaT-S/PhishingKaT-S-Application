/**
 * update: 2022-08-18
 * OneClickPage
 * 최종 작성자: 김진일
 *
 * 완료
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' ;
import 'package:phishing_kat_pluss/kat_pages/one_click_bank_questions_page.dart';
import 'package:phishing_kat_pluss/kat_pages/prepaid_phone_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../kat_widget/kat_appbar_back.dart';
import '../kat_widget/kat_webview.dart';
import '../theme.dart';
import 'one_click_bank_page.dart';

/**
 * Bank Class
 * assets/json/bank.json
 * 데이터 구조
 */
class Bank {
  final String name ;
  final List<String> phones ;
  final String image ;
  Bank({required this.name, required this.phones, required this.image}) ;

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name : json['name'],
      phones : List<String>.from(json['ph']),
      image: json['image'],
    );
  }
}


class OneClickPage extends StatefulWidget {
  const OneClickPage({Key? key}) : super(key: key);

  @override
  _OneClickPageState createState() => _OneClickPageState();
}


class _OneClickPageState extends State<OneClickPage> {
  TextEditingController search_controller = TextEditingController();
  List<Bank> _banks = [] ;
  late Bank _selected_bank_name ;

  Future ReadJsonData() async {
    final String loadJson = await rootBundle.loadString('assets/json/bank.json');
    final res = json.decode(loadJson);

    for (var bank in res['banks']) {
      _banks.add(Bank.fromJson(bank)) ;
    }
  }

  @override
  void initState() {
    super.initState();
    search_controller.addListener(() { });
    ReadJsonData();
  }

  @override
  void dispose() {
    search_controller.dispose();
    super.dispose() ;
  }

  _launchCaller(String phone_number) async {
    var url = Uri(scheme: 'tel', path: phone_number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
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
              textInputAction: TextInputAction.search,
              controller: search_controller,
              decoration: const InputDecoration(
                hintText: '은행명 입력',
                border: InputBorder.none,
              ),
              onSubmitted: (text) {
                bool isSearched = false;
                for (var bank in _banks) {
                  if ( bank.name.contains(text)) {
                    isSearched = true;
                    Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => OneClickBank(bank_name: bank.name,
                                    phone_list: bank.phones,
                                    image: bank.image,)));
                  }
                }

                /// 입력한 은행을 찾지 못하였을 경우
                if ( !isSearched ) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const BankQuestionsCenter()
                  ));
                }
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: IconButton(icon: Icon(Icons.cancel), color: AppTheme.grey, onPressed: () { search_controller.clear(); },),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: IconButton(icon: Icon(Icons.search), color: AppTheme.blueText ,onPressed: () {  },),
          )
        ],
      )
    );
  }

  Widget _search_list() {
    return SingleChildScrollView(
      child: _banks.isNotEmpty ? Container(
        height: 150,
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                  itemCount: _banks.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => OneClickBank(bank_name: _banks[index].name,
                                                               phone_list: _banks[index].phones,
                                                               image: _banks[index].image,)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 50,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.grey,
                            )
                          )
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_banks[index].name, style: AppTheme.body1,),
                        )
                      )
                    );
                  },
                )
            )
          ],
        ),
      ) : Container() ,
    );
  }

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
          Padding(padding: EdgeInsets.only(top: 40),),
          // _search_list(),
        ],
      ),
    );
  }

  Widget _declaration() {

    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
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
                  onTap: () {
                    _launchCaller('1332');
                  },
                ),

                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset('assets/images/6046.png'),
                  ),
                  onTap: () {
                    _launchCaller('112');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('현재 서비스 이용시간이 아닙니다.'),
            content: const Text('서비스 이용 시간\n매일 09:00~22:00'),
            actions: <Widget>[
              TextButton(
                child: const Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  Widget _other_functions() {
    const double HEIGHT = 100;
    const double LABEL_HEIGHT = 40;
    List<String> imgList = ['deposit_loan_credit_card_lookup', 'general_certificate_revocation',
                            'check_my_phone_number', 'check_the_authenticity_of_official_documents'];
    const List<String> urlList = ['https://www.payinfo.or.kr/extl/qryExtlFxamtIns.do?menu=1', 'https://login.kt.com/wamui/NewKTFindIdPhoneCertifiedFront.do', '', 'https://www.gov.kr/mw/EgovPageLink.do?link=confirm/AA040_confirm_id'] ;
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
                if ( index == 0 ) {
                  DateTime _now = DateTime.now() ;

                  if ( _now.hour < 9 || _now.hour > 22 ) {
                    /**
                     * 서비스 이용 불가 표시
                     */
                    _displayDialog(context) ;
                  } else {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => KaTWebView(title: titleList[index], url: urlList[index],))) ;
                  }
                } else {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => KaTWebView(title: titleList[index], url: urlList[index],))) ;
                }
              } else {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const PrepaidPhonePage()));
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
