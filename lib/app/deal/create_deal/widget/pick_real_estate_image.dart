import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuple/tuple.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';
import 'package:youreal/app/deal/model/deal_document.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/widgets_common/upload_images.dart';

class PickRealEstateImage extends StatefulWidget {
  final DealDocument images;

  const PickRealEstateImage({Key? key, required this.images}) : super(key: key);

  @override
  State<PickRealEstateImage> createState() => _PickRealEstateImageState();
}

class _PickRealEstateImageState extends State<PickRealEstateImage> {
  late CreateDealBloc createDealBloc;

  @override
  void initState() {
    super.initState();
    createDealBloc = context.read<CreateDealBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateDealBloc, CreateDealState,
        Tuple2<DealDocument, bool>>(
      selector: (state) => Tuple2(state.dealImages, state.canPickImage),
      builder: (context, tuple2) {
        final dealImages = tuple2.item1;
        final canPickImage = tuple2.item2;
        return Container(
          padding: EdgeInsets.only(right: 5.w),
          child: Column(
            children: [
              Container(
                height: 35.h,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hình ảnh",
                  style: kText18_Light,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                height: 125.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                alignment: AlignmentDirectional.centerStart,
                child: UploadImage(
                  key: UniqueKey(),
                  initialImages: dealImages.imagePathOrUrls,
                  onImageSelected: (result) {
                    createDealBloc.add(CreateDealDealImageChanged(result));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
