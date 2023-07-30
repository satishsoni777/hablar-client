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
  WebViewController? _webViewController;
  @override
  void initState() {
    _webViewController = WebViewController();
    _webViewController
      ?..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController?.setNavigationDelegate(NavigationDelegate(onPageFinished: (a) {
      _isLoading = true;
      setState(() {});
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Stack(
        children: <Widget>[
          WebViewWidget(controller: _webViewController!),
          if (!_isLoading)
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ))
        ],
      )),
    );
  }
}
