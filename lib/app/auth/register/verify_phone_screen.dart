import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvt_input_keyboard/tvt_input_keyboard.dart';
import 'package:youreal/app/auth/blocs/verify_phone_bloc/verify_phone_bloc.dart';
import 'package:youreal/app/auth/login/login_with_phone_number.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({Key? key}) : super(key: key);

  static const id = "VerifyPhoneScreen";
  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final pinController = TextEditingController();
  final StreamController<ErrorAnimationType> errorController =
      StreamController();
  VerifyPhoneBloc? _bloc;
  final pinLength = 6;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<VerifyPhoneBloc>(context, listen: false);
    _bloc!.add(const VerifyPhoneTimerStarted());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final buttonWidth = (mediaQuery.size.width - 16.w * 3) / 2;
    return Scaffold(
      body: BlocListener<VerifyPhoneBloc, VerifyPhoneState>(
        listener: (context, state) {
          if (state.error.isNotEmpty) {
            Utils.showInfoSnackBar(context,
                message: state.error, isError: true);
          }
          if (state.isLogged) {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                LoginWithPhoneNumber.id, (route) => false);
          }
        },
        child: Center(
          child: Column(
            children: [
              SizedBox(height: mediaQuery.padding.top + 100.h),
              Text(
                "Xác thực số điện thoại",
                style: kText32_Primary,
              ),
              SizedBox(height: 40.h),
              Text(
                "Nhập mã xác nhận đã được gửi đến",
                style: kText18_Dark,
              ),
              SizedBox(height: 16.h),
              Text(
                _bloc!.state.phoneNumber,
                style: kText32_Primary,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: PinCodeTextField(
                  appContext: context,
                  length: pinLength,
                  onChanged: (val) {
                    _bloc!.add(VerifyPhoneCodeChanged(val));
                  },
                  controller: pinController,
                  errorAnimationController: errorController,
                  showKeyboard: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8.r),
                    activeColor: yrColorHint,
                    inactiveColor: yrColorHint,
                    borderWidth: 0.7,
                    fieldHeight: 56.h,
                    fieldWidth: 56.h,
                  ),
                ),
              ),
              BlocSelector<VerifyPhoneBloc, VerifyPhoneState, int>(
                selector: (state) => state.timer,
                builder: (context, timer) {
                  if (timer != 0) {
                    return Text(
                      "Gửi lại mã xác thực sau: ${timer}s",
                      style: kText18_Dark,
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => _bloc!.add(const VerifyPhoneCodeResent()),
                      child: Text(
                        "Gửi lại mã xác thực",
                        style: kText18_Primary,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: yrColorPrimary,
                      side: const BorderSide(
                        color: yrColorPrimary,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      fixedSize: Size(buttonWidth, 45.h),
                    ),
                    child: Text(
                      "Quay về",
                      style: kText18_Primary,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _bloc!.add(const VerifyPhoneClicked());
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: yrColorPrimary,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      backgroundColor: yrColorPrimary,
                      fixedSize: Size(buttonWidth, 45.h),
                    ),
                    child: Text(
                      "Xác nhận",
                      style: kText18_Light,
                    ),
                  )
                ],
              ),
              const Spacer(),
              Container(
                color: const Color(0xFFD1D5DB),
                padding: EdgeInsets.only(bottom: 70.h),
                child: Keyboard(
                  onKeyboardTap: (val) {
                    if (pinController.text.length >= pinLength) return;
                    pinController.text += val;
                    _bloc!.add(VerifyPhoneCodeChanged(pinController.text));
                  },
                  textStyle: kText25_Dark,
                  numHeight: 50.h,
                  numWidth: mediaQuery.size.width / 3 - 20.w,
                  rightButtonFn: () {
                    if (pinController.text.isNotEmpty) {
                      pinController.text = pinController.text
                          .substring(0, pinController.text.length - 1);
                      _bloc!.add(
                        VerifyPhoneCodeChanged(pinController.text),
                      );
                    }
                  },
                  rightIcon: const Icon(
                    Icons.backspace_outlined,
                    color: yrColorDark,
                  ),
                  style: KeyboardStyle.STYLE1,
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: yrColorLight,
    );
  }
}
