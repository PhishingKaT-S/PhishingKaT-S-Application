/**
 * update: 2022-08-18
 * Detect noticePage
 * 최종 작성자: 김진일
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kat_widget/kat_appbar_back.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<String> title = ['피싱캣S 공지사항', '피싱캣S 공지사항'] ;
  List<String> written_date = ['2021. 5. 31', '2021. 5. 31'] ;
  List<String> content = ['hello', '안녕하세요, 피싱캣S 개발팀 입니다.\n\n드디어 정식 서비스를 런칭하게 되었습니다.\n\n저희 서비스는 데이터 취약계층을 위한 스미싱 솔루션으로 자연어처리기법(NLP)를 이용하여 실시간 문자탐지로 사기 위험이 높은 문자를 분류하고 스미싱 피해를 예방(방지)하는 솔루션입니다.\n\n베타 런칭 기간'] ;

  Widget _expansionTile(int index) {
    bool notice_tap = false;

    return ExpansionTile(
      trailing: notice_tap
        ? Icon(Icons.keyboard_arrow_down_outlined)
        : Icon(Icons.keyboard_arrow_up_outlined),

      title: Text(title[index]),
      subtitle: Text(written_date[index]),
      children: <Widget>[
        ListTile(
          title: Text(content[index]), tileColor: const Color(0xFFF6F6F6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(title: '공지사항'),
      body: Column(
        children: List.generate(title.length, (index) {
          return _expansionTile(index) ;
        }),
      ),
    );
  }
}
