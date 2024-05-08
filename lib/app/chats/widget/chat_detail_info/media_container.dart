import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'image_storage.dart';
import 'yr_tab_bar.dart';

class MediaContainer extends StatefulWidget {
  const MediaContainer({Key? key}) : super(key: key);

  @override
  State<MediaContainer> createState() => _MediaContainerState();
}

class _MediaContainerState extends State<MediaContainer>
    with TickerProviderStateMixin {
  TabController? tabController;
  late ChatDetailBloc bloc;
  @override
  void didChangeDependencies() {
    tabController ??= TabController(length: 1, vsync: this);
    super.didChangeDependencies();
    bloc = context.read<ChatDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kho lưu trữ",
          style: kText18Weight500_Light,
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: 1.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 6.h,
              ),
              YrTabBar(
                controller: tabController!,
              ),
              Container(
                width: 1.sw,
                height: 210.h,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: yrColorLight,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.w),
                    bottomLeft: Radius.circular(16.w),
                    bottomRight: Radius.circular(16.w),
                  ),
                ),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ImageStorage(
                      imageUrls: bloc.state.imageChatUrl,
                    ),
                    // VideoStorage(videoUrls: videoUrls),
                    // FileStorage(fileUrls: fileUrls),
                    // const Text('4'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//region tempData
  final imagePaths = <String>[
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerMeltdowns.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/SubaruOutbackOnStreetAndDirt.jpg",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/TearsOfSteel.jpg",
  ];
  final videoUrls = <String>[
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
  ];

  final fileUrls = <String>[
    "https://ifta.org/public/files/journal/d_ifta_journal_17.pdf",
    "https://sample-videos.com/doc/Sample-doc-file-5000kb.doc",
    "https://sample-videos.com/doc/Sample-doc-file-100kb.doc",
    "https://sample-videos.com/pdf/Sample-pdf-5mb.pdf",
    "https://sample-videos.com/xls/Sample-Spreadsheet-1000-rows.xls",
    "https://sample-videos.com/xls/Sample-Spreadsheet-10000-rows.xls",
    "https://sample-videos.com/ppt/Sample-PPT-File-1000kb.ppt",
    "https://filesamples.com/samples/document/txt/sample3.txt",
  ];

//endregion
}
