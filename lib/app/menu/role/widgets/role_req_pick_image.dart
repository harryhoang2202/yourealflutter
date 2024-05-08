import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/widgets_common/upload_images.dart';

class RoleReqPickImage extends StatelessWidget {
  const RoleReqPickImage(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imagePaths,
      required this.onPicked,
      this.readOnly = false})
      : super(key: key);

  final String title;
  final String subtitle;
  final List<String> imagePaths;
  final ValueChanged<List<String>> onPicked;
  final bool readOnly;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(text: title, style: kText14_Dark, children: [
              TextSpan(
                text: "\n$subtitle",
                style: kText14Weight400_Dark,
              )
            ]),
          ),
        ),
        8.verSp,
        Container(
          height: 125.h,
          alignment: AlignmentDirectional.centerStart,
          child: UploadImage(
            key: UniqueKey(),
            initialImages: imagePaths,
            onImageSelected: onPicked,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
