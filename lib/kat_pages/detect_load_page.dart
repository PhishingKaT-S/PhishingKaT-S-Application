/**
 * update: 2022-08-16
 * Detect Loading Page
 * 최종 작성자: 김진일
 */


import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phishing_kat_pluss/local_database/DBHelper.dart';
import 'package:phishing_kat_pluss/providers/attendanceProvider.dart';
import 'package:phishing_kat_pluss/providers/smsProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../Theme.dart';
import '../local_database/Sms.dart';
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
  late Timer _timer ;
  final double threshold = 0.4 ;
  late AnimationController controller; // progress
  var interpreter_score; //머신러닝 돌릴 때 모델 담을 그릇
  var interpreter_category; //머신러닝 돌릴 때 모델 담을 그릇
  double score = 0;
  int num_of_completed_sms = 0 ;
  int num_of_total_sms = 0 ;
  int num_of_smishing_sms = 0 ;
  List<double> scoreList = [] ;
  List<Sms> dataList = [];
  List<Sms> dataListNonSmishing = [];
  static const platform = MethodChannel('samples.flutter.dev/channel') ;

  List<String> msgs = [] ;

  var ABAE_keywords=[
    ["추가"],
    ["인증", "발신", "번호", "카톡"],
    ["권리", "차등", "이용", "전용", "거부","사고", "설명", "신청", "제외"],
    ["승인","오전"],
    ["빙자", "중층", "집행", "비대", "보건", "부처", "신한은행", "확보", "자영", "복지", "영업", "폐업", "수시", "운영", "카카오", "담당자", "부담", "인자", "감소", "상환", "직장인", "인원", "한도", "무관", "사항", "임차", "모두", "생계비", "연체", "지속", "중소", "일화", "시어", "위반", "국민", "현재", "충족", "기획재정부", "변동", "시작", "추가경정예산", "확산", "생활고", "이하", "매출", "대책", "천만원", "부지", "자료", "수료", "인상", "해당", "마지막", "운용", "재난", "개선", "입원", "적용", "보이스피싱", "휴직", "회복", "출발", "발송", "조건", "환자", "요약", "요구", "보증금", "하반기"],
    ["나야", "이번", "액정", "엄마", "여기", "휴대폰", "수리", "잠시", "사용", "먹통", "고장", "답장", "아빠", "화면", "바로"],
    ["오류", "해외", "국외", "정보", "안마", "부적정", "지불", "미만", "하락", "상담", "플러스", "제습기", "국내외", "한국", "화물", "일치", "유이", "최고", "원본", "카메라", "주문", "시불", "월간", "휘센", "번가", "소비자원", "약정", "변경", "지연", "주유", "이상", "조회", "소비자", "처리", "직구", "시신", "보류", "다음", "이자율", "주신", "노출", "가죽", "수정", "케이", "주소지", "대하", "일정", "시문", "에너지", "가산", "결제", "심의", "금지", "취소", "변제", "수령", "법정", "요망", "정상처리", "발급", "도로명", "의자", "코모", "접수", "예정", "최소", "플러스카드", "은행", "국민은행", "에어컨", "소파", "상환", "소니", "오류", "스파", "디몬", "기간", "금리", "익월", "연체", "모든", "이자", "여신", "로마", "수반", "현대", "국내", "물품", "소비자보호법", "하단", "완료", "통관", "위니", "세탁기", "입력", "냉장고", "국제", "전월", "실적", "아마존", "회비", "의무", "카톡", "이내", "신용카드", "유효","버터", "침대", "캐논", "포함", "불이익", "제한", "즉시", "원정", "지정", "본인"],
    ["심사", "전용", "생활", "동의", "부족", "설명", "창업", "법률", "제외", "금융", "권리", "차등", "주시", "여유", "인지세", "수료", "저축은행", "면책", "대출", "시기", "소상", "상이","사업자", "공인",  "무소득", "적용", "일부", "채무", "사고", "사기", "립니", "증빙"],
    ["방법", "등록", "정보", "시작", "분양", "재의", "예약", "오후", "축하", "일반", "채널", "기간", "시간", "인근", "포함", "승인", "수령", "오전", "아래", "이자", "책임", "중도", "개발", "경력", "임대", "예정"],
    ["검찰", "경찰", "공정", "사실", "상식", "선거법", "위반", "허위"]
  ];

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
    _timer?.cancel();
    controller.dispose();
    interpreter_score.close() ;
    interpreter_category.close() ;

    super.dispose();
  }

  Future<void> _getSmsFromChannel() async {
    List<String> ch = [];
    ch.clear();
    try{

      var getNumberOfSMSMMS = await platform.invokeMethod('getNumberOfSMSMMS') ;

      num_of_total_sms = 0 ;
      num_of_completed_sms = 0 ;

      String size = '[NUM_OF_MSG]' ;
      if ( getNumberOfSMSMMS.length != 0 ) {
        int _userId = context
            .read<LaunchProvider>()
            .getUserInfo()
            .userId;
        int _attendance_30 = await context.read<AttendanceProvider>()
            .get30Attendance(_userId);
        int _analysis_30 = await context.read<SmsProvider>().get30Analysis(
            _userId);

        num_of_total_sms = int.parse(getNumberOfSMSMMS.toString());
        int _currScore = context
            .read<LaunchProvider>()
            .getUserInfo()
            .score;


        _timer = Timer.periodic(Duration(milliseconds: (_currScore == -1)? 150:80), (timer) async {
          if (num_of_total_sms != 0 &&
              num_of_completed_sms < num_of_total_sms) {
            setState(() {
              num_of_completed_sms++;
            });
          } else if (num_of_completed_sms == num_of_total_sms) {
            _timer?.cancel();

            if (num_of_completed_sms == num_of_total_sms) {
              int _score = 0;


              _currScore = context
                  .read<LaunchProvider>()
                  .getUserInfo()
                  .score;

              // 처음 검사할 때 문자 메세지 다 가져오기
              // print("sms list: $dataList");
              if (_currScore == -1) {
                DBHelper().deleteAllSMS();
                for (int i = 0; i < dataList.length; i++) {
                  DBHelper().insertSMS(dataList[i]);
                }

                await context.read<SmsProvider>().insertSMSList(
                    context.read<SmsProvider>().getUnknownSmsList());
                // print("TEST");
              }

              _score = ((1 - (num_of_smishing_sms / num_of_total_sms)) * 50).toInt();
              _score += (((_attendance_30 + _analysis_30) / 30) * 25).toInt();

              context.read<LaunchProvider>().updateAnalysisDate(context
                  .read<LaunchProvider>()
                  .getUserInfo()
                  .userId);

              context.read<LaunchProvider>().setScore(_score);
              context.read<LaunchProvider>().set_load_flag(true);
              await context.read<SmsProvider>().insertScore(_userId, _score);
              context.read<SmsProvider>().getInitialInfo(_userId);
              context.read<SmsProvider>().getReportDate(_userId);
              // context.read<SmsProvider>().updateScore(context.read<LaunchProvider>().getUserInfo().userId);


              Navigator.pop(context);
            }
          }
        });

        var getSMSandMMS = await platform.invokeMethod('getSMSMMS');
        if ( getSMSandMMS.length != 0 ){
          ch = getSMSandMMS.cast<String>() ;

          setState(() {
            msgs = ch ;
          });

          await context.read<SmsProvider>().setSmsToSmsProvider(msgs);
        }
      }

    } on PlatformException catch (e) {
      ch.add("No data") ;
    }

    // context.read<LaunchProvider>().setUpdate();
  }

  double isPhone(String Text){ //폰 번호 유무
    RegExp basicReg = RegExp(r'(\d{2,4})?(-|\s)?(\d{3,4})(-|\s)?(\d{3,4})');
    if(basicReg.hasMatch(Text)) {
      // Iterable<RegExpMatch> matches = basicReg.allMatches(Text);
      // for (final m in matches) {
      //   if(m[0].toString().length < 8) return 0.0;
      // }
      return 1.0;
    }
    else return 0.0;
  }

  double isUrl(String Text){
    RegExp basicReg = RegExp(r'(http)?(s)?:?(\/\/)?([a-z0-9\w]+\.*)+[a-z0-9]{2,4}');
    if(basicReg.hasMatch(Text)){
      // Iterable<RegExpMatch> matches = basicReg.allMatches(Text);
      // for (final m in matches) {
      //   if(!m[0].toString().contains('.')) return 0.0;
      // }
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
    if(Text.contains("+")|Text.contains("%")|Text.contains("/")) return 1.0;
    else return 0.0;
  }

  double smishing_symbol(String text){
    if(text.contains("만원") || text.contains("천원")|| text.contains("백원") || text.contains("십원")) return 1.0;
    RegExp pattern = RegExp(r",(\d{3})원");
    if(pattern.hasMatch(text)) return 1.0;
    else return 0.0;
  }

  /*List<double> keyword(String text){
    var ret_keyword=[0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0];

    for(int i =0; i<10; i++) {
      ABAE_keywords[i].forEach((value){
        if(text.contains(value)){
          ret_keyword[i] = 1.0;
        }
      });
    }
    for(int i =0; i<10; i++) {
      print(ret_keyword[i]);
    }
    return ret_keyword;
  }*/

  void model_create() async {
    interpreter_score = await Interpreter.fromAsset('smish_converted_model.tflite');
    interpreter_category = await Interpreter.fromAsset('cate_converted_model.tflite');
  }

  Future<void> _detectionSms() async {
    //final url = Uri.parse('http://52.53.168.246:5000/api') ;
    int _score = 0;
    int _userId = context.read<LaunchProvider>().getUserInfo().userId;
    int _attendance_30 = await context.read<AttendanceProvider>().get30Attendance(_userId);
    int _analysis_30 = await context.read<SmsProvider>().get30Analysis(_userId);
    final List<SmsInfo> smsData = context.read<SmsProvider>().getUnknownSmsList();
    var ret_keyword=List.generate(10, (index) => 0.0);
    var ret =List.generate(15, (index) => 0.0);
    // print("DATA"+smsData.length.toString());
    int type = 0;



    setState(() {
      num_of_total_sms = smsData.length;
    });

    // print("Total: " + num_of_total_sms.toString());

    int cnt = 1 ;

    for (int i = 0; i < smsData.length; i++) {
      ret[0] = isPhone(smsData[i].body);
      ret[1] = isUrl(smsData[i].body);
      ret[2] = textLength(smsData[i].body);
      ret[3] = MathSymbol(smsData[i].body);
      ret[4] = smishing_symbol(smsData[i].body);
      for(int j =0; j<10; j++) {
        ret_keyword[j]=0.0;
        ret[j+5]=0.0;
        for (int p = 0 ; p < ABAE_keywords[j].length; p++) {
          if(smsData[i].body.contains(ABAE_keywords[j][p])){
            ret_keyword[j] = 1.0;
            ret[j+5]=1.0;
          }
        }
        //print(ret[j]);
      }

      var output_score = List.filled(1 * 1, 0).reshape([1, 1]);
      var output_category = List.filled(1* 6, 0).reshape([1, 6]);

      interpreter_score.run(ret, output_score);
      interpreter_category.run(ret_keyword, output_category);

      // print(smsData[i].body + ":     " +output_score[0][0].toString());

      int max_index=0;
      double max_value=output_category[0][0];
      for (int k = 1; k < 6; k++) {
        // print(output_category[0][k]);
        if (max_value < output_category[0][k]) {
          max_index=k;
          max_value=output_category[0][k];
        }
      }
      type=max_index;

      // 0.5 이상 Smishing Data로 간주
      if (output_score[0][0] >= threshold ) {
        num_of_smishing_sms++;
        if ( num_of_smishing_sms <= 100 ) {
          Sms _sms = Sms(id: cnt,
              sender: smsData[i].phone,
              text: smsData[i].body,
              date: smsData[i].date,
              type: type,
              prediction: (output_score[0][0] * 100).toInt(),
              smishing: 1);
          dataList.add(_sms) ;
        }


      }
      else {
        Sms _sms = Sms(id: cnt,
            sender: smsData[i].phone,
            text: smsData[i].body,
            date: smsData[i].date,
            type: -1,
            prediction: (output_score[0][0] * 100).toInt(),
            smishing: 0);
        dataListNonSmishing.add(_sms) ;
      }
      cnt++;
      setState(() {
        // num_of_completed_sms++;
      });
    }
    // print("_detectionSms: $dataList") ;
    int _currScore = await context
        .read<LaunchProvider>()
        .getUserInfo()
        .score;
    context.read<SmsProvider>().setDangerSms(num_of_smishing_sms);
    if( _currScore == -1){
      context.read<SmsProvider>().insertSMSInfoList(dataList, _userId);
      context.read<SmsProvider>().insertSMSInfoList(dataListNonSmishing, _userId);
    }


    // print("SMISH: " + num_of_smishing_sms.toString() + " " + num_of_completed_sms.toString());

    //  밑에 코드 Timer 안에 넣음
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