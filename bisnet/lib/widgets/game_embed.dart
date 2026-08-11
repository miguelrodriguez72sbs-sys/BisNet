import 'package:flutter/material.dart';

import 'game_embed_io.dart' if (dart.library.html) 'game_embed_web.dart';

class GameEmbed extends StatelessWidget {
  final String url;
  final String title;

  const GameEmbed({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return buildGameEmbed(url: url, title: title);
  }
}
