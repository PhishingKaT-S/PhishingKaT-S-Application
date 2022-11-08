import 'package:flutter/material.dart';

/*
* jiwon:
*  content:
*   7/29: adding
*             color: the collor startBackground
*             text style: button blue, start_caption
*             buttonstyle: buttonStyle_white
* */
class AppTheme {
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color whiteGrey = Color(0xFFF8F6F8);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color whiteText = Color(0XFFFFFFFF);
  static const Color greenText = Color(0xFF6EBD96);

  static const Color yellowText = Color(0xFFFFDE44);

  static const Color redText = Color(0xFFFF7573);

  static const Color deactivatedText = Color(0xFF767676);
  static const Color blueText = Color(0xFF0b80F5);

  static const Color greyText = Color(0xFF9b9b9b);

  static const Color orangeText = Color(0xFFFF971E);

  static const Color pinkText = Color(0xFFF48292);

  static const Color redText2 = Color(0xFFFD0000);

  static const Color redOrangeText = Color(0xFFF1712B);

  static const Color orangeText2 = Color(0xFFFFB846);

  static const Color greenText2 = Color(0xFF009944);

  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color blueBackground = Color(0xFFE8F4FF);

  static const Color whiteBackground = Color(0XFFFFFFFF);
  static const Color skyBackground = Color(0xFF9BCDFF);
  static const Color lightYellowBackground = Color(0xFFFCFDF5CE);

  static const Color whiteGreyBackground = Color(0xFFF0F0F0);

  static const Color blueLineChart = Color(0xFF0473E1);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color startBackground = Color(0xFF0473E1);
  static const Color pinkBackground = Color(0xFFF0C9D5);

  static const Color greenBackground = Color(0xFFB1D4C1);

  static const Color orangeBackground = Color(0xFFFEE3C6);

  static const Color redBackground = Color(0xFFFAC4C4);

  static const Color messageContent = Color(0xff231815); // 화면 7.1, , 8/17일 추가

  static const Color lightdark = Color(0xFF707070); //8/18 수정
  static const Color lightdark2 = Color(0xFF777777); //8/18 수정
  static const Color lightGrey = Color(0xFFb1aeae); //8/18 수정
  static const Color birth = Color(0xcc000000);

  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle big_title_white = TextStyle(
      fontFamily: fontName,
      fontSize: 59,
      color: white,
      fontWeight: FontWeight.bold);

  static const TextStyle big_subtitle_sky = TextStyle(
      fontFamily: fontName,
      fontSize: 25,
      color: skyBackground,
      fontWeight: FontWeight.bold);

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle display1_blue = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: blueText,
  );

  static const TextStyle score_start_pink = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: 0.4,
    height: 0.9,
    color: pinkText,
  );

  static const TextStyle display_orange = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    color: orangeText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: 'applegothicRegular',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: 'applegothicRegular',
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 1.5,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle0 = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: 'applegothicRegular',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: Colors.black, // was lightText
  );
  static const TextStyle caption_select = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: Colors.white, // was lightText
  );

  static const TextStyle caption2_black = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    letterSpacing: 0.2,
    color: AppTheme.nearlyBlack, // was lightText
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: 0.2,
    color: whiteText, // was lightText
  );

  static const TextStyle button_blue = TextStyle(
    // 로그인 버튼의 파란색 버튼
    fontFamily: 'applegothicRegular',
    fontWeight: FontWeight.bold,
    fontSize: 19,
    letterSpacing: 0.2,
    color: blueText,
    height: 1
  );

  static const TextStyle blue_normal = TextStyle(
    // 법규 화면의 개인정보 처리 방침 //제 1조 약관의 목적
    fontFamily: 'applegothicRegular',
    fontSize: 20,
    letterSpacing: 0.2,
    color: blueText,
  );

  static const TextStyle start_caption = TextStyle(
    //스타트 하단 텍스트
    fontFamily: fontName,
    fontSize: 10,
    letterSpacing: 0.2,
    color: whiteText,
  );

  static const TextStyle start_caption_button = TextStyle(
      //스타트 하단 텍스트
      fontFamily: fontName,
      fontSize: 10,
      letterSpacing: 0.2,
      color: whiteText,
      // decoration: TextDecoration.underline,
      // decorationThickness: 4,
      // decorationStyle: TextDecorationStyle.solid
  );

  static const TextStyle unseleted = TextStyle(
      fontFamily: 'applegothicRegular',
      fontSize: 14,
      letterSpacing: 0.7,
      color: darkText,
      fontWeight: FontWeight.w600);

  static const TextStyle selected = TextStyle(
      fontFamily: 'applegothicRegular',
      fontSize: 14,
      letterSpacing: 0.5,
      color: whiteText,
      fontWeight: FontWeight.w600);

  /* 8/3 수정 purpose, law_content 추가 */
  static const TextStyle purpose = TextStyle(
      //법규에 제1조 약관의 목적
      fontFamily: 'applegothicRegular',
      fontSize: 12,
      letterSpacing: 0.2,
      color: lightdark,
      fontWeight: FontWeight.bold);

  static const TextStyle law_content = TextStyle(
    //법규에 제1조 약관의 내용 화면 0.2 서비스 이용 약관
    fontFamily: 'applegothicRegular',
    fontSize: 12,
    letterSpacing: 0.2,
    height: 1.5,
    color: lightdark,
  );

  static const TextStyle title_blue = TextStyle(
      fontFamily: fontName,
      fontSize: 17,
      color: blueText,
      fontWeight: FontWeight.bold);

  static const TextStyle score_rank_white =
      TextStyle(fontFamily: fontName, fontSize: 14, color: white);

  static const TextStyle num_of_cases_black = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: darkText,
  );

  static const TextStyle rank_content_black = TextStyle(
    fontFamily: fontName,
    fontSize: 8,
    color: darkText,
  );

  static final ButtonStyle buttonStyle_white = ButtonStyle(
    //LoginPage 시작하기 버튼
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17.5),
    )),
    //shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
    //elevation: MaterialStateProperty.all<double>(0)
  );
  static final ButtonStyle bottom_button = ButtonStyle(
    //LoginPage 시작하기 버튼
    backgroundColor: MaterialStateProperty.all<Color>(startBackground),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    )),
    //shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
    //elevation: MaterialStateProperty.all<double>(0)
  );

  static final TextStyle birthday = TextStyle(
    // 문자 내에 위험요소, 1.7 url 검사
    fontFamily: fontName,
    fontSize: 17,
    letterSpacing: 0.2,
    color: birth, // was lightText
  );

  /* 8/17일 URL 검사결과() 1.7.1 ~ 1.8.1 텍스트 스타일*
   */
  static final TextStyle uncheck_messageManage = TextStyle(
    // 문자 내에 위험요소, 1.7 url 검사
    fontFamily: fontName,
    fontSize: 18,
    letterSpacing: 0.2,
    color: greyText, // was lightText
  );
  static final TextStyle check_messageManage = TextStyle(
    // 문자 내에 위험요소, 1.7 url 검사
    fontFamily: fontName,
    fontSize: 18,
    letterSpacing: 0.2,
    color: blueText, // was lightText
  );
  static const TextStyle smsPhone = TextStyle(
    //번호
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: -0.04,
    color: whiteText,
  );

  static const TextStyle checksmsContent = TextStyle(
    //문자 메세지 내용
    fontFamily: fontName,
    fontSize: 12,
    letterSpacing: 0.2,
    color: whiteText,
  );

  static const TextStyle unchecksmsContent = TextStyle(
    //문자 메세지 내용
    fontFamily: fontName,
    fontSize: 12,
    letterSpacing: 0.2,
    color: messageContent,
  );
  static const TextStyle whitetitle = TextStyle(
    //8/17일 수정
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    letterSpacing: 0.18,
    color: whiteText,
  );
  static const TextStyle unseletDate = TextStyle(
    //날짜
    fontFamily: fontName,
    fontSize: 12,
    letterSpacing: 0.2,
    color: greyText,
  );
  static const TextStyle selectDate = TextStyle(
    //날짜
    fontFamily: fontName,
    fontSize: 12,
    letterSpacing: 0.2,
    color: whiteText,
  );
  static const TextStyle unseletedURL = TextStyle(
      fontFamily: fontName,
      fontSize: 12,
      letterSpacing: 0.2,
      color: greyText,
      fontWeight: FontWeight.bold);
  static final ButtonStyle buttonStyle_whitewithbolder = ButtonStyle(
    //LoginPage 시작하기 버튼
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey, width: 2),
      borderRadius: BorderRadius.circular(17.5),
    )),
    //shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
    //elevation: MaterialStateProperty.all<double>(0)
  );

  static const TextStyle serviceLimit = TextStyle(
    // 0.3 권한 요청
    fontFamily: 'applegothicRegular',
    fontSize: 14,
    letterSpacing: 0.2,
    height: 1.5,
    color: greyText, // was lightText
  );
  static const TextStyle serviceAuth = TextStyle(
    // h6 -> title
    fontFamily: 'applegothicBold',
    fontSize: 19,
    height: 1.5,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle serviceCaption = TextStyle(
    // h6 -> title
    fontFamily: 'applegothicMedium',
    fontSize: 18,
    height: 1.5,
    letterSpacing: 0.18,
    color: lightGrey,
  );


  static const TextStyle nationalNumber = TextStyle(
    // 0.4 국가번호
    fontFamily: 'applegothicRegular',
    fontSize: 15,
    fontWeight: FontWeight.bold,
    height: 1.5,
    letterSpacing: 0.15,
    color: lightdark2,
  );
  static const TextStyle timer = TextStyle(
    // 0.4 timer
    fontFamily: 'applegothicRegular',
    fontSize: 15,
    fontWeight: FontWeight.bold,
    height: 1.5,
    letterSpacing: 0.15,
    color: blueText,
  );

  static const TextStyle certicationResend = TextStyle(
    // Caption -> caption
      fontFamily: 'applegothicRegular',
      fontSize: 14,
      letterSpacing: 0.2,
      color: blueText,
      // was lightText
      decoration: TextDecoration.underline);

  static const TextStyle unselecttoggleGender = TextStyle(
    // 0.5 생년성별 텍스트
      fontFamily: 'applegothicRegular',
      fontSize: 14,
      letterSpacing: 0.2,
      color: lightGrey,
      // was lightText
      fontWeight: FontWeight.bold);

  static const TextStyle selecttoggleGender = TextStyle(
    // 0.5 생년성별 텍스트
      fontFamily: 'applegothicRegular',
      fontSize: 14,
      letterSpacing: 0.2,
      color: whiteText,
      // was lightText
      fontWeight: FontWeight.bold);

  static const TextStyle menu_news = TextStyle(
    fontFamily: 'applegothicBold',
    fontSize: 13,
    letterSpacing: 0.2,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle family_app = TextStyle(
      fontFamily: 'applegothicLight',
      fontSize: 12,
      letterSpacing: 0.2,
      color: Colors.black,
      // fontWeight: FontWeight.w100,
      overflow: TextOverflow.ellipsis
  );

  static const TextStyle menu_news2 = TextStyle(
    fontFamily: 'applegothicBold',
    fontSize: 13,
    letterSpacing: 0.2,
    color: Colors.black,
    fontWeight: FontWeight.w100,
    overflow: TextOverflow.ellipsis
  );

  static const TextStyle menu_list = TextStyle(
      fontFamily: 'applegothicMedium',
      fontSize: 15,
      letterSpacing: 0.2,
      color: Color(0xFF9b9b9b),
  );
  static const TextStyle menu_list_select = TextStyle(
      fontFamily: 'applegothicMedium',
      fontSize: 12,
      letterSpacing: 0.2,
      color: Color(0xFF0b80f5),
      fontWeight: FontWeight.w600
  );

  static const TextStyle service_center = TextStyle(
      fontFamily: 'applegothicMedium',
      fontSize: 15,
      letterSpacing: 0.2,
      color: Color(0xFF010101),
      fontWeight: FontWeight.w500
  );

  static const TextStyle service_center_blue = TextStyle(
      fontFamily: 'applegothicMedium',
      fontSize: 12,
      letterSpacing: 0.2,
      color: Color(0xFF0b80f5),
      fontWeight: FontWeight.w500
  );
}
