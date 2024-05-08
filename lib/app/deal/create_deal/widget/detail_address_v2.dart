import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuple/tuple.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/model/address.dart';
import 'package:youreal/common/model/country.dart';

import 'address_autocomplete.dart';
import 'address_drop_down.dart';

class DetailAddressV2 extends StatefulWidget {
  const DetailAddressV2({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailAddressV2> createState() => _DetailAddressV2State();
}

class _DetailAddressV2State extends State<DetailAddressV2> {
  late CreateDealBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<CreateDealBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 12.w),
              child: Text(
                "Số nhà",
                style: kText14Weight400_Light,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            BlocSelector<CreateDealBloc, CreateDealState, Address>(
              selector: (state) => state.addressNotIncludeStreet,
              builder: (context, addressNotIncludeStreet) {
                return AddressAutoComplete(
                  addressDetail: bloc.state.addressDetail,
                  address: addressNotIncludeStreet,
                  onLocationChanged: (newLocation) {
                    bloc.add(CreateDealLocationChanged(newLocation));
                  },
                );
              },
            )
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          padding: EdgeInsets.only(left: 8.w),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 5.w, bottom: 2.w),
                        child: Text(
                          "Tỉnh/Thành phố trung ương*",
                          style: kText14Weight400_Light,
                        ),
                      ),
                      BlocSelector<CreateDealBloc, CreateDealState,
                          Tuple2<List<Province>, Province?>>(
                        selector: (state) =>
                            Tuple2(state.provinces, state.selectedProvince),
                        builder: (context, tuple2) {
                          final provinces = tuple2.item1;
                          final selectedProvince = tuple2.item2;
                          return Container(
                            height: 45.h,
                            decoration: BoxDecoration(
                                color: yrColorLight,
                                borderRadius: BorderRadius.circular(8.w)),
                            child: AddressDropdown<Province?>(
                              items: provinces
                                  .map((it) => DropdownMenuItem(
                                        value: it,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: Text(
                                            it.name,
                                            style: kText14Weight400_Hint,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedProvince,
                              onChanged: (province) {
                                if (province != null) {
                                  bloc.add(
                                      CreateDealProvinceSelected(province));
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 2.w),
                        child: Text(
                          "Thành phố/Quận/Huyện*",
                          style: kText14Weight400_Light,
                        ),
                      ),
                      BlocSelector<CreateDealBloc, CreateDealState,
                          Tuple2<List<District>, District?>>(
                        selector: (state) =>
                            Tuple2(state.districts, state.selectedDistrict),
                        builder: (context, tuple2) {
                          final districts = tuple2.item1;
                          final selectedDistrict = tuple2.item2;
                          return Container(
                            height: 45.h,
                            decoration: BoxDecoration(
                                color: yrColorLight,
                                borderRadius: BorderRadius.circular(8.w)),
                            child: AddressDropdown<District?>(
                              items: districts
                                  .map((it) => DropdownMenuItem(
                                        value: it,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 8.w),
                                            child: Text(
                                              it.name,
                                              style: kText14Weight400_Hint,
                                            )),
                                      ))
                                  .toList(),
                              value: selectedDistrict,
                              onChanged: (district) {
                                if (district != null) {
                                  bloc.add(
                                      CreateDealDistrictSelected(district));
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 5.w, bottom: 2.w),
                        child: Text(
                          "Phường/Xã",
                          style: kText14Weight400_Light,
                        ),
                      ),
                      BlocSelector<CreateDealBloc, CreateDealState,
                          Tuple2<List<Ward>, Ward?>>(
                        selector: (state) =>
                            Tuple2(state.wards, state.selectedWard),
                        builder: (context, tuple2) {
                          final wards = tuple2.item1;
                          final selectedWard = tuple2.item2;
                          return Container(
                            height: 45.h,
                            decoration: BoxDecoration(
                                color: yrColorLight,
                                borderRadius: BorderRadius.circular(8.w)),
                            child: AddressDropdown<Ward?>(
                              items: wards
                                  .map((it) => DropdownMenuItem(
                                        value: it,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 8.w),
                                            child: Text(
                                              it.name,
                                              style: kText14Weight400_Hint,
                                            )),
                                      ))
                                  .toList(),
                              value: selectedWard,
                              onChanged: (ward) {
                                if (ward != null) {
                                  bloc.add(CreateDealWardSelected(ward));
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
      ],
    );
  }
}
