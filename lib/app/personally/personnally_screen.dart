import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:tuple/tuple.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/menu/menu.dart';
import 'package:youreal/app/setting/blocs/update_info_bloc.dart';
import 'package:youreal/app/setup_profile/widgets/setup_profile_dropdown.dart';
import 'package:youreal/app/setup_profile/widgets/setup_profile_text_field.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/country.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';

import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/notification_button.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

class PersonallyScreen extends StatefulWidget {
  const PersonallyScreen({Key? key}) : super(key: key);
  static const id = "PersonallyScreen";
  @override
  _PersonallyScreenState createState() => _PersonallyScreenState();
}

class _PersonallyScreenState extends State<PersonallyScreen> {
  final _key = GlobalKey<ScaffoldState>();
  late UpdateInfoBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<UpdateInfoBloc>();
    late final StreamSubscription subscription;
    subscription = _bloc.stream.listen((state) {
      if (state.firstName.isNotEmpty) {
        setState(() {
          _firstNameController.text = _bloc.state.firstName;
          _lastNameController.text = _bloc.state.lastName;
          //_emailController.text = _bloc.state.email;
          _phoneController.text = _bloc.state.phone;
          _dobController.text = _bloc.state.dob;
        });
        subscription.cancel();
      }
    });
    var address =
        Provider.of<AppModel>(context, listen: false).user.userAddress;
    if (address != null && address.address != null) {
      _addressController.text = address.address!;
    }
  }

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: const YrBackButton(),
        title: Text(
          "Trang cá nhân",
          style: kText28_Light,
        ),
        actions: const [
          NotificationButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            const _UserAvatar(),

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
                    // border: const BorderSide(color: yrColorPrimary),
                    labelColor: yrColorLight,
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
                    // border: const BorderSide(color: yrColorPrimary),
                    labelColor: yrColorLight,
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
                    keyboardType: TextInputType.phone,
                    textColor: yrColorPrimary,
                    fillColor: yrColorGrey2,
                    prefixText: "(+84)",
                    prefixStyle: kText14Weight400_Hint,
                    hint: "",
                    heightBoxInput: 45.h,
                    readOnly: true,
                    labelColor: yrColorLight,
                    // border: const BorderSide(color: yrColorPrimary),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: SetupProfileTextField(
                    heightBoxInput: 45.h,
                    controller: _dobController,
                    label: "Ngày sinh",
                    keyboardType: TextInputType.datetime,
                    textColor: yrColorPrimary,
                    fillColor: yrColorGrey2,
                    // border: const BorderSide(color: yrColorPrimary),
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
                    labelColor: yrColorLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            //
            _Address(bloc: _bloc, addressController: _addressController),

            SizedBox(height: 50.h),
            Align(
              alignment: Alignment.center,
              child:
                  BlocSelector<UpdateInfoBloc, UpdateInfoState, ButtonStatus>(
                selector: (state) => state.status,
                builder: (context, buttonStatus) {
                  return ProgressButtonAnimation(
                    onPressed: () {
                      _bloc.add(
                        UpdateInfoSubmitted(onComplete: (error) async {
                          if (error != null) {
                            Utils.showInfoSnackBar(
                              context,
                              message: error,
                              isError: true,
                            );
                          } else {
                            await Utils.showInfoSnackBar(
                              context,
                              message: "Cập nhật thông tin thành công",
                            );
                          }
                        }),
                      );
                    },
                    progressIndicator: const CircularProgressIndicator(
                      color: yrColorPrimary,
                    ),
                    state: buttonStatus,
                    height: 54.h,
                    radius: 10.r,
                    minWidth: 1.sw,
                    maxWidth: 1.sw,
                    stateWidgets: {
                      ButtonStatus.idle: Text(
                        "Lưu thay đổi",
                        style: kText18_Primary,
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
                      ButtonStatus.idle: yrColorLight,
                      ButtonStatus.loading: yrColorLight,
                      ButtonStatus.fail: yrColorError,
                      ButtonStatus.success: yrColorSuccess,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, provider, child) {
        return Container(
          margin: EdgeInsets.only(top: 16.h),
          alignment: Alignment.center,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipOval(
                    child: getImage(
                      provider.user.picture ?? "avatar.png",
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      useCached: false,
                      isAsset: provider.user.picture == null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        Tools().showPickerMultiImage(
                            context: context,
                            maxAssets: 1,
                            successGallery: (res) async {
                              if (res.isEmpty) return;
                              final user = provider.user;
                              var img = await Tools().resizeImage(res.first);
                              final apiResult = await APIServices()
                                  .changeAvatar(imagePath: img);
                              provider.user = user;
                            },
                            successCamera: (res) {});
                      },
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: yrColorWarning,
                        size: 20.w,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                provider.user.fullName,
                style: kText18_Light,
              ),
            ],
          ),
        );
      },
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
              labelColor: yrColorLight,
              textColor: yrColorPrimary,
              // border: BorderStyle.solid,
              fillColor: yrColorGrey2,
              heightBoxInput: 45.h,
              onChanged: (val) {
                if (val != null) _bloc.add(UpdateInfoProvinceChanged(val));
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
        BlocSelector<UpdateInfoBloc, UpdateInfoState,
            Tuple2<List<District>, District?>>(
          selector: (state) => Tuple2(state.districts, state.selectedDistrict),
          builder: (context, tuple) {
            return SetupProfileDropdown<District>(
              label: "Quận/Huyện",
              labelColor: yrColorLight,
              textColor: yrColorPrimary,
              // border: BorderStyle.solid,
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
        BlocSelector<UpdateInfoBloc, UpdateInfoState,
            Tuple2<List<Ward>, Ward?>>(
          selector: (state) => Tuple2(state.wards, state.selectedWard),
          builder: (context, tuple) {
            return SetupProfileDropdown<Ward>(
              label: "Phường/Xã",
              onChanged: (val) {
                if (val != null) _bloc.add(UpdateInfoWardChanged(val));
              },
              heightBoxInput: 45.h,
              labelColor: yrColorLight,
              textColor: yrColorPrimary,
              // border: BorderStyle.solid,
              fillColor: yrColorGrey2,
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
            _bloc.add(UpdateInfoAddressChanged(val));
          },
          heightBoxInput: 45.h,
          controller: _addressController,
          textColor: yrColorPrimary,
          fillColor: yrColorGrey2,
          // border: const BorderSide(color: yrColorPrimary),
          labelColor: yrColorPrimary,
        ),
      ],
    );
  }
}
