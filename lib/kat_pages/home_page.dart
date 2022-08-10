/// update: 2022-07-21
/// Homepage
/// 최종 작성자: 김진일

import 'package:flutter/material.dart';
import 'package:line_chart/charts/line-chart.widget.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_bottombar.dart';
import 'package:phishing_kat_pluss/theme.dart';
import '../kat_widget/kat_drawer.dart';
import 'package:flutter_circular_chart_two/flutter_circular_chart_two.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePage() ;
}

class _HomePage extends State<HomePage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  double dividingLine = 250 ;
  double SCORE_RANGE = 110;

  Widget _get_circular_chart(double score) {

    return AnimatedCircularChart(
      key: _chartKey,
      size: Size(SCORE_RANGE + 30, SCORE_RANGE + 30),
      initialChartData: <CircularStackEntry>[
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              score,
              AppTheme.blueText,
              rankKey: 'completed',
            ),
            CircularSegmentEntry(
              100 - score,
              Colors.blueGrey[600],
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: true,
    );
  }

  Widget _main_score_view() {
    double score = 69 ;
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
                      child: SvgPicture.asset('assets/logo/kat_bad.svg', width:100, height: 100, fit: BoxFit.contain),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/kat_pages/score');
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                width: SCORE_RANGE,
                                height: SCORE_RANGE,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.whiteGrey,
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                        child: Container(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(score.toInt().toString(), style: AppTheme.display1_blue, textAlign: TextAlign.center),
                                                const Text('점', style: AppTheme.subtitle, textAlign: TextAlign.center)
                                              ],
                                            )
                                        )
                                    ),
                                    _get_circular_chart(score),
                                  ],
                                ),
                              ),
                            )
                          ),

                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text('안심 점수', style: AppTheme.title, textAlign: TextAlign.center),
                            ),
                          ),

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('최근 검사', style: AppTheme.caption),
                                Text('2022-07-05', style: AppTheme.caption),
                              ],
                            )
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('최근 업데이트', style: AppTheme.caption),
                                Text('2022-07-05', style: AppTheme.caption),
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
                    const Text(' 건'),
                  ],
                )
            )

          ],
        )
    );
  }

  Widget _data_analysis_day_button() {
    const double BUTTON_WIDTH = 50 ;
    const double BUTTON_HEIGHT = 30 ;
    const double PADDING_SIZE = 10 ;

    final isSelected = [false, false, false] ;
    List<String> dayList = ['1개월', '3개월', '전체'] ;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(dayList.length, (index) {
        return Container(
          padding: EdgeInsets.only(left: PADDING_SIZE),
          width: BUTTON_WIDTH, height: BUTTON_HEIGHT,
          child: TextButton(onPressed: () {}, child: Text(dayList[index], style: AppTheme.caption,), style: TextButton.styleFrom(padding: EdgeInsets.zero,backgroundColor: AppTheme.whiteGreyBackground)),
        );
      })
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
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text('이번주 피싱 분석', style: AppTheme.subtitle0),
                ),
                Container(
                  child: _data_analysis_day_button(),
                )
              ],
            ),
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
        Navigator.pushNamed(context, '/kat_pages/attendance');
      },
      child: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          children: [
            Container(height: 2, width: MediaQuery.of(context).size.width * 0.8, color: AppTheme.whiteGrey),
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
            Container(height: 2, width: MediaQuery.of(context).size.width * 0.8, color: AppTheme.whiteGrey) ,
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
      width: MediaQuery.of(context).size.width * 0.07,
      height: MediaQuery.of(context).size.width * 0.07,
      child: const CircleAvatar(
        backgroundColor: AppTheme.blueBackground,
        radius: 30,
        child: Icon(Icons.check),
      ),
    ) :
    Container(
        margin: EdgeInsets.all(2),
        width: MediaQuery.of(context).size.width * 0.07,
        height: MediaQuery.of(context).size.width * 0.07,
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
    List<String> functionList = <String> ['원클릭 신고', '털린 정보 확인', 'URL검사'] ;
    List<String> imgList = <String> ['phone_check.png', 'info_check.png', 'url_check.png'] ;
    List<String> pageList = <String> ['one_click', 'info_check', 'url_check'];
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
                    width: 80,
                    height: 80,
                    child: OutlinedButton(
                      child: Image.asset('assets/images/' + imgList[index], width: 80,),
                      onPressed: () {
                        Navigator.pushNamed(context, '/kat_pages/' + pageList[index]);
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(functionList[index])
                  ),
                ],
              ) ;
            }
          )
        )
    ) ;
  }

  Widget _vertical_divider (){
    return const VerticalDivider(
      thickness: 1,
      color: Color(0xFFF6F4F4),
    );
  }

  Widget _daily_chart() {
    List<LineChartModel> data = [
      LineChartModel(amount: 77, date: DateTime(2020, 1, 1)),
      LineChartModel(amount: 76, date: DateTime(2020, 1, 2)),
      LineChartModel(amount: 75, date: DateTime(2020, 1, 3)),
      LineChartModel(amount: 85, date: DateTime(2020, 1, 4)),
      LineChartModel(amount: 78, date: DateTime(2020, 1, 5)),
      LineChartModel(amount: 97, date: DateTime(2020, 1, 6)),
    ];

    Paint circlePaint = Paint()..color = AppTheme.blueLineChart;
    Paint linePaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = AppTheme.blueLineChart;

    Paint insideCirclePaint = Paint()..color = Colors.white;

    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1,
                               top: 20, bottom: 10),
      height: 200,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _vertical_divider(),
              _vertical_divider(),
              _vertical_divider(),
              _vertical_divider(),
              _vertical_divider(),
              _vertical_divider(),
            ],
          ),
          LineChart(
            width: MediaQuery.of(context).size.width * 0.91,
            height: 100,
            data: data,
            linePaint: linePaint,
            circlePaint: circlePaint,
            showPointer: true,
            showCircles: true,
            customDraw: (Canvas canvas, Size size) {},
            insideCirclePaint: insideCirclePaint,
            onValuePointer: (LineChartModelCallback value) {
              print('${value.chart} ${value.percentage}');
            },
            onDropPointer: () {
              print('onDropPointer');
            },
            insidePadding: 15,
          ),
        ],
      )
    );
  }

  Widget _daily_report() {
    List<String> dayList = ['1/24', '1/25', '2/20', '2/27', '2/28', '3/30'] ;
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

          /// Daily Chart
          _daily_chart(),

          Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dayList.length, (index) {
                  return Text(dayList[index]) ;
                })
            )
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KaTAppBar(),
      // drawer: KaTDrawer(),
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

