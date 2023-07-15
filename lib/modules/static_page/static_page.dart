import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key, required this.url});
  final String url;
  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
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
          child: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            onProgress: (a) {},
            onPageFinished: (a) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageStarted: (a) {
              setState(() {
                _isLoading = true;
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (c) {},
          ),
          if (!_isLoading)
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ))
        ],
      )),
    );
  }
}
