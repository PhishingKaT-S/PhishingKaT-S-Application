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

  Widget _headerView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('voicephishing.jpeg')
        )
      ),
      child: Stack(
        children: [


        ],
      )
    );
  }

  Widget _newsList() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _headerView(),
              _newsList(),
            ],
          ),
        )
    );
  }
}
