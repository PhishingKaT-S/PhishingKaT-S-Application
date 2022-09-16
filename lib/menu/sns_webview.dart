import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnsWebView extends StatelessWidget {
  final String url;
  const SnsWebView( {Key? key, required this.url}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: "random",
        ),
      ),
    );
  }
}
