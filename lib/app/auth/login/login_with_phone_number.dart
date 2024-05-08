import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/auth/blocs/login/login_bloc.dart';
import 'package:youreal/app/auth/forgot_password/forgot_password_screen.dart';
import 'package:youreal/app/auth/register/register_screen.dart';
import 'package:youreal/app/setup_profile/setup_profile_screen.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/view_models/app_model.dart';

import 'widgets/custom_checkbox.dart';
import 'widgets/password_field.dart';
import 'widgets/phone_field.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  static const id = "LoginWithPhoneNumber";

  @override
  _LoginWithPhoneNumberState createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool? showPass = false;
  bool saveLogin = false;
  bool endAnimation = false;
  ButtonStatus stateOnlyText = ButtonStatus.idle;
  late AppModel appModel;
  late LoginBloc loginBloc;

  listenStateButton(LoginState state) async {
    state.maybeWhen(
      signInError: () {
        setState(() {
          stateOnlyText = ButtonStatus.fail;
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            stateOnlyText = ButtonStatus.idle;
          });
        });
      },
      signedIn: (user) {
        appModel.user = user;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            stateOnlyText = ButtonStatus.success;
          });
          context.read<AuthBloc>().add(AuthEvent.onSignIn(user));
        });
      },
      signInNoFilter: () {
        Navigator.pushReplacementNamed(
          context,
          SetupProfileScreen.id,
        );
      },
      orElse: () {
        setState(() {
          stateOnlyText = ButtonStatus.loading;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    loadData();
    startAnimation();
  }

  startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      endAnimation = true;
    });
  }

  loadData() async {
    super.initState();
    final prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        saveLogin = prefs.getBool(kUserSaved) ?? false;
      });
      var obtainedPhoneNumber = prefs.getString("phoneNumber");
      var obtainedEmail = prefs.getString("password");
      setState(() {
        _phoneNumber.text = obtainedPhoneNumber ?? "";
        _password.text = obtainedEmail ?? "";
      });
    } catch (e, trace) {
      printLog("$e $trace");
      saveLogin = false;
    }
  }

  savedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("phoneNumber", _phoneNumber.text);
    await prefs.setString("password", _password.text);
  }

  @override
  Widget build(BuildContext context) {
    appModel = Provider.of<AppModel>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                  AnimatedPositioned(
                    top: endAnimation == true ? 30.h : size.height / 2 - 100.h,
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.decelerate,
                    child: Text(
                      "YouReal",
                      style: kTextTitle,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 900),
                    top: endAnimation == true ? 175.h : size.height,
                    curve: Curves.decelerate,
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
                      child: Column(children: [
                        Container(
                          padding: EdgeInsets.only(top: 76.h),
                          alignment: Alignment.center,
                          child: Text(
                            "Đăng nhập",
                            style: kText32_Primary,
                          ),
                        ),
                        SizedBox(
                          height: 54.h,
                        ),

                        //region Số điện thoại
                        PhoneField(phoneNumber: _phoneNumber),
                        //endregion

                        SizedBox(
                          height: 16.h,
                        ),

                        //region Password
                        PasswordField(
                          password: _password,
                          onSubmit: (_) {
                            if (_formKey.currentState!.validate()) {
                              if (saveLogin) savedAccount();
                              if (stateOnlyText == ButtonStatus.idle) {
                                loginBloc.add(
                                  LoginEvent.signIn(_phoneNumber.text.trim(),
                                      _password.text.trim()),
                                );
                              }
                            }
                          },
                        ),
                        //endregion

                        SizedBox(
                          height: 40.h,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  saveLogin = !saveLogin;
                                });
                              },
                              child: Row(
                                children: [
                                  CustomCheckbox(
                                    isChecked: saveLogin,
                                    size: 21.h,
                                    margin: EdgeInsets.only(right: 8.w),
                                    checkedFillColor: Colors.transparent,
                                    unCheckedBorderColor: yrColorPrimary,
                                    icon: SvgPicture.asset(
                                      "assets/icons/ic_check.svg",
                                    ),
                                  ),
                                  Text(
                                    "Ghi nhớ đăng nhập",
                                    style: kText14_Primary,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                if (_phoneNumber.text.isEmpty) {
                                  Utils.showInfoSnackBar(context,
                                      message:
                                          "Vui lòng nhập số điện thoại để lấy lại mật khẩu",
                                      isError: true);
                                } else {
                                  final newPassword = await Navigator.pushNamed(
                                    context,
                                    ForgotPasswordScreen.id,
                                    arguments: _phoneNumber.text.trim(),
                                  );
                                  if (newPassword != null &&
                                      newPassword is String) {
                                    _password.text = newPassword;
                                  }
                                }
                              },
                              child: Text(
                                "Quên mật khẩu?",
                                style: kText14_Primary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 30.h,
                        ),

                        BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                          listenStateButton(state);
                        }, builder: (context, state) {
                          return ProgressButtonAnimation(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool(kUserSaved, saveLogin);
                                if (saveLogin) savedAccount();
                                if (stateOnlyText == ButtonStatus.idle) {
                                  setState(() {
                                    stateOnlyText = ButtonStatus.loading;
                                  });
                                  loginBloc.add(
                                    LoginEvent.signIn(_phoneNumber.text.trim(),
                                        _password.text.trim()),
                                  );
                                }
                              }
                            },
                            state: stateOnlyText,
                            height: 45.h,
                            radius: stateOnlyText == ButtonStatus.loading
                                ? 25.r
                                : 10.r,
                            maxWidth: MediaQuery.of(context).size.width,
                            minWidth: 45.h,
                            stateWidgets: {
                              ButtonStatus.idle: Text(
                                "Đăng nhập",
                                style: kText18_Light,
                              ),
                              ButtonStatus.fail: Text(
                                "Đăng nhập không thành công",
                                style: kText18_Light,
                              ),
                              ButtonStatus.success: Text(
                                "Đăng nhập thành công",
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
                        }),
                        SizedBox(
                          height: 40.h,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Bạn chưa có tài khoản? ",
                            style: kText14_Primary,
                            children: [
                              TextSpan(
                                text: "Tạo tài khoản",
                                style: kText14Bold_Primary,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterScreen.id,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
