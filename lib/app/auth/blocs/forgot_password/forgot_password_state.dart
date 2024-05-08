part of 'forgot_password_bloc.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const ForgotPasswordState._();
  const factory ForgotPasswordState({
    required String phoneNumber,
    required StatusState status,
  }) = _ForgotPasswordState;

  factory ForgotPasswordState.initial(String phoneNumber) =>
      ForgotPasswordState(
        phoneNumber: phoneNumber,
        status: const IdleState(),
      );
}
