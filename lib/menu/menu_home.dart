/**
 * writerL: 유이새
 * update: 2022-08-19
 * description: 메뉴 홈 페이지
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/theme.dart';

class MenuHome extends StatefulWidget {
  const MenuHome({Key? key}) : super(key: key);

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  bool sns_tap = false;
  bool app_tap = false;

  ListTile menu_list_tile_nevigation(String tileTitle, IconData leadingIcon) {
    return ListTile(
      title: Text(
        tileTitle,
        style: AppTheme.menu_list,
      ),
      leading: Icon(
        leadingIcon,
        color: Colors.grey,
      ),
      onLongPress: () {},
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

  Column family_app(String image, String app_name){
    return Column(
      children: [
        Image.asset(image),
        Text(app_name, style: AppTheme.menu_news2,)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          Image.asset(
                            'assets/images/alert.png',
                            width: 20,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/menu_profile.png',
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '홍길동(1234)',
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
                            children: const [
                              Text(
                                '안심점수',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w100,
                                    color: Color(0xFF0b80f5)),
                              ),
                              Text(
                                ' 69점',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    //padding: const EdgeInsets.all(20.0),
                    // alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: Color(0xFFabe7ff),
                        border: Border.all(color: Color(0xFFabe7ff)),
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '피싱관련 주요뉴스',
                          style: AppTheme.menu_news,
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: const [
                            Text(
                              '[관련기사] ',
                              style: AppTheme.menu_news,
                              textAlign: TextAlign.left,
                            ),
                            // row안에 text overflow를 적용하려면 flexible을 사용해야함.
                            Flexible(
                              child: Text(
                                '야간근무 전 은행 들렀다 보이스피싱범 잡은 경찰이 어쩌고 저쩌고 일단 길게 쓰고',
                                style: AppTheme.menu_news2,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: Text(
                  "지인에게 추천하기",
                  style: AppTheme.menu_list,
                ),
                leading: Icon(
                  Icons.thumb_up_off_alt_outlined,
                  color: Colors.grey,
                ),
                dense: true,
              ),
              menu_divider(),
              menu_list_tile_nevigation('고객센터', Icons.support_agent_outlined),
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
                            onTap: () {},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: const Text(
                              '- 네이버블로그',
                              style: AppTheme.menu_news2,
                            ),
                            onTap: () {},
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
                onTap: (){setState(() {
                  app_tap = !app_tap;
                });},
              ),
              menu_divider(),
              app_tap?Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFf6f6f6),
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/instagram.png',)
                      ],
                    )
                    // family_app('assets/images/line.png', '피싱캣'),
                    // family_app('assets/images/line.png', '모의훈련\n출시예정'),
                    // family_app('assets/images/line.png', '시티즌코난'),
                  ],
                ),
              ):Container(),
              menu_list_tile_nevigation('공지사항', Icons.push_pin_rounded),
              menu_divider(),
              menu_list_tile_nevigation('설정', Icons.settings_outlined),
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
}
