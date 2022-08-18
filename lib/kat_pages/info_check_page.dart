/**
 * writer: 유이새
 * Date: 2022.08.10
 * Description: 털린 내 정보 찾기 서비스 페이지 webview
 */

import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phishing_kat_pluss/kat_widget/kat_appbar_back.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class InfoCheckPage extends StatefulWidget {
  const InfoCheckPage({Key? key}) : super(key: key);

  @override
  _InfoCheckPageState createState() => _InfoCheckPageState();
}

class _InfoCheckPageState extends State<InfoCheckPage> {
  @override
  Widget build(BuildContext context) {
    Future<ConnectivityResult> checkConnectionStatus() async {
      var result = await (Connectivity().checkConnectivity());
      print(result);
      if (result == ConnectivityResult.none) {
        throw new SocketException("인터넷 연결 상태를 확인해 주세요.");
      }

      return result;  // wifi, mobile
    }

    Future http_status() async {
      var url = Uri.parse(
        'https://kidc.eprivacy.go.kr/search/issueVerify.do',
      );
      final response = await http.get(url);
      print(response.headers);
      print('Response status: ${response.statusCode}');
      return response;
    }

    return Scaffold(
        appBar: AppBarBack(
        title: "털린 정보 확인",
      ),
      body: FutureBuilder(
        future: checkConnectionStatus(),
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          if(true){
            return Container();
          }
          else{
            return SafeArea(
              child: WebView(
                initialUrl: 'https://kidc.eprivacy.go.kr/search/issueVerify.do',
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                userAgent: "random",
              ),
            );
          }

        }),
      ),
    );
  }
}
