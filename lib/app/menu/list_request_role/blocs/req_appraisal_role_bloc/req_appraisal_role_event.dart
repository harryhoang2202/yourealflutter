part of 'req_appraisal_role_bloc.dart';

@freezed
class ReqAppraisalRoleEvent with _$ReqAppraisalRoleEvent {
  const factory ReqAppraisalRoleEvent.submitted() = ReqAppraisalRoleSubmitted;
  const factory ReqAppraisalRoleEvent.dataValidated() =
      ReqAppraisalDataValidated;

  const factory ReqAppraisalRoleEvent.portraitImgChanged(
    List<String> paths,
  ) = ReqAppraisalRolePortraitImgChanged;

  const factory ReqAppraisalRoleEvent.idImgChanged(
    List<String> paths,
  ) = ReqAppraisalRoleIdImgChanged;

  const factory ReqAppraisalRoleEvent.agreeRuleChanged(
    bool value,
  ) = ReqAppraisalRoleAgreeRuleChanged;

  const factory ReqAppraisalRoleEvent.emailChanged(
    String value,
  ) = ReqAppraisalEmailChanged;

  const factory ReqAppraisalRoleEvent.addressChanged(
    String value,
  ) = ReqAppraisalAddressChanged;
  const factory ReqAppraisalRoleEvent.approvedRequest(
    String value,
  ) = ReqAppraisalApprovedRequest;
  const factory ReqAppraisalRoleEvent.notApprovedRequest(
    String value,
  ) = ReqAppraisalNotApprovedRequest;
}
