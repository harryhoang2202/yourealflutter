import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:tvt_input_keyboard/tvt_input_keyboard.dart';
import 'package:tvt_tab_bar/tvt_tab_bar.dart';
import 'package:youreal/app/auth/login/widgets/custom_checkbox.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/country.dart';
import 'package:youreal/common/tools.dart';

import 'blocs/setup_profile_bloc.dart';
import 'widgets/multi_checkbox.dart';
import 'widgets/setup_profile_dropdown.dart';
import 'widgets/setup_profile_text_field.dart';

class SetupProfileScreen extends StatelessWidget {
  const SetupProfileScreen({Key? key}) : super(key: key);

  static const id = "SetupProfileScreen";

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SetupProfileBloc>(context, listen: false);
    final mq = MediaQuery.of(context);
    return BlocListener<SetupProfileBloc, SetupProfileState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          Utils.showInfoSnackBar(context, message: state.error, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: yrColorPrimary,
        body: NestedWillPopScope(
          onWillPop: () {
            Navigator.pop(context);
            return Future.value(true);
          },
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: mq.padding.top + 30.h),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: yrColorLight,
                            )),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Tạo hồ sơ",
                              style: kText32_Light,
                            ),
                          ),
                        ),
                        SizedBox(width: 40.w)
                      ],
                    ),
                    SizedBox(height: 16.h),

                    //region avatar
                    BlocSelector<SetupProfileBloc, SetupProfileState, String>(
                      selector: (state) => state.avatarUrl,
                      builder: (context, avatarUrl) {
                        return SizedBox.fromSize(
                          size: Size(96.h, 96.h),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (avatarUrl.isEmpty)
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: yrColorLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: yrColorPrimary,
                                      size: 56.h,
                                    ),
                                  ),
                                ),
                              if (avatarUrl.isNotEmpty)
                                Positioned.fill(
                                    child: CircleAvatar(
                                  radius: 48.h,
                                  backgroundImage: FileImage(File(avatarUrl)),
                                )),
                              Positioned(
                                bottom: 0,
                                left: 60.h,
                                child: InkResponse(
                                  onTap: () async {
                                    await Tools().showPickerMultiImage(
                                        context: context,
                                        maxAssets: 1,
                                        successGallery: (res) async {
                                          var img = await Tools()
                                              .resizeImage(res.first);
                                          bloc.add(
                                              SetupProfileAvatarChanged(img));
                                        },
                                        successCamera: (res) {});
                                  },
                                  radius: 12.h,
                                  child: Icon(
                                    Icons.add_circle_rounded,
                                    color: yrColorAccent,
                                    size: 24.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    //endregion
                    SizedBox(height: 16.h),
                    const _PersonalInformation(),
                    SizedBox(height: 16.h),
                    const _Budget(),
                    SizedBox(height: 16.h),
                    _InterestedRealEstate(),
                    SizedBox(height: 40.h),
                    //region policy
                    BlocSelector<SetupProfileBloc, SetupProfileState, bool>(
                      selector: (state) => state.agreeRule,
                      builder: (context, agreeRule) {
                        return InkWell(
                          onTap: () {
                            bloc.add(SetupProfileAgreeRuleChanged(!agreeRule));
                          },
                          child: Row(
                            children: [
                              CustomCheckbox(
                                isChecked: agreeRule,
                                size: 20.w,
                                margin: EdgeInsets.only(right: 8.w),
                                checkedFillColor: Colors.transparent,
                                unCheckedBorderColor: yrColorLight,
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_check.svg",
                                  color: yrColorLight,
                                  height: 10.h,
                                ),
                              ),
                              Flexible(
                                child: Text.rich(
                                  TextSpan(
                                    text: "Tôi đồng ý với các ",
                                    style: kText14Weight400_Light,
                                    children: [
                                      TextSpan(
                                        text: "Điều khoản",
                                        style: kText14_Light,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {},
                                      ),
                                      TextSpan(
                                        text: " và ",
                                        style: kText14Weight400_Light,
                                      ),
                                      TextSpan(
                                        text: "Chính sách bảo mật",
                                        style: kText14_Light,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {},
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    //endregion
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.center,
                      child: BlocSelector<SetupProfileBloc, SetupProfileState,
                          ButtonStatus>(
                        selector: (state) => state.buttonStatus,
                        builder: (context, buttonStatus) {
                          return ProgressButtonAnimation(
                            onPressed: () {
                              bloc.add(const SetupProfileSubmitted());
                            },
                            progressIndicator: const CircularProgressIndicator(
                              color: yrColorPrimary,
                            ),
                            state: buttonStatus,
                            height: 45.h,
                            radius: 10.r,
                            maxWidth: MediaQuery.of(context).size.width,
                            stateWidgets: {
                              ButtonStatus.idle: Text(
                                "Tham gia ngay",
                                style: kText18_Primary,
                              ),
                              ButtonStatus.fail: Text(
                                "Đã có lỗi xảy ra",
                                style: kText18_Light,
                              ),
                              ButtonStatus.success: Text(
                                "Thành công!",
                                style: kText18_Primary,
                              ),
                            },
                            stateColors: const {
                              ButtonStatus.idle: yrColorLight,
                              ButtonStatus.loading: yrColorLight,
                              ButtonStatus.fail: yrColorError,
                              ButtonStatus.success: yrColorLight,
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonalInformation extends StatefulWidget {
  const _PersonalInformation({
    Key? key,
  }) : super(key: key);

  @override
  State<_PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<_PersonalInformation> {
  final genderDropdownItems = Gender.values
      .map(
        (e) => DropdownMenuItem(
          value: e,
          child: Text(e.name),
        ),
      )
      .toList();

  Province? province;
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SetupProfileBloc>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Thông tin cá nhân",
          style: kText14_Light,
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: SetupProfileTextField(
                onChanged: (val) {
                  bloc.add(SetupProfileLastNameChanged(val));
                },
                label: "Họ",
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SetupProfileTextField(
                onChanged: (val) {
                  bloc.add(SetupProfileFirstNameChanged(val));
                },
                label: "Tên đệm và tên",
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SetupProfileTextField(
          label: "Email",
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) {
            bloc.add(SetupProfileEmailChanged(val));
          },
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: BlocSelector<SetupProfileBloc, SetupProfileState, Gender>(
                selector: (state) => state.gender,
                builder: (context, gender) {
                  return SetupProfileDropdown<Gender>(
                    label: "Giới tính",
                    onChanged: (val) {
                      if (val != null) {
                        bloc.add(SetupProfileGenderChanged(val));
                      }
                    },
                    items: genderDropdownItems,
                    value: gender,
                  );
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SetupProfileTextField(
                label: 'Ngày sinh',
                hint: "dd/mm/yyyy",
                keyboardType: TextInputType.datetime,
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: SvgPicture.asset("assets/icons/ic_calendar.svg"),
                ),
                suffixIconConstraints:
                    BoxConstraints.tightFor(width: 32.w, height: 20.w),
                onChanged: (val) {
                  bloc.add(SetupProfileDobChanged(val));
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        //region Địa chỉ
        BlocSelector<SetupProfileBloc, SetupProfileState,
            Tuple2<List<Province>, Province?>>(
          selector: (state) => Tuple2(state.provinces, state.selectedProvince),
          builder: (context, tuple2) {
            return SetupProfileDropdown<Province>(
              label: "Tỉnh/Thành phố",
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    province = val;
                  });
                  bloc.add(SetupProfileProvinceChanged(val));
                }
              },
              items: tuple2.item1
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name,
                        style: kText14_Primary,
                      ),
                    ),
                  )
                  .toList(),
              value: tuple2.item2,
            );
          },
        ),
        SizedBox(height: 8.h),
        BlocSelector<SetupProfileBloc, SetupProfileState,
            Tuple2<List<District>, District?>>(
          selector: (state) => Tuple2(state.districts, state.selectedDistrict),
          builder: (context, tuple) {
            return SetupProfileDropdown<District>(
              label: "Quận/Huyện",
              onChanged: (val) {
                if (val != null) {
                  bloc.add(SetupProfileDistrictChanged(province!, val));
                }
              },
              items: tuple.item1
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name,
                        style: kText14_Primary,
                      ),
                    ),
                  )
                  .toList(),
              value: tuple.item2,
            );
          },
        ),
        SizedBox(width: 8.h),
        BlocSelector<SetupProfileBloc, SetupProfileState,
            Tuple2<List<Ward>, Ward?>>(
          selector: (state) => Tuple2(state.wards, state.selectedWard),
          builder: (context, tuple) {
            return SetupProfileDropdown<Ward>(
              label: "Phường/Xã",
              onChanged: (val) {
                if (val != null) bloc.add(SetupProfileWardChanged(val));
              },
              items: tuple.item1
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name,
                        style: kText14_Primary,
                      ),
                    ),
                  )
                  .toList(),
              value: tuple.item2,
            );
          },
        ),
        SizedBox(height: 8.h),
        SetupProfileTextField(
          label: "Địa chỉ cụ thể",
          keyboardType: TextInputType.streetAddress,
          onChanged: (val) {
            bloc.add(SetupProfileLocationChanged(val));
          },
        ),
        //endregion
      ],
    );
  }
}

class _InterestedRealEstate extends StatelessWidget {
  _InterestedRealEstate({
    Key? key,
  }) : super(key: key);

  final realEstateTypes = RealEstateType.values
      .map((e) => CheckBoxState<RealEstateType>(title: e.name, value: e))
      .toList();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SetupProfileBloc>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bất động sản bạn đang quan tâm:", style: kText14_Light),
        Text(
          "(Chọn ít nhất 2 loại)",
          style: kText14Weight400_Light,
        ),
        SizedBox(height: 16.h),
        MultiCheckbox<RealEstateType>(
          scrollPhysics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          items: realEstateTypes,
          onCheckChanged: (values) {
            bloc.add(SetupProfileInterestedRealTypeChanged(values));
          },
          crossAxisCount: 2,
          margin: EdgeInsets.only(right: 8.w),
          style: kText14_Light,
          mainAxisExtent: 32.h,
          size: 20.w,
          unCheckedBorderColor: yrColorLight,
          checkedFillColor: Colors.transparent,
          icon: SvgPicture.asset(
            "assets/icons/ic_check.svg",
            color: yrColorLight,
            height: 10.h,
          ),
        ),
      ],
    );
  }
}

class _Budget extends StatelessWidget {
  const _Budget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SetupProfileBloc>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //region budget

        Text(
          "Ngân sách tài chính",
          style: kText14_Light,
        ),
        SizedBox(height: 32.h),

        BlocSelector<SetupProfileBloc, SetupProfileState,
            Tuple2<double, double>>(
          selector: (state) => Tuple2(state.minBudget, state.maxBudget),
          builder: (context, tuple) {
            return FlutterSlider(
              handlerAnimation: const FlutterSliderHandlerAnimation(
                scale: 1,
              ),
              handlerHeight: 24.w,
              handlerWidth: 24.w,
              values: [tuple.item1, tuple.item2],
              rangeSlider: true,
              trackBar: FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(
                    color: yrColorAccent,
                    borderRadius: BorderRadius.circular(16.r)),
                activeTrackBarHeight: 10.h,
                inactiveTrackBarHeight: 10.h,
                inactiveTrackBar: BoxDecoration(
                    color: yrColorLight,
                    borderRadius: BorderRadius.circular(16.r)),
              ),
              onDragCompleted: (a, lowerValue, upperValue) {
                bloc.add(SetupProfileBudgetChanged(
                    RangeValues(lowerValue, upperValue)));
              },
              tooltip: FlutterSliderTooltip(
                custom: (value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 12.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: yrColorLight,
                            borderRadius: BorderRadius.circular(4.w)),
                        child: Text(
                          "${Utils.milToBil(value)} tỷ",
                          style: kText14_Primary,
                        ),
                      ),
                      ClipPath(
                        clipper: TriangleClipper(),
                        child: Container(
                          color: yrColorLight,
                          height: 8.h,
                          width: 16.w,
                        ),
                      )
                    ],
                  );
                },
                alwaysShowTooltip: true,
                positionOffset: FlutterSliderTooltipPositionOffset(top: -24.h),
              ),
              rightHandler: FlutterSliderHandler(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: yrColorAccent,
                  ),
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              handler: FlutterSliderHandler(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: yrColorAccent,
                  ),
                ),
              ),
              max: 100,
              min: 1,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "0 VNĐ",
              style: kText14_Light,
            ),
            Text(
              "10.000.000.000 VNĐ",
              style: kText14_Light,
            ),
          ],
        ),
        //endregion budget
      ],
    );
  }
}
