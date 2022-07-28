/**
 * writer: 유이새
 * Date: 2022.07.04
 * Description: 404 error page
 */

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Error404 extends StatelessWidget {
  const Error404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lotties/error404.json',
                width: MediaQuery.of(context).size.width / 2),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '오류가 발생했습니다',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '불편을 드려 죄송합니다\n잠시 후 다시 시도해주세요',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text(
                '확인',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(
                      0xFF0372e0,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: const Size(208, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
