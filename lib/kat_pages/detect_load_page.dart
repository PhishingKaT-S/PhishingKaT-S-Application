/**
 * update: 2022-08-16
 * Detect Loading Page
 * 최종 작성자: 김진일
 */


import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phishing_kat_pluss/providers/smsProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../Theme.dart';
import '../providers/launch_provider.dart';

class SmsData {
  double prediction = 0.0;

  SmsData({required this.prediction}) ;

  factory SmsData.fromJson(Map<String, dynamic> json)  {
    return SmsData(
      prediction: double.parse(json['prediction'][0].toString()), // double
    );
  }
}

class DetectLoadPage extends StatefulWidget {
  const DetectLoadPage({Key? key}) : super(key: key);

  @override
  _DetectLoadPageState createState() => _DetectLoadPageState();
}

class _DetectLoadPageState extends State<DetectLoadPage> with TickerProviderStateMixin {
  final double threshold = 0.4 ;
  late AnimationController controller; // progress
  var interpreter_score; //머신러닝 돌릴 때 모델 담을 그릇
  var interpreter_category; //머신러닝 돌릴 때 모델 담을 그릇
  double score = 0;
  int num_of_completed_sms = 0 ;
  int num_of_total_sms = 0 ;
  int num_of_smishing_sms = 0 ;
  List<double> scoreList = [] ;

  List<int> predictionList = [] ;
  static const platform = MethodChannel('samples.flutter.dev/channel') ;

  List<String> msgs = [] ;

  @override
  void initState() {
    model_create();     //머신러닝 모델 초기화
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      duration: const Duration(milliseconds: 5), vsync: this,
    )..addListener(() {
      setState(() {

      });
    });
    controller.repeat();

    super.initState() ;
    Future.microtask(() async {
      await _getSmsFromChannel() ;
      await _detectionSms() ;

    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _getSmsFromChannel() async {
    List<String> ch = [];
    ch.clear();
    try{
      var res = await platform.invokeMethod('getResult');
      ch = res.cast<String>() ;

      if ( ch.isEmpty ) print("No data") ;
      else
      {
        // for ( var sms in ch ) {
        //   List<String> s = sms.split("[sms_text]") ;
          // print(s[0] + " " + s[1] + " " + s[2] + " " + s[3]) ;
        // }
      }
    } on PlatformException catch (e) {
      ch.add("No data") ;
    }

    setState(() {
      msgs = ch ;
      num_of_completed_sms = 0 ;
      num_of_total_sms = ch.length ;
    });

    await context.read<SmsProvider>().setSmsToSmsProvider(msgs);

    // context.read<LaunchProvider>().setUpdate();
  }

  double isPhone(String Text){ //폰 번호 유무
    RegExp basicReg = RegExp(r"(\\d{2,4})?(-|\\s)?(\\d{3,4})(-|\\s)?(\\d{3,4})$");
    if(basicReg.hasMatch(Text))
      return 1.0;
    else return 0.0;
  }
  double isUrl(String Text){
    RegExp basicReg = RegExp(r"(http)?(s)?:?(\\/\\/)?([a-z0-9\\w]+\\.*)+[a-z0-9]{2,4}");
    if(basicReg.hasMatch(Text)){
      return 1.0;
    }
    else return 0.0;
  }
  double textLength(String Text){
    if(Text.length >= 200) {
      return 1.0;
    }
    else{
      return 0.0;
    }
  }
  double MathSymbol(String Text){
    if(Text.contains("+")|Text.contains("-")|Text.contains("%")|Text.contains("/")) return 1.0;
    else return 0.0;
  }
  double smishing_symbol(String text){
    if(text.contains("만원") || text.contains("천원")|| text.contains("백원") || text.contains("십원")) return 1.0;
    RegExp pattern = RegExp(r",(\\d{3})원");
    if(pattern.hasMatch(text)) return 1.0;
    else return 0.0;
  }
  List<double> keyword(String text){
    var ret_keyword=[0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0];
    var keywords=[
      ["아이디", "확인", "방식", "문의", "수리", "연락", "건강검진", "국제", "서류"],
      ["수리", "아이디", "비율", "확인", "규제", "아빠", "전화", "은행", "중도"],
      ["국제", "배송", "확인", "요청", "아이디", "서류", "경감", "자산", "대한"],
      ["일화", "번호", "오류", "규제", "모든", "대상", "안내", "조심", "국민"],
      ["법령", "신고", "발급", "배송", "이상", "전산", "개인", "문의", "자산"],
      ["제외", "노출", "아빠", "방문", "우대금리", "확인", "지정", "요청", "여기"],
      ["수리", "발급", "방식", "최고", "국제", "확인", "심의", "자동", "신고"],
      ["교통", "은행", "문의", "배송", "공인", "수리", "국제", "일치", "제공"],
      ["국제", "원본", "일시", "원금", "문의", "노출", "참고", "코로나", "분할"],
      ["긴급", "기타", "대출", "일부", "매출", "전화", "기준", "문의", "조회"],
      ["당일", "확인", "기한", "천만", "아빠", "문의", "수리", "역시", "배송"],
      ["긴급", "대한", "개인", "최저", "바로", "조회", "변경", "생활", "시간"],
      ["수리", "정상처리", "확인", "노출", "우대금리", "요청", "카톡", "원금", "당일"],
      ["확인", "지금", "일치", "문의", "대출", "은행", "안내", "생활", "수리"],
      ["수시", "년도", "원금", "운영", "처리", "경감", "아빠", "안내", "일용직"],
      ["문의", "대출", "매출", "국제", "역시", "중도", "안정", "이자", "원금"],
      ["수리", "여기", "공단", "은행", "차등", "최초", "진시", "대한", "면책"],
      ["노출", "일부", "마감", "자산", "확인", "국제", "처리", "문의", "연결"],
      ["자산", "추가", "이자", "발급", "범위", "바로", "수리", "대한", "제외"],
      ["확인", "이자", "수리", "문의", "연결", "당일", "국제", "최저", "발급"]
    ];

    for(int i =0; i<20; i++) {
      for(int j =0; j<8; j++){
        print(keywords[i][j]);
        if(text.contains(keywords[i][j])) {
          ret_keyword[i] = 1.0;
          break;
        }
        ret_keyword[i]=0.0;
      }
    }
    for(int i =0; i<20; i++) {
        print(ret_keyword[i]);
    }
    return ret_keyword;
  }
  void model_create() async {
    interpreter_score = await Interpreter.fromAsset('smish_converted_model.tflite');
    interpreter_category = await Interpreter.fromAsset('cate_converted_model.tflite');
  }
  Future<void> _detectionSms() async {
    //final url = Uri.parse('http://52.53.168.246:5000/api') ;
    final List<SmsInfo> smsData = context.read<SmsProvider>()
        .getUnknownSmsList();
    int type = 0;
    var ret_keyword=List.generate(20, (index) => 0.0);
    var ret = List.generate(25, (index) => 0.0);
    var ABAE_keywords=[
      ["아이디", "확인", "방식", "문의", "수리", "연락", "건강검진", "국제", "서류"],      ["수리", "아이디", "비율", "확인", "규제", "아빠", "전화", "은행", "중도"],
      ["국제", "배송", "확인", "요청", "아이디", "서류", "경감", "자산", "대한"],      ["일화", "번호", "오류", "규제", "모든", "대상", "안내", "조심", "국민"],
      ["법령", "신고", "발급", "배송", "이상", "전산", "개인", "문의", "자산"],      ["제외", "노출", "아빠", "방문", "우대금리", "확인", "지정", "요청", "여기"],
      ["수리", "발급", "방식", "최고", "국제", "확인", "심의", "자동", "신고"],      ["교통", "은행", "문의", "배송", "공인", "수리", "국제", "일치", "제공"],
      ["국제", "원본", "일시", "원금", "문의", "노출", "참고", "코로나", "분할"],      ["긴급", "기타", "대출", "일부", "매출", "전화", "기준", "문의", "조회"],
      ["당일", "확인", "기한", "천만", "아빠", "문의", "수리", "역시", "배송"],      ["긴급", "대한", "개인", "최저", "바로", "조회", "변경", "생활", "시간"],
      ["수리", "정상처리", "확인", "노출", "우대금리", "요청", "카톡", "원금", "당일"],      ["확인", "지금", "일치", "문의", "대출", "은행", "안내", "생활", "수리"],
      ["수시", "년도", "원금", "운영", "처리", "경감", "아빠", "안내", "일용직"],      ["문의", "대출", "매출", "국제", "역시", "중도", "안정", "이자", "원금"],
      ["수리", "여기", "공단", "은행", "차등", "최초", "진시", "대한", "면책"],      ["노출", "일부", "마감", "자산", "확인", "국제", "처리", "문의", "연결"],
      ["자산", "추가", "이자", "발급", "범위", "바로", "수리", "대한", "제외"],      ["확인", "이자", "수리", "문의", "연결", "당일", "국제", "최저", "발급"]
    ];
    num_of_total_sms = smsData.length;

    print("Total: " + num_of_total_sms.toString());

    for (int i = 0; i < smsData.length; i++) {//
      ret[0] = isPhone(smsData[i].body);
      ret[1] = isUrl(smsData[i].body);
      ret[2] = textLength(smsData[i].body);
      ret[3] = textLength(smsData[i].body);
      ret[4] = smishing_symbol(smsData[i].body);
      for(int j =0; i<20; i++) {
        for(int k =0; j<8; j++){
          if(smsData[i].body.contains(ABAE_keywords[j][k])) {
            ret_keyword[j] = 1.0;
            ret[j+5]=1.0;
            break;
          }
          ret[j+5]=0.0;
          ret_keyword[j]=0.0;
        }
      }

      var output_score = List.filled(1 * 1, 0).reshape([1, 1]);
      var output_category = List.filled(1* 6, 0).reshape([1, 6]);

      interpreter_score.run(ret, output_score);
      interpreter_category.run(ret_keyword, output_category);


      /*
    for (int i = 0 ; i < num_of_total_sms ; i++) {

      List<String> text = msgs[i].split("[sms_text]");

      var response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode({
          'exp' : text[3] // body (sms text)
        }),
        encoding: Encoding.getByName('utf-8'),
      );

      print(response.body) ;

      SmsData _sms = SmsData.fromJson(json.decode(response.body)) ;
*/
      // 0.5 이상 Smishing Data로 간주
      if (output_score[0][0].ceil()*100 >= threshold*100) {
        num_of_smishing_sms++;
      }
      for (int i = 1; i < 6; i++) {
        if (output_category[0][i] > output_category[0][type]) {
          type = i;
        }
      }

      predictionList.add(output_score[0][0].ceil());
      setState(() {
        num_of_completed_sms++;
      });
/*
      if ( response.statusCode == 200 ) {
      } else {
        print("Error\n" + text[3]) ;
        // 연결이 끊어졌습니다.
      }
*/    }

      context.read<SmsProvider>().setDangerSms(num_of_smishing_sms);

      print("SMISH: " + num_of_smishing_sms.toString());

      int _currScore = context.read<LaunchProvider>().getUserInfo().score ;

      if (num_of_completed_sms == num_of_total_sms) {
        _currScore = context
            .read<LaunchProvider>()
            .getUserInfo()
            .score;

        // 처음 검사할 때 문자 메세지 다 가져오기
        if (_currScore == -1) {
          await context.read<SmsProvider>().insertSMSList(
              context.read<SmsProvider>().getUnknownSmsList());
        }

      context.read<LaunchProvider>().updateAnalysisDate(context.read<LaunchProvider>().getUserInfo().userId) ;

      _currScore = context.read<LaunchProvider>().getUserInfo().score ;


        context.read<LaunchProvider>().setScore(Random(1234).nextInt(100));

        context.read<SmsProvider>().insertScore(context
            .read<LaunchProvider>()
            .getUserInfo()
            .userId);
        context.read<SmsProvider>().updateScore(context
            .read<LaunchProvider>()
            .getUserInfo()
            .userId);

        Navigator.pop(context);
      }
    }

    Widget _percentage() {
      if (num_of_total_sms == 0) {
        score = 0;
      }
      else {
        score = num_of_completed_sms / num_of_total_sms * 100;
      }

      /**
       * _percentage
       * 현재 스미싱 검사 퍼센트 표시
       * */
      return Container(
        margin: const EdgeInsets.all(2),
        width: MediaQuery
            .of(context)
            .size
            .width * 0.5,
        height: MediaQuery
            .of(context)
            .size
            .width * 0.5,
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
                        Text(score.toInt().toString(),
                            style: AppTheme.big_title_white,
                            textAlign: TextAlign.center),
                        const Text('%', style: AppTheme.big_subtitle_sky,
                            textAlign: TextAlign.center)
                      ],
                    )
                )
            ),

            Center(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.35,
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.35,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                    value: (num_of_total_sms != 0) ? (num_of_completed_sms /
                        num_of_total_sms) : 0,
                    semanticsLabel: 'Circular progress indicator',
                  ),
                )
            )
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
          width: MediaQuery
              .of(context)
              .size
              .width * 0.3,
          height: 30,
          decoration: BoxDecoration(
            color: AppTheme.blueBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
              child: Text('$num_of_completed_sms / $num_of_total_sms',
                  style: AppTheme.title_blue)
          )
      );
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
              Text('잠깐만 기다려주세요!', style: TextStyle(fontSize: 16,
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold)),
              Text('AI가 꼼꼼하게 정밀검사를 하고 있어요.', style: TextStyle(fontSize: 16,
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold)),
            ],
          )
      );
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/load_page.png'),
                ),
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1),
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