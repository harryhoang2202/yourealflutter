import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:youreal/common/constants/extensions.dart';

import '../../../../common/config/color_config.dart';
import '../../../../common/config/text_config.dart';
import '../../../../common/tools.dart';

class AppraisalFileItem extends StatefulWidget {
  const AppraisalFileItem({
    Key? key,
    required this.pathOrUrl,
    this.onRemoved,
    this.showLoading,
    this.hideLoading,
    this.readOnly = false,
    this.nameFile,
    this.padding,
    this.margin,
    this.textMargin,
    this.shortFor = 30,
  }) : super(key: key);
  final String? nameFile;
  final String pathOrUrl;
  final GestureTapCallback? onRemoved;
  final VoidCallback? showLoading;
  final VoidCallback? hideLoading;
  final bool readOnly;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? textMargin;
  final int shortFor;
  @override
  State<AppraisalFileItem> createState() => _AppraisalFileItemState();
}

class _AppraisalFileItemState extends State<AppraisalFileItem> {
  bool get isUrl => widget.pathOrUrl.isHttpUrl;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: yrColorLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: widget.padding ??
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isLoading) {
                  return;
                }
                Utils.openFile(
                  context,
                  pathOrUrl: widget.pathOrUrl,
                  showLoading: widget.showLoading ??
                      () {
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                      },
                  hideLoading: widget.hideLoading ??
                      () {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                );
              },
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isLoading
                        ? SizedBox.fromSize(
                            key: const ValueKey<int>(0),
                            size: Size(16.w, 16.w),
                            child: const CircularProgressIndicator.adaptive(
                              backgroundColor: yrColorPrimary,
                              strokeWidth: 3,
                            ),
                          )
                        : SizedBox(
                            key: const ValueKey<int>(1),
                            height: 30.h,
                            child: Utils.icFromFile(widget.pathOrUrl),
                          ),
                  ),
                  SizedBox(width: widget.textMargin ?? 12.w),
                  Expanded(
                    child: Text(
                      widget.nameFile ??
                          widget.pathOrUrl
                              .split("/")
                              .last
                              .shortFor(shortForLength: widget.shortFor),
                      style: kText14Weight400_Dark,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: widget.textMargin ?? 12.w),
                ],
              ),
            ),
          ),
          if (!widget.readOnly)
            GestureDetector(
              onTap: widget.onRemoved,
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: Icon(
                  Icons.cancel_outlined,
                  color: yrColorError,
                  size: 30.r,
                ),
              ),
            )
        ],
      ),
    );
  }
}
