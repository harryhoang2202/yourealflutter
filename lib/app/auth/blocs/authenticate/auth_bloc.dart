import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/services/data/api_remote.dart';
import 'package:youreal/services/domain/auth/i_auth_repository.dart';
import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/domain/filter/i_filter_repository.dart';
import 'package:youreal/services/services_api.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiRemote _apiRemote;
  final IAuthRepository _authRepository;
  final IFilterRepository _filterRepository;
  AuthBloc(this._apiRemote, this._authRepository, this._filterRepository)
      : super(const AuthState.authenticating()) {
    on<AuthEventInitial>((event, emit) async {
      _apiRemote.init(
        token: () async {
          final prefs = await SharedPreferences.getInstance();
          var result = prefs.getBool(kUserSaved) ?? false;
          if (result) {
            var token = prefs.getString("tokenUser") ?? '';
            return token;
          } else {
            return '';
          }
        },
        onExpireToken: () {
          event.onExpired?.call();
        },
      );
    });
    on<AuthEventLoadAccount>((event, emit) async {
      emit(const AuthState.authenticating());
      final prefs = await SharedPreferences.getInstance();
      try {
        var user = await _authRepository.userInfo();
        if (user.isRight()) {
          await prefs.setBool(kUserSaved, true);
          //TODO : add access token to service api old
          //TODO : remove when refactor finish
          APIServices(prefs.getString('tokenUser'));

          // Check filter
          var filter = await _filterRepository.filter();
          filter.fold(
            (l) => emit(const AuthState.noFilterAuthenticated()),
            (r) => emit(AuthState.authenticated(
                user.getOrElse(() => throw Exception()))),
          );
        } else {
          await prefs.setBool(kUserSaved, false);
          emit(const AuthState.unAuthentication());
        }
      } catch (e) {
        emit(const AuthState.unAuthentication());
      }
    });
    on<AuthEventOnSignIn>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      //TODO : add access token to service api old
      //TODO : remove when refactor finish
      APIServices(prefs.getString('tokenUser'));
      emit(AuthState.authenticated(event.user));
    });
    on<AuthEventOnSignOut>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(kUserSaved);
        await prefs.remove("tokenUser");
      } finally {
        emit(const AuthState.unAuthentication());
      }
    });
  }
}
