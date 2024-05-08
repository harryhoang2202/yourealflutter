import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuple/tuple.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';

import 'chat_text_message_item.dart';

class ChatImageMessageItems extends StatefulWidget implements ChatMessageItem {
  final List<String> images;
  @override
  final bool isMe;
  @override
  final MessagePosition position;
  @override
  final String name;

  const ChatImageMessageItems({
    Key? key,
    required this.images,
    required this.isMe,
    required this.position,
    required this.name,
  }) : super(key: key);
  @override
  ChatImageMessageItems copyWith({
    List<String>? images,
    bool? isMe,
    MessagePosition? position,
    String? name,
  }) {
    return ChatImageMessageItems(
      images: images ?? this.images,
      isMe: isMe ?? this.isMe,
      position: position ?? this.position,
      name: name ?? this.name,
    );
  }

  @override
  State<ChatImageMessageItems> createState() => _ChatImageMessageItemsState();
}

class _ChatImageMessageItemsState extends State<ChatImageMessageItems> {
  late Future<List<String>> imagesFuture;

  @override
  void initState() {
    super.initState();
    imagesFuture = APIServices().getPreviewLinks(paths: widget.images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.position == MessagePosition.First && !widget.isMe)
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              widget.name,
              style: kText14Weight400_Accent,
            ),
          ),
        Container(
          constraints: BoxConstraints(maxWidth: 290.w, minHeight: 0),
          padding: EdgeInsets.zero,
          child: FutureBuilder<List<String>>(
            future: imagesFuture,
            builder: (context, snapshot) {
              bool isLoading = false;
              late List<String> images;
              if (snapshot.connectionState != ConnectionState.done) {
                isLoading = true;
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data?.isEmpty == true) {
                images = widget.images;
              } else {
                images = snapshot.data!;
              }
              return StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemBuilder: (context, index) =>
                    _buildImage(context, index, isLoading, images),
                staggeredTileBuilder: _buildCell,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: images.length,
                mainAxisSpacing: 2.w,
                crossAxisSpacing: 2.w,
                physics: const NeverScrollableScrollPhysics(),
              );
            },
          ),
        ),
      ],
    );
  }

  StaggeredTile _buildCell(int index) {
    if (widget.images.length.isOdd && index == widget.images.length - 1) {
      return const StaggeredTile.count(2, 1);
    } else {
      return const StaggeredTile.count(1, 1);
    }
  }

  Tuple4<double, double, double, double> _calculateBorder(int index) {
    double tr = 4.w, tl = 4.w, br = 4.w, bl = 4.w;
    if (widget.images.length > 1) {
      if (widget.images.length.isEven) {
        //1 row
        if (widget.images.length == 2) {
          switch (index) {
            case 0: //first left
              tl = 16.w;
              bl = 16.w;
              break;
            case 1: //first right
              tr = 16.w;
              br = 16.w;
              break;
          }
        }
        //>=2 rows
        else {
          switch (index) {
            case 0: //first left
              tl = 16.w;
              break;
            case 1: //first right
              tr = 16.w;
              break;
          }
          if (index == widget.images.length - 2) {
            bl = 16.w;
          } else if (index == widget.images.length - 1) {
            br = 16.w;
          }
        }
      } else {
        switch (index) {
          case 0: //first left
            tl = 16.w;
            break;
          case 1: //first right
            tr = 16.w;
            break;
        }
        if (index == widget.images.length - 1) {
          bl = 16.w;
          br = 16.w;
        }
      }
    } else {
      tr = tl = br = bl = 16.w;
    }
    return Tuple4(tr, tl, br, bl);
  }

  Widget _buildImage(
      BuildContext context, int index, bool isLoading, List<String> images) {
    final borders = _calculateBorder(index);
    double tr = borders.item1,
        tl = borders.item2,
        br = borders.item3,
        bl = borders.item4;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(tl),
      topRight: Radius.circular(tr),
      bottomLeft: Radius.circular(bl),
      bottomRight: Radius.circular(br),
    );
    final placeHolder = Shimmer.fromColors(
      baseColor: yrColorHint,
      highlightColor: yrColorLight,
      child: SizedBox.expand(
        child: Material(
          color: yrColorLight,
          borderRadius: borderRadius,
        ),
      ),
    );
    if (isLoading) {
      return placeHolder;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 290.w),
      child: getImage(
        images[index],
        onTap: () {
          openPhotoViewer(context,
              index: index, imagePaths: images, viewOnly: true);
        },
        fit: BoxFit.cover,
        borderRadius: borderRadius,
      ),
    );
    // return CachedNetworkImage(
    //   imageUrl: images[index],
    //   fit: BoxFit.cover,
    //   placeholder: (__, _) => placeHolder,
    //   errorWidget: (_, __, ___) => ClipRRect(
    //     borderRadius: borderRadius,
    //     child: Container(
    //       constraints: BoxConstraints(maxWidth: 290.w),
    //       color: yrColorHint,
    //       child: const Center(
    //         child: Icon(
    //           Icons.broken_image,
    //           color: yrColorPrimary,
    //         ),
    //       ),
    //     ),
    //   ),
    //   imageBuilder: (context, imgProvider) => Container(
    //     constraints: BoxConstraints(maxWidth: 290.w),
    //     child: GestureDetector(
    //       onTap: () {
    //         openPhotoViewer(context,
    //             index: index, imagePaths: images, viewOnly: true);
    //       },
    //       child: ClipRRect(
    //         child: Image(
    //           image: imgProvider,
    //           fit: BoxFit.cover,
    //         ),
    //         borderRadius: borderRadius,
    //       ),
    //     ),
    //   ),
    // );
  }
}
