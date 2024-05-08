import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tvt_button/tvt_button.dart';

import 'package:youreal/services/services_api.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState.initial()) {
    on<RegisterPhoneNumberChanged>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phone));
    });
    on<RegisterPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<RegisterRePasswordChanged>((event, emit) {
      emit(state.copyWith(rePassword: event.password));
    });
    on<RegisterClicked>(_registerClickedToState);
    on<RegisterCodeResent>(_registerCodeResentToState);
  }

  _registerClickedToState(event, emit) async {
    if (state.buttonStatus != ButtonStatus.idle) return;
    if (event.formKey.currentState != null &&
        !event.formKey.currentState!.validate()) return;
    emit(state.copyWith(buttonStatus: ButtonStatus.loading));
    final result = await APIServices()
        .verifyPhone(state.phoneNumber.replaceRange(0, 1, "+84"));

    if (result is String || result == null) {
      emit(state.copyWith(buttonStatus: ButtonStatus.fail));
    } else {
      emit(state.copyWith(
        buttonStatus: ButtonStatus.success,
        verificationToken: result["verificationToken"] ?? "",
        createdDateUtc: result["createdDateUtc"] ?? "",
      ));
    }
    emit(state.copyWith(
      buttonStatus: ButtonStatus.idle,
    ));
  }

  _registerCodeResentToState(event, emit) async {
    final result = await APIServices()
        .verifyPhone(state.phoneNumber.replaceRange(0, 1, "+84"));

    if (result is! String) {
      emit(state.copyWith(
        buttonStatus: ButtonStatus.idle,
        verificationToken: result["verificationToken"] ?? "",
        createdDateUtc: result["createdDateUtc"] ?? "",
      ));
    }
  }
}
