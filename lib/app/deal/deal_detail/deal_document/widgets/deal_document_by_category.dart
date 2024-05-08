import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

class DealDocumentByCategory extends StatelessWidget {
  const DealDocumentByCategory({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122.h,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return getImage(
            items[index],
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              openPhotoViewer(context,
                  index: index, imagePaths: items, viewOnly: true);
            },
            width: 108.w,
            height: 122.h,
          );
        },
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => 8.horSp,
      ),
    );
  }
}
