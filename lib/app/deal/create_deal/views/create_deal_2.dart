import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:tvt_button/tvt_button.dart';

import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';
import 'package:youreal/app/deal/create_deal/widget/file_grid_view.dart';
import 'package:youreal/app/deal/create_deal/widget/popup_doc.dart';
import 'package:youreal/app/deal/create_deal/widget/real_estate_document_image.dart';
import 'package:youreal/app/deal/model/deal_document.dart';
import 'package:youreal/app/form_appraisal/appraisal_1/form_information_appraisal_1.dart';
import 'package:youreal/app/form_appraisal/appraisal_1/widgets/secondary_button.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'create_deal_complete.dart';

class CreateDeal_2 extends StatefulWidget {
  static const id = "CreateDeal_2";

  const CreateDeal_2({
    Key? key,
  }) : super(key: key);

  @override
  _CreateDeal_2State createState() => _CreateDeal_2State();
}

class _CreateDeal_2State extends State<CreateDeal_2> {
  late CreateDealBloc createDealBloc;
  late AppModel appModel;

  @override
  void initState() {
    super.initState();
    createDealBloc = context.read<CreateDealBloc>();
  }

  _onBackTapped(BuildContext context) async {
    // bool result = await Utils.showConfirmDialog(context,
    //     title: 'Bạn có muốn lưu deal nháp ?');
    // if (result) {
    //   createDealBloc.add(const CreateDealBackTapped());
    // } else {
    // Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route)=>false);
    //   Navigator.pop(context);
    // }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    appModel = Provider.of<AppModel>(context);
    return BlocListener<CreateDealBloc, CreateDealState>(
      listener: (_, state) async {
        final status = state.status;
        if (status is CreateDeal2Success) {
          Navigator.pushNamed(
            context,
            CreateDealComplete.id,
            arguments: createDealBloc.state.draftDealId,
          );
        }
      },
      child: GestureDetector(
        //Hide keyboard when click outside
        onTertiaryTapDown: (_) => Utils.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: yrColorPrimary,
          appBar: AppBar(
            backgroundColor: yrColorPrimary,
            centerTitle: true,
            elevation: 0,
            title: Text(
              "Khởi tạo Deal",
              style: kText28_Light,
            ),
            leading: YrBackButton(
              onTap: () async {
                await _onBackTapped(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  ///Hồ sơ liên quan đến bất động sản
                  DocumentRelateToRealEstate(
                    bloc: createDealBloc,
                  ),
                  24.verSp,

                  ///Hồ sơ liên quan đến chủ Bất động sản
                  BlocSelector<
                      CreateDealBloc,
                      CreateDealState,
                      Tuple2<DealDocumentType,
                          Map<DealDocumentType, DealDocument>>>(
                    selector: (state) =>
                        Tuple2(state.ownerDocType, state.dealDocuments),
                    builder: (context, tuple2) {
                      final ownerDocType = tuple2.item1;
                      final dealDocuments = tuple2.item2;
                      return RealEstateDocumentImage(
                        title: "Hồ sơ liên quan đến chủ BĐS",
                        docType: ownerDocType,
                        images: dealDocuments,
                        typePickTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            useRootNavigator: true,
                            builder: (context) => PopupDoc(
                              onSelect: (type) {
                                createDealBloc
                                    .add(CreateDealOwnerDocTypeChanged(type));
                                Navigator.pop(context);
                              },
                              initialType: ownerDocType,
                              category: DealDocumentCategory.Owner,
                            ),
                          );
                        },
                        onImageSelected: (pickedPaths) {
                          createDealBloc.add(CreateDealDocumentImageChanged(
                              pickedPaths, ownerDocType));
                        },
                      );
                    },
                  ),

                  SizedBox(
                    height: 32.h,
                  ),

                  ///Tổng quan
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tổng quan",
                        style: kText18_Light,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Container(
                        height: 90.h,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: yrColorLight),
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        padding: EdgeInsets.only(top: 12.h),
                        child: TextFormField(
                          controller: createDealBloc.state.dealOverview,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          expands: true,
                          style: kText14Weight400_Light,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12.w),
                          ).allBorder(InputBorder.none),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 32.h,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Tài sản thẩm định chưa?",
                      style: kText18_Light,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),

                  BlocSelector<CreateDealBloc, CreateDealState, bool>(
                    selector: (state) => state.isAppraised,
                    builder: (context, isAppraised) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              createDealBloc.add(
                                  const CreateDealAppraisalStatusChanged(
                                      false));
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: !isAppraised
                                          ? yrColorLight
                                          : yrColorPrimary,
                                      border: Border.all(
                                          color: yrColorLight, width: 2)),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Yêu cầu thẩm định",
                                  style: kText14Weight400_Light,
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              createDealBloc.add(
                                  const CreateDealAppraisalStatusChanged(true));
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isAppraised
                                          ? yrColorLight
                                          : yrColorPrimary,
                                      border: Border.all(
                                          color: yrColorLight, width: 2)),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Đã được thẩm định",
                                  style: kText14Weight400_Light,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30.w,
                          )
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Row(
                    children: [
                      Material(
                        color: yrColorLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.h),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () async {
                            Navigator.pushNamed(
                                context, FormInformationAppraisal_1.id,
                                arguments: createDealBloc);
                            // if (roleId == 4) {
                            // } else {
                            //   await showAnimatedDialog(
                            //     barrierDismissible: false,
                            //     context: context,
                            //     builder: (context) => ErrorDialog(
                            //       error:
                            //           'Chức năng này chỉ dành cho thẩm định viên',
                            //     ),
                            //     animationType: DialogTransitionType.slideFromTop,
                            //     duration: Duration(milliseconds: 300),
                            //     curve: Curves.easeOut,
                            //   );
                            // }
                          },
                          child: Container(
                            height: 62.h,
                            width: 208.w,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.fact_check_outlined,
                                  color: yrColorPrimary,
                                ),
                                8.horSp,
                                Flexible(
                                  child: Text(
                                    "Form nhập thông tin thẩm định",
                                    style: kText18_Primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BlocSelector<CreateDealBloc, CreateDealState, bool>(
                    selector: (state) => state.isRuleAccepted,
                    builder: (context, isRuleAccepted) {
                      return InkWell(
                        onTap: () {
                          createDealBloc.add(
                              CreateDealAcceptRuleChanged(!isRuleAccepted));
                        },
                        child: SizedBox(
                          height: 20.h,
                          child: Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 20.h,
                                decoration: BoxDecoration(
                                  color: isRuleAccepted
                                      ? yrColorLight
                                      : Colors.transparent,
                                  border: Border.all(color: yrColorHint),
                                ),
                              ),
                              SizedBox(
                                width: 11.w,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Tôi đã đọc và hiểu nội dung ",
                                      style: kText14Weight400_Light,
                                      children: [
                                    TextSpan(
                                      text: "thỏa thuận hợp đồng",
                                      style: kText14_Light,
                                    ),
                                  ]))
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  BlocSelector<CreateDealBloc, CreateDealState, StatusState>(
                    selector: (state) => state.status,
                    builder: (context, status) {
                      return Container(
                        height: 48.h,
                        width: screenWidth,
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.h)),
                        alignment: Alignment.center,
                        child: ProgressButtonAnimation(
                          onPressed: () =>
                              createDealBloc.add(const CreateDealSubmitted()),
                          state: ((StatusState status) {
                            if (status is LoadingState) {
                              return ButtonStatus.loading;
                            } else if (status is ErrorState) {
                              return ButtonStatus.fail;
                            } else if (status is CreateDeal2Success) {
                              return ButtonStatus.success;
                            }
                            return ButtonStatus.idle;
                          })(status),
                          height: 48.h,
                          maxWidth: screenWidth,
                          progressIndicator: const CircularProgressIndicator(
                            backgroundColor: yrColorLight,
                          ),
                          minWidth: 48.h,
                          stateWidgets: {
                            ButtonStatus.idle: Text(
                              "Nộp hồ sơ".toUpperCase(),
                              style: kText18Weight400_Primary,
                            ),
                            ButtonStatus.fail: Text(
                              "Nộp hồ sơ không thành công",
                              style: kText18Weight400_Light,
                            ),
                            ButtonStatus.success: Text(
                              "Nộp hồ sơ thành công",
                              style: kText18Weight400_Primary,
                            ),
                          },
                          stateColors: const {
                            ButtonStatus.idle: yrColorLight,
                            ButtonStatus.loading: yrColorPrimary,
                            ButtonStatus.fail: yrColorError,
                            ButtonStatus.success: yrColorSuccess,
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentRelateToRealEstate extends StatelessWidget {
  const DocumentRelateToRealEstate({
    Key? key,
    required this.bloc,
  }) : super(key: key);
  final CreateDealBloc bloc;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateDealBloc, CreateDealState,
        Tuple2<DealDocumentType, Map<DealDocumentType, DealDocument>>>(
      selector: (state) => Tuple2(state.realDocType, state.dealDocuments),
      builder: (context, tuple2) {
        final docType = tuple2.item1;
        final docFiles = tuple2.item2[docType]!.filePathOrUrls;
        final dealDocuments = tuple2.item2;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RealEstateDocumentImage(
              title: "Hồ sơ liên quan đến BĐS",
              docType: docType,
              images: dealDocuments,
              typePickTap: () async {
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: true,
                  builder: (context) => PopupDoc(
                    onSelect: (type) {
                      bloc.add(CreateDealRealDocTypeChanged(type));
                      Navigator.pop(context);
                    },
                    initialType: docType,
                    category: DealDocumentCategory.RealEstate,
                  ),
                );
              },
              onImageSelected: (pickedPaths) {
                bloc.add(CreateDealDocumentImageChanged(pickedPaths, docType));
              },
            ),
            8.verSp,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SecondaryButton(
                  onTap: () async {
                    final files = await Utils.pickFiles();
                    if (files.isEmpty) return;

                    final newFiles = files.map((e) => e.path!).toList();
                    bloc.add(CreateDealDocumentFileChanged(
                        [...docFiles, ...newFiles], docType));
                  },
                  title: "Tải tệp",
                  textColor: yrColorDark,
                ),
                8.horSp,
                if (docFiles.isNotEmpty)
                  Expanded(
                    child: FileGridView(
                      docFiles: docFiles,
                      onRemoved: (newItems) {
                        bloc.add(
                            CreateDealDocumentFileChanged(newItems, docType));
                      },
                      width: 220.w,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
