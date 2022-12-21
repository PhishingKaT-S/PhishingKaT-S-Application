/**
 * update: 2022-08-17
 * ScorePage
 * 최종 작성자: 김진일
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mysql1/mysql1.dart';
import 'package:phishing_kat_pluss/db_conn.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar_back.dart';
import 'package:phishing_kat_pluss/providers/launch_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../theme.dart';
import 'package:provider/provider.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ScorePage() ;
}

class _ScorePage extends State<ScorePage> {
  List<String> types = ['수사기관 사칭', '정부기관 사칭', '지인/가족 사칭', '택배 사칭', '금융기관 사칭', '기업 사칭'] ;
  double score = 0.89;
  List<int> types_of_ranks = [] ;
  List<int> num_of_sms_of_ranks = [] ;
  List<Color> chart_colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple] ;
  List<_PieData> pieData = [] ;
  // final List<_PieData> pieData = [
  //
  //   _PieData('기관사칭\n10개', 8, Colors.red.shade400),
  //   _PieData('지인사칭\n7개', 16, Colors.red),
  //   _PieData('URL 포함\n20개', 29, Colors.red.shade300),
  //   _PieData('택배사칭\n5개', 1, Colors.red.shade200),
  // ];

  Widget _pieChart(){
    return FutureBuilder(
      future: _get_rank_of_phishing_analysis(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if ( snapshot.hasError) {
            return const Text('네트워크가 연결되어있지 않아 불러올 수 없습니다.');
          } else if ( snapshot.hasData ) {
            return Center(
              child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  // title: ChartTitle(text: 'Sales by sales person'),
                  borderWidth: 0,
                  // legend: Legend(isVisible: true),
                  series: <PieSeries<_PieData, String>>[
                    PieSeries<_PieData, String>(
                      explode: true,
                      explodeIndex: 0,
                      // sortingOrder: SortingOrder.ascending,
                      // sortFieldValueMapper: (_PieData data, _) => data.x,
                      dataSource: pieData,
                      xValueMapper: (_PieData data, _) => data.x,
                      yValueMapper: (_PieData data, _) => data.y,
                      dataLabelMapper: (_PieData data, _) => data.x,
                      pointColorMapper: (_PieData data, _) => data.color,
                      dataLabelSettings: DataLabelSettings(isVisible: true),

                    ),
                  ]),
            );
          } else {
            return Container() ;
          }
        }
    );
  }

  Future _get_rank_of_phishing_analysis() async {
    pieData.clear();
    var user_id = context.watch<LaunchProvider>().getUserInfo().userId;
    int t = 0 ;
    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async {
      await conn.query("SELECT type, COUNT(*) AS num_of_sms FROM sms WHERE user_id = ? AND smishing = 1 GROUP BY type ORDER BY COUNT(*) DESC LIMIT 5", [user_id])
          .then((results) {
        if ( results.isNotEmpty ) {
          for ( var res in results )  {
            int type = res['type'] as int;
            int num_of_sms = res['num_of_sms'] as int;

            print(types[type]+ " " + num_of_sms.toString()) ;

            types_of_ranks.add(type) ;
            num_of_sms_of_ranks.add(num_of_sms) ;
            pieData.add( _PieData(types[type] + "\n${num_of_sms}건", num_of_sms, chart_colors[t++]));
          }
        } else {
          print("No data") ;
          return false;
        }
      }).onError((error, stackTrace) {
        return false;
      });
      conn.close();
    }).onError((error, stackTrace) {
      /// 네트워크 에러 처리

    });
    return true ;
  }

  Widget _dividing_line() {
    return Container(
      height: 15,
      color: AppTheme.whiteGrey,
    );
  }

  Widget _star_background() {
    if (context.watch<LaunchProvider>().getUserInfo().score.toDouble() * 0.01 >= 0.8) {
      print(1);
      return Container(
        width: MediaQuery.of(context).size.width * 0.2,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.56),
        child: Image.asset('assets/images/score_rank_background_80_100.png',)
      );
    } else {
      print(0);
      return Container() ;
    }
  }

  Widget _score() {
    score = context.watch<LaunchProvider>().getUserInfo().score.toDouble() * 0.01;
    double average = 0.89;
    double SCORE_HEIGHT = 40 ;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 10,),
      child: Stack(
        children: [
          /// 안심점수의 가장 바깥 테두리
          Container(
            height: SCORE_HEIGHT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppTheme.skyBackground, width: 2.0,),
            ),
          ),

          /// 평균 점수 (파란색 표시)
          Container(
            width: MediaQuery.of(context).size.width * 0.8 * average, // 평균 87점
            height: SCORE_HEIGHT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppTheme.skyBackground,
              border: Border.all(color: AppTheme.skyBackground, width: 2.0,),
            ),
          ),

          /// 현재 안심 점수
          Container(
            width: MediaQuery.of(context).size.width * 0.8 * context.watch<LaunchProvider>().getUserInfo().score.toDouble() * 0.01, // 현재 69점
            height: SCORE_HEIGHT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: (score >= 0.8) ? (AppTheme.greenBackground) :
                     (score >= 0.7) ? (AppTheme.lightYellowBackground) :
                     (score >= 0.6) ? (AppTheme.orangeBackground) :
                     (AppTheme.redBackground),
              border: Border.all(color: (score >= 0.8) ? (AppTheme.greenBackground) :
                                        (score >= 0.7) ? (AppTheme.lightYellowBackground) :
                                        (score >= 0.6) ? (AppTheme.orangeBackground) :
                                        (AppTheme.redBackground),
                                width: 2.0,),
            ),
          ),

          /// 안심점수에 이모티콘
          Container(
            width: MediaQuery.of(context).size.width * 0.8 * score,
            height: SCORE_HEIGHT,
            child: Align(
              alignment: Alignment.centerRight,
              child: (score >= 0.8) ? (Image.asset('assets/images/score_rank_80_100.png', height: SCORE_HEIGHT,)) :
                     (score >= 0.7) ? (Image.asset('assets/images/score_rank_70_79.png', height: SCORE_HEIGHT,)) :
                     (score >= 0.6) ? (Image.asset('assets/images/score_rank_60_69.png', height: SCORE_HEIGHT,)) :
                     (Image.asset('assets/images/score_rank_0_59.png', height: SCORE_HEIGHT,))
            ),
          ),

          /// 점수
          Container(
            width: MediaQuery.of(context).size.width * 0.8 * score - 45,
            height: SCORE_HEIGHT,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text((score * 100).toInt().toString(),
                          style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.bold, fontSize: 36,
                              color: (score >= 0.8) ? AppTheme.greenText2 :
                              (score >= 0.7) ? (AppTheme.orangeText2) :
                              (score >= 0.6) ? (AppTheme.redOrangeText) :
                              (AppTheme.redText2),)),
            ),
          ),
        ],
      )
    ) ;
  }

  Widget _comment(int _score) {
    return (_score > 90) ? const Text('휴대폰이 매우 안전해요!', style: TextStyle(color: AppTheme.skyBackground, fontWeight: FontWeight.bold)) :
           (_score > 80) ? const Text('휴대폰이 안전해요!', style: TextStyle(color: AppTheme.greenBackground, fontWeight: FontWeight.bold)) :
           (_score > 70) ? const Text('보안에 조금 더 신경써주세요!', style: TextStyle(color: AppTheme.orangeBackground, fontWeight: FontWeight.bold)) :
                           const Text('보안에 신경써주세요!', style: TextStyle(color: AppTheme.redBackground, fontWeight: FontWeight.bold)) ;

  }
  Widget _my_score() {
    score = context.watch<LaunchProvider>().getUserInfo().score.toDouble() * 0.01;
    UserInfo _userInfo = context.watch<LaunchProvider>().getUserInfo() ;
    int _age = DateTime.now().year - int.parse(_userInfo.year) + 1 ;
    String _gender = (_userInfo.gender == false) ? "남성" : "여성" ;
    List<String> _job=['일반', '직장인','실버','주부'];

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: 30),

      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('나의 안심점수 순위는?', style: AppTheme.subtitle,),
              _score(),
              _comment(_userInfo.score),
              Text('다른 유저들의 평균점수 : ${_age.toString()[0] + '0'}대 : $_gender : ${_job[int.parse(_userInfo.profession)]} : ' + (score * 100).toInt().toString() + '점'),
            ],
          ),

          /// 점수 80점 이상의 경우, 별 배경 표시
          _star_background(),
        ],
      )
    );
  }

  Widget _risk_ranking() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('이번달 피싱분석 위험도 순위', style: AppTheme.title),
            const Text('피싱 위험도가 높은 문자를 유형별로 확인할 수 있어요.', style: AppTheme.caption),
            const Padding(padding: EdgeInsets.only(top: 30)),
            _pieChart(),
          ],
        )
    ) ;
  }


  @override
  Widget build(BuildContext context) {

    /**
     * 이것 또한 AppBar를 따로 빼서 구현할 것 인지 정해야함.
     * */
    return Scaffold(
        appBar: AppBarBack(title: "안심점수"),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _my_score(),
              _dividing_line(),
              _risk_ranking(),
              // const Padding(padding: EdgeInsets.only(top: 15)),
              // _pieChart(),
            ],
          ),
        )
    );
  }
}

class _PieData {
  _PieData(this.x, this.y, [this.color = Colors.blue]);

  final String x;
  final int y;
  final Color color;
}