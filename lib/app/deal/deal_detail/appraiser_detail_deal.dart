import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/create_deal/widget/create_deal_number_text_field.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';

import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'widget/deal_document_screen.dart';
import 'widget/deal_images_widget.dart';
import 'widget/google_maps_location.dart';
import 'widget/upload_appraisal_form.dart';

class AppraiserDetailDeal extends StatefulWidget {
  final Deal deal;

  static const id = "AppraiserDetailDeal";

  const AppraiserDetailDeal({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  _AppraiserDetailDealState createState() => _AppraiserDetailDealState();
}

class _AppraiserDetailDealState extends State<AppraiserDetailDeal> {
  bool isLoading = false;
  List<String> appraisalFilePaths = [];

  late AppModel appModel;
  TextEditingController realEstateValuatedValue = TextEditingController();
  FocusNode realEstateValuatedFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appModel = Provider.of<AppModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: yrColorPrimary,
          appBar: AppBar(
            backgroundColor: yrColorPrimary,
            elevation: 0,
            leadingWidth: 80.w,
            centerTitle: true,
            leading: const YrBackButton(),
            title: Text(
              "Chi tiết deal",
              style: kText28_Light,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    DealImagesWidget(
                      deal: widget.deal,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),

                    ///header
                    Column(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            widget.deal.realEstate!.realEstateTypeName!
                                .toString(),
                            style: kText18_Light,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(
                            children: [
                              Container(
                                  alignment: Alignment.topCenter,
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_location1.svg",
                                    color: yrColorLight,
                                  )),
                              SizedBox(
                                width: 8.w,
                              ),
                              SizedBox(
                                width: screenWidth - 200.w,
                                child: Text(
                                  widget.deal.realEstate!.address != null
                                      ? "${widget.deal.realEstate!.address!.fullAddress}"
                                      : "Đang cập nhật",
                                  style: kText14Weight400_Light,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),

                    ///Vị trí
                    GoogleMapsLocation(
                      deal: widget.deal,
                    ),

                    SizedBox(
                      height: 18.h,
                    ),

                    ///Tổng quan
                    Column(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            "Tổng quan",
                            style: kText18_Light,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        if (widget.deal.realEstate!.note != null)
                          Column(
                            children: widget.deal.realEstate!.note!.content!
                                .split(".")
                                .map((e) {
                              return _element1Build(e);
                            }).toList(),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                    ),

                    ///Phần đất
                    Column(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            "Phần đất",
                            style: kText18_Light,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        _element2Build(
                            "Diện tích sàn sử dụng: ",
                            widget.deal.realEstate!.acreage1 != null
                                ? "${widget.deal.realEstate!.acreage1!.content}m²"
                                : "Đang cập nhật"),
                        _element2Build(
                            "Diện tích không thuộc lộ giới: ",
                            widget.deal.realEstate!.acreage2 != null
                                ? "${widget.deal.realEstate!.acreage2!.content}m²"
                                : "Đang cập nhật"),
                        _element2Build(
                            "Diện tích thuộc lộ giới: ",
                            widget.deal.realEstate!.acreage3 != null
                                ? "${widget.deal.realEstate!.acreage3!.content}m²"
                                : "Đang cập nhật"),
                        _element2Build(
                            "Diện tích khuôn viên: ",
                            widget.deal.realEstate!.acreage4 != null
                                ? "${widget.deal.realEstate!.acreage4!.content}m²"
                                : "Đang cập nhật"),
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                    ),

                    Column(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            (widget.deal.dealStatusId.index <=
                                    DealStatus.WaitingApproval.index)
                                ? "Giá ký gửi"
                                : "Giá trị bất động sản",
                            style: kText18_Light,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 18.w),
                          child: Text(
                            "${Tools().convertMoneyToSymbolMoney(widget.deal.price.toString())} VNĐ",
                            style: kText18_Accent,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        if (widget.deal.dealStatusId.index >
                            DealStatus.WaitingVerification.index)
                          Column(
                            children: [
                              Container(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  "Giá trị thẩm định",
                                  style: kText18_Light,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 18.w),
                                child:
                                    widget.deal.realEstate!.giaThamDinh != null
                                        ? Text(
                                            "${Tools().convertMoneyToSymbolMoney(widget.deal.realEstate!.giaThamDinh!.content!.toString())} VNĐ",
                                            style: kText18_Accent,
                                          )
                                        : Text(
                                            "0 VNĐ",
                                            style: kText18_Accent,
                                          ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                      ],
                    ),

                    _buildSeeAllDocuments(),
                    SizedBox(
                      height: 24.h,
                    ),

                    SizedBox(
                      height: 40.h,
                    ),
                    _buttonWidgetBuild(appModel),
                    SizedBox(
                      height: 80.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonWidgetBuild(appModel) {
    if (widget.deal.dealStatusId == DealStatus.WaitingVerification) {
      return Column(
        children: [
          UploadAppraisalForm(fileChanged: (files) {
            appraisalFilePaths = files;
          }),
          12.verSp,
          Padding(
            padding: EdgeInsets.all(5.0.w),
            child: CreateDealNumberTextField(
              controller: realEstateValuatedValue,
              focusNode: realEstateValuatedFocus,
              prefixText: "Mức giá thẩm định/tư vấn",
              affixText: "VNĐ",
              suffixIconWidth: 50.w,
              inputAction: TextInputAction.next,
            ),
          ),
          8.verSp,
          PrimaryButton(
            text: "Thẩm định",
            onTap: _onAppraisalSubmitted,
            backgroundColor: yrColorLight,
            textColor: yrColorPrimary,
            enable: !isLoading,
          ),
        ],
      );
    } else if (widget.deal.dealStatusId != DealStatus.WaitingApproval) {
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }

  ///Tổng quan
  Widget _element1Build(title) {
    return Container(
      padding: EdgeInsets.only(left: 5.w),
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            height: 2,
            width: 2,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: yrColorLight),
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            title,
            style: kText14Weight400_Light,
          ),
        ],
      ),
    );
  }

  ///Phần đất
  Widget _element2Build(title1, title2) {
    return Container(
      padding: EdgeInsets.only(left: 5.w),
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          RichText(
            text: TextSpan(
                text: title1,
                style: kText14Weight400_Light,
                children: [
                  TextSpan(
                    text: title2,
                    style: kText14Weight400_Light,
                  )
                ]),
          ),
        ],
      ),
    );
  }

  void _onAppraisalSubmitted() async {
    realEstateValuatedFocus.unfocus();
    if (isLoading) return;

    if (appraisalFilePaths.isEmpty) {
      return Utils.showErrorDialog(context,
          message: "Vui lòng tải lên ít nhất 01 file thẩm định");
    }
    if (realEstateValuatedValue.text.isEmpty) {
      return Utils.showErrorDialog(context,
          message: "Vui lòng nhập mức giá thẩm định/tư vấn");
    }
    setState(() {
      isLoading = true;
    });
    final fileUrls = await uploadFiles(appraisalFilePaths);

    if (fileUrls.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return Utils.showErrorDialog(
        context,
        message: "Đã có lỗi xảy ra",
      );
    }
    try {
      await APIServices().submitAppraisalForm(
          link: fileUrls.join(","),
          realEstateId: widget.deal.realEstateId!,
          realEstateValuatedValue:
              double.parse(realEstateValuatedValue.text.replaceAll('.', '')),
          dealId: widget.deal.id);
      Navigator.pop(context, true);
      await Utils.showInfoSnackBar(context,
          message: "Nộp form thẩm định thành công!");
    } on DioError catch (e) {
      printLog("[$runtimeType] _onAppraisalSubmitted error: ${e.errorMessage}");
    } catch (e) {
      printLog("[$runtimeType] _onAppraisalSubmitted error: $e");
      await Utils.showInfoSnackBar(context,
          message: "Đã có lỗi xảy ra ${e.toString()}", isError: true);
      setState(() {
        isLoading = false;
      });
    } finally {}
  }

  Widget _buildSeeAllDocuments() {
    return PrimaryButton(
      text: 'Xem các giấy tờ liên quan',
      onTap: () {
        Navigator.pushNamed(context, DealDocumentScreen.id,
            arguments: widget.deal);
      },
      backgroundColor: yrColorLight,
      textColor: yrColorPrimary,
    );
  }
}
