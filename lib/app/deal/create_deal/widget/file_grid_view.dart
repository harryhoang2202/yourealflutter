import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../form_appraisal/appraisal_1/widgets/appraisal_file_item.dart';

class FileGridView extends StatelessWidget {
  const FileGridView({
    Key? key,
    required this.docFiles,
    this.onRemoved,
    required this.width,
    this.shortFor = 17,
    this.readOnly = false,
  }) : super(key: key);

  final List<String> docFiles;
  final ValueChanged<List<String>>? onRemoved;
  final double width;
  final int shortFor;
  final bool readOnly;
  int get gridRowCount {
    if (docFiles.isEmpty) {
      return 1;
    }
    final count = docFiles.length >= 3 ? 3 : docFiles.length;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h * gridRowCount,
      child: Scrollbar(
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridRowCount,
            mainAxisSpacing: 8.w,
            childAspectRatio: 50.h / width,
            crossAxisSpacing: 4.w,
          ),
          padding: EdgeInsets.only(bottom: 2.w),
          physics: const BouncingScrollPhysics(),
          itemCount: docFiles.length,
          itemBuilder: (context, index) {
            final item = docFiles[index];
            return AppraisalFileItem(
              pathOrUrl: item,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              margin: EdgeInsets.zero,
              textMargin: 4.w,
              shortFor: shortFor,
              readOnly: readOnly,
              onRemoved: () {
                final newFiles = [...docFiles];
                newFiles.remove(item);
                if (onRemoved != null) {
                  onRemoved!(newFiles);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
