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

import '../theme.dart';
import 'package:provider/provider.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ScorePage() ;
}

class _ScorePage extends State<ScorePage> {
  List<String> types = ['', '공공기관 사칭', '070번호/해외발신', '[web]발신', '보험/금융상품', 'url/jpg\n파일 포함'] ; // 처음 ''은 0건 일 경우
  double score = 0.89;
  List<int> types_of_ranks = [0] ;
  List<int> num_of_sms_of_ranks = [0] ;

  Future _get_rank_of_phishing_analysis() async {
    var user_id = context.watch<LaunchProvider>().getUserInfo().userId;

    await MySqlConnection.connect(Database.getConnection())
        .then((conn) async {
      await conn.query("SELECT type, COUNT(*) AS num_of_sms FROM sms WHERE user_id = ? AND smishing = 1 GROUP BY type ORDER BY COUNT(*) DESC LIMIT 5", [user_id])
          .then((results) {
        if ( results.isNotEmpty ) {
          for ( var res in results )  {
            int type = res['type'] as int;
            int num_of_sms = res['num_of_sms'] as int;

            print(type.toString() + " " + num_of_sms.toString()) ;

            types_of_ranks.add(type) ;
            num_of_sms_of_ranks.add(num_of_sms) ;
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

  Widget _my_score() {
    score = context.watch<LaunchProvider>().getUserInfo().score.toDouble() * 0.01;
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
              const Text('보안에 조금 더 신경 써주세요!', ),
              Text('다른 유저들의 평균점수 : 30대 : 남성 : 직장인 : ' + (score * 100).toInt().toString() + '점'),
            ],
          ),

          /// 점수 80점 이상의 경우, 별 배경 표시
          _star_background(),
        ],
      )
    );
  }

  Widget _content_in_pie_chart(double width, double margin_top, double margin_left, String rank, String num, String content ) {

    return Container(
      width: width,
      margin: EdgeInsets.only(top: margin_top, left: margin_left),
      child: Column(
        children: [
          Text(rank, style: AppTheme.score_rank_white),
          Padding(padding: EdgeInsets.only(top:3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(num, style: AppTheme.num_of_cases_black),
              Text('건', style: AppTheme.caption2_black) ,
            ],
          ),
          Padding(padding: EdgeInsets.only(top:1)),
          Center(
            child: Text(content, style: AppTheme.rank_content_black, textAlign: TextAlign.center,)
          )
        ],
      )
    );
  }

  Widget _score_pie_chart() {
    return FutureBuilder(
      future: _get_rank_of_phishing_analysis(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if ( snapshot.hasError) {
          return Text('${snapshot.error}') ;
        } else if ( snapshot.hasData ) {
          return Container(
              padding: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height * 0.43,
              width: MediaQuery.of(context).size.height * 0.43,
              child: Center(
                child: Stack(
                  children: [
                    Image.asset('assets/images/pie_chart.png'),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.43 * 0.31, left: MediaQuery.of(context).size.height * 0.43 * 0.295),
                      child: Column(
                        children: [
                          const Text('1위', style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 20, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),
                          const Padding(padding: EdgeInsets.only(top:3)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text((types_of_ranks.length < 6) ? num_of_sms_of_ranks[0].toString() : num_of_sms_of_ranks[1].toString(),
                                  style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 24, fontWeight: FontWeight.bold)),
                              const Text('건', style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 14,)) ,
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top:1)),
                          Text((types_of_ranks.length < 6) ? types[types_of_ranks[0]] : types[types_of_ranks[1]], style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 14)),
                        ],
                      ),
                    ),

                    _content_in_pie_chart(MediaQuery.of(context).size.width * 0.15, MediaQuery.of(context).size.height * 0.43 * 0.015,
                        MediaQuery.of(context).size.height * 0.43 * 0.16, '5위',
                        (types_of_ranks.length < 6) ? num_of_sms_of_ranks[0].toString() : num_of_sms_of_ranks[5].toString(),
                        (types_of_ranks.length < 6) ? types[types_of_ranks[0]] : types[types_of_ranks[5]]),
                    _content_in_pie_chart(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.43 * 0.13,
                        MediaQuery.of(context).size.height * 0.43 * 0.72, '2위',
                        (types_of_ranks.length < 3) ? num_of_sms_of_ranks[0].toString() : num_of_sms_of_ranks[2].toString(),
                        (types_of_ranks.length < 3) ? types[types_of_ranks[0]] : types[types_of_ranks[2]]),
                    _content_in_pie_chart(MediaQuery.of(context).size.width * 0.18, MediaQuery.of(context).size.height * 0.43 * 0.55,
                        0, '4위', (types_of_ranks.length < 5) ? num_of_sms_of_ranks[0].toString() : num_of_sms_of_ranks[4].toString(),
                        (types_of_ranks.length < 5) ? types[types_of_ranks[0]] : types[types_of_ranks[4]]),
                    _content_in_pie_chart(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.43 * 0.68,
                        MediaQuery.of(context).size.height * 0.43 * 0.62, '3위',
                        (types_of_ranks.length < 4) ? num_of_sms_of_ranks[0].toString() : num_of_sms_of_ranks[3].toString(),
                        (types_of_ranks.length < 4) ? types[types_of_ranks[0]] : types[types_of_ranks[3]]),
                  ],
                ),
              )
          );
        } else {
          return Container() ;
        }
      },
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
          _score_pie_chart(),
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
            ],
          ),
        )
    );
  }
}