import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/tools.dart';

class DealImagesWidget extends StatefulWidget {
  const DealImagesWidget({
    Key? key,
    required this.deal,
  }) : super(key: key);
  final Deal deal;

  @override
  State<DealImagesWidget> createState() => _DealImagesWidgetState();
}

class _DealImagesWidgetState extends State<DealImagesWidget> {
  bool get isHasImage => _imageSliders.isNotEmpty;

  bool get iSingleImage => _imageSliders.length == 1;
  final List<Widget> _imageSliders = [];
  int _currentImage = 0;

  _loadImageSliders() {
    final imagePaths =
        widget.deal.realEstate?.realEstateImages?.content?.split(",");
    if (imagePaths == null) return;

    for (int i = 0; i < imagePaths.length; i++) {
      _imageSliders.add(
        getImage(
          imagePaths[i],
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            openPhotoViewer(context,
                index: i, imagePaths: imagePaths, viewOnly: true);
          },
          height: 100.h,
          width: 1.sw,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImageSliders();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isHasImage)
          CarouselSlider(
            items: _imageSliders,
            options: CarouselOptions(
                enableInfiniteScroll: iSingleImage ? false : true,
                autoPlay: iSingleImage ? false : true,
                height: 227.h,
                enlargeCenterPage: true,
                aspectRatio: 1.7,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImage = index;
                  });
                }),
          ),
        if (!iSingleImage)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _imageSliders.map((url) {
              int index = _imageSliders.indexOf(url);
              return Container(
                width: 8.0.w,
                height: 8.0.w,
                margin:
                    EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 2.0.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentImage == index ? yrColorSecondary : yrColorLight,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
