import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ScorePage() ;
}

class _ScorePage extends State<ScorePage> {
  Widget _dividing_line() {
    return Container(
      height: 15,
      color: AppTheme.whiteGrey,
    );
  }

  Widget _score() {
    double average = 0.89;
    double score = 0.69;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 10,),
      child: Stack(
        children: [
          Container(
            height: 50,

            // color: AppTheme.white,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppTheme.skyBackground, width: 2.0,),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8 * average, // 평균 87점
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppTheme.skyBackground,
              border: Border.all(color: AppTheme.skyBackground, width: 2.0,),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.8 * score, // 현재 69점
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppTheme.lightYellowBackground,
              border: Border.all(color: AppTheme.lightYellowBackground, width: 2.0,),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.8 * score,
            height: 50,
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset('assets/images/sad.png', height: 50,),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.8 * score - 56,
            height: 50,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text((score * 100).toInt().toString(), style: AppTheme.display_orange,),
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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('나의 안심점수 순위는?'),
          _score(),
          Text('보안에 조금 더 신경 써주세요!'),
          Text('다른 유저들의 평균점수 : 30대 : 남성 : 직장인 : 87점'),
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("안심점수", style: TextStyle(color: AppTheme.blueText),),
          backgroundColor: AppTheme.blueBackground,
          centerTitle: true,
        ),

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