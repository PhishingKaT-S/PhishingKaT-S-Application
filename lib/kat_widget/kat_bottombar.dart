/// update: 2022-07-21
/// Homepage
/// 최종 작성자: 김진일

import 'package:flutter/material.dart';

import '../theme.dart';

class KatBottomBar extends StatefulWidget {
  const KatBottomBar({Key? key}) : super(key: key);

  @override
  State<KatBottomBar> createState() => _KatBottomBar() ;
}

class _KatBottomBar extends State<KatBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * BottomNavigationBar
     * 모든 화면에 하단 바로 사용
     * 홈, 메세지 관리, 메뉴 페이지가 구현되어 있지 않아, 각각 페이지로 Navigation은 아직 적용 X
     * */
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: '메세지관리',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: '메뉴',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppTheme.blueText,
      onTap: _onItemTapped,
    );
  }
}