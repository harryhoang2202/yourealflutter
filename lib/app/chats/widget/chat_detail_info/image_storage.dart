import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

class ImageStorage extends StatefulWidget {
  const ImageStorage({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  final List<String> imageUrls;

  @override
  State<ImageStorage> createState() => _ImageStorageState();
}

class _ImageStorageState extends State<ImageStorage>
    with AutomaticKeepAliveClientMixin {
  List<Widget> images = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.imageUrls.length; i++) {
      images.add(
        getImage(
          widget.imageUrls[i],
          onTap: () {
            openPhotoViewer(context,
                index: i, imagePaths: widget.imageUrls, viewOnly: true);
          },
          width: 90.w,
          height: 90.w,
          borderRadius: BorderRadius.circular(10),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        if (index < 7 || index == 7 && images.length == 8) {
          return images[index];
        }

        return SizedBox.fromSize(
          size: Size(90.w, 90.w),
          child: Stack(
            children: [
              images[index],
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: yrColorLight.withOpacity(0.5),
                  child: Text(
                    "${images.length - (index + 1)}+",
                    style: kText14Weight400_Dark,
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: yrColorSecondary,
                    onTap: () {
                      openPhotoViewer(
                        context,
                        index: index,
                        imagePaths: widget.imageUrls,
                        viewOnly: true,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: images.length > 8 ? 8 : images.length,
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
