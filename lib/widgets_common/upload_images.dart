import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

class UploadImage extends StatefulWidget {
  final Function(List<String>) onImageSelected;
  final Function? onTap;
  final List<String> initialImages;
  final int maxAssets;
  final bool readOnly;

  const UploadImage({
    Key? key,
    required this.onImageSelected,
    this.onTap,
    this.initialImages = const [],
    this.maxAssets = 9,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  List<String> listImagePath = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initInitialImages();
  }

  _initInitialImages() {
    listImagePath = [...widget.initialImages];
  }

  Widget _itemImageBuild(int index, BuildContext context) {
    final link = listImagePath[index];
    return getImage(
      link,
      width: 108.w,
      height: 122.h,
      fit: BoxFit.cover,
      onTap: () {
        openPhotoViewer(
          context,
          index: listImagePath.indexOf(link),
          imagePaths: listImagePath,
          onImageDeleted: widget.readOnly
              ? null
              : (imagePaths) {
                  setState(() {
                    listImagePath = imagePaths;
                  });
                  widget.onImageSelected(listImagePath);
                },
          viewOnly: widget.readOnly,
        );
      },
      borderRadius: BorderRadius.circular(8),
    );
  }

  Future<void> pickUploadImageFromGallery(
      List<String> resultList, BuildContext context) async {
    for (var img in resultList) {
      final imgResize = await Tools().resizeImage(img);
      listImagePath.add(imgResize);
    }
    if (mounted) {
      setState(() {
        widget.onImageSelected(listImagePath);
      });
    }
  }

  Future<void> pickUploadImageFromCamera(
      String result, BuildContext context) async {
    setState(() {
      listImagePath.add(result);
      widget.onImageSelected(listImagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly && listImagePath.isEmpty) {
      return Center(
        child: Text(
          "Không có hình ảnh",
          style: kText18_Light,
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          if (widget.readOnly) {
            return const SizedBox.shrink();
          }
          return _UploadImageButton(
            onTap: () async {
              Utils.hideKeyboard(context);
              if (widget.onTap != null) widget.onTap!();
              await Tools().showPickerMultiImage(
                  context: context,
                  successGallery: (resultList) {
                    pickUploadImageFromGallery(resultList, context);
                  },
                  maxAssets: widget.maxAssets,
                  successCamera: (result) {
                    pickUploadImageFromGallery(result, context);
                  });
            },
          );
        }
        return _itemImageBuild(index - 1, context);
      },
      itemCount: listImagePath.length + 1,
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(width: 8.w),
    );
  }
}

class _UploadImageButton extends StatelessWidget {
  const _UploadImageButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: yrColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
        side: const BorderSide(color: yrColorPrimary),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 122.h,
          width: 92.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_outlined,
                size: 40.h,
                color: yrColorPrimary,
              ),
              SizedBox(
                height: 24.h,
              ),
              SizedBox(
                width: 73.w,
                child: Text(
                  "Chụp/Tải ảnh lên",
                  style: kText14Weight400_Dark,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
