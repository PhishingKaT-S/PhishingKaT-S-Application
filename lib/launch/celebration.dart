/*
   write: jiwon
   date: 7 26
   discription 0.6 celebration for joinning
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Theme.dart';
import '../kat_pages/home_page.dart';
import '../kat_widget/launch_appbar.dart';
import '../providers/launch_provider.dart';

/*
* 이 화면이 보이면 3초후 꺼지고 진짜 home으로 돌아감
*
* */

class CeleBration extends StatefulWidget {
  @override
  State<CeleBration> createState() => _CeleBrationState();
}

class _CeleBrationState extends State<CeleBration> {
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 3000))
    //     .then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    //     builder: (context) =>  const HomePage()), (route) => false));
    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline1!,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.height * 0.1,
                    20,
                    0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  '당신과,\n당신의 소중한 이웃들이\n피싱으로부터 안전할 수 있게',
                  style: AppTheme.title,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    0,
                    20,
                    MediaQuery.of(context).size.width * 0.1),
                alignment: Alignment.centerLeft,
                child: const Text(
                  '피싱캣S는 모두가 안심하고\n소통할 수 있는 세상을 만듭니다',
                  style: AppTheme.body1,
                ),
              ),
              Container (
                  padding: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/images/launch_end.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth)
              )
            ],
          ),
        ),
      ), //당신과 당신의
    );
  }
}