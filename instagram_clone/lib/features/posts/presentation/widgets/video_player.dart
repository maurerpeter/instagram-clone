import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:meta/meta.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const VideoPlayerWidget({
    Key key,
    @required this.videoPlayerController,
    this.looping,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    // Wrapper on top of the videoPlayerController
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 1,
        autoInitialize: true,
        looping: widget.looping,
        autoPlay: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
