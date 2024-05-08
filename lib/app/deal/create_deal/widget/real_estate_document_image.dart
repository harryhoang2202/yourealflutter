import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/model/deal_document.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/widgets_common/upload_images.dart';

class RealEstateDocumentImage extends StatelessWidget {
  const RealEstateDocumentImage({
    Key? key,
    required this.docType,
    required this.images,
    required this.typePickTap,
    this.onImageSelected,
    required this.title,
    this.readOnly = false,
  }) : super(key: key);

  final String title;
  final DealDocumentType docType;
  final Map<DealDocumentType, DealDocument> images;
  final void Function() typePickTap;
  final void Function(List<String> pickedPaths)? onImageSelected;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: kText18_Light,
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Material(
          color: yrColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              typePickTap();
              Utils.hideKeyboard(context);
            },
            child: Container(
              height: 45.h,
              padding: EdgeInsets.only(left: 10.w, right: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      docType.name,
                      style: kText14Weight400_Hint,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: yrColorHint,
                  ),
                ],
              ),
            ),
          ),
        ),
        8.verSp,
        if (!readOnly)
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hình ảnh: ${images[docType]!.imagePathOrUrls.length}/10",
              style: kText14Weight400_Light,
            ),
          ),
        8.verSp,
        SizedBox(
          height: 125.h,
          child: UploadImage(
            key: UniqueKey(),
            initialImages: images[docType]!.imagePathOrUrls,
            onImageSelected: onImageSelected ?? (_) {},
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
