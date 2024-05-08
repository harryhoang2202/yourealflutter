import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tvt_input_keyboard/tvt_input_keyboard.dart';
import 'package:youreal/app/auth/blocs/forgot_password/forgot_password_bloc.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import '../../deal/deal_detail/widget/row_button.dart';
import '../login/widgets/password_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const id = "ForgotPasswordScreen";
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<ForgotPasswordBloc>();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    passwordFocusNode = FocusNode();
    rePasswordFocusNode = FocusNode();
  }

  late TextEditingController passwordController;
  late TextEditingController rePasswordController;
  late FocusNode passwordFocusNode;
  late FocusNode rePasswordFocusNode;
  String code = "";
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (_, state) async {
        final status = state.status;
        if (status is SuccessState) {
          await Utils.showInfoSnackBar(context,
              message: "Mật khẩu đã được thay đổi thành công!");
          if (mounted) {
            Navigator.pop(context, passwordController.tText);
          }
        } else if (status is ErrorState) {
          await Utils.showErrorDialog(
            context,
            message: status.error,
          );
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: context.select<ForgotPasswordBloc, StatusState>(
            (value) => value.state.status) is LoadingState,
        child: Scaffold(
          backgroundColor: yrColorLight,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  16.verSp,
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.w),
                    child: const YrBackButton(
                      color: yrColorPrimary,
                    ),
                  ),
                  80.verSp,
                  Text(
                    "Xác thực số điện thoại",
                    style: kText32Weight500_Primary,
                  ),
                  40.verSp,
                  Text(
                    "Nhập mã xác nhận đã được gửi đến",
                    style: kText20Weight500_Dark,
                  ),
                  16.verSp,
                  Text(
                    bloc.state.phoneNumber.replaceRange(3, null, "*" * 7),
                    style: kText32Weight500_Primary,
                  ),
                  16.verSp,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        code = value;
                      },
                      onCompleted: (_) {
                        passwordFocusNode.requestFocus();
                      },
                      autoDismissKeyboard: false,
                      enablePinAutofill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        borderWidth: 1,
                        activeColor: yrColorGrey2,
                        inactiveColor: yrColorHint,
                        fieldHeight: 56.w,
                        fieldWidth: 56.w,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Gửi lại mã xác thực sau: ",
                        style: kText18Weight500_Dark,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return CountDownText(
                            key: UniqueKey(),
                            from: 60,
                            style: kText18Weight500_Dark,
                            countDownEndWidget: GestureDetector(
                              onTap: () {
                                setState(() {});
                                bloc.add(
                                    const ForgotPasswordPhoneVerificationRequestSent());
                              },
                              child: Text(
                                "Gửi lại mã",
                                style: kText18Weight500_Primary.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  16.verSp,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: PasswordField(
                      password: passwordController,
                      onSubmit: (_) {
                        rePasswordFocusNode.requestFocus();
                      },
                      focusNode: passwordFocusNode,
                    ),
                  ),
                  16.verSp,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: PasswordField(
                      label: "Xác nhận mật khẩu",
                      password: rePasswordController,
                      onSubmit: (_) {
                        bloc.add(
                          ForgotPasswordSubmitted(
                            password: passwordController.tText,
                            code: code,
                            rePassword: rePasswordController.tText,
                          ),
                        );
                      },
                      focusNode: rePasswordFocusNode,
                    ),
                  ),
                  40.verSp,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: RowButton(
                      onLeftTap: () {
                        Navigator.pop(context);
                      },
                      onRightTap: () {
                        bloc.add(
                          ForgotPasswordSubmitted(
                            password: passwordController.tText,
                            code: code,
                            rePassword: rePasswordController.tText,
                          ),
                        );
                      },
                      leftText: "Quay về",
                      rightText: "Xác nhận",
                      leftTheme: RowButton.defaultRightTheme.copyWith(
                        borderSide: const BorderSide(
                          color: yrColorPrimary,
                        ),
                      ),
                      rightTheme: RowButton.defaultLeftTheme,
                    ),
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

class CountDownText extends StatefulWidget {
  const CountDownText({
    Key? key,
    required this.from,
    required this.countDownEndWidget,
    required this.style,
  }) : super(key: key);
  final int from;
  final Widget countDownEndWidget;
  final TextStyle style;

  @override
  State<CountDownText> createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText> {
  late int from;

  @override
  void initState() {
    super.initState();
    from = widget.from;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (from != 0) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            from--;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0.0, -0.5), end: const Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          ),
        );
      },
      child: from == 0
          ? widget.countDownEndWidget
          : Text(
              "${from}s",
              style: widget.style,
            ),
    );
  }
}
