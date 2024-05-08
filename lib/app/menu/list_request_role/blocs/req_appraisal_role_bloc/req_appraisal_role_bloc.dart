import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/menu/list_request_role/model/role_requiring.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';

part 'req_appraisal_role_bloc.freezed.dart';

part 'req_appraisal_role_event.dart';

part 'req_appraisal_role_state.dart';

class ReqAppraisalRoleBloc
    extends Bloc<ReqAppraisalRoleEvent, ReqAppraisalRoleState> {
  final _services = APIServices();

  ReqAppraisalRoleBloc({RoleRequiring? request})
      : super(ReqAppraisalRoleState.initial(request: request)) {
    _mapEventToState();
  }

  _mapEventToState() {
    on<ReqAppraisalRolePortraitImgChanged>((event, emit) {
      emit(state.copyWith(portraits: [...event.paths]));
    });

    on<ReqAppraisalEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.value));
    });

    on<ReqAppraisalRoleSubmitted>(_submittedToState);
    on<ReqAppraisalDataValidated>(_validatedToState);
    on<ReqAppraisalApprovedRequest>(_approvedRequestToState);
    on<ReqAppraisalNotApprovedRequest>(_notApprovedRequestToState);
    on<ReqAppraisalAddressChanged>((event, emit) {
      emit(state.copyWith(address: event.value));
    });

    on<ReqAppraisalRoleIdImgChanged>((event, emit) {
      emit(state.copyWith(ids: [...event.paths]));
    });
    on<ReqAppraisalRoleAgreeRuleChanged>((event, emit) {
      emit(state.copyWith(agreeRule: event.value));
    });
  }

  bool _validateData() {
    if (state.portraits.length < 2 ||
            state.ids.length < 2 /*||
        filePaths.length < 2*/
        ) return false;
    return true;
  }

  Future<void> _approvedRequestToState(ReqAppraisalApprovedRequest event,
      Emitter<ReqAppraisalRoleState> emit) async {
    try {
      emit(state.copyWith(status: ButtonStatus.loading));
      await _services.approvedRequest(
          id: state.id!, statusId: 4, adminNote: event.value);
      _showDialog(emit, ShowDialogType.Waiting);
      emit(state.copyWith(status: ButtonStatus.success));
    } on Exception catch (e) {
      _emitError(emit, e.toString().replaceFirst("Exception: ", ""));
      emit(state.copyWith(status: ButtonStatus.fail));
    }
  }

  Future<void> _notApprovedRequestToState(ReqAppraisalNotApprovedRequest event,
      Emitter<ReqAppraisalRoleState> emit) async {
    try {
      emit(state.copyWith(status: ButtonStatus.loading));
      await _services.approvedRequest(
          id: state.id!, statusId: 2, adminNote: event.value);
      _showDialog(emit, ShowDialogType.Waiting);
      emit(state.copyWith(status: ButtonStatus.success));
    } on Exception catch (e) {
      _emitError(emit, e.toString().replaceFirst("Exception: ", ""));
      emit(state.copyWith(status: ButtonStatus.fail));
    }
  }

  FutureOr<void> _submittedToState(ReqAppraisalRoleSubmitted event,
      Emitter<ReqAppraisalRoleState> emit) async {
    if (!_validateData()) {
      _emitError(emit, 'VUI LÒNG CHỌN TỐI THIỂU 2 HÌNH ẢNH CHO MỖI MỤC');
      return;
    }

    try {
      emit(state.copyWith(status: ButtonStatus.loading));
      await _services.requireRole(
        roleId: 4,
        note: "",
        portraitLinks: await uploadFiles(state.portraits),
        idLinks: await uploadFiles(state.ids),
      );
      _showDialog(emit, ShowDialogType.Waiting);
      emit(state.copyWith(status: ButtonStatus.success));
    } on Exception catch (e) {
      _emitError(emit, e.toString().replaceFirst("Exception: ", ""));
      emit(state.copyWith(status: ButtonStatus.fail));
    }
  }

  FutureOr<void> _validatedToState(ReqAppraisalDataValidated event,
      Emitter<ReqAppraisalRoleState> emit) async {
    if (!_validateData()) {
      _emitError(emit, 'VUI LÒNG CHỌN TỐI THIỂU 2 HÌNH ẢNH CHO MỖI MỤC');
      return;
    }
    _showDialog(emit, ShowDialogType.Confirm);
  }

  _emitError(Emitter<ReqAppraisalRoleState> emit, String error) {
    emit(
      state.copyWith(error: error),
    );
    emit(
      state.copyWith(error: ""),
    );
  }

  _showDialog(Emitter<ReqAppraisalRoleState> emit, ShowDialogType type) {
    emit(
      state.copyWith(showDialogType: type),
    );
    emit(
      state.copyWith(showDialogType: ShowDialogType.Idle),
    );
  }
}
