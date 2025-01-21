import 'dart:io';

import 'package:flutter/material.dart';

class PreviewTestScreen extends StatelessWidget {
  final String title;
  final String image;
  final String musicUrl;

  const PreviewTestScreen({super.key,
    required this.title,
    required this.image,
    required this.musicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Image.file(File(image)),
          const SizedBox(height: 20),
          Text("Music: $musicUrl"),
          // Add the music player logic to play the selected music here
        ],
      ),
    );
  }
}
