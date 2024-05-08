part of 'forgot_password_bloc.dart';

@freezed
class ForgotPasswordEvent with _$ForgotPasswordEvent {
  const factory ForgotPasswordEvent.submitted({
    required String code,
    required String password,
    required String rePassword,
  }) = ForgotPasswordSubmitted;
  const factory ForgotPasswordEvent.phoneVerificationRequestSent() =
      ForgotPasswordPhoneVerificationRequestSent;
}
