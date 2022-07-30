/*
* writer Jiwon Jung
* date: 7/26
* description: writing 0.2, 0.21
* 7/29: be modifying the border of inner scaffold
* */

import 'package:flutter/material.dart';
import '../Theme.dart';
import 'access_authority.dart';
import 'private_info.dart';
import 'service.dart';
import '../kat_widget//launch_bottombar.dart';

class Policy extends StatefulWidget {

  @override
  State<Policy> createState() => _tabviewState();
}

class _tabviewState extends State<Policy> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      /*
      * 밑의 확인을 누르면 AcessAuthoiry로 옮겨감
      * */
      bottomNavigationBar: _bottom_bar(context),

      appBar: _appbar(),

        //내용 출력
        body:TabBarView(
            controller: _tabController,
            children: [
              //서비스에 대한 카드를 보여준다.
              Container(
                child: Card(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  /*shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),*/
                  elevation: 0,
                  child:Service()
                ),
                color: AppTheme.startBackground,
              ),

              //개인 정보에 대한 카드를 보여준다
              Container(
                child: Card(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  /*shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),*/
                  elevation: 0,
                  child: privateinfo(),
                ),
              )
            ],

      )

    );
  }

  PreferredSize _appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        backgroundColor: AppTheme.startBackground,
        elevation: 0,
        bottom:TabBar(
          padding: EdgeInsets.fromLTRB(20,0, 20, 0),
          controller: _tabController,
          tabs: myTabs
        )
      ),
    );
  }

  Widget _bottom_bar(BuildContext context) {
    return bottomBar(title: '확인', onPress: (){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>(AccessAuthority())));
    });
  }
}
