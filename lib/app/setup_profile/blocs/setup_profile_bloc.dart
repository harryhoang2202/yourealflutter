import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/country.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/utils/nullable.dart';

import 'package:youreal/services/services_api.dart';
import 'package:youreal/view_models/app_model.dart';

part 'setup_profile_event.dart';

part 'setup_profile_state.dart';

class SetupProfileBloc extends Bloc<SetupProfileEvent, SetupProfileState> {
  SetupProfileBloc() : super(SetupProfileState.initial()) {
    on<SetupProfileInitialLoaded>((event, emit) async {
      emit(state.copyWith(
        provinces: await AppModel().loadProvinces(),
      ));
    });
    on<SetupProfileSubmitted>(
      _submittedToState,
      transformer: Utils.debounce(
        const Duration(milliseconds: 400),
      ),
    );

    on<SetupProfileEmailChanged>((event, emit) {
      emit(state.copyWith(
        email: event.email,
      ));
    });

    on<SetupProfileFirstNameChanged>((event, emit) {
      emit(state.copyWith(
        firstName: event.name,
      ));
    });
    on<SetupProfileLastNameChanged>((event, emit) {
      emit(state.copyWith(
        lastName: event.name,
      ));
    });
    on<SetupProfileLocationChanged>((event, emit) {
      emit(state.copyWith(
        location: event.location,
      ));
    });

    on<SetupProfileGenderChanged>((event, emit) {
      emit(state.copyWith(
        gender: event.gender,
      ));
    });
    on<SetupProfileProvinceChanged>(_provinceChangedToState);
    on<SetupProfileDistrictChanged>(_districtChangedToState);
    on<SetupProfileWardChanged>(_wardChangedToState);
    on<SetupProfileBudgetChanged>((event, emit) {
      emit(state.copyWith(
        minBudget: event.value.start,
        maxBudget: event.value.end,
      ));
    });
    on<SetupProfileInterestedRealTypeChanged>((event, emit) {
      emit(state.copyWith(
        interestedRealEstateTypes: event.types,
      ));
    });
    on<SetupProfileDobChanged>((event, emit) {
      emit(state.copyWith(
        dob: event.dob,
      ));
    });
    on<SetupProfileAgreeRuleChanged>((event, emit) {
      emit(state.copyWith(
        agreeRule: event.value,
      ));
    });
    on<SetupProfileAvatarChanged>((event, emit) {
      emit(state.copyWith(
        avatarUrl: event.url,
      ));
    });
    add(const SetupProfileInitialLoaded());
  }

  _provinceChangedToState(SetupProfileProvinceChanged event, emit) async {
    emit(state.copyWith(
      selectedProvince: Nullable<Province?>(event.province),
      selectedDistrict: Nullable<District?>(null),
      selectedWard: Nullable<Ward?>(null),
    ));

    emit(state.copyWith(
      districts: await AppModel().loadDistricts(event.province),
      wards: [],
    ));
  }

  _districtChangedToState(SetupProfileDistrictChanged event, emit) async {
    emit(state.copyWith(
      selectedProvince: Nullable<Province?>(event.province),
      selectedDistrict: Nullable<District?>(event.district),
      selectedWard: Nullable<Ward?>(null),
    ));

    emit(state.copyWith(
      wards: await AppModel().loadWards(event.province, event.district),
    ));
  }

  _wardChangedToState(SetupProfileWardChanged event, emit) async {
    emit(state.copyWith(
      selectedWard: Nullable<Ward?>(event.ward),
    ));
  }

  _submittedToState(
      SetupProfileSubmitted event, Emitter<SetupProfileState> emit) async {
    final validateResult = state.validate();

    if (validateResult != null) {
      emit(state.copyWith(
        error: validateResult,
      ));
      emit(state.copyWith(
        error: "",
      ));
      return;
    }
    emit(state.copyWith(
      buttonStatus: ButtonStatus.loading,
    ));

    final position = jsonEncode({
      "id": state.selectedProvince!.id,
      "name": state.selectedProvince!.name,
    });
    final budget = "${state.minBudget},${state.maxBudget}";
    final realEstateType =
        state.interestedRealEstateTypes.map((e) => e.name).toList();

    final result = await Future.wait([
      APIServices().sendCriteria(
          position: position,
          soilType: realEstateType,
          investmentLimit: budget),
      APIServices().changeAvatar(imagePath: state.avatarUrl),
      APIServices().updateInfoAccount(
          firstName: state.firstName,
          lastName: state.lastName,
          dob: state.dob.MMddyyyy),
    ]);
    if (result.every((element) => element == true)) {
      emit(state.copyWith(
        buttonStatus: ButtonStatus.success,
      ));
    } else {
      emit(state.copyWith(
        buttonStatus: ButtonStatus.fail,
      ));
    }

    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(
      buttonStatus: ButtonStatus.idle,
    ));
  }
}
