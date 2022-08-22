
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'kat_appbar_back.dart';

class KaTWebView extends StatelessWidget {
  const KaTWebView({Key? key, required this.title, required this.url}) : super(key: key);
  final String title, url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(title: title),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        userAgent: "random",
      ),
    );
  }
}
