import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String href;
  const WebPage(this.href, {Key? key}) : super(key: key);
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  void initState() {
    print(widget.href);
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebBrowser(
        initialUrl: widget.href,
        javascriptEnabled: true,
      ),
    );
  }
}
