/// update: 2022-07-21
/// Homepage
/// 최종 작성자: 김진일

import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_bottombar.dart';
import 'package:phishing_kat_pluss/theme.dart';
import '../kat_widget/kat_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePage() ;
}

class _HomePage extends State<HomePage> {
  double dividingLine = 250 ;

  Widget _main_score_view() {

    /**
     * _mainScoreView
     * 피싱 캣 로고와 안심 점수 및 최근 업데이트 날짜 표시
     *
     * [수정해야할 사항]
     * 1. 점수 로직 구현 및 점수 표시
     * */
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                height: dividingLine,
                color: AppTheme.blueBackground,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Icon(Icons.favorite, size: 100),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.black,
                            ),
                          ),

                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('안심 점수', style: AppTheme.title, textAlign: TextAlign.center),
                            ),
                          ),

                          Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('최근 검사'),
                                  Text('2022-07-05'),
                                ],
                              )
                          ),
                          Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('최근 업데이트'),
                                  Text('2022-07-05'),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: AppTheme.whiteBackground,
            ),
          ],
        ),
        _smishing_analysis_button(),
      ],
    );
  }

  Widget _smishing_analysis_button() {

    /**
     * _smishingAnalysisButton
     * 오늘의 스미싱 분석 버튼
     * */
    return Positioned(
      top: dividingLine - 30,
      left: MediaQuery.of(context).size.width * 0.25,
      right: MediaQuery.of(context).size.width * 0.25,
      child: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.only(left: 0, top: 15, right:0, bottom: 15),
          child: Text("오늘의 스미싱분석", style: AppTheme.button),
        ),
        onPressed: () {},
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                )
            )
        ),
      ),
    );
  }

  Widget _smishing_data(String bullet, String name, String num, Color color) {

    /**
     * _smishingData
     * _smishingDataAnalysisView 에서 사용하고 있음
     * */
    return Container(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(bullet, style: TextStyle(color: color)),
                  Text(name),
                ],
              ),
            ),

            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(num, style: TextStyle(color: color)),
                  ],
                )
            )

          ],
        )
    );
  }

  Widget _smishing_data_analysis_view() {
    const DATA_ANALYSIS_VIEW_HEIGHT = 120.0;
    const bullet = "\u2022" ;

    /**
     * _smishingDataAnalysisView
     * 기존 받은 문자, 모르는 번호, 피싱 의심 문자 개수 표시
     *
     * [수정해야할 사항]
     * Smishing Detection 후, 기존 받은 문자, 모르는 번호, 피싱 의심 문자 데이터 가져와서 개수 표시
     * */
    return Container(
      height: DATA_ANALYSIS_VIEW_HEIGHT,
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Text('이번주 피싱 분석', style: AppTheme.subtitle),
          ),
          _smishing_data(bullet, " 기존 받은 문자", "000", AppTheme.greenText),
          _smishing_data(bullet, " 모르는 번호", "000", AppTheme.yellowText),
          _smishing_data(bullet, " 피싱 의심 문자", "000", AppTheme.redText),
        ],
      ),
    );
  }



  Widget _attendance_check() {
    List<String> dayList = <String> ['월', '화', '수', '목', '금', '토', '일'] ;
    List<bool> dayCheckList = <bool> [false, false, false, true, false, false, true] ;

    /**
     * _attendanceCheck
     * 유저의 한 주에 대한 출석 체크
     *
     * [수정해야할 사항]
     * 1. Database에서 일주일 치 출석 정보를 가져와 표시
     */
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/attendance');
      },
      child: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          children: [
            Container(height: 2, width: MediaQuery.of(context).size.width * 0.9, color: AppTheme.whiteGrey),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5),),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: const Text('출석 체크', style: AppTheme.subtitle,)) ,

                Row(
                    children: List.generate(dayList.length, (index) {
                      return _day(dayList[index], dayCheckList[index]);
                    })
                )
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5),),
            Container(height: 2, width: MediaQuery.of(context).size.width * 0.9, color: AppTheme.whiteGrey) ,
          ],
        ),
      ),
    );
  }

  Widget _day(String day, bool check) {
    /**
     * _day
     * _attendance_check 에서 true 일 경우, 요일로 표시, false 일 경우, 체크로 표시
     */
    return (check) ?
    Container(
      margin: EdgeInsets.all(2),
      width: 30,
      height: 30,
      child: const CircleAvatar(
        backgroundColor: AppTheme.blueBackground,
        radius: 30,
        child: Icon(Icons.check),
      ),
    ) :
    Container(
        margin: EdgeInsets.all(2),
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.whiteGrey,
        ),
        child: Center(
          child: Text(day),
        )
    ) ;
  }

  Widget _additional_fuctions() {
    List<String> functionList = <String> ['선불폰 확인', '털린 정보 확인', 'URL검사'] ;

    /**
     * _additional_fuctions
     * 선불폰 확인, 털린 정보 확인, URL 검사 페이지로 이동
     *
     * [수정해야할 사항]
     * 1. Navigation 지정
     */
    return Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            top: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(functionList.length, (index) {
              return Column(
                children: [
                  Container(
                    height: 70,
                    child: OutlinedButton(
                      child: const Icon(Icons.favorite, size: 50),
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(functionList[index])
                  ),
                ],
              ) ;
            })
        )
    ) ;
  }

  Widget _daily_report() {

    /**
     * _daily_report
     * 업데이트한 날짜를 데이터로 차트 표시
     *
     * [수정해야할 사항]
     * 1. 차트 표시
     * 2. Database 에서 데이터 가져오기
     */
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1),
            height: 45,
            color: AppTheme.whiteGrey,
            child: const Text('일별 리포트', style: AppTheme.subtitle),
          ),

          Container(

          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KaTAppBar(),
      drawer: KaTDrawer(),
      bottomNavigationBar: const KatBottomBar(),
      body: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _main_score_view(),
            _smishing_data_analysis_view(),
            _attendance_check(),
            _additional_fuctions(),
            _daily_report(),
          ],
        ),
      ),
    );
  }
}

