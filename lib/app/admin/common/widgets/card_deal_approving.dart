import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/form_appraisal/blocs/approving_deal_bloc/approving_deal_bloc.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

class ListDealApproving extends StatefulWidget {
  final ApprovingDealBloc bloc;

  const ListDealApproving({Key? key, required this.bloc}) : super(key: key);

  @override
  _ListDealApprovingState createState() => _ListDealApprovingState();
}

class _ListDealApprovingState extends State<ListDealApproving> {
  late var _dealState;

  @override
  void initState() {
    super.initState();
    _dealState = ApprovingDealInitial();
  }

  @override
  Widget build(BuildContext context) {
    _showListDealBuild(List<Deal> list) {
      return SizedBox(
        height: list.length * 160.h,
        child: ListView.builder(
            itemCount: list.length,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Deal item = list[index];
              return CardDealApproving(
                deal: item,
                onTap: () {
                  widget.bloc.add(
                      LoadDetailDealApprovingEvent(dealId: item.id.toString()));
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (context) => const WaitingWidget());
                },
              );
            }),
      );
    }

    return BlocConsumer<ApprovingDealBloc, ApprovingDealState>(
      listener: (context, state) {
        if (state is LoadingDealApprovingState) {
          setState(() {
            _dealState = state;
          });
        } else if (state is LoadedDealApprovingState) {
          setState(() {
            _dealState = state;
          });
        } else if (state is LoadedDealApprovingErrorState) {
          setState(() {
            _dealState = state;
          });
        } else if (state is LoadedDetailDealApprovingState) {
          Navigator.pushNamed(
            context,
            DealTracking.id,
            arguments: state.deal,
          );
        }
      },
      builder: (context, state) {
        if (_dealState is LoadingDealApprovingState) {
          return Container(
              padding: EdgeInsets.only(top: 20.h),
              child: const CircularProgressIndicator());
        } else if (_dealState is LoadedDealApprovingState) {
          if (_dealState.deals.length > 0) {
            return _showListDealBuild(_dealState.deals);
          } else {
            return Container(
              padding: EdgeInsets.only(top: 20.h),
              child: Center(
                  child: Text(
                "Không có dữ liệu",
                style: kText14_Light,
              )),
            );
          }
        } else if (_dealState is LoadedDealApprovingErrorState) {
          return Container(
            padding: EdgeInsets.only(top: 20.h),
            child: Center(
                child: Text(
              "Opp! Đã có lỗi xảy ra",
              style: kText14_Light,
            )),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class CardDealApproving extends StatelessWidget {
  final Deal deal;
  final Function()? onTap;

  const CardDealApproving({
    Key? key,
    required this.deal,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 145.h,
        decoration: BoxDecoration(
            color: yrColorLight, borderRadius: BorderRadius.circular(8.w)),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            SizedBox(
              height: 142.h,
              width: 134.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                child: getImage(
                  "image_1.png",
                  fit: BoxFit.fill,
                  isAsset: true,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 12.w, right: 6.w, top: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            deal.realEstate != null
                                ? deal.realEstate!.realEstateTypeName!
                                    .toString()
                                : "",
                            style: kText14_Primary,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35.h,
                      child: Row(
                        children: [
                          Container(
                            height: 20.h,
                            alignment: Alignment.topCenter,
                            child: SvgPicture.asset(
                                "assets/icons/ic_location1.svg"),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Container(
                                height: 35.h,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  deal.realEstate!.address != null
                                      ? "${deal.realEstate!.address!.district}, "
                                          "${deal.realEstate!.address!.province}"
                                      : "Đang cập nhật",
                                  style: kText14Weight400_Dark,
                                  overflow: TextOverflow.clip,
                                )),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: yrColorDark,
                          size: 20.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          deal.realEstate!.acreage1 != null
                              ? "${deal.realEstate!.acreage1!.content}m²"
                              : "Đang cập nhật",
                          style: kText14Weight400_Dark,
                        ),
                        kDEAL_ID(deal.id),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${Tools().convertMoneyToSymbolMoney(deal.price!)} VNĐ",
                            style: kText14_Error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class WaitingWidget extends StatelessWidget {
//   const WaitingWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: BlocConsumer<ApprovingDealBloc, ApprovingDealState>(
//         listener: (context, state) {
//           if (state is LoadedDetailDealApprovingState) Navigator.pop(context);
//         },
//         builder: (context, state) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }
