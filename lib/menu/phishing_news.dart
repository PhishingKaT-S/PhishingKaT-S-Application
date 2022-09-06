/**
 * writer: 유이새
 * Date: 2022.08.31
 * Description: webview
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class NewsWebView extends StatefulWidget {
  const NewsWebView({Key? key}) : super(key: key);

  @override
  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
          child: WebView(
            initialUrl: 'https://blog.naver.com/jubileeline21',
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            userAgent: "random",
          ),
        ));
  }
}
