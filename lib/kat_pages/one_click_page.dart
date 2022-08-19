/**
 * update: 2022-08-18
 * OneClickPage
 * 최종 작성자: 김진일
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kat_widget/kat_appbar_back.dart';
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
                  height: HEIGHT + 10,
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Card(
                    child: Image.asset('assets/images/' + imgList[index] + '.png', fit: BoxFit.fill,),
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
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,
                                   right: MediaQuery.of(context).size.width * 0.1),
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
