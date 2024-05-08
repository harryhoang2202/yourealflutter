import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';

class PopupQuesionWithTextBox extends StatefulWidget {
  // final Deal deal;
  final String title;
  final String titleInput;
  final TextEditingController controller;
  final Function onApprove;
  final bool isRejected;
  const PopupQuesionWithTextBox(
      {Key? key,
      // required this.deal,
      required this.title,
      required this.controller,
      required this.onApprove,
      this.titleInput = "Lý do từ chối",
      this.isRejected = true})
      : super(key: key);

  @override
  State<PopupQuesionWithTextBox> createState() =>
      _PopupQuesionWithTextBoxState();
}

class _PopupQuesionWithTextBoxState extends State<PopupQuesionWithTextBox> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 250.h,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 95.h,
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: kText14_Primary,
                ),
              ),
              Container(
                height: 150.h,
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titleInput,
                      textAlign: TextAlign.center,
                      style: kText14_Primary,
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: TextFormField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.top,
                          controller: widget.controller,
                          validator: (value) {
                            if (widget.isRejected) {
                              if (value!.isEmpty) {
                                return "Bạn cần nhập lý do";
                              } else {
                                return null;
                              }
                            }
                            return null;
                          },
                          style: kText14_Primary,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: yrColorPrimary),
                                  borderRadius: BorderRadius.circular(8.r)),
                              hintText: "Nhập...",
                              hintStyle: kText14Weight400_Hint)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          width: screenWidth,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 55.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: yrColorLight,
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(color: yrColorPrimary)),
                    child: Text(
                      "Hủy",
                      style: kText18Weight400_Primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (widget.isRejected) {
                      if (_formKey.currentState!.validate()) {
                        widget.onApprove();
                        Navigator.pop(context, true);
                      }
                    } else {
                      widget.onApprove();
                      Navigator.pop(context, true);
                    }
                  },
                  child: Container(
                    height: 55.h,
                    decoration: BoxDecoration(
                        color: yrColorPrimary,
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(color: yrColorPrimary)),
                    alignment: Alignment.center,
                    child: Text(
                      "Xác nhận",
                      style: kText18_Light,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
