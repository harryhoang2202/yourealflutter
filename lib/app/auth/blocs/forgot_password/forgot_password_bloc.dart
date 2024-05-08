import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/status_state.dart';

import 'package:youreal/services/services_api.dart';

part 'forgot_password_bloc.freezed.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final _service = APIServices();
  ForgotPasswordBloc(String phoneNumber)
      : super(ForgotPasswordState.initial(phoneNumber)) {
    _mapEventToState();
    add(const ForgotPasswordPhoneVerificationRequestSent());
  }

  void _mapEventToState() {
    on<ForgotPasswordPhoneVerificationRequestSent>((event, emit) async {
      _service.verifyPhoneNumberResetPassword(phoneNumber: state.phoneNumber);
    });
    on<ForgotPasswordSubmitted>((event, emit) async {
      try {
        final password = event.password,
            rePassword = event.rePassword,
            code = event.code;
        printLog("Reset password code $code");
        if (password != rePassword) {
          throw "Mật khẩu không trùng khớp";
        }
        if (code.length < 6) {
          throw "Mã xác nhận không chính xác";
        }
        emit(state.copyWith(status: const LoadingState()));

        final result = await _service.resetPassword(
          phoneNumber: state.phoneNumber,
          newPassword: password,
          verificationCode: code,
        );
        if (result == false) {
          throw "Mã xác nhận không chính xác hoặc đã hết hạn sử dụng";
        }
        emit(state.copyWith(status: const SuccessState()));
      } on DioError catch (e) {
        emit(
          state.copyWith(
            status: const ErrorState(
              error: "Mã xác nhận không chính xác hoặc đã hết hạn sử dụng",
            ),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: ErrorState(error: e.toString())));
      } finally {
        emit(state.copyWith(status: const IdleState()));
      }
    });
  }
}
