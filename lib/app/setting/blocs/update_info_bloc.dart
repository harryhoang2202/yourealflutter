import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/country.dart';

import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/view_models/app_model.dart';

part 'update_info_bloc.freezed.dart';
part 'update_info_event.dart';
part 'update_info_state.dart';

class UpdateInfoBloc extends Bloc<UpdateInfoEvent, UpdateInfoState> {
  UpdateInfoBloc(this._appModel) : super(const UpdateInfoState()) {
    _mapEventToState();
    add(UpdateInfoInitialLoaded(_appModel.user));
  }

  final AppModel _appModel;

  final _services = APIServices();
  Province? province;
  void _mapEventToState() {
    on<UpdateInfoInitialLoaded>((event, emit) async {
      emit(
        state.copyWith(
            firstName: event.user.firstName ?? "",
            lastName: event.user.lastName ?? "",
            dob: event.user.getDob(),
            phone: event.user.phoneNumber?.replaceAll("+84", "") ?? ""),
      );

      emit(
        state.copyWith(
          provinces: await _appModel.loadProvinces(),
          address: _appModel.user.userAddress != null &&
                  _appModel.user.userAddress!.address != null
              ? _appModel.user.userAddress!.address!
              : "",
          districts: _appModel.user.userAddress != null
              ? await _appModel.loadDistricts(Province(
                  id: "0",
                  name: _appModel.user.userAddress!.subdivision!.firstLevel!))
              : [],
          wards: _appModel.user.userAddress != null
              ? await _appModel.loadWards(
                  Province(
                      id: "0",
                      name:
                          _appModel.user.userAddress!.subdivision!.firstLevel!),
                  District(
                      id: "000",
                      name: _appModel
                          .user.userAddress!.subdivision!.secondLevel!))
              : [],
          selectedProvince: _appModel.user.userAddress != null &&
                  _appModel.user.userAddress!.subdivision!.firstLevel != null
              ? Province(
                  id: "0",
                  name: _appModel.user.userAddress!.subdivision!.firstLevel!)
              : null,
          selectedDistrict: _appModel.user.userAddress != null &&
                  _appModel.user.userAddress!.subdivision!.secondLevel != null
              ? District(
                  id: "000",
                  name: _appModel.user.userAddress!.subdivision!.secondLevel!)
              : null,
          selectedWard: _appModel.user.userAddress != null &&
                  _appModel.user.userAddress!.subdivision!.thirdLevel != null
              ? Ward(
                  id: "0000",
                  name: _appModel.user.userAddress!.subdivision!.thirdLevel!)
              : null,
        ),
      );
      province = state.selectedProvince;
    });

    on<UpdateInfoProvinceChanged>((event, emit) async {
      province = event.province;

      emit(state.copyWith(
        selectedProvince: event.province,
        selectedDistrict: null,
        selectedWard: null,
      ));

      emit(state.copyWith(
        districts: await AppModel().loadDistricts(event.province),
        wards: [],
      ));
    });

    on<UpdateInfoDistrictChanged>((event, emit) async {
      emit(state.copyWith(
        selectedDistrict: event.district,
        selectedWard: null,
      ));

      emit(state.copyWith(
        wards: await AppModel().loadWards(event.province, event.district),
      ));
    });
    on<UpdateInfoWardChanged>((event, emit) async {
      emit(state.copyWith(
        selectedWard: event.ward,
      ));
    });

    on<UpdateInfoFirstNameChanged>((event, emit) async {
      emit(state.copyWith(
        firstName: event.name,
      ));
    });
    on<UpdateInfoLastNameChanged>((event, emit) async {
      emit(state.copyWith(
        lastName: event.name,
      ));
    });
    // on<UpdateInfoEmailChanged>((event, emit) async {
    //   emit(state.copyWith(
    //     email: event.email,
    //   ));
    // });

    on<UpdateInfoDobChanged>((event, emit) async {
      emit(state.copyWith(
        dob: event.dob,
      ));
    });
    on<UpdateInfoAddressChanged>((event, emit) async {
      emit(state.copyWith(
        address: event.address,
      ));
    });
    on<UpdateInfoSubmitted>((event, emit) async {
      final validateResult = state.validate();

      if (validateResult != null) {
        event.onComplete(validateResult);
        return;
      }
      emit(state.copyWith(
        status: ButtonStatus.loading,
      ));
      await _services.updateInfoAccount(
          firstName: state.firstName,
          lastName: state.lastName,
          dob: state.dob.MMddyyyy);
      _appModel.user =
          (await _services.getUserInfo(token: _services.accessToken))!;
      String? subdivisionId;
      if (state.selectedWard != null) {
        subdivisionId = state.selectedWard?.id;
      } else if (state.selectedDistrict != null) {
        subdivisionId = state.selectedDistrict?.id;
      } else {
        subdivisionId = state.selectedProvince?.id;
      }
      _services.uploadAddressUser(subdivisionId ?? "", state.address);
      _appModel.user =
          (await _services.getUserInfo(token: _services.accessToken))!;
      emit(state.copyWith(
        status: ButtonStatus.success,
      ));
      event.onComplete(null);
      await Future.delayed(const Duration(seconds: 2), () {
        emit(state.copyWith(
          status: ButtonStatus.idle,
        ));
      });
    });
  }
}
