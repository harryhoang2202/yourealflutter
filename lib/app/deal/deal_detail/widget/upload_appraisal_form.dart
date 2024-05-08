import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/form_appraisal/appraisal_1/widgets/appraisal_file_item.dart';
import 'package:youreal/app/form_appraisal/appraisal_1/widgets/secondary_button.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/services/services_api.dart';

class UploadAppraisalForm extends StatefulWidget {
  const UploadAppraisalForm({
    Key? key,
    required this.fileChanged,
  }) : super(key: key);
  final ValueChanged<List<String>> fileChanged;

  @override
  _UploadAppraisalFormState createState() => _UploadAppraisalFormState();
}

class _UploadAppraisalFormState extends State<UploadAppraisalForm> {
  String? _extension;
  List<String> pickedPaths = [];

  void _pickFiles() async {
    List<PlatformFile> pickedFiles = [];
    try {
      pickedFiles = (await FilePicker.platform.pickFiles(
            type: FileType.any,
            allowMultiple: true,
            onFileLoading: (FilePickerStatus status) => printLog(status),
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '').split(',')
                : null,
          ))
              ?.files ??
          [];
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }

    List<String> paths = pickedFiles.map((e) => e.path!).toList();
    setState(() {
      pickedPaths = [...pickedPaths, ...paths];
      widget.fileChanged(pickedPaths);
    });
  }

  void _logException(String message) {
    printLog(message);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "File thẩm định",
          style: kText18_Light,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => _popupTemplateAppraisal(context));
          },
          child: Container(
            height: 40.h,
            padding: EdgeInsets.only(left: 12.w),
            child: Row(
              children: [
                Icon(Icons.download_for_offline_outlined,
                    size: 20.r, color: yrColorLight),
                SizedBox(width: 5.w),
                Text("Mẫu thẩm định", style: kText14Weight400_Light)
              ],
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pickedPaths.length,
          itemBuilder: (context, index) {
            var item = pickedPaths[index];
            return AppraisalFileItem(
              onRemoved: () {
                setState(() {
                  pickedPaths.removeAt(index);
                });
                widget.fileChanged(pickedPaths);
              },
              pathOrUrl: item,
            );
          },
        ),
        SecondaryButton(
          onTap: () async {
            var result = await showDialog(
                context: context, builder: (context) => _popupQuesion(context));
            if (result != null && result == true) _pickFiles();
          },
        )
      ],
    );
  }

  _popupTemplateAppraisal(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      contentPadding: EdgeInsets.zero,
      title: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        alignment: Alignment.center,
        child: Text(
          "Mẫu thẩm định",
          textAlign: TextAlign.center,
          style: kText18_Primary,
        ),
      ),
      content: Container(
        height: 150.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        alignment: Alignment.center,
        child: Column(children: [
          AppraisalFileItem(
              nameFile: "Mẫu tư vấn giá nhà ở",
              readOnly: true,
              pathOrUrl:
                  "${APIServices().url}documents/real-estate-doc/b8f50d08c4ce45c280e0e6a4e8d51c47.docx"),
          AppraisalFileItem(
              nameFile: "Mẫu tư vấn giá chung cư",
              readOnly: true,
              pathOrUrl:
                  "${APIServices().url}documents/real-estate-doc/9e7bdad9fa844dd7a7289a574b092394.docx")
        ]),
      ),
      buttonPadding: EdgeInsets.zero,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: PrimaryButton(
            text: "Đóng",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  _popupQuesion(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 95.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        alignment: Alignment.center,
        child: Text(
          "Hãy chắc chắn bạn đã có mẫu thẩm định của YouReal trước khi tải tệp lên.",
          textAlign: TextAlign.center,
          style: kText14_Primary,
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
                child: PrimaryButton(
                  text: "Tải mẫu",
                  textColor: yrColorPrimary,
                  backgroundColor: yrColorLight,
                  borderSide: const BorderSide(color: yrColorPrimary),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: PrimaryButton(
                  text: "Tải tệp lên",
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
