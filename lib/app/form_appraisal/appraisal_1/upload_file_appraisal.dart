import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';

import 'package:youreal/app/deal/create_deal/widget/create_deal_number_text_field.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';

import 'package:youreal/services/services_api.dart';

import 'widgets/appraisal_file_item.dart';
import 'widgets/secondary_button.dart';

class UploadFileAppraisal extends StatefulWidget {
  const UploadFileAppraisal({
    Key? key,
  }) : super(key: key);

  @override
  _UploadFileAppraisalState createState() => _UploadFileAppraisalState();
}

class _UploadFileAppraisalState extends State<UploadFileAppraisal> {
  late CreateDealBloc createDealBloc;

  String? _extension;

  FocusNode realEstateValuatedFocus = FocusNode();
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
    } catch (e, trace) {
      _logException("$e $trace");
    }

    List<String> paths = pickedFiles.map((e) => e.path!).toList();
    createDealBloc.add(CreateDealAppraisalFileChanged(
        [...createDealBloc.state.appraisalFiles, ...paths]));
  }

  void _logException(String message) {
    printLog(message);
  }

  @override
  void initState() {
    super.initState();
    createDealBloc = context.read<CreateDealBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CreateDealNumberTextField(
          controller: createDealBloc.state.realEstateValuatedValue,
          focusNode: realEstateValuatedFocus,
          prefixText: "Mức giá thẩm định/tư vấn",
          affixText: "VNĐ",
          suffixIconWidth: 50.w,
          inputAction: TextInputAction.next,
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          "File thẩm định",
          style: kText14Weight400_Light,
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
        SizedBox(
          height: 10.h,
        ),
        BlocSelector<CreateDealBloc, CreateDealState, List<String>>(
          selector: (state) => state.appraisalFiles,
          builder: (context, appraisalFiles) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appraisalFiles.length,
                itemBuilder: (context, index) {
                  var item = appraisalFiles[index];
                  return AppraisalFileItem(
                    onRemoved: () {
                      createDealBloc.add(CreateDealAppraisalFileRemoved(index));
                    },
                    pathOrUrl: item,
                  );
                });
          },
        ),
        SecondaryButton(
          onTap: () async {
            var result = await showDialog(
                context: context, builder: (context) => _popupQuesion(context));
            if (result != null && result == true) _pickFiles();
          },
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
        child: Column(
          children: [
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
          ],
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
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 55.h,
                    decoration: BoxDecoration(
                        color: yrColorPrimary,
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(color: yrColorPrimary)),
                    alignment: Alignment.center,
                    child: Text(
                      "Đóng",
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
