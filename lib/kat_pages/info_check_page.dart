/**
 * writer: 유이새
 * Date: 2022.08.10
 * Description: 털린 내 정보 찾기 서비스 페이지 webview
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar_back.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InfoCheckPage extends StatefulWidget {
  const InfoCheckPage({Key? key}) : super(key: key);

  @override
  _InfoCheckPageState createState() => _InfoCheckPageState();
}

class _InfoCheckPageState extends State<InfoCheckPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarBack(title: "털린 정보 확인",),
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://kidc.eprivacy.go.kr/search/issueVerify.do',
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          userAgent: "random",
        ),
      ),
    );
  }
}
