import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/services/data/extension.dart';
import 'package:youreal/services/domain/auth/i_auth_repository.dart';
import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/domain/filter/i_filter_repository.dart';
import 'package:youreal/services/notification_services.dart';
import 'package:youreal/services/services_api.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final APIServices _services = APIServices();
  final _notificationServices = NotificationServices();
  final IAuthRepository _authRepository;
  final IFilterRepository _filterRepository;
  LoginBloc(this._authRepository, this._filterRepository)
      : super(const LoginState.initial()) {
    on<_Started>((event, emit) {});
    on<_SignIn>((event, emit) async {
      try {
        emit(const LoginState.signingIn());
        var tokenInfo = await _authRepository.loginWithPhoneNumberAndPassword(
          event.phoneNumber,
          event.password,
        );
        await tokenInfo.fold((l) => throw Exception(), (r) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(kUserSaved, true);
          var isSaveToken = await prefs.setString("tokenUser", r.accessToken!);
          if (!isSaveToken) throw Exception();
          var user = await _authRepository.userInfo();
          if (user.isRight()) {
            final filter = await _filterRepository.filter();
            filter.fold(
                (l) => emit(const LoginState.signInNoFilter()),
                (r) => emit(
                      LoginState.signedIn(
                        user.getOrElse(
                          () => throw Exception(),
                        ),
                      ),
                    ));
          } else {
            emit(const LoginState.signInError());
          }
        });
      } catch (e) {
        emit(const LoginState.signInError());
      } finally {}
    });
    // on<_GetAccountLogged>((event, emit) async {
    //   final prefs = await SharedPreferences.getInstance();
    //   emit(const LoginState.loadingAccountSave());
    //   try {
    //     var result = prefs.getBool(kUserSaved)!;
    //     if (result) {
    //       var _token = prefs.getString("tokenUser")!;
    //       var _userInfo = await _services.getUserInfo(token: _token);
    //       if (_userInfo != null) {
    //         await prefs.setBool(kUserSaved, true);
    //         emit(LoginState.loadedAccountSave(_userInfo));
    //       } else {
    //         await prefs.setBool(kUserSaved, false);
    //         emit(const LoginState.loadedAccountSaveError());
    //       }
    //     } else {
    //       emit(const LoginState.loadedAccountSaveError());
    //     }
    //   } catch (e) {
    //     emit(const LoginState.loadedAccountSaveError());
    //   }
    // });

    // on<_SignOut>((event, emit) async {
    //   try {
    //     emit(const LoginState.signingOut());
    //     final prefs = await SharedPreferences.getInstance();
    //     await prefs.setBool(kUserSaved, false);
    //     await _services.deleteDeviceToken(
    //         token: _notificationServices.deviceToken);
    //     emit(const LoginState.signedOut());
    //   } finally {
    //     emit(const LoginState.signedOut());
    //   }
    // });
  }
}
