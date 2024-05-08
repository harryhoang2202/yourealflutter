part of 'req_appraisal_role_bloc.dart';

@freezed
class ReqAppraisalRoleState with _$ReqAppraisalRoleState {
  const ReqAppraisalRoleState._();

  const factory ReqAppraisalRoleState({
    String? id,
    required String email,
    required String address,
    required List<String> portraits,
    required List<String> ids,
    required bool agreeRule,
    required ShowDialogType showDialogType,
    required ButtonStatus status,
    required String error,
  }) = _ReqAppraisalRoleState;

  factory ReqAppraisalRoleState.initial({RoleRequiring? request}) {
    return ReqAppraisalRoleState(
      id: request != null ? request.id!.toString() : null,
      error: "",
      showDialogType: ShowDialogType.Idle,
      email: "",
      address: "",
      portraits: request != null && request.portrait != null
          ? request.portrait!.split(",")
          : [],
      ids: request != null && request.idCard != null
          ? request.idCard!.split(",")
          : [],
      agreeRule: false,
      status: ButtonStatus.idle,
    );
  }
}
