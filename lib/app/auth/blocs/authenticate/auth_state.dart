part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticating() = AuthStateAuthenticating;
  const factory AuthState.noFilterAuthenticated() =
      AuthStateNoFilterAuthenticated;
  const factory AuthState.authenticated(User user) = AuthStateAuthenticated;
  const factory AuthState.unAuthentication() = AuthStateUnAuthenticated;
}
