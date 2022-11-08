/// update: 2022-07-21
/// Homepage
/// 최종 작성자: 김진일

import 'package:flutter/material.dart';
import 'package:line_chart/charts/line-chart.widget.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_bottombar.dart';
import 'package:phishing_kat_pluss/providers/launch_provider.dart';
import 'package:phishing_kat_pluss/providers/smsProvider.dart';
import 'package:phishing_kat_pluss/theme.dart';
import 'package:provider/provider.dart';
import 'package:awesome_circular_chart/awesome_circular_chart.dart';

import '../providers/attendanceProvider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _isSelected = [false, false, true];
  List<bool> _weekAttendance = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      int _userId = Provider.of<LaunchProvider>(context, listen: false)
          .getUserInfo()
          .userId;
      Provider.of<SmsProvider>(context, listen: false).getReportDate(_userId);
      Provider.of<SmsProvider>(context, listen: false).getInitialInfo(_userId);
      print("user id:: $_userId");
      _attendanceProvider =
          Provider.of<AttendanceProvider>(context, listen: false);

      bool _attendance = await _attendanceProvider.getTodayAttendance(_userId);
      if (!_attendance) {
        _attendanceProvider.setTodayAttendance(_userId);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.only(top: 10.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: const Center(
                child: Text(
              '출석 체크 이벤트',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            )),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(),
                const Text(
                  '\n이번 달 출석 목표 : 25회',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  '현재 출석 달성 : ${_attendanceProvider.getMonthAttendance()}회',
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  '\n목표 달성하려면 ${25 - _attendanceProvider.getMonthAttendance()}회 남았어요!\n',
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  // height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                    color: Colors.blue,
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  //color: Colors.blue,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        );
      }
      setState(() {
        _weekAttendance = _attendanceProvider.getWeekAttendance();
        // smish_detect_flag = Provider.of<LaunchProvider>(context, listen: false).getUserInfo().score == -1 ? false : true;
        // if(smish_detect_flag){
        //   score = Provider.of<LaunchProvider>(context, listen: false).getUserInfo().score.toDouble();
        // }
      });
    });
  }

  late AttendanceProvider _attendanceProvider;

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();
  double dividingLine = 250;

  double SCORE_WIDTH_RANGE = 110;
  double score = 0.0;
  bool smish_detect_flag = false; // provider ?

  Widget _getCircularChart(double score) {
    setState(() {
      smish_detect_flag =
          (context.watch<LaunchProvider>().getUserInfo().score != -1)
              ? true
              : false;
    });
    score = context.watch<LaunchProvider>().getUserInfo().score.toDouble();
    smish_detect_flag =
        (context.watch<LaunchProvider>().getUserInfo().score != -1)
            ? true
            : false;
    return AnimatedCircularChart(
      key: _chartKey,
      size: Size(SCORE_WIDTH_RANGE + 30, SCORE_WIDTH_RANGE + 30),
      initialChartData: <CircularStackEntry>[
        CircularStackEntry(
          ((context.watch<LaunchProvider>().getUserInfo().score != -1)
                  ? true
                  : false)
              ? (<CircularSegmentEntry>[
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
                ])
              : (<CircularSegmentEntry>[
                  const CircularSegmentEntry(
                    0,
                    AppTheme.blueText,
                    rankKey: 'completed',
                  ),
                  const CircularSegmentEntry(
                    100,
                    Color(0xFFF0C9D5),
                    rankKey: 'remaining',
                  ),
                ]),
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: true,
    );
  }

  Widget _mainScoreView() {
    //print("2 : ${context.watch<LaunchProvider>().getUserInfo().score}");
    /**
     * _mainScoreView
     * 피싱 캣 로고와 안심 점수 및 최근 업데이트 날짜 표시
     *
     * [수정해야할 사항]
     * 1. 점수 로직 구현 및 점수 표시
     * */
    score = context.watch<LaunchProvider>().getUserInfo().score.toDouble();
    smish_detect_flag =
        (context.watch<LaunchProvider>().getUserInfo().score != -1)
            ? true
            : false;
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                height: dividingLine,
                color: AppTheme.blueBackground,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: (!smish_detect_flag)
                            ? Image.asset('assets/logo/score_default.png',
                                width: MediaQuery.of(context).size.width * 0.2,
                                fit: BoxFit.contain)
                            : (score >= 80)
                                ? Image.asset('assets/logo/score_80_100.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    fit: BoxFit.contain)
                                : (score >= 70)
                                    ? Image.asset('assets/logo/score_70_80.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        fit: BoxFit.contain)
                                    : (score >= 60)
                                        ? Image.asset(
                                            'assets/logo/score_60_69.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            fit: BoxFit.contain)
                                        : Image.asset(
                                            'assets/logo/score_0_59.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            fit: BoxFit.contain)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: InkWell(
                            onTap: () {
                              (smish_detect_flag)
                                  ? Navigator.pushNamed(
                                      context, '/kat_pages/score')
                                  : Navigator.pushNamed(
                                      context, '/kat_pages/detect_load');
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              width: SCORE_WIDTH_RANGE,
                              height: SCORE_WIDTH_RANGE,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                      child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: (smish_detect_flag)
                                                ? [
                                                    Text(
                                                        score
                                                            .toInt()
                                                            .toString(),
                                                        style: AppTheme
                                                            .display1_blue,
                                                        textAlign:
                                                            TextAlign.center),
                                                    const Text('점',
                                                        style:
                                                            AppTheme.subtitle,
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]
                                                : [
                                                    const Text('분석 시작',
                                                        style: AppTheme
                                                            .score_start_pink,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ],
                                          ))),
                                  _getCircularChart(score),
                                ],
                              ),
                            ),
                          )),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text('안심 점수',
                                  style: AppTheme.title,
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          (smish_detect_flag)
                              ? (Column(
                                  children: [
                                    Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('최근 검사',
                                            style: AppTheme.caption),
                                        Text(context.read<SmsProvider>().get_recent_analysis_date(),
                                            style: AppTheme.caption),
                                      ],
                                    )),
                                    Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('최근 업데이트',
                                            style: AppTheme.caption),
                                        Text('2022-09-05',
                                            style: AppTheme.caption),
                                      ],
                                    )),
                                  ],
                                ))
                              : (const Center(
                                  child: Text('분석 시작 버튼을 눌러주세요!',
                                      style: AppTheme.caption2_black),
                                ))
                        ],
                      ),
                    ),
                  ],
                )),
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
          padding: EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 15),
          child: Text("오늘의 스미싱분석", style: AppTheme.button),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/kat_pages/detect_load');
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ))),
      ),
    );
  }

  Widget _smishingData(String bullet, String name, String num, Color color) {
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
              children: (context.watch<LaunchProvider>().getUserInfo().score !=
                      -1)
                  ? [
                      Text(
                          num,
                          style: TextStyle(color: color)),
                      const Text(' 건'),
                    ]
                  : [
                      const Icon(Icons.arrow_right, color: AppTheme.greyText),
                      const Text('피싱 분석 필요',
                          style: TextStyle(color: AppTheme.greyText)),
                    ],
            ))
      ],
    ));
  }

  Widget _dataAnalysisDayButton() {
    const double BUTTON_WIDTH = 50;
    const double BUTTON_HEIGHT = 30;
    const double PADDING_SIZE = 10;

    List<String> dayList = ['1개월', '3개월', '전체'];

    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(dayList.length, (index) {
          return Container(
            padding: EdgeInsets.only(left: PADDING_SIZE),
            width: BUTTON_WIDTH,
            height: BUTTON_HEIGHT,
            child: TextButton(
              onPressed: () {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    if (i == index) {
                      _isSelected[index] = true;
                      print("${i}: true");
                    } else {
                      _isSelected[i] = false;
                      print("$i: false");
                    }
                  }
                });
              },
              child: Text(
                dayList[index],
                style: (_isSelected[index])
                    ? AppTheme.caption_select
                    : AppTheme.caption,
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: (_isSelected[index])
                    ? const Color(0xFF95DBED)
                    : AppTheme.whiteGreyBackground,
              ),
            ),
          );
        }));
  }

  Widget _smishingDataAnalysisView() {
    const DATA_ANALYSIS_VIEW_HEIGHT = 120.0;
    const bullet = "\u2022";

    /**
     * _smishingDataAnalysisView
     * 기존 받은 문자, 모르는 번호, 피싱 의심 문자 개수 표시
     *
     * [수정해야할 사항]
     * Smishing Detection 후, 기존 받은 문자, 모르는 번호, 피싱 의심 문자 데이터 가져와서 개수 표시
     * */
    return Container(
      height: DATA_ANALYSIS_VIEW_HEIGHT,
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text('이번주 피싱 분석', style: AppTheme.subtitle0),
                ),
                Container(
                  child: _dataAnalysisDayButton(),
                )
              ],
            ),
          ),
          _smishingData(bullet, " 기존 받은 문자", context
              .watch<SmsProvider>()
              .getTotalSms()
              .toString(), AppTheme.greenText),
          _smishingData(bullet, " 모르는 번호", context
              .watch<SmsProvider>()
              .getUnknownSms()
              .toString(), AppTheme.yellowText),
          _smishingData(bullet, " 피싱 의심 문자", context
              .watch<SmsProvider>()
              .getDangerSms()
              .toString(), AppTheme.redText),
        ],
      ),
    );
  }

  Widget _attendanceCheck() {
    List<String> dayList = <String>['월', '화', '수', '목', '금', '토', '일'];
    List<bool> dayCheckList =
        Provider.of<AttendanceProvider>(context, listen: true)
            .getWeekAttendance();

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
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          children: [
            Container(
                height: 2,
                width: MediaQuery.of(context).size.width * 0.8,
                color: AppTheme.whiteGrey),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: const Text(
                  '출석 체크',
                  style: AppTheme.subtitle,
                )),
                Row(
                    children: List.generate(dayList.length, (index) {
                  return _day(dayList[index], dayCheckList[index]);
                }))
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
                height: 2,
                width: MediaQuery.of(context).size.width * 0.8,
                color: AppTheme.whiteGrey),
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
    return (check)
        ? Container(
            margin: EdgeInsets.all(2),
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.07,
            child: const CircleAvatar(
              backgroundColor: AppTheme.blueBackground,
              radius: 30,
              child: Icon(Icons.check),
            ),
          )
        : Container(
            margin: EdgeInsets.all(2),
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.07,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.whiteGrey,
            ),
            child: Center(
              child: Text(day),
            ));
  }

  Widget _additionalFuctions() {
    List<String> functionList = <String>['원클릭 신고', '털린 정보 확인', 'URL검사'];
    List<String> imgList = <String>[
      'phone_check.png',
      'info_check.png',
      'url_check.png'
    ];
    List<String> pageList = <String>['one_click', 'info_check', 'url_check'];
    /**
     * _additional_fuctions
     * 선불폰 확인, 털린 정보 확인, URL 검사 페이지로 이동
     *
     * [수정해야할 사항]
     * 1. Navigation 지정
     */
    return Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
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
                      child: Image.asset(
                        'assets/images/' + imgList[index],
                        width: 80,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/kat_pages/' + pageList[index]);
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(functionList[index])),
                ],
              );
            })));
  }

  Widget _verticalDivider() {
    return Container(
      width: 2,
      height: 150,
      color: const Color(0xFFF6F4F4),
    );
  }

  Widget _scoreInChart(double? _score, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.08,
      margin: EdgeInsets.only(
          top: 1.35 * (100 - _score!),
          right: (index < 5) ? MediaQuery.of(context).size.width * 0.08 : 0),
      height: 20,
      child: Center(child: Text(_score.round().toString())),
    );
  }

  Widget _currentLine() {
    return Container(
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.only(
        //   left: MediaQuery.of(context).size.width * 0.05,
        //   right: MediaQuery.of(context).size.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05),
                height: 220,
                child: Card(
                  shadowColor: AppTheme.grey,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ])
          ],
        ));
  }

  Widget _dailyChart() {
    List<String> dayList = context.watch<SmsProvider>().dayList;
    List<LineChartModel> data = context.watch<SmsProvider>().data;

    Paint circlePaint = Paint()..color = AppTheme.blueLineChart;
    Paint linePaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = AppTheme.blueLineChart;

    Paint insideCirclePaint = Paint()..color = Colors.white;

    return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        height: 300,
        child: Stack(
          children: [
            /// 막대
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(data.length, (index) {
                    return _verticalDivider();
                  })),
            ),

            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.06,
                right: MediaQuery.of(context).size.width * 0.06,
              ),
              child: (smish_detect_flag)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(data.length, (index) {
                        return _scoreInChart(data[index].amount, index);
                      }))
                  : Container(),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              padding: EdgeInsets.only(
                top: 30,
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
              ),
              child: (smish_detect_flag)
                  ? LineChart(
                      width: MediaQuery.of(context).size.width * 0.95,
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
                    )
                  : Container(),
            ),

            // _currentLine(),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.06),
                margin: EdgeInsets.only(top: 170),
                child: (smish_detect_flag)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dayList.length, (index) {
                          return Text(dayList[index]);
                          // (index < 5)
                          //   ? Text(dayList[index])
                          //   : Container(
                          //     width: MediaQuery.of(context).size.width * 0.12,
                          //     height: MediaQuery.of(context).size.width * 0.12,
                          //     decoration: BoxDecoration(
                          //       color: AppTheme.blueLineChart,
                          //       borderRadius: BorderRadius.circular(25),
                          //     ),
                          //     child: Center(child: Text(dayList[index], textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.white))),
                          //   );
                        }))
                    : Container())
          ],
        ));
  }

  Widget _dailyReport() {
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
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1),
            height: 45,
            color: AppTheme.whiteGrey,
            child: const Text('일별 리포트', style: AppTheme.subtitle),
          ),

          /// Daily Chart
          _dailyChart(),
        ],
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const KaTAppBar(),
      // drawer: KaTDrawer(),
      bottomNavigationBar: const KatBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _mainScoreView(),
            _smishingDataAnalysisView(),
            _attendanceCheck(),
            _additionalFuctions(),
            _dailyReport(),
          ],
        ),
      ),
    );
  }
}
