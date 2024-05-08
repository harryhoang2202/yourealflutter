import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvt_tab_bar/tvt_tab_bar.dart';

import 'package:video_player/video_player.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(90.w, 90.w),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              pushNewScreen(context,
                  screen: FullScreenVideoPlayer(controller: _controller));
            },
            child: VideoPlayer(_controller),
          ),
          Positioned(
            bottom: 10.h,
            child: Container(
              color: yrColorLight.withOpacity(0.5),
              width: 90.w,
              padding: EdgeInsets.only(right: 2.w),
              alignment: Alignment.centerRight,
              child: Text(
                durationToString(_controller.value.duration),
                style: kText14Weight400_Dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  const FullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      body: NestedWillPopScope(
        onWillPop: () async {
          if (controller.value.isPlaying) {
            await controller.pause();
          }
          return Future.value(true);
        },
        child: Center(
          child: controller.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                  child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller)),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
