/**
 * writerL: 유이새
 * update: 2022-08-19
 * description: 메뉴 홈 페이지
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:phishing_kat_pluss/providers/news_provider.dart';
import 'package:phishing_kat_pluss/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/launch_provider.dart';
import 'package:flutter_share/flutter_share.dart';

import 'sns_webview.dart';

class MenuHome extends StatefulWidget {
  const MenuHome({Key? key}) : super(key: key);

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  bool sns_tap = false;
  bool app_tap = false;
  bool setting_tap = false;
  DateTime? _setting_contact_sync = null;
  bool auto_update = false;

  List<String> news = [];

  // @override
  // void initState(){
  //   super.initState();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) async{
  //     news = Provider.of<NewsProvider>(context, listen: false).getNewsContent();
  //   });
  // }

  static const platform = MethodChannel('onestore');

  ListTile menu_list_tile_nevigation(
      String tileTitle, IconData leadingIcon, String page) {
    return ListTile(
      title: Text(
        tileTitle,
        style: AppTheme.menu_list,
      ),
      leading: Icon(
        leadingIcon,
        color: Colors.grey,
      ),
      onTap: () => Navigator.pushNamed(context, page),
      dense: true,
    );
  }

  Divider menu_divider() {
    return Divider(
      thickness: 1,
      height: 0,
      indent: 10,
      endIndent: 10,
    );
  }

  GestureDetector family_app(String image, String app_name, String t_url) {
    return GestureDetector(
      onTap: () async {
        await platform
            .invokeMethod("browseOneStore", <String, String>{"url": t_url});
      },
      child: Column(
        children: [
          Image.asset(
            image,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Text(
            app_name,
            style: AppTheme.menu_news2,
          )
        ],
      ),
    );
  }

  Container share_app(String image, String app_name) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      child: Column(
        children: [
          Image.asset(
            image,
            width: MediaQuery.of(context).size.width * 0.13,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            app_name,
            style: AppTheme.menu_news2,
          )
        ],
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'PhishingKaT-S+',
        text: 'phishingkat-s',
        linkUrl: 'app url',
        chooserTitle: 'PhishingKaT-s+');
  }

  @override
  Widget build(BuildContext context) {
    news = context.watch<NewsProvider>().getNewsContent();
    //LaunchProvider _userProvider = Provider.of<LaunchProvider>(context);
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Image.asset(
              'assets/images/menu_background.png',
              //width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.30,
              fit: BoxFit.none,
            ),
            Consumer<LaunchProvider>(
              builder: (BuildContext context, countProvider, child) =>
                  Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        /**
                                 * 여기에 알람에 유무에 따라 동적으로 아이콘을 변경해야함.
                                 */
                        Stack(
                          children: [
                            InkWell(
                                child: Container(
                                    child: Image.asset(
                                  'assets/images/alert.png',
                                  width: 20,
                                )),
                                onTap: () {
                                  Navigator.pushNamed(context, '/menu/alarm');
                                })
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/menu_profile.png',
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<LaunchProvider>(context)
                                  .getUserInfo()
                                  .nickname
                                  .toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              children: [
                                const Text(
                                  '안심점수',
                                  style: TextStyle(
                                      fontSize: 15,
                                      //fontWeight: FontWeight.w100,
                                      fontFamily: 'NotoSansKRBold',
                                      color: Color(0xFF0b80f5)),
                                ),
                                Provider.of<LaunchProvider>(context)
                                            .getUserInfo()
                                            .score ==
                                        -1
                                    ? const Text(
                                        '--',
                                        style: TextStyle(
                                            fontSize: 15,
                                            //fontWeight: FontWeight.w900,
                                            fontFamily: 'NotoSansKRBold',
                                            color: Color(0xFF0b80f5)),
                                      )
                                    : Text(
                                        ' ${Provider.of<LaunchProvider>(context).getUserInfo().score}점',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            //fontWeight: FontWeight.w900,
                                            fontFamily: 'NotoSansKRBold',
                                            color: Color(0xFF0b80f5)),
                                      ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/menu/news');
                      },
                      child: Container(
                        height: 50,
                        //padding: const EdgeInsets.all(20.0),
                        // alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            color: const Color(0xFFabe7ff),
                            border: Border.all(color: const Color(0xFFabe7ff)),
                            borderRadius: BorderRadius.circular(15.0)),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '피싱관련 주요뉴스',
                              style: AppTheme.menu_news,
                              textAlign: TextAlign.left,
                            ),
                            Row(
                              children: [
                                const Text(
                                  '[관련기사] ',
                                  style: AppTheme.menu_news,
                                  textAlign: TextAlign.left,
                                ),
                                context
                                    .watch<NewsProvider>()
                                    .getNewsContent()[0] == " "?
                                    const Text(""):

                                // row안에 text overflow를 적용하려면 flexible을 사용해야함.
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child:
                                    AnimatedTextKit(
                                      repeatForever: true,
                                      animatedTexts: [
                                        FadeAnimatedText(
                                          context
                                              .watch<NewsProvider>()
                                              .getNewsContent()[0],
                                          textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                                            duration: const Duration(seconds: 5)

                                        ),
                                        FadeAnimatedText(context
                                            .watch<NewsProvider>()
                                            .getNewsContent()[1],
                                          textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                                            duration: const Duration(seconds: 5)

                                        ),
                                        FadeAnimatedText(context
                                            .watch<NewsProvider>()
                                            .getNewsContent()[2],
                                          textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                                          duration: const Duration(seconds: 5)
                                        ),
                                      ],
                                    )
                                    // Text(
                                    //   context.watch<NewsProvider>().getNewsContent()[0],
                                    //   //news[0],
                                    //   style: AppTheme.menu_news2,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   maxLines: 1,
                                    //   softWrap: true,
                                    // ),
                                    )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text(
                  "지인에게 추천하기",
                  style: AppTheme.menu_list,
                ),
                leading: const Icon(
                  Icons.thumb_up_off_alt_outlined,
                  color: Colors.grey,
                ),
                dense: true,
                onTap: () {
                  //buildShowMaterialModalBottomSheet(context);
                  share();
                },
              ),
              menu_divider(),
              menu_list_tile_nevigation(
                  '고객센터', Icons.support_agent_outlined, '/menu/service_center'),
              menu_divider(),
              ListTile(
                title: Text(
                  "SNS",
                  style: AppTheme.menu_list,
                ),
                leading: Icon(
                  Icons.language_outlined,
                  color: Colors.grey,
                ),
                trailing: sns_tap
                    ? Icon(Icons.keyboard_arrow_down_outlined)
                    : Icon(Icons.keyboard_arrow_up_outlined),
                dense: true,
                onTap: () {
                  setState(() {
                    sns_tap = !sns_tap;
                  });
                },
              ),
              menu_divider(),
              sns_tap
                  ? Container(
                      color: Color(0xFFf6f6f6),
                      padding:
                          EdgeInsets.only(top: 15.0, bottom: 15.0, left: 70),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Text(
                              '- 인스타그램',
                              style: AppTheme.menu_news2,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SnsWebView(
                                      url:
                                          "https://www.instagram.com/phishingkat/"),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: const Text(
                              '- 네이버블로그',
                              style: AppTheme.menu_news2,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SnsWebView(
                                      url:
                                          "https://blog.naver.com/jubileeline21"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
              ListTile(
                title: const Text(
                  "패밀리 앱",
                  style: AppTheme.menu_list,
                ),
                leading: const Icon(
                  Icons.share,
                  color: Colors.grey,
                ),
                trailing: app_tap
                    ? const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      )
                    : const Icon(Icons.keyboard_arrow_up_outlined,
                        color: Colors.grey),
                dense: true,
                onTap: () {
                  setState(() {
                    app_tap = !app_tap;
                  });
                },
              ),
              menu_divider(),
              app_tap
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xFFf6f6f6),
                      padding: EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 70, right: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          family_app('assets/images/phishingKat.png', '피싱캣',
                              'https://m.onestore.co.kr/mobilepoc/apps/appsDetail.omp?prodId=0000758242'),
                          family_app(
                              'assets/images/phishingKatPlus.png',
                              '모의훈련\n출시예정',
                              'http://phishingkat.com/app/PKat-TL-22.apk'),
                          family_app('assets/images/citizenConan.png', '시티즌코난',
                              'https://m.onestore.co.kr/mobilepoc/apps/appsDetail.omp?prodId=0000758242'),
                        ],
                      ),
                    )
                  : Container(),
              menu_list_tile_nevigation(
                  '공지사항', Icons.push_pin_rounded, '/menu/notice'),
              menu_divider(),
              // menu_list_tile_nevigation('설정', Icons.settings_outlined, '/menu/setting'),
              ListTile(
                title: const Text(
                  '설정',
                  style: AppTheme.menu_list,
                ),
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Colors.grey,
                ),
                trailing: setting_tap
                    ? const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      )
                    : const Icon(Icons.keyboard_arrow_up_outlined,
                        color: Colors.grey),
                onTap: () {
                  setState(() {
                    setting_tap = !setting_tap;
                  });
                },
                dense: true,
              ),
              setting_tap
                  ? Container(
                      color: Color(0xFFf6f6f6),
                      padding: EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 70, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '- 연락처 동기화',
                                    style: AppTheme.menu_news2,
                                  ),
                                  Text(
                                      (_setting_contact_sync != null)
                                          ? ('${_setting_contact_sync?.year}년 ${_setting_contact_sync?.month}월 ${_setting_contact_sync?.day}일')
                                          : ('No date'),
                                      style: AppTheme.caption),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.sync_rounded),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '- DB 자동 업데이트',
                                  style: AppTheme.menu_news2,
                                ),
                                FlutterSwitch(
                                  height: 25,
                                  showOnOff: true,
                                  activeTextColor: AppTheme.white,
                                  inactiveTextColor: AppTheme.white,
                                  value: auto_update,
                                  onToggle: (val) {
                                    setState(() {
                                      auto_update = val;
                                    });
                                  },
                                )
                              ])
                        ],
                      ),
                    )
                  : Container(),
              menu_divider(),
              ListTile(
                title: const Text(
                  "버전 정보",
                  style: AppTheme.menu_list,
                ),
                leading: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.grey,
                ),
                trailing: Text(
                  "V.0.0.1",
                  style: AppTheme.menu_list,
                ),
                onTap: () {},
                dense: true,
              ),
            ],
          ),
        )
      ],
    ));
  }

  Future<dynamic> buildShowMaterialModalBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      duration: const Duration(milliseconds: 400),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "공유하기",
                style: TextStyle(
                    fontFamily: 'dreamGothic5',
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const Divider(
              thickness: 3,
              height: 0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                share_app('assets/images/facebook.png', '페이스북'),
                share_app('assets/images/twitter.png', '트위터'),
                share_app('assets/images/instagram.png', '인스타그램'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                share_app('assets/images/kakaokalk.png', '카카오툭'),
                share_app('assets/images/line.png', '라인'),
                share_app('assets/images/band.png', '밴드'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                share_app('assets/images/email.png', '이메일'),
                share_app('assets/images/message.png', '메시지'),
                share_app('assets/images/copy_url.png', 'URL복사'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
