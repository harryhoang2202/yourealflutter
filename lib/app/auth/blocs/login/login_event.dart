part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = _Started;
  const factory LoginEvent.signIn(String phoneNumber, String password) =
      _SignIn;
  // const factory LoginEvent.signOut() = _SignOut;
  // const factory LoginEvent.getAccountLogged() = _GetAccountLogged;
}
