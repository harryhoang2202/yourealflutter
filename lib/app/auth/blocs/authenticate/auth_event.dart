part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.initial({VoidCallback? onExpired}) = AuthEventInitial;
  const factory AuthEvent.loadAccount() = AuthEventLoadAccount;
  const factory AuthEvent.onSignIn(User user) = AuthEventOnSignIn;
  const factory AuthEvent.onSignOut() = AuthEventOnSignOut;
}
