import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar_back.dart';

import '../theme.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ScorePage() ;
}

class _ScorePage extends State<ScorePage> {
  double score = 0.89;

  Widget _dividing_line() {
    return Container(
      height: 15,
      color: AppTheme.whiteGrey,
    );
  }

  Widget _star_background() {
    if (score >= 0.8) {
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
            width: MediaQuery.of(context).size.width * 0.8 * score, // 현재 69점
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
          Text(content, style: AppTheme.rank_content_black),
        ],
      )
    );
  }

  Widget _score_pie_chart() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height * 0.43,
      // width: MediaQuery.of(context).size.width * 0.8,
      child: Center(
        child: Stack(
          children: [
            Image.asset('assets/images/pie_chart.png'),

            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.25, left: MediaQuery.of(context).size.width * 0.235),
              child: Column(
                children: [
                  const Text('1위', style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 20, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),
                  const Padding(padding: EdgeInsets.only(top:3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('27', style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('건', style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 14,)) ,
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top:1)),
                  const Text('url/jpg 파일 포함', style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 14)),
                ],
              ),
            ),

            _content_in_pie_chart(MediaQuery.of(context).size.width * 0.15, MediaQuery.of(context).size.height * 0.43 * 0.015,
                MediaQuery.of(context).size.width * 0.13, '5위', '2', '공공기관 사칭'),
            _content_in_pie_chart(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.43 * 0.13,
                MediaQuery.of(context).size.width * 0.585, '2위', '5', '070번호/해외발신'),
            _content_in_pie_chart(MediaQuery.of(context).size.width * 0.18, MediaQuery.of(context).size.height * 0.43 * 0.55,
                0, '4위', '4', '[web]발신'),
            _content_in_pie_chart(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.43 * 0.68,
                MediaQuery.of(context).size.width * 0.5, '3위', '5', '보험/금융상품'),
          ],
        ),
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