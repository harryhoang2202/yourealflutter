part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginStateInitial;
  const factory LoginState.signingIn() = LoginStateSigningIn;
  const factory LoginState.signedIn(User user) = LoginStateSignedIn;
  const factory LoginState.signInError() = LoginStateSignInError;
  const factory LoginState.signInNoFilter() = LoginStateSignInNoFilter;
}
