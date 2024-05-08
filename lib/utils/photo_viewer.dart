import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/yr_image_url.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

class PhotoViewer extends StatefulWidget {
  static const kHeroTag = "PhotoViewerTag";
  PhotoViewer({
    Key? key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    this.scrollDirection = Axis.horizontal,
    required this.imagePaths,
    this.onImageDeleted,
    this.useCached = true,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> imagePaths;
  final Axis scrollDirection;
  final void Function(List<String> imagePaths)? onImageDeleted;
  final bool useCached;

  @override
  State<StatefulWidget> createState() {
    return _PhotoViewerState();
  }
}

class _PhotoViewerState extends State<PhotoViewer> {
  late int currentIndex = widget.initialIndex;
  late List<YrImageUrl> imagePaths;
  Completer loadPreviewUrlCompleter = Completer();
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    (() async {
      if (widget.imagePaths
          .any((element) => element.contains("X-Amz-Signature"))) {
        imagePaths = widget.imagePaths
            .map((e) => YrImageUrl(url: e, previewUrl: e))
            .toList();
      } else if (widget.imagePaths
          .any((element) => element.contains("amazonaws"))) {
        final previewUrls =
            await APIServices().getPreviewLinks(paths: widget.imagePaths);
        imagePaths = widget.imagePaths
            .map((e) => YrImageUrl(url: e, previewUrl: ""))
            .toList();
        for (int i = 0; i < previewUrls.length; i++) {
          imagePaths[i] = imagePaths[i].copyWith(previewUrl: previewUrls[i]);
        }
      } else {
        imagePaths = widget.imagePaths
            .map((e) => YrImageUrl(url: e, previewUrl: e))
            .toList();
      }
      loadPreviewUrlCompleter.complete();
    })();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (endDetails) {
        double? velocity = endDetails.primaryVelocity;
        if (velocity != null && velocity > 0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: yrColorSecondary,
          centerTitle: true,
          elevation: 0,
          leading: const YrBackButton(),
        ),
        body: Container(
          decoration: widget.backgroundDecoration ??
              const BoxDecoration(color: yrColorSecondary),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              FutureBuilder(
                future: loadPreviewUrlCompleter.future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(
                      child: SpinKitThreeBounce(
                        color: yrColorLight,
                      ),
                    );
                  }
                  return PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: _buildItem,
                    itemCount: imagePaths.length,
                    loadingBuilder: widget.loadingBuilder ??
                        (context, _) =>
                            const Center(child: CircularProgressIndicator()),
                    backgroundDecoration: widget.backgroundDecoration ??
                        const BoxDecoration(color: yrColorSecondary),
                    pageController: widget.pageController,
                    onPageChanged: onPageChanged,
                    scrollDirection: widget.scrollDirection,
                  );
                },
              ),
              if (widget.onImageDeleted != null)
                Container(
                  padding: EdgeInsets.all(20.w),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        removeImage(
                          currentIndex,
                          onImageDeleted: widget.onImageDeleted!,
                        );
                        if (imagePaths.isEmpty) Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.delete,
                              color: yrColorLight,
                            ),
                            Text(
                              '   Xóa',
                              style: kText14Weight400_Light,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final item = imagePaths[index];

    return PhotoViewGalleryPageOptions(
      imageProvider: getImage(item.previewUrl),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.url + index.toString()),
    );
  }

  ImageProvider getImage(String path) {
    if (path.contains("assets/images")) {
      return AssetImage(path);
    }

    if (path.isHttpUrl) {
      if (widget.useCached) {
        //return CachedNetworkImageProvider(path);
        return NetworkImage(path);
      } else {
        return NetworkImage(path);
      }
    } else {
      return FileImage(File(path));
    }
  }

  void removeImage(
    int index, {
    required Function(List<String> imagePaths) onImageDeleted,
  }) {
    if (imagePaths.isEmpty) return;
    if (index > imagePaths.length - 1) {
      setState(() {
        imagePaths.removeLast();
      });
      onImageDeleted(imagePaths.map((e) => e.url).toList());

      return;
    }
    setState(() {
      imagePaths.removeAt(index);
    });
    onImageDeleted(imagePaths.map((e) => e.url).toList());
  }
}
