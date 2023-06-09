// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file is used to extract code samples for the README.md file.
// Run update-excerpts if you modify this file.

// ignore_for_file: library_private_types_in_public_api, public_member_api_docs

// #docregion basic-example
import 'package:flutter/material.dart';
import 'package:video_player_mux/video_player_mux.dart';

void main() => runApp(const VideoApp());

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        data: {
        "env_key": "YOUR_ENV_KEY", //MUST PROVIDE
        "cpd_player_name": "YOUR_PLAYER_NAME",
        "cpd_viewer_user_id": "YOUR_VIEWER_USER_ID",
        "cvd_video_title": "YOUR_VIDEO_TITLE",
        "cvd_video_id": "YOUR_VIDEO_ID",
        "cd_1": "YOUR_CUSTOM_DATA_1",
        "cd_2": "YOUR_CUSTOM_DATA_2",
        "cd_3": "YOUR_CUSTOM_DATA_3",
        "cd_4": "YOUR_CUSTOM_DATA_4",
        "cd_5": "YOUR_CUSTOM_DATA_5",
        "cd_6": "YOUR_CUSTOM_DATA_6",
        "cd_7": "YOUR_CUSTOM_DATA_7",
        "cd_8": "YOUR_CUSTOM_DATA_8",
        "cd_9": "YOUR_CUSTOM_DATA_9",
        }
        )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
// #enddocregion basic-example
