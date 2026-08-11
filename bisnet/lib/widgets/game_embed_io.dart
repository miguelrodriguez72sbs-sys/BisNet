import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget buildGameEmbed({required String url, required String title}) {
  return Scaffold(
    backgroundColor: const Color(0xFFF9F9F4),
    appBar: AppBar(title: Text(title)),
    body: _GameWebView(url: url),
  );
}

class _GameWebView extends StatefulWidget {
  final String url;

  const _GameWebView({required this.url});

  @override
  State<_GameWebView> createState() => _GameWebViewState();
}

class _GameWebViewState extends State<_GameWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
