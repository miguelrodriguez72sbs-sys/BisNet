import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

Widget buildGameEmbed({required String url, required String title}) {
  return Scaffold(
    backgroundColor: const Color(0xFFF9F9F4),
    appBar: AppBar(title: Text(title)),
    body: _GameIframe(url: url),
  );
}

class _GameIframe extends StatefulWidget {
  final String url;

  const _GameIframe({required this.url});

  @override
  State<_GameIframe> createState() => _GameIframeState();
}

class _GameIframeState extends State<_GameIframe> {
  late final String _viewType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewType = 'game-iframe-${widget.url.hashCode}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = widget.url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..onload = ((web.Event _) => _onLoaded()).toJS;
      return iframe;
    });
  }

  void _onLoaded() {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HtmlElementView(viewType: _viewType),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
