import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/form_appraisal/appraisal_1/widgets/appraisal_file_item.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

class AppraisalDocuments extends StatefulWidget {
  const AppraisalDocuments({
    Key? key,
    required this.appraisalFiles,
  }) : super(key: key);
  final List<String> appraisalFiles;

  @override
  State<AppraisalDocuments> createState() => _AppraisalDocumentsState();
}

class _AppraisalDocumentsState extends State<AppraisalDocuments> {
  bool isExpanded = false;
  final enableAnimation = true;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 0, maxHeight: 260.h),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            8.verSp,
            InkWell(
              onTap: enableAnimation
                  ? () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    }
                  : null,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hồ sơ thẩm định & tư vấn giá",
                        style: kText18_Light,
                      ),
                      if (enableAnimation)
                        AnimatedRotation(
                          turns: isExpanded ? 0.75 : 0.25,
                          duration: const Duration(milliseconds: 200),
                          child: SvgPicture.asset(
                            getIcon("ic_left_arrow.svg"),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            8.verSp,
            Visibility(
              visible: isExpanded ? true : false,
              child: Expanded(
                child: widget.appraisalFiles.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.w, horizontal: 16.w),
                        child: Text(
                          "Deal chưa được thẩm định",
                          style: kText16Weight400_Light,
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: AppraisalFileItem(
                              pathOrUrl: widget.appraisalFiles[index],
                              readOnly: true,
                            ),
                          );
                        },
                        itemCount: widget.appraisalFiles.length,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
