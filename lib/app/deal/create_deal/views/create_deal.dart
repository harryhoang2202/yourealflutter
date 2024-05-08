import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/common/fliter/index.dart';
import 'package:youreal/app/deal/common/address_search_provider.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';

import 'package:youreal/app/deal/create_deal/widget/choose_real_estate_widget.dart';
import 'package:youreal/app/deal/create_deal/widget/create_deal_number_text_field.dart';
import 'package:youreal/app/deal/create_deal/widget/detail_address.dart';
import 'package:youreal/app/deal/create_deal/widget/pick_real_estate_image.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/model/deal_document.dart';
import 'package:youreal/app/deal/deal_detail/widget/map_widget.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'create_deal_2.dart';

class CreateDealArgs {
  final bool editToBuy;
  final Deal? draftDeal;
  const CreateDealArgs({
    this.draftDeal,
    required this.editToBuy,
  });
}

class CreateDealScreen extends StatefulWidget {
  static const id = "CreateDealScreen";
  final bool editToBuy;

  const CreateDealScreen({Key? key, this.editToBuy = false}) : super(key: key);

  @override
  _CreateDealScreenState createState() => _CreateDealScreenState();
}

class _CreateDealScreenState extends State<CreateDealScreen> {
  final Completer<googleMap.GoogleMapController> _controller = Completer();
  late AppModel appModel;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final floorFocusNode = FocusNode();
  final timeDepositFocusNode = FocusNode();
  late CreateDealBloc createDealBloc;
  bool isChangeInfo = false;
  @override
  void dispose() {
    floorFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appModel = Provider.of<AppModel>(context);
    createDealBloc = context.read<CreateDealBloc>();
  }

  Future<bool> _onBackTapped(BuildContext context) async {
    bool result = await Utils.showConfirmDialog(context,
        title: 'Bạn có muốn lưu deal nháp ?');
    if (result) {
      createDealBloc.add(const CreateDealBackTapped());
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDealBloc, CreateDealState>(
      listener: (_, state) async {
        final status = state.status;
        if (status is CreateDealPopBack) {
          Navigator.pop(context);
        } else if (status is ErrorState) {
          await Utils.showInfoSnackBar(
            context,
            message: status.error,
            isError: true,
            position: FlushbarPosition.BOTTOM,
            blockBackgroundInteraction: true,
          );
          // Navigator.pop(context);
        } else if (status is CreateDeal1Success) {
          Navigator.pushNamed(context, CreateDeal_2.id,
              arguments: createDealBloc);
        }
      },
      child: WillPopScope(
        onWillPop: () async => _onBackTapped(context),
        child: BlocSelector<CreateDealBloc, CreateDealState, StatusState>(
          selector: (state) => state.status,
          builder: (context, status) {
            return ModalProgressHUD(
              inAsyncCall: status is LoadingState,
              progressIndicator: const CircularProgressIndicator(
                color: Colors.white,
              ),
              child: Scaffold(
                key: _key,
                backgroundColor: yrColorPrimary,
                appBar: AppBar(
                  backgroundColor: yrColorPrimary,
                  centerTitle: true,
                  leading: YrBackButton(
                    onTap: () async {
                      Navigator.maybePop(context);
                    },
                  ),
                  elevation: 0,
                  title: Text(
                    widget.editToBuy ? "Chỉnh sửa Deal" : "Khởi tạo Deal",
                    style: kText28_Light,
                  ),
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bắt buộc nhập các trường có dấu *",
                                  style: kText14Weight400_Dark.copyWith(
                                      color: yrColorLight),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  "Loại bất động sản*",
                                  style: kText18_Light,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.h),
                          child: ChooseRealEstateWidget(
                            createDealBloc: createDealBloc,
                          ),
                        ),

                        ///Địa chỉ
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Địa chỉ",
                            style: kText18_Light,
                          ),
                        ),
                        const DetailAddress(),

                        SizedBox(
                          height: 20.h,
                        ),

                        ///Vị trí

                        Consumer<AddressSearchProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 177.h,
                              child: MapWidget(
                                onMapCreated:
                                    (googleMap.GoogleMapController controller) {
                                  _controller.complete(controller);
                                  provider.controller = controller;
                                  provider.onAddressSelected(
                                    createDealBloc.state.addressDetail.tText,
                                    (latlng) => {
                                      createDealBloc.add(
                                          CreateDealLocationChanged(latlng))
                                    },
                                  );
                                },
                                location: provider.selectedLocation,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),

                        ///Diện tích
                        AcreageInput(
                            createDealBloc: createDealBloc,
                            floorFocusNode: floorFocusNode,
                            timeDepositFocusNode: timeDepositFocusNode),
                        SizedBox(
                          height: 8.h,
                        ),

                        ///Giá ký gửi

                        InvestmentPrice(createDealBloc: createDealBloc),

                        SizedBox(
                          height: 20.h,
                        ),

                        BlocSelector<CreateDealBloc, CreateDealState,
                            Tuple2<DealDocument, bool>>(
                          selector: (state) =>
                              Tuple2(state.dealImages, state.canPickImage),
                          builder: (context, tuple) {
                            final dealImages = tuple.item1;
                            return PickRealEstateImage(
                              images: dealImages,
                            );
                          },
                        ),

                        24.verSp,

                        PrimaryButton(
                          text: 'Tiếp tục',
                          onTap: () {
                            // createDealBloc
                            //     .add(const CreateDealContinueTapped());
                            Navigator.pushNamed(context, CreateDeal_2.id,
                                arguments: createDealBloc);
                          },
                          textColor: yrColorPrimary,
                          backgroundColor: yrColorLight,
                          debounceTime: 1000,
                        ),
                        40.verSp,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class InvestmentPrice extends StatelessWidget {
  const InvestmentPrice({
    Key? key,
    required this.createDealBloc,
  }) : super(key: key);

  final CreateDealBloc createDealBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateDealNumberTextField(
          controller: createDealBloc.state.depositPrice,
          prefixText: "Giá ký gửi*",
          affixText: "VNĐ",
          suffixIconWidth: 50.w,
          inputAction: TextInputAction.next,
          onChanged: (value) {
            createDealBloc.add(
              CreateDealInvestmentLimitChanged(
                  createDealBloc.state.minInvestValue,
                  double.parse(value.replaceAll(".", ''))),
            );
            createDealBloc.add(
              CreateDealInvestmentMaxChanged(
                  double.parse(value.replaceAll(".", ''))),
            );
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              "Hạn mức đầu tư",
              style: kText14Weight400_Light,
            ),
          ),
        ),
        BlocSelector<CreateDealBloc, CreateDealState,
            Tuple3<double, double, double>>(
          selector: (state) => Tuple3(state.minInvestValue,
              state.maxInvestValue, state.investmentLimitUpperBound),
          builder: (context, tuple) {
            final minValue = tuple.item1;
            final maxValue = tuple.item2;
            final investValueUpperBound = tuple.item3;
            return Stack(
              children: [
                Container(
                  height: 90.h,
                  padding: EdgeInsets.only(top: 10.h),
                  child: CustomSlider1(
                    valueMin: 0,
                    valueMax: investValueUpperBound,
                    valueLower: minValue,
                    valueUpper: maxValue,
                    step: kInvestmentRangeStep,
                    valueChange: (low, high) {
                      createDealBloc.add(
                        CreateDealInvestmentLimitChanged(low, high),
                      );
                    },
                  ),
                ),
                Container(
                  height: 20.h,
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  margin: EdgeInsets.only(top: 60.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "0 VNĐ",
                        style: kText14Weight400_Light,
                      ),
                      Text(
                        "${Tools().convertMoneyToSymbolMoney(investValueUpperBound.toString())} VNĐ",
                        style: kText14Weight400_Light,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class AcreageInput extends StatelessWidget {
  const AcreageInput({
    Key? key,
    required this.createDealBloc,
    required this.floorFocusNode,
    required this.timeDepositFocusNode,
  }) : super(key: key);

  final CreateDealBloc createDealBloc;
  final FocusNode floorFocusNode;
  final FocusNode timeDepositFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Diện tích",
          style: kText18_Light,
          textAlign: TextAlign.left,
        ),
        CreateDealNumberTextField(
          controller: createDealBloc.state.totalAcreage,
          prefixText: "Tổng diện tích*",
          affixText: "m²",
          allowFraction: true,
          inputAction: TextInputAction.next,
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CreateDealNumberTextField(
                controller: createDealBloc.state.length,
                prefixText: "Chiều dài*",
                affixText: "m",
                allowFraction: true,
                inputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: CreateDealNumberTextField(
                controller: createDealBloc.state.width,
                prefixText: "Chiều rộng*",
                affixText: "m",
                allowFraction: true,
                inputAction: TextInputAction.next,
                onEditingComplete: () {
                  if (createDealBloc.state.hasFloor) {
                    floorFocusNode.requestFocus();
                  } else {
                    timeDepositFocusNode.requestFocus();
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        FloorInput(
          createDealBloc: createDealBloc,
          floorFocusNode: floorFocusNode,
        ),

        ///Thời gian ký gửi
        CreateDealNumberTextField(
          controller: createDealBloc.state.depositMonth,
          prefixText: "Thời gian ký gửi",
          affixText: "tháng",
          suffixIconWidth: 70.w,
          focusNode: timeDepositFocusNode,
          inputAction: TextInputAction.next,
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}

class FloorInput extends StatelessWidget {
  const FloorInput({
    Key? key,
    required this.createDealBloc,
    required this.floorFocusNode,
  }) : super(key: key);

  final CreateDealBloc createDealBloc;
  final FocusNode floorFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateDealBloc, CreateDealState, bool>(
      selector: (state) => state.hasFloor,
      builder: (context, hasFloor) {
        return Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 12.w, top: 5.w),
              child: Text(
                "Tầng: ",
                style: kText14Weight400_Light,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            InkWell(
              onTap: () {
                createDealBloc.add(const CreateDealHasFloorChanged(false));
              },
              child: Row(
                children: [
                  Container(
                    height: 15.h,
                    width: 15.h,
                    margin: EdgeInsets.only(top: 5.w),
                    decoration: const BoxDecoration(
                        color: yrColorLight, shape: BoxShape.circle),
                    child: hasFloor
                        ? const SizedBox()
                        : SvgPicture.asset(
                            getIcon("check.svg"),
                            color: yrColorPrimary,
                            fit: BoxFit.fill,
                          ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "Không",
                        style: kText14Weight400_Light,
                      ))
                ],
              ),
            ),
            SizedBox(
              width: 30.w,
            ),
            InkWell(
              onTap: () {
                createDealBloc.add(const CreateDealHasFloorChanged(true));
              },
              child: Row(
                children: [
                  Container(
                    height: 15.h,
                    width: 15.h,
                    margin: EdgeInsets.only(top: 5.w),
                    decoration: const BoxDecoration(
                        color: yrColorLight, shape: BoxShape.circle),
                    child: !hasFloor
                        ? const SizedBox()
                        : SvgPicture.asset(
                            getIcon("check.svg"),
                            color: yrColorPrimary,
                            fit: BoxFit.fill,
                          ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 6.w),
                    child: Text(
                      "Có",
                      style: kText14Weight400_Light,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 50.w,
            ),
            Expanded(
              child: CreateDealNumberTextField(
                controller: createDealBloc.state.numberOfFloors,
                prefixText: "Số tầng: ",
                enabled: hasFloor,
                focusNode: floorFocusNode,
                inputAction: TextInputAction.next,
              ),
            ),
          ],
        );
      },
    );
  }
}
