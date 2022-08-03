/*
* writer Jiwon Jung
* date: 7/26
* description: writing 0.2, 0.21
* 7/29: be modifying the border of inner scaffold
* 8/3: modifying the view, deleting the private_info.dart, service.dart
* */

import 'package:flutter/material.dart';
import '../Theme.dart';

class Policy extends StatefulWidget {

  @override
  State<Policy> createState() => _tabviewState();
}

class _tabviewState extends State<Policy> with SingleTickerProviderStateMixin {
  String _conTent='피싱캣S 서비스 이용자 여러분 반갑습니다! \n피싱캣S 서비스를 이용해 주셔서 감사합니다. 여러분이 이용하시면서 필요하시거나 궁금해하실 기본적인 서비스 이용 관련 정보를 약관에 담아 안내드립니다. 약관을 통해 AI굿윌보이스(이하 “회사”)와 회원(이하 ‘회원’)과의 권리, 의무 및 책임사항, 기타 사항을 확인하실 수 있으며 회사는 이 약관의 내용을 여러분이 쉽게 확인할 수 있도록 서비스 초기 화면에 게시합니다. 회사는 안정적인 서비스를 지속적으로 제공하기 위해 최선을 다해 노력해 나갈 것이며, 여러분이 조금만 시간을 내서 약관을 읽어주신다면, 여러분과 더욱 가까운 사이가 될 것이라고 믿습니다.\n\n약관에서 사용되는 용어의 정의와 해석은 다음과 같습니다.\n“회원”은 본 약관 및 개인정보처리방침에 동의하고 서비스 이용 자격을 부여 받은 자를 의미합니다.\n“서비스”는 구현되는 단말기(PC, TV, 휴대형단말기 등의 각종 유무선 장치를 포함)와 상관없이 회원이 이용할 수 있는 피싱캣S 및 피싱캣S 관련 제반 서비스를 의미합니다.\n“계정(ID)”은 회원의 식별과 서비스 이용을 위하여 회원이 정하는 문자, 숫자, 특수문자의 조합을 의미합니다.\n\n회사는 약관의 내용을 회원이 쉽게 알 수 있도록 게시하며, 사전 공지 후 개정합니다. 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스초기 화면 및 별도의 연결화면 또는 팝업화면 등에 게시합니다. 또한, 관련법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다. 약관을 개정할 경우에는 적용일자 및 개정사유 등을 명시하여 그 적용일자로부터 최소한 7일 이전(회원에게 불리하거나 중대한 사항의 변경은 30일 이전)부터 그 적용일자 경과 후 상당한 기간이 경과할 때까지 서비스에 게시합니다. 약관 개정 공지일로부터 개정약관 시행일 7일 후까지 본 개정약관에 대한 거부의사를 표시하지 않으면 개정약관에 동의한 것으로 봅니다. 개정약관의 적용에 동의하지 않는 경우 회원은 이용계약을 해지할 수 있습니다.\n\n약관과 기타약관은 상호 보완됩니다.\n회사는 유료서비스 및 개별 서비스에 대해서는 별도의 이용약관 및 정책(이하 “기타 약관 등”)을 둘 수 있습니다. 이 약관에서 정하지 아니한 사항이나 해석에 대해서는 “기타 약관” 및 관계법령 또는 상관례에 따릅니다.\n';
  static const List<Tab> myTabs = <Tab>[
    Tab(text: '서비스'),
    Tab(text: '개인정보'),
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
        Container(
          child: Scaffold(
          /*
          * 밑의 확인을 누르면 AcessAuthoiry로 옮겨감
          * */
         // bottomNavigationBar: _bottom_bar(context),

          appBar: _appBar2(),

            //내용 출력
            body:
            TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    //서비스에 대한 카드를 보여준다.
                    _service(), //service 뷰

                    //개인 정보에 대한 카드를 보여준다
                    _privateInfo(),

                  ],

          ),


      ),
        ),
    );
  }

  Widget _privateInfo() {
    return Container(
                    child: SingleChildScrollView(
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          margin: EdgeInsets.fromLTRB(20, 0, 20,0),
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                children:<Widget>[
                                  Row(
                                    children: [
                                      Flexible(
                                          flex:6,
                                          child: Container(child: Text('개인정보 처리 방침', style: AppTheme.button_blue), width: double.infinity,)
                                      ),
                                      Flexible(
                                          flex:3,
                                          child: SizedBox(width: double.infinity,)),
                                      Flexible(
                                          flex:1,
                                          child:
                                          Container(child: IconButton(onPressed: (){}, icon: Icon(Icons.check, color: Colors.blue,)),width: double.infinity,)
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('제1조 약관의 목적', style: AppTheme.purpose),
                                  ),
                                  SizedBox(height:10),
                                  Text(_conTent, style: AppTheme.law_content)

                                ]
                            ),
                          )

                      ),
                    ),
                    color: AppTheme.startBackground,
                  );
  }

  Widget _service() {
    return Container(
                    child: SingleChildScrollView(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.fromLTRB(20, 0, 20,0),
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children:<Widget>[
                              Row(
                                children: [
                                  Flexible(
                                      flex:6,
                                      child: Container(child: Text('서비스 이용 약관', style: AppTheme.button_blue), width: double.infinity,)
                                  ),
                                  Flexible(
                                    flex:3,
                                      child: SizedBox(width: double.infinity,)),
                                  Flexible(
                                    flex:1,
                                      child:
                                      Container(child: IconButton(onPressed: (){}, icon: Icon(Icons.check, color: Colors.blue,)),width: double.infinity,)
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text('제1조 약관의 목적', style: AppTheme.purpose),
                              ),
                              SizedBox(height:10),
                              Text(_conTent, style: AppTheme.law_content)

                            ]
                          ),
                        )

                      ),
                    ),
                    color: AppTheme.startBackground,
                  );
  }


  AppBar _appBar2() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.startBackground,

      title:
          Center(
            child: Container(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
              child: TabBar(
                  controller: _tabController,
                  tabs: myTabs
              ),
            )
          ),
    );
  }


}
