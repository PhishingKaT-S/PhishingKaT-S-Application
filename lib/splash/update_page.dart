/**
 * writer: 유이새
 * Date: 2022.07.05
 * Description: SplashScreen for loading update data.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phishing_kat_pluss/theme.dart';

import '404_error.dart';

class UpdateSplashPage extends StatelessWidget {
  const UpdateSplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ///이미지
            const Text('업데이트', style: AppTheme.body1,),
            const Text('다운로드할 리소스가 있습니다', style: AppTheme.body2,),
            OutlinedButton(onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const DataLoading())),
              child: const Text('확인', style: AppTheme.body1),)
          ],
        ),
      ),
    );
  }
}

class DataLoading extends StatelessWidget {
  const DataLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      ///future: update할 데이터를 받아오는 부분
        future: UpdateData.instance.update(context),

        /// future의 상태에 따라 보여주는 화면이 다르다.
        /// future를 기다리는 중이면 Splash화면을 보여준다.
        builder: (context, AsyncSnapshot snapshot) {
          /// Loading 중 화면
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/downloading.json'),
                  const Text('진행중입니다', style: AppTheme.body1,),
                ],
              ),
            ); // 초기 로딩 시 Splash Screen
          }

          ///future에서 데이터를 불러오는 중에 에러가 발생하면 에러 메시지를 띄워준다.
          else if (snapshot.hasError) {
            return const MaterialApp(
                home: Error404()); // 초기 로딩 에러 시 Error Screen
          }

          ///future에서 데이터를 불러온 다음 home page로 이동
          else {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/complete.json'),
                  const Text('패치가 완료되었습니다', style: AppTheme.body1,),
                  OutlinedButton(onPressed: () =>
                      Navigator.pushNamed(context, '/testpage'),
                      child: const Text("앱 시작하기", style: AppTheme.body1,),),
                ],
              ),
            );
          }
        });
  }
}

class UpdateData {
  UpdateData._();

  static final instance = UpdateData._();

  Future update(BuildContext context) async {
    // . . .
    // udpate를 위한
    // . . .
    //
    return await Future.delayed(const Duration(milliseconds: 20000));
  }
}
