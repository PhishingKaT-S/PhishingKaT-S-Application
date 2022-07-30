import 'package:flutter/material.dart';
/*
* jiwon:
*  content:
*   7/29: adding
*             color: the collor startBackground
*             text style: button blue, start_caption
*             buttonstyle: buttonStyle_white
* */
class AppTheme{

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color whiteGrey = Color(0xFFF8F6F8) ;

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color whiteText = Color(0XFFFFFFFF);
  static const Color greenText = Color(0xFF6EBD96) ;
  static const Color yellowText = Color(0xFFFFDE44) ;
  static const Color redText = Color(0xFFFF7573) ;
  static const Color deactivatedText = Color(0xFF767676);
  static const Color blueText = Color(0xFF0b80F5) ;
  static const Color greyText = Color(0xFF9b9b9b) ;
  static const Color orangeText = Color(0xFFFF971E) ;

  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color blueBackground = Color(0xFFE8F4FF) ;
  static const Color whiteBackground = Color(0XFFFFFFFF);
  static const Color skyBackground = Color(0xFF9BCDFF);
  static const Color lightYellowBackground = Color(0xFFFCFDF5CE) ;
  static const Color whiteGreyBackground = Color(0xFFF0F0F0) ;
  static const Color blueLineChart = Color(0xFF0473E1);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color startBackground = Color(0xFF0473E1);
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

  static const TextStyle display1 = TextStyle( // h4 -> display1
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

  static const TextStyle display_orange = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    color: orangeText,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle0 = TextStyle( // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static const TextStyle caption2_black = TextStyle( // Caption -> caption
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

  static const TextStyle button_blue = TextStyle( // 로그인 버튼의 파란색 버튼
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 19,
    letterSpacing: 0.2,
    color:blueText,
  );

  static const TextStyle start_caption = TextStyle( //스타트 하단 텍스트
    fontFamily: fontName,
    fontSize: 10,
    letterSpacing: 0.2,
    color: whiteText,
  );

  static final ButtonStyle buttonStyle_white = ButtonStyle( //LoginPage 시작하기 버튼
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17.5),
    ))
  );
}