import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/auth/blocs/register_bloc/register_bloc.dart';
import 'package:youreal/app/auth/login/widgets/password_field.dart';
import 'package:youreal/app/auth/login/widgets/phone_field.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'verify_phone_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const id = "RegisterScreen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _rePassword = TextEditingController();

  RegisterBloc? registerBloc;

  @override
  void didChangeDependencies() {
    registerBloc = BlocProvider.of<RegisterBloc>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.buttonStatus == ButtonStatus.success) {
          //close keyboard
          FocusScope.of(context).requestFocus(FocusNode());

          Navigator.pushNamed(context, VerifyPhoneScreen.id,
              arguments: registerBloc!);
        }
      },
      child: Scaffold(
        backgroundColor: yrColorPrimary,
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 30.h,
                      child: Text(
                        "YouReal",
                        style: kTextTitle,
                      ),
                    ),
                    Positioned(
                      top: 175.h,
                      child: Container(
                        height: size.height,
                        width: size.width,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: yrColorLight,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(56.h),
                            topRight: Radius.circular(56.h),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 76.h),
                              alignment: Alignment.center,
                              child: Text(
                                "Tạo tài khoản",
                                style: kText32_Primary,
                              ),
                            ),
                            SizedBox(
                              height: 54.h,
                            ),

                            //region Số điện thoại
                            PhoneField(
                              phoneNumber: _phoneNumber,
                              onChanged: (val) => registerBloc!
                                  .add(RegisterPhoneNumberChanged(val)),
                            ),
                            //endregion

                            SizedBox(
                              height: 16.h,
                            ),

                            //region Password
                            PasswordField(
                              onChanged: (val) => registerBloc!
                                  .add(RegisterPasswordChanged(val)),
                              password: _password,
                            ),
                            //endregion
                            SizedBox(
                              height: 16.h,
                            ),
                            //region RePassword
                            PasswordField(
                              password: _rePassword,
                              label: "Xác nhận mật khẩu",
                              validator: (val) {
                                if (val != _password.text) {
                                  return "Mật khẩu xác nhận không trùng khớp";
                                }
                                return null;
                              },
                              onChanged: (val) => registerBloc!
                                  .add(RegisterRePasswordChanged(val)),
                            ),
                            //endregion
                            SizedBox(
                              height: 55.h,
                            ),

                            BlocSelector<RegisterBloc, RegisterState,
                                ButtonStatus>(
                              selector: (state) => state.buttonStatus,
                              builder: (context, buttonStatus) {
                                return ProgressButtonAnimation(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   CupertinoPageRoute(
                                    //     builder: (_) => BlocProvider(
                                    //       create: (context) => VerifyPhoneBloc(
                                    //           _phoneNumber.text.trim()),
                                    //       child: VerifyPhoneScreen(),
                                    //     ),
                                    //   ),
                                    // );
                                    registerBloc!.add(
                                      RegisterClicked(_formKey),
                                    );
                                  },
                                  state: buttonStatus,
                                  height: 45.h,
                                  radius: 10.r,
                                  maxWidth: screenWidth,
                                  stateWidgets: {
                                    ButtonStatus.idle: Text(
                                      "Đăng ký",
                                      style: kText18_Light,
                                    ),
                                    ButtonStatus.fail: Text(
                                      "Đăng ký không thành công",
                                      style: kText18_Light,
                                    ),
                                    ButtonStatus.success: Text(
                                      "Đăng ký thành công",
                                      style: kText18_Light,
                                    ),
                                  },
                                  stateColors: const {
                                    ButtonStatus.idle: yrColorPrimary,
                                    ButtonStatus.loading: yrColorPrimary,
                                    ButtonStatus.fail: yrColorError,
                                    ButtonStatus.success: yrColorPrimary,
                                  },
                                );
                              },
                            ),

                            SizedBox(
                              height: 40.h,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Bạn đã có tài khoản? ",
                                style: kText14Weight400_Primary,
                                children: [
                                  TextSpan(
                                    text: "Đăng nhập ngay",
                                    style: kText14Bold_Primary,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
