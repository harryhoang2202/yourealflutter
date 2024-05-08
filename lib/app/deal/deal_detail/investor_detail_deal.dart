import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'widget/deal_images_widget.dart';
import 'widget/google_maps_location.dart';
import 'widget/popup_payment.dart';

class InvestorDetailDeal extends StatefulWidget {
  final Deal deal;

  static const id = "InvestorDetailDeal";

  const InvestorDetailDeal({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  _InvestorDetailDealState createState() => _InvestorDetailDealState();
}

class _InvestorDetailDealState extends State<InvestorDetailDeal> {
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
        if (isLoading)
          Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.black38,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  Widget _buttonWidgetBuild(appModel) {
    return PrimaryButton(
      text: "Tham gia ngay",
      onTap: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => PopupPayment(
            deal: widget.deal,
          ),
        );
      },
      backgroundColor: yrColorLight,
      textColor: yrColorPrimary,
    );
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

  Widget _buildSeeAllDocuments() {
    return Material(
      borderRadius: BorderRadius.circular(8.w),
      color: yrColorLight,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 72.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                color: yrColorPrimary,
                size: 20.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "Hình ảnh",
                style: kText14_Primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
