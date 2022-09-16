/**
 * update: 2022-08-16
 * Detect Loading Page
 * 최종 작성자: 김진일
 */


import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_chart_two/flutter_circular_chart_two.dart';
import 'package:phishing_kat_pluss/providers/smsProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Theme.dart';
import '../providers/launch_provider.dart';

class DetectLoadPage extends StatefulWidget {
  const DetectLoadPage({Key? key}) : super(key: key);

  @override
  _DetectLoadPageState createState() => _DetectLoadPageState();
}

class _DetectLoadPageState extends State<DetectLoadPage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
  int num_of_completed_sms = 1 ;
  int num_of_total_sms = 0 ;

  static const platform = MethodChannel('samples.flutter.dev/channel') ;

  List<String> msgs = [] ;

  @override
  void initState() {
    super.initState() ;
    Future.microtask(() async {
      await _getSmsFromChannel() ;
      await _detectionSms() ;
    });

  }

  Future<void> _getSmsFromChannel() async {
    List<String> ch = [];
    try{
      var res = await platform.invokeMethod('getResult');
      ch = res.cast<String>() ;

      if ( ch.length == 1 ) print("No data") ;
      else
      {
        for ( var sms in ch ) {
          List<String> s = sms.split("[sms_text]") ;
          print(s[0] + " " + s[1] + " " + s[2] + " " + s[3]) ;
        }
      }
    } on PlatformException catch (e) {
      ch.add("No data") ;
    }

    setState(() {
      msgs = ch ;
      num_of_total_sms = ch.length ;
    });

    context.read<SmsProvider>().setSmsToSmsProvider(msgs);
  }

  Future<void> _detectionSms() async {
    final url = Uri.parse('http://52.53.168.246:5000/api') ;
    for (int i = 0 ; i < num_of_total_sms ; i++) {
      List<String> text = msgs[i].split("[sms_text]");
      var response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode({
          'exp' : text[3]
        }),
        encoding: Encoding.getByName('utf-8'),
      );

      print(response.body) ;

      if ( response.statusCode == 200 ) {
        setState(() {
          num_of_completed_sms++;
        });
      } else if ( response.statusCode == 400 ) {
        // 연결이 끊어졌습니다.
      }
    }

    if ( num_of_completed_sms == num_of_total_sms ) {
      Navigator.pop(context);
    }
  }

  /**
   * _get_circular_chart
   * 현재 스미싱 검사 상태 원형 차트
   * */
  Widget _getCircularChart(double score) {
    return AnimatedCircularChart(
      key: _chartKey,
      size: Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.width * 0.5),
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
              AppTheme.skyBackground,
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

  Widget _percentage() {
    double score = 0;
    if (num_of_total_sms == 0) { score = 0 ;}
    else { score = num_of_completed_sms / num_of_total_sms * 100; }
    print(score);
    /**
     * _percentage
     * 현재 스미싱 검사 퍼센트 표시
     * */
    return Container(
      margin: const EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
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
                      Text(score.toInt().toString(), style: AppTheme.big_title_white, textAlign: TextAlign.center),
                      const Text('%', style: AppTheme.big_subtitle_sky, textAlign: TextAlign.center)
                    ],
                  )
              )
          ),
          _getCircularChart(score),
        ],
      ),
    );
  }

  Widget _progress() {
    /**
     * _progress
     * 현재 스미싱 검사 진행 상황 표시
     *
     * [수정해야할 사항]
     * 1. 메세지 개수 값 가져오기
     * */
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: 30,
        decoration: BoxDecoration(
          color: AppTheme.blueBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Text('$num_of_completed_sms / $num_of_total_sms', style: AppTheme.title_blue)
        )
    ) ;
  }

  Widget _notice() {
    /**
     * _notice
     * 알림 표시
     * */
    return Container(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('잠깐만 기다려주세요!', style: TextStyle(fontSize: 16, color: AppTheme.white, fontWeight: FontWeight.bold)),
            Text('AI가 꼼꼼하게 정밀검사를 하고 있어요.', style: TextStyle(fontSize: 16, color: AppTheme.white, fontWeight: FontWeight.bold)),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/load_page.png'),
              ),
            ),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  children: [
                    _percentage(),
                    _progress(),
                    _notice(),
                  ],
                )
            )
        )
    );
  }
}
