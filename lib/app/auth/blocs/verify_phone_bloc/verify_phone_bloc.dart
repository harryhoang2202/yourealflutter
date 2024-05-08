import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youreal/app/auth/blocs/register_bloc/register_bloc.dart';

import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';

part 'verify_phone_event.dart';

part 'verify_phone_state.dart';

class VerifyPhoneBloc extends Bloc<VerifyPhoneEvent, VerifyPhoneState> {
  late RegisterState registerState;

  VerifyPhoneBloc({required RegisterBloc registerBloc})
      : super(VerifyPhoneState.initial(registerBloc.state.phoneNumber)) {
    registerState = registerBloc.state;
    registerBloc.stream.listen((registerState) {
      this.registerState = registerState;
    });
    on<VerifyPhoneCodeChanged>((event, emit) {
      emit(state.copyWith(pinCode: event.code));
    });
    on<VerifyPhoneClicked>(
      _onVerifyClickedToState,
      transformer: Utils.debounce(
        const Duration(milliseconds: 400),
      ),
    );
    on<VerifyPhoneTimerStarted>((event, emit) async {
      while (state.timer > 0) {
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(timer: state.timer - 1));
      }
    });
    on<VerifyPhoneCodeResent>((event, emit) async {
      registerBloc.add(RegisterCodeResent());
      emit(state.copyWith(timer: 60));
      add(const VerifyPhoneTimerStarted());
    });
  }

  _onVerifyClickedToState(event, emit) async {
    final result = await APIServices().createAccount(
      phone: registerState.phoneNumber.replaceRange(0, 1, "+84"),
      password: registerState.password,
      verificationToken: registerState.verificationToken,
      verificationCode: state.pinCode,
      createdDateUtc: registerState.createdDateUtc,
    );
    if (result is String) {
      //error
      emit(state.copyWith(error: result));
      emit(state.copyWith(error: ""));
    } else {
      emit(state.copyWith(isLogged: true));
    }
  }
}
