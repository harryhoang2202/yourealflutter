import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:tuple/tuple.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/setting/blocs/update_info_bloc.dart';
import 'package:youreal/app/setup_profile/widgets/setup_profile_dropdown.dart';
import 'package:youreal/app/setup_profile/widgets/setup_profile_text_field.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/country.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/view_models/app_model.dart';

class UpdateInfoDialog extends StatefulWidget {
  const UpdateInfoDialog({Key? key}) : super(key: key);

  static BlocProvider<UpdateInfoBloc> getInstance(AppModel appModel) {
    return BlocProvider<UpdateInfoBloc>(
      create: (context) => UpdateInfoBloc(appModel),
      lazy: false,
      child: const UpdateInfoDialog(),
    );
  }

  @override
  State<UpdateInfoDialog> createState() => _UpdateInfoDialogState();
}

class _UpdateInfoDialogState extends State<UpdateInfoDialog> {
  late UpdateInfoBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<UpdateInfoBloc>();
    late final StreamSubscription subscription;
    subscription = _bloc.stream.listen((state) {
      if (state.firstName.isNotEmpty) {
        _firstNameController.text = _bloc.state.firstName;
        _lastNameController.text = _bloc.state.lastName;
        //_emailController.text = _bloc.state.email;
        _phoneController.text = _bloc.state.phone;
        _dobController.text = _bloc.state.dob;

        subscription.cancel();
      }
      var address =
          Provider.of<AppModel>(context, listen: false).user.userAddress;
      if (address != null && address.address != null) {
        _addressController.text = address.address!;
      }
    });
  }

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(8.w),
      titlePadding: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      title: const _UpdateInfoDialogTitle(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.w),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: SetupProfileTextField(
                label: "Họ",
                controller: _lastNameController,
                textColor: yrColorPrimary,
                fillColor: yrColorGrey2,
                heightBoxInput: 45.h,
                onChanged: (val) {
                  _bloc.add(UpdateInfoLastNameChanged(val));
                },
                border: const BorderSide(color: yrColorPrimary),
                labelColor: yrColorPrimary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SetupProfileTextField(
                label: "Tên",
                controller: _firstNameController,
                textColor: yrColorPrimary,
                fillColor: yrColorGrey2,
                heightBoxInput: 45.h,
                onChanged: (val) {
                  _bloc.add(UpdateInfoFirstNameChanged(val));
                },
                border: const BorderSide(color: yrColorPrimary),
                labelColor: yrColorPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // SetupProfileTextField(
        //   label: "Email",
        //   controller: _emailController,
        //   textColor: yrColorPrimary,
        //   fillColor: yrColorGrey2,
        //   onChanged: (val) {
        //     _bloc.add(UpdateInfoEmailChanged(val));
        //   },
        //   border: const BorderSide(color: yrColorPrimary),
        //   labelColor: yrColorPrimary,
        //   keyboardType: TextInputType.emailAddress,
        // ),
        // SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: SetupProfileTextField(
                controller: _phoneController,
                label: "Số điện thoại",
                heightBoxInput: 45.h,
                keyboardType: TextInputType.phone,
                textColor: yrColorPrimary,
                fillColor: yrColorGrey2,
                prefixText: "(+84)",
                prefixStyle: kText14Weight400_Hint,
                hint: "",
                readOnly: true,
                labelColor: yrColorPrimary,
                border: const BorderSide(color: yrColorPrimary),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SetupProfileTextField(
                controller: _dobController,
                label: "Ngày sinh",
                heightBoxInput: 45.h,
                keyboardType: TextInputType.datetime,
                textColor: yrColorPrimary,
                fillColor: yrColorGrey2,
                border: const BorderSide(color: yrColorPrimary),
                hint: "dd/mm/yyyy",
                suffixIcon: GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 365 * 10),
                      ),
                      firstDate: DateTime(1940),
                      lastDate: DateTime.now().subtract(
                        const Duration(days: 365 * 10),
                      ),
                      useRootNavigator: true,
                    );
                    if (pickedDate != null) {
                      _dobController.text = pickedDate.ddMMyyyy;
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: SvgPicture.asset("assets/icons/ic_calendar.svg"),
                  ),
                ),
                suffixIconConstraints:
                    BoxConstraints.tightFor(width: 32.w, height: 20.w),
                onChanged: (val) {
                  _bloc.add(UpdateInfoDobChanged(val));
                },
                labelColor: yrColorPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        //
        _Address(bloc: _bloc, addressController: _addressController),

        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.center,
          child: BlocSelector<UpdateInfoBloc, UpdateInfoState, ButtonStatus>(
            selector: (state) => state.status,
            builder: (context, buttonStatus) {
              return ProgressButtonAnimation(
                onPressed: () {
                  _bloc.add(
                    UpdateInfoSubmitted(onComplete: (error) async {
                      if (error != null) {
                        Utils.showInfoSnackBar(context,
                            message: error, isError: true);
                      } else {
                        await Utils.showInfoSnackBar(context,
                            message: "Cập nhật thông tin thành công");
                        Navigator.pop(context);
                      }
                    }),
                  );
                },
                progressIndicator: const CircularProgressIndicator(
                  color: yrColorLight,
                ),
                state: buttonStatus,
                height: 54.h,
                radius: 10.r,
                minWidth: 1.sw,
                maxWidth: 1.sw,
                stateWidgets: {
                  ButtonStatus.idle: Text(
                    "Đồng ý",
                    style: kText18Weight400_Light,
                  ),
                  ButtonStatus.fail: Text(
                    "Đã có lỗi xảy ra",
                    style: kText18Weight400_Light,
                  ),
                  ButtonStatus.success: Text(
                    "Thành công!",
                    style: kText18Weight400_Light,
                  ),
                },
                stateColors: const {
                  ButtonStatus.idle: yrColorPrimary,
                  ButtonStatus.loading: yrColorPrimary,
                  ButtonStatus.fail: yrColorError,
                  ButtonStatus.success: yrColorSuccess,
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Address extends StatelessWidget {
  const _Address({
    Key? key,
    required UpdateInfoBloc bloc,
    required TextEditingController addressController,
  })  : _bloc = bloc,
        _addressController = addressController,
        super(key: key);

  final UpdateInfoBloc _bloc;
  final TextEditingController _addressController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocSelector<UpdateInfoBloc, UpdateInfoState,
            Tuple2<List<Province>, Province?>>(
          selector: (state) => Tuple2(state.provinces, state.selectedProvince),
          builder: (context, tuple2) {
            return SetupProfileDropdown<Province>(
              label: "Tỉnh/Thành phố",
              labelColor: yrColorPrimary,
              textColor: yrColorPrimary,
              border: BorderStyle.solid,
              fillColor: yrColorGrey2,
              heightBoxInput: 45.h,
              onChanged: (val) {
                if (val != null) _bloc.add(UpdateInfoProvinceChanged(val));
              },
              items: tuple2.item1
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
              value: tuple2.item2,
            );
          },
        ),
        SizedBox(height: 8.h),
        BlocSelector<UpdateInfoBloc, UpdateInfoState,
            Tuple2<List<District>, District?>>(
          selector: (state) => Tuple2(state.districts, state.selectedDistrict),
          builder: (context, tuple) {
            return SetupProfileDropdown<District>(
              label: "Quận/Huyện",
              labelColor: yrColorPrimary,
              textColor: yrColorPrimary,
              border: BorderStyle.solid,
              fillColor: yrColorGrey2,
              heightBoxInput: 45.h,
              onChanged: (val) {
                if (val != null) {
                  _bloc.add(UpdateInfoDistrictChanged(_bloc.province!, val));
                }
              },
              items: tuple.item1
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
              value: tuple.item2,
            );
          },
        ),
        SizedBox(height: 8.h),
        BlocSelector<UpdateInfoBloc, UpdateInfoState,
            Tuple2<List<Ward>, Ward?>>(
          selector: (state) => Tuple2(state.wards, state.selectedWard),
          builder: (context, tuple) {
            return SetupProfileDropdown<Ward>(
              label: "Phường/Xã",
              heightBoxInput: 45.h,
              onChanged: (val) {
                if (val != null) _bloc.add(UpdateInfoWardChanged(val));
              },
              labelColor: yrColorPrimary,
              textColor: yrColorPrimary,
              border: BorderStyle.solid,
              fillColor: yrColorGrey2,
              items: tuple.item1
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
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
          heightBoxInput: 45.h,
          keyboardType: TextInputType.streetAddress,
          onChanged: (val) {
            _bloc.add(UpdateInfoAddressChanged(val));
          },
          controller: _addressController,
          textColor: yrColorPrimary,
          fillColor: yrColorGrey2,
          border: const BorderSide(color: yrColorPrimary),
          labelColor: yrColorPrimary,
        ),
      ],
    );
  }
}

class _UpdateInfoDialogTitle extends StatelessWidget {
  const _UpdateInfoDialogTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Center(
          child: Text(
            "THAY ĐỔI THÔNG TIN",
            style: kText18Weight500_Primary,
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 22.w,
            splashRadius: 12.w,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.close,
              color: yrColorHint,
            ),
          ),
        ),
      ],
    );
  }
}
