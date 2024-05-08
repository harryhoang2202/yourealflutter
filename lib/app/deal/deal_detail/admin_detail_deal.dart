import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/deal_detail/widget/popup_reopen_deal.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/app_loading.dart';

import 'package:youreal/view_models/app_bloc.dart';

import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'blocs/deal_detail_bloc.dart';
import 'widget/deal_document_screen.dart';
import 'widget/deal_images_widget.dart';
import 'widget/google_maps_location.dart';
import 'widget/pickAppraiser.dart';
import 'widget/popup_quesion.dart';
import 'widget/popup_question_with_text_box.dart';
import 'widget/row_button.dart';

class AdminDetailDeal extends StatefulWidget {
  final Deal deal;

  static const id = "AdminDetailDeal";

  const AdminDetailDeal({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  _AdminDetailDealState createState() => _AdminDetailDealState();
}

class _AdminDetailDealState extends State<AdminDetailDeal> {
  bool isLoading = false;
  late Deal deal;
  TextEditingController noteController = TextEditingController();
  late AppModel appModel;
  TextEditingController realEstateValuatedValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      deal = widget.deal;
    });
    AppBloc.dealDetailBloc.initial(widget.deal.id.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appModel = Provider.of<AppModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DealDetailBloc, DealDetailState>(
      listener: (context, state) {
        if (state.initialStatus is SuccessState) {
          setState(() {
            deal = state.deal!;
          });
        }
      },
      listenWhen: ((previous, current) =>
          previous.initialStatus != current.initialStatus),
      child: Stack(
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
                        deal: deal,
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
                              deal.realEstate!.realEstateTypeName!.toString(),
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
                                    deal.realEstate!.address != null
                                        ? "${deal.realEstate!.address!.fullAddress}"
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
                        deal: deal,
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
                          if (deal.realEstate!.note != null)
                            Column(
                              children: deal.realEstate!.note!.content!
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
                              deal.realEstate!.acreage1 != null
                                  ? "${deal.realEstate!.acreage1!.content}m²"
                                  : "Đang cập nhật"),
                          _element2Build(
                              "Diện tích không thuộc lộ giới: ",
                              deal.realEstate!.acreage2 != null
                                  ? "${deal.realEstate!.acreage2!.content}m²"
                                  : "Đang cập nhật"),
                          _element2Build(
                              "Diện tích thuộc lộ giới: ",
                              deal.realEstate!.acreage3 != null
                                  ? "${deal.realEstate!.acreage3!.content}m²"
                                  : "Đang cập nhật"),
                          _element2Build(
                              "Diện tích khuôn viên: ",
                              deal.realEstate!.acreage4 != null
                                  ? "${deal.realEstate!.acreage4!.content}m²"
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
                              (deal.dealStatusId.index <=
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
                              "${Tools().convertMoneyToSymbolMoney(deal.price.toString())} VNĐ",
                              style: kText18_Accent,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          if (deal.dealStatusId.index >
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
                                  child: deal.realEstate!.giaThamDinh != null
                                      ? Text(
                                          "${Tools().convertMoneyToSymbolMoney(deal.realEstate!.giaThamDinh!.content!.toString())} VNĐ",
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
      ),
    );
  }

  Widget _buttonWidgetBuild(appModel) {
    switch (deal.dealStatusId) {
      case DealStatus.Cancelled:
        return PrimaryButton(
          text: "Mở lại/Gia hạn deal",
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => PopupReOpenDeal(
                dealId: deal.id.toString(),
                title: "Bạn muốn mở lại/gia hạn deal #${deal.id}?",
              ),
            );
            AppBloc.dealDetailBloc.initial(deal.id.toString());
          },
          textColor: yrColorPrimary,
          backgroundColor: yrColorLight,
        );
      case DealStatus.WaitingVerification: //assign thợ thẩm định
        return RowButton(
          onLeftTap: () {},
          onRightTap: () async {
            showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (_) => PickAppraiserBottomSheet(
                      deal: deal,
                    ),
                backgroundColor: Colors.transparent);
          },
          leftText: "Đóng",
          rightText: "Gửi yêu cầu",
        );
      case DealStatus.WaitingApproval: //duyệt deal
        return BlocListener<DealDetailBloc, DealDetailState>(
          listener: (context, state) async {
            if (state.approvedStatus is LoadingState) {
              AppLoading.show(context);
            } else if (state.approvedStatus is SuccessState) {
              AppLoading.dismiss(context);
              AppBloc.dealDetailBloc.initial(deal.id.toString());
              await Utils.showInfoSnackBar(
                context,
                message: "Bạn đã duyệt deal #${deal.id}",
                duration: const Duration(seconds: 1, milliseconds: 100),
              );
            } else if (state.approvedStatus is ErrorState) {
              AppLoading.dismiss(context);
              Utils.showInfoSnackBar(
                context,
                message: "Có lỗi xảy ra! Vui lòng kiểm tra lại",
                isError: true,
              );
            } else if (state is IdleState) {
              AppLoading.dismiss(context);
            }
          },
          listenWhen: ((previous, current) =>
              previous.approvedStatus != current.approvedStatus),
          child: BlocListener<DealDetailBloc, DealDetailState>(
            listener: (context, state) async {
              if (state.approvedStatus is LoadingState) {
                AppLoading.show(context);
              } else if (state.rejectStatus is SuccessState) {
                AppLoading.dismiss(context);
                AppBloc.dealDetailBloc.initial(deal.id.toString());
                await Utils.showInfoSnackBar(
                  context,
                  message: "Bạn đã từ chối duyệt deal #${deal.id}",
                );
              } else if (state.rejectStatus is ErrorState) {
                AppLoading.dismiss(context);
                Utils.showInfoSnackBar(
                  context,
                  message: "Có lỗi xảy ra! Vui lòng kiểm tra lại",
                  isError: true,
                );
              } else if (state is IdleState) {
                AppLoading.dismiss(context);
              }
            },
            listenWhen: ((previous, current) =>
                previous.rejectStatus != current.rejectStatus),
            child: RowButton(
              onLeftTap: () async {
                final result = await showDialog(
                      context: context,
                      builder: (context) => PopupQuesionWithTextBox(
                        title: "Bạn muốn từ chối duyệt deal #${deal.id}?",
                        controller: noteController,
                        onApprove: () {
                          AppBloc.dealDetailBloc
                              .reject(deal.id.toString(), noteController.text);
                        },
                      ),
                    ) ??
                    false;
                if (!result) return;
              },
              onRightTap: () async {
                final result = await showDialog(
                      context: context,
                      builder: (context) => const PopupQuesion(
                        title: "Bạn chắc chắn sẽ duyệt deal này?",
                        textOk: "Duyệt",
                      ),
                    ) ??
                    false;
                if (!result) return;

                AppBloc.dealDetailBloc.approved(deal.id.toString());
              },
              leftText: "Từ chối",
              rightText: 'Duyệt deal',
            ),
          ),
        );

      default:
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

  Widget _buildSeeAllDocuments() {
    return PrimaryButton(
      text: 'Xem các giấy tờ liên quan',
      onTap: () {
        Navigator.pushNamed(context, DealDocumentScreen.id, arguments: deal);
      },
      backgroundColor: yrColorLight,
      textColor: yrColorPrimary,
    );
  }
}
