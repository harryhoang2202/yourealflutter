import 'package:flutter/material.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'video_item.dart';

class VideoStorage extends StatefulWidget {
  const VideoStorage({
    Key? key,
    required this.videoUrls,
  }) : super(key: key);
  final List<String> videoUrls;

  @override
  _VideoStorageState createState() => _VideoStorageState();
}

class _VideoStorageState extends State<VideoStorage>
    with AutomaticKeepAliveClientMixin {
  final videos = <VideoItem>[];

  @override
  void didChangeDependencies() {
    for (final url in widget.videoUrls) {
      videos.add(VideoItem(url: url));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        if (index < 7) {
          return videos[index];
        }
        return SizedBox.fromSize(
          size: Size(90.w, 90.w),
          child: Stack(
            children: [
              videos[index],
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: yrColorLight.withOpacity(0.5),
                  child: Text(
                    "${videos.length - (index + 1)}+",
                    style: kText14Weight400_Dark,
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: yrColorSecondary,
                    onTap: () {},
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: videos.length > 8 ? 8 : videos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        crossAxisCount: 4,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
