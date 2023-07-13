import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key, required this.url});
  final String url;
  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  late WebViewController _controller;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: WebView(
        initialUrl: widget.url,
        onProgress: (a) {},
        onPageFinished: (a) {
          _isLoading = true;
          setState(() {});
        },
        onPageStarted: (a) {
          _isLoading = true;
          setState(() {});
        },
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (c) {
          _controller = c;
        },
      )),
    );
  }
}
