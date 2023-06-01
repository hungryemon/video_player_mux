<?code-excerpt path-base="excerpts/packages/video_player_mux_example"?>

# Video Player Mux plugin for Flutter with Mux monitoring feature

[![pub package](https://img.shields.io/pub/v/video_player.svg)](https://pub.dev/packages/video_player_mux)

A Flutter plugin for Android for playing back video on a Widget surface and sending data to mux for monitoring.

|             | Android |
|-------------|---------|
| **Support** | SDK 21+ |

![The example app running](https://github.com/hungryemon/video_player_mux/tree/master/doc/demo_ipod.gif?raw=true)

## Installation

First, add `video_player_mux` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).


### Android

If you are using network-based videos, ensure that the following permission is present in your
Android Manifest file, located in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Also add the following snippet in app-level build.gradle `<project root>/android/app/build.gradle`:
```gradle
// Build the plugin project with warnings enabled. This is here rather than
// in the plugin itself to avoid breaking clients that have different
// warnings (e.g., deprecation warnings from a newer SDK than this project
// builds with).
gradle.projectsEvaluated {
    project(":video_player_android_mux") {
        tasks.withType(JavaCompile) {
            options.compilerArgs << "-Xlint:all" << "-Werror"

            // Workaround for several warnings when building
            // that the above turns into errors, coming from
            // org.checkerframework.checker.nullness.qual and 
            // com.google.errorprone.annotations:
            // 
            //   warning: Cannot find annotation method 'value()' in type
            //   'EnsuresNonNull': class file for
            //   org.checkerframework.checker.nullness.qual.EnsuresNonNull not found
            //
            //   warning: Cannot find annotation method 'replacement()' in type
            //   'InlineMe': class file for
            //   com.google.errorprone.annotations.InlineMe not found
            //
            // The dependency version are taken from:
            // https://github.com/google/ExoPlayer/blob/r2.18.1/constants.gradle
            //
            // For future reference the dependencies are excluded here:
            // https://github.com/google/ExoPlayer/blob/r2.18.1/library/common/build.gradle#L33-L34
            dependencies {
                implementation "org.checkerframework:checker-qual:3.13.0"
                implementation "com.google.errorprone:error_prone_annotations:2.10.0"
            }
        }
    }
}
```

## Supported Formats

- On Android, the backing player is [ExoPlayer](https://google.github.io/ExoPlayer/),
  please refer [here](https://google.github.io/ExoPlayer/supported-formats.html) for list of supported formats.

## Example

<?code-excerpt "basic.dart (basic-example)"?>
```dart
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
        //ONLY WORKS FOR ANDROID NOW
        data: {
        "env_key": "YOUR_ENV_KEY", //MUST PROVIDE
        "cpd_player_name": "YOUR_PLAYER_NAME",
        "cpd_viewer_user_id": "YOUR_VIEWER_USER_ID",
        "cvd_video_title": "YOUR_VIDEO_TITLE",
        "cvd_video_id": "YOUR_VIDEO_ID",
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
```

## Usage

The following section contains usage information that goes beyond what is included in the
documentation in order to give a more elaborate overview of the API.

This is not complete as of now. You can contribute to this section by [opening a pull request](https://github.com/flutter/packages/pulls).

### Playback speed

You can set the playback speed on your `_controller` (instance of `VideoPlayerController`) by
calling `_controller.setPlaybackSpeed`. `setPlaybackSpeed` takes a `double` speed value indicating
the rate of playback for your video.
For example, when given a value of `2.0`, your video will play at 2x the regular playback speed
and so on.

To learn about playback speed limitations, see the [`setPlaybackSpeed` method documentation](https://pub.dev/documentation/video_player/latest/video_player/VideoPlayerController/setPlaybackSpeed.html).

Furthermore, see the example app for an example playback speed implementation.
