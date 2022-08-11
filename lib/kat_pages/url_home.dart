/*
* write: jiwon
* date: 8/10
* scene 1.7.1~ 1.8.1
*
* */

import 'package:flutter/material.dart';

import '../Theme.dart';

class InspectFeedback extends StatefulWidget {
  const InspectFeedback({Key? key}) : super(key: key);

  @override
  State<InspectFeedback> createState() => _InspectFeedbackState();
}

class _InspectFeedbackState extends State<InspectFeedback> with SingleTickerProviderStateMixin {
  bool flag = false; //
  int _idx =0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _last_list() {

    List<String> msgList = ['텔레마케팅으로 분류된 문자입니다.','지인사칭으로 분류된 문자입니다.', '위험 URL 포함으로 분류된 문자입니다.'];
    List<int> scoreList = [90, 70, 60, 70, 30, 10, 30, 90];
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 20, bottom: 10, left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: List.generate(scoreList.length, (index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 10),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: (scoreList[index] > 80 ) ? const Image(image: AssetImage('assets/images/smsManage1.png')) : (scoreList[index] > 60) ? const Image(image: AssetImage('assets/images/smsManage2.png')) : const Image(image: AssetImage('assets/images/smsManage3.png')),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    color: AppTheme.whiteGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[

                                Container(

                                    margin: EdgeInsets.fromLTRB(2, 0, MediaQuery.of(context).size.width*0.02, 0),
                                    child: Text('010-1234-1234', style: AppTheme.subtitle)),
                                Container(
                                    color: Colors.blue,
                                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0,0, 0),
                                    child: Text('2021-10-26 11:40', style: AppTheme.unseletedURL),),
                                Container(
                                  color: Colors.red,

                                    child: IconButton(
                                      icon: Icon(
                                          Icons.arrow_drop_down,
                                      size: 10),
                                      onPressed: (){},
                                    )

                                )
                              ]
                          ),
                        ),

                        Container(
                          height: 30,
                            margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: Text(msgList[index%3])),
                      ],
                    )
                  ),
                ],
              ),
            );
          })
        )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appbarBackground,

      title: flag ? Text('메세지 관리', style: AppTheme.appbarText,) : Text('Url 검사결과', style: AppTheme.appbarText,),
        centerTitle: true,
      ),
      body:Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 60,
            color: Color(0xfff0f0f0),
            child: TabBar(
              onTap: (index){
                  setState(() {
                    _idx =index;
                  });
              },
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  border: Border.all(color:AppTheme.startBackground),
                  borderRadius: BorderRadius.circular(50),
                  color: AppTheme.startBackground),
              controller: _tabController,

              tabs: [
                Container(
                  height: 40,
                  width: 250,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (_idx==0)?  Colors.transparent:Colors.white,
                      border:Border.all(color: (_idx==0) ? AppTheme.startBackground : AppTheme.nearlyBlack),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text('최신순', style: (_idx==0)? AppTheme.selected:AppTheme.unseletedURL),
                  ),
                ),
                Container(
                  height: 40,
                  width: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: (_idx==1) ? AppTheme.startBackground : AppTheme.nearlyBlack),
                      borderRadius: BorderRadius.circular(50),
                       color: (_idx==1)?  Colors.transparent:Colors.white,

                       // border:Border.all(color:  AppTheme.startBackground)
                      ),
                    alignment: Alignment.center,
                    child: Text('위험도순', style: (_idx==1)? AppTheme.selected:AppTheme.unseletedURL),
                  ),
                ),
                Container(
                  height: 40,
                  width: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      color: (_idx==2)?  Colors.transparent:Colors.white,
                      border:Border.all(color: (_idx==2) ? AppTheme.startBackground : AppTheme.nearlyBlack),
                        borderRadius: BorderRadius.circular(50),
                       // border:Border.all(color:  AppTheme.startBackground)
                      ),
                    alignment: Alignment.center,
                    child: Text('전체', style: (_idx==2)? AppTheme.selected:AppTheme.unseletedURL),
                  ),
                )
              ],
            )
          ),
          Expanded(child:
              TabBarView(
                controller: _tabController,
                children: [
                  _last_list(),
                  Container(
                    color:Colors.white,
                  ),
                  Container(
                    color:Colors.white,
                  )
                ],

          ))
        ],
      )
    );
  }
}
