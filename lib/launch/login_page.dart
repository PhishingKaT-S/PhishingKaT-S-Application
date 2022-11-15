/*
* writer Jiwon Jung
* date: 7/29
* description: adding the bottom line writing
* */

/*
writer:정지원
date: 7/26
description: Creating the LoginPage
next Page=>AccessAuthority()
*
* */

import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/launch/access_authority.dart';
import 'package:provider/provider.dart';
import '../providers/launch_provider.dart';
import 'policy.dart';

import '../theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.topCenter,
          color: AppTheme.startBackground,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '시작하기를 누르면',
                style: AppTheme.start_caption,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Policy()));
                },
                child: const Text(
                  '이용약관 및 정책',
                  style: AppTheme.start_caption_button,
                ),
              ),
              const Text(
                '동의로 간주합니다',
                style: AppTheme.start_caption,
              ),
            ],
          ),
        ),
        body: Container(
          color: AppTheme.startBackground,
          child: Center(child: _start_view(context)),
        ));
  }

  Widget _bottom_bar() {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.topCenter,
      color: AppTheme.startBackground,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '시작하기를 누르면',
            style: AppTheme.start_caption,
          ),
          TextButton(
            onPressed: () {
              // Navigator.push(LoginPage.context,
              //   MaterialPageRoute(builder: (context) => Policy()));
            },
            child: const Text(
              '이용약관 및 정책',
              style: AppTheme.start_caption_button,
            ),
          ),
          const Text(
            '동의로 간주합니다',
            style: AppTheme.start_caption,
          ),
        ],
      ),
    );
  }

  Widget _start_view(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.zero,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '나와 내 이웃을 지키는',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'shineforU',
                  height: 1),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.zero,
          child: const Align(
            alignment: Alignment.topCenter,
            child: Text(
              '피싱캣S',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'shineforU',
                  height: 1.1),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          height: 35,
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextButton(
              style: AppTheme.buttonStyle_white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccessAuthority()));
              },
              child: const Text("시작하기", style: AppTheme.button_blue, )),
        ),
      ],
    );
  }

  /*
    * 구현 맞추기 위한 sizedbox
    *
    * */
  Widget expanded_sizedBox() {
    return const Expanded(
        child: // 간격 맞추기
            SizedBox(),
        flex: 1);
  }
}
