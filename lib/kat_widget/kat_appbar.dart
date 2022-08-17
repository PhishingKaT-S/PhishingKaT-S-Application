/// update: 2022-06-29
/// AppBar widget
/// 최종 작성자: 유이새

import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/theme.dart';

//AppBar를 위젯으로 만들어서 사용하기 위해서는 PreferredSizeWidget으로 만들어야 한다.
class KaTAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KaTAppBar({Key? key}) : super(key: key);

  // error: Missing concrete implementation of 'getter PreferredSizeWidget.preferredSize'.
  // error 해결하기 위해서 getter 추가
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset('assets/logo/appbar_title.png', scale: 8,), // title of AppBar
      elevation: 0.0, // appbar 하단의 그림자 제거
      backgroundColor: Colors.white,
      actions: [

      ],
    );
  }
}